// Theater Admin Panel JavaScript

// API Configuration
const API_BASE_URL = 'http://localhost:8080/api';

// Global variables
let currentSection = 'dashboard';
let sidebarCollapsed = false;
let mobileMenuOpen = false;

// API Service Class
class AdminApiService {
    static async fetchMovies() {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/movies`);
            if (!response.ok) throw new Error('Failed to fetch movies');
            return await response.json();
        } catch (error) {
            console.error('Error fetching movies:', error);
            return [];
        }
    }

    static async addMovie(movieData) {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/movies`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(movieData)
            });
            return await response.json();
        } catch (error) {
            console.error('Error adding movie:', error);
            return { success: false, message: 'Network error' };
        }
    }

    static async updateMovie(id, movieData) {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/movies/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(movieData)
            });
            return await response.json();
        } catch (error) {
            console.error('Error updating movie:', error);
            return { success: false, message: 'Network error' };
        }
    }

    static async deleteMovie(id) {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/movies/${id}`, {
                method: 'DELETE'
            });
            return await response.json();
        } catch (error) {
            console.error('Error deleting movie:', error);
            return { success: false, message: 'Network error' };
        }
    }

    static async fetchScreenings() {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/screenings`);
            if (!response.ok) throw new Error('Failed to fetch screenings');
            return await response.json();
        } catch (error) {
            console.error('Error fetching screenings:', error);
            return [];
        }
    }

    static async addScreening(screeningData) {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/screenings`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(screeningData)
            });
            return await response.json();
        } catch (error) {
            console.error('Error adding screening:', error);
            return { success: false, message: 'Network error' };
        }
    }

    static async fetchBookings() {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/bookings`);
            if (!response.ok) throw new Error('Failed to fetch bookings');
            return await response.json();
        } catch (error) {
            console.error('Error fetching bookings:', error);
            return [];
        }
    }

    static async getDashboardStats() {
        try {
            const response = await fetch(`${API_BASE_URL}/admin/stats/dashboard`);
            if (!response.ok) throw new Error('Failed to fetch dashboard stats');
            return await response.json();
        } catch (error) {
            console.error('Error fetching dashboard stats:', error);
            return {
                movieCount: 0,
                todayScreenings: 0,
                todayBookings: 0,
                todayRevenue: 0
            };
        }
    }
}

// Initialize application
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
    loadDashboard();
    setupEventListeners();
});

function initializeApp() {
    console.log('Theater Admin Panel initialized');
    loadMoviesTable();
    loadBookingsTable();
    loadTheatersGrid();
}

function setupEventListeners() {
    // Sidebar toggle
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const menuToggle = document.querySelector('.menu-toggle');
    
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', toggleSidebar);
    }
    
    if (menuToggle) {
        menuToggle.addEventListener('click', toggleMobileMenu);
    }
    
    // Global search
    const globalSearch = document.getElementById('globalSearch');
    if (globalSearch) {
        globalSearch.addEventListener('input', handleGlobalSearch);
    }
    
    // Window resize handler
    window.addEventListener('resize', handleWindowResize);
    
    // Form submissions
    setupFormHandlers();
}

// Sidebar functions
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    sidebarCollapsed = !sidebarCollapsed;
    
    if (sidebarCollapsed) {
        sidebar.classList.add('collapsed');
    } else {
        sidebar.classList.remove('collapsed');
    }
}

function toggleMobileMenu() {
    const sidebar = document.getElementById('sidebar');
    mobileMenuOpen = !mobileMenuOpen;
    
    if (mobileMenuOpen) {
        sidebar.classList.add('mobile-open');
    } else {
        sidebar.classList.remove('mobile-open');
    }
}

function handleWindowResize() {
    if (window.innerWidth > 768) {
        const sidebar = document.getElementById('sidebar');
        sidebar.classList.remove('mobile-open');
        mobileMenuOpen = false;
    }
}

// Navigation functions
async function showSection(sectionName) {
    // Hide all sections
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(section => section.classList.remove('active'));
    
    // Show selected section
    const targetSection = document.getElementById(sectionName);
    if (targetSection) {
        targetSection.classList.add('active');
    }
    
    // Update navigation
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => link.classList.remove('active'));
    
    const activeLink = document.querySelector(`[onclick="showSection('${sectionName}')"]`);
    if (activeLink) {
        activeLink.classList.add('active');
    }
    
    // Update page title
    const pageTitle = document.getElementById('pageTitle');
    const titles = {
        dashboard: 'Dashboard',
        movies: 'Quản Lý Phim',
        screenings: 'Lịch Chiếu',
        bookings: 'Đặt Vé',
        theaters: 'Phòng Chiếu',
        reports: 'Báo Cáo',
        settings: 'Cài Đặt'
    };
    
    if (pageTitle && titles[sectionName]) {
        pageTitle.textContent = titles[sectionName];
    }
    
    currentSection = sectionName;
    
    // Load section-specific data
    await loadSectionData(sectionName);
    
    // Close mobile menu after navigation
    if (window.innerWidth <= 768) {
        toggleMobileMenu();
    }
}

async function loadSectionData(sectionName) {
    switch (sectionName) {
        case 'dashboard':
            await loadDashboard();
            break;
        case 'movies':
            await loadMoviesTable();
            break;
        case 'bookings':
            await loadBookingsTable();
            break;
        case 'theaters':
            loadTheatersGrid();
            break;
        case 'reports':
            loadReports();
            break;
    }
}

// Dashboard functions
async function loadDashboard() {
    await loadDashboardStats();
    await loadRecentBookings();
    initializeCharts();
}

async function loadDashboardStats() {
    try {
        const stats = await AdminApiService.getDashboardStats();
        
        // Update stat cards
        updateStatCard('movieCount', stats.movieCount || 0, 'Phim Đang Chiếu');
        updateStatCard('todayBookings', stats.todayBookings || 0, 'Vé Đã Bán');
        updateStatCard('todayRevenue', formatCurrency(stats.todayRevenue || 0), 'Doanh Thu (VNĐ)');
        updateStatCard('todayScreenings', stats.todayScreenings || 0, 'Suất Chiếu Hôm Nay');
    } catch (error) {
        console.error('Error loading dashboard stats:', error);
        showNotification('Không thể tải thống kê dashboard', 'error');
    }
}

function updateStatCard(type, value, label) {
    const cards = document.querySelectorAll('.stat-card');
    cards.forEach(card => {
        const content = card.querySelector('.stat-content');
        if (content && content.querySelector('p').textContent.includes(label.split(' ')[0])) {
            content.querySelector('h3').textContent = value;
        }
    });
}

async function loadRecentBookings() {
    const bookingsList = document.getElementById('recentBookingsList');
    if (!bookingsList) return;
    
    try {
        const bookings = await AdminApiService.fetchBookings();
        const recentBookings = bookings.slice(0, 5);
        
        bookingsList.innerHTML = recentBookings.map(booking => `
            <div class="booking-item" style="padding: 1rem; border-bottom: 1px solid #f3f4f6; display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <strong>${booking.user?.name || 'N/A'}</strong>
                    <p style="margin: 0; color: #6b7280; font-size: 0.875rem;">${booking.screening?.movie?.title || 'N/A'}</p>
                    <small style="color: #9ca3af;">${formatDate(booking.bookingTime)} • ${booking.bookedSeats?.length || 0} ghế</small>
                </div>
                <div style="text-align: right;">
                    <p style="margin: 0; font-weight: 600;">${formatCurrency(booking.totalAmount)}</p>
                    <span class="status-badge ${booking.bookingStatus?.toLowerCase()}">${getStatusText(booking.bookingStatus)}</span>
                </div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading recent bookings:', error);
        bookingsList.innerHTML = '<p style="text-align: center; color: #6b7280;">Không thể tải dữ liệu đặt vé</p>';
    }
}

function initializeCharts() {
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart');
    if (revenueCtx) {
        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                datasets: [{
                    label: 'Doanh Thu (triệu VNĐ)',
                    data: [12, 19, 15, 25, 22, 30, 28],
                    borderColor: '#0d9488',
                    backgroundColor: 'rgba(13, 148, 136, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}

// Movies management
async function loadMoviesTable() {
    const tableBody = document.getElementById('moviesTableBody');
    if (!tableBody) return;
    
    try {
        const movies = await AdminApiService.fetchMovies();
        
        if (movies.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: #6b7280;">Chưa có phim nào</td></tr>';
            return;
        }
        
        tableBody.innerHTML = movies.map(movie => `
            <tr>
                <td>
                    <img src="${movie.posterUrl || '/images/placeholder-movie.jpg'}" 
                         alt="${movie.title}" 
                         style="width: 50px; height: 75px; object-fit: cover; border-radius: 0.5rem;">
                </td>
                <td>
                    <strong>${movie.title}</strong>
                </td>
                <td>${movie.genre}</td>
                <td>${movie.durationMin} phút</td>
                <td>
                    <span class="status-badge ${movie.status || 'showing'}">
                        ${movie.status === 'showing' ? 'Đang chiếu' : 'Sắp chiếu'}
                    </span>
                </td>
                <td>
                    <button class="btn btn-secondary" onclick="editMovie(${movie.id})" style="margin-right: 0.5rem;">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-danger" onclick="deleteMovie(${movie.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading movies:', error);
        tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center; color: #dc2626;">Không thể tải dữ liệu phim</td></tr>';
    }
}

function showAddMovieModal() {
    const modal = document.getElementById('addMovieModal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

async function addMovie(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const movieData = {
        title: formData.get('title'),
        genre: formData.get('genre'),
        durationMin: parseInt(formData.get('duration')),
        description: formData.get('description'),
        posterUrl: formData.get('poster'),
        releaseDate: formData.get('releaseDate'),
        status: 'showing'
    };
    
    try {
        const result = await AdminApiService.addMovie(movieData);
        
        if (result.success) {
            await loadMoviesTable();
            closeModal('addMovieModal');
            showNotification('Thêm phim thành công!', 'success');
            event.target.reset();
        } else {
            showNotification(result.message || 'Có lỗi xảy ra khi thêm phim', 'error');
        }
    } catch (error) {
        console.error('Error adding movie:', error);
        showNotification('Không thể thêm phim. Vui lòng thử lại.', 'error');
    }
}

function editMovie(movieId) {
    // TODO: Implement edit movie functionality
    showNotification(`Chỉnh sửa phim ID: ${movieId}`, 'info');
}

async function deleteMovie(movieId) {
    if (confirm('Bạn có chắc chắn muốn xóa phim này?')) {
        try {
            const result = await AdminApiService.deleteMovie(movieId);
            
            if (result.success) {
                await loadMoviesTable();
                showNotification('Đã xóa phim thành công!', 'success');
            } else {
                showNotification(result.message || 'Có lỗi xảy ra khi xóa phim', 'error');
            }
        } catch (error) {
            console.error('Error deleting movie:', error);
            showNotification('Không thể xóa phim. Vui lòng thử lại.', 'error');
        }
    }
}

// Bookings management
async function loadBookingsTable() {
    const tableBody = document.getElementById('bookingsTableBody');
    if (!tableBody) return;
    
    try {
        const bookings = await AdminApiService.fetchBookings();
        
        if (bookings.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: #6b7280;">Chưa có đặt vé nào</td></tr>';
            return;
        }
        
        tableBody.innerHTML = bookings.map(booking => `
            <tr>
                <td><strong>#${booking.id}</strong></td>
                <td>${booking.user?.name || 'N/A'}</td>
                <td>${booking.screening?.movie?.title || 'N/A'}</td>
                <td>${formatDate(booking.bookingTime)}</td>
                <td>${booking.bookedSeats?.length || 0} ghế</td>
                <td>${formatCurrency(booking.totalAmount)}</td>
                <td>
                    <span class="status-badge ${booking.bookingStatus?.toLowerCase()}">${getStatusText(booking.bookingStatus)}</span>
                </td>
                <td>
                    <button class="btn btn-secondary" onclick="viewBooking(${booking.id})" style="margin-right: 0.5rem;">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${booking.bookingStatus === 'RESERVED' ? `
                        <button class="btn btn-primary" onclick="confirmBooking(${booking.id})" style="margin-right: 0.5rem;">
                            <i class="fas fa-check"></i>
                        </button>
                    ` : ''}
                    <button class="btn btn-danger" onclick="cancelBooking(${booking.id})">
                        <i class="fas fa-times"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading bookings:', error);
        tableBody.innerHTML = '<tr><td colspan="8" style="text-align: center; color: #dc2626;">Không thể tải dữ liệu đặt vé</td></tr>';
    }
}

function filterBookings() {
    const statusFilter = document.getElementById('bookingStatusFilter').value;
    const dateFilter = document.getElementById('bookingDateFilter').value;
    
    let filteredBookings = sampleBookings;
    
    if (statusFilter) {
        filteredBookings = filteredBookings.filter(booking => booking.status === statusFilter);
    }
    
    if (dateFilter) {
        filteredBookings = filteredBookings.filter(booking => booking.date === dateFilter);
    }
    
    // Update table with filtered results
    const tableBody = document.getElementById('bookingsTableBody');
    if (tableBody) {
        tableBody.innerHTML = filteredBookings.map(booking => `
            <tr>
                <td><strong>${booking.id}</strong></td>
                <td>${booking.customer}</td>
                <td>${booking.movie}</td>
                <td>${formatDate(booking.date)}</td>
                <td>${booking.seats}</td>
                <td>${formatCurrency(booking.amount)}</td>
                <td>
                    <span class="status-badge ${booking.status}">${getStatusText(booking.status)}</span>
                </td>
                <td>
                    <button class="btn btn-secondary" onclick="viewBooking('${booking.id}')" style="margin-right: 0.5rem;">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${booking.status === 'pending' ? `
                        <button class="btn btn-primary" onclick="confirmBooking('${booking.id}')" style="margin-right: 0.5rem;">
                            <i class="fas fa-check"></i>
                        </button>
                    ` : ''}
                    <button class="btn btn-danger" onclick="cancelBooking('${booking.id}')">
                        <i class="fas fa-times"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    }
}

function viewBooking(bookingId) {
    const booking = sampleBookings.find(b => b.id === bookingId);
    if (booking) {
        showNotification(`Xem chi tiết booking: ${booking.id}`, 'info');
    }
}

function confirmBooking(bookingId) {
    const booking = sampleBookings.find(b => b.id === bookingId);
    if (booking) {
        booking.status = 'confirmed';
        loadBookingsTable();
        showNotification('Đã xác nhận booking thành công!', 'success');
    }
}

function cancelBooking(bookingId) {
    if (confirm('Bạn có chắc chắn muốn hủy booking này?')) {
        const booking = sampleBookings.find(b => b.id === bookingId);
        if (booking) {
            booking.status = 'cancelled';
            loadBookingsTable();
            showNotification('Đã hủy booking thành công!', 'warning');
        }
    }
}

// Theaters management
function loadTheatersGrid() {
    const theatersGrid = document.getElementById('theatersGrid');
    if (!theatersGrid) return;
    
    theatersGrid.innerHTML = sampleTheaters.map(theater => `
        <div class="theater-card">
            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                <h4 style="margin: 0; color: var(--text-color);">${theater.name}</h4>
                <span class="status-badge ${theater.status}">
                    ${theater.status === 'active' ? 'Hoạt động' : 'Bảo trì'}
                </span>
            </div>
            <div style="margin-bottom: 1rem;">
                <p style="margin: 0.25rem 0; color: var(--light-text);">
                    <i class="fas fa-users" style="margin-right: 0.5rem;"></i>
                    Sức chứa: ${theater.capacity} ghế
                </p>
                <p style="margin: 0.25rem 0; color: var(--light-text);">
                    <i class="fas fa-tv" style="margin-right: 0.5rem;"></i>
                    Loại: ${theater.type}
                </p>
            </div>
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-secondary" onclick="editTheater(${theater.id})" style="flex: 1;">
                    <i class="fas fa-edit"></i> Chỉnh sửa
                </button>
                <button class="btn btn-primary" onclick="manageSeats(${theater.id})" style="flex: 1;">
                    <i class="fas fa-couch"></i> Quản lý ghế
                </button>
            </div>
        </div>
    `).join('');
}

function showAddTheaterModal() {
    showNotification('Tính năng thêm phòng chiếu đang được phát triển', 'info');
}

function editTheater(theaterId) {
    const theater = sampleTheaters.find(t => t.id === theaterId);
    if (theater) {
        showNotification(`Chỉnh sửa ${theater.name}`, 'info');
    }
}

function manageSeats(theaterId) {
    const theater = sampleTheaters.find(t => t.id === theaterId);
    if (theater) {
        showNotification(`Quản lý ghế cho ${theater.name}`, 'info');
    }
}

// Reports
function loadReports() {
    initializeReportCharts();
}

function initializeReportCharts() {
    // Movie Revenue Chart
    const movieRevenueCtx = document.getElementById('movieRevenueChart');
    if (movieRevenueCtx) {
        new Chart(movieRevenueCtx, {
            type: 'doughnut',
            data: {
                labels: ['Avatar', 'Spider-Man', 'Top Gun', 'Other'],
                datasets: [{
                    data: [45, 30, 15, 10],
                    backgroundColor: [
                        '#0d9488',
                        '#fbbf24',
                        '#ef4444',
                        '#8b5cf6'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Occupancy Chart
    const occupancyCtx = document.getElementById('occupancyChart');
    if (occupancyCtx) {
        new Chart(occupancyCtx, {
            type: 'bar',
            data: {
                labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                datasets: [{
                    label: 'Tỷ lệ lấp đầy (%)',
                    data: [65, 72, 68, 85, 92, 95, 88],
                    backgroundColor: '#0d9488'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });
    }
}

function generateReport() {
    const startDate = document.getElementById('reportStartDate').value;
    const endDate = document.getElementById('reportEndDate').value;
    
    if (!startDate || !endDate) {
        showNotification('Vui lòng chọn khoảng thời gian', 'warning');
        return;
    }
    
    showNotification(`Tạo báo cáo từ ${formatDate(startDate)} đến ${formatDate(endDate)}`, 'success');
}

// Settings
function saveSettings() {
    const settings = {
        theaterName: document.getElementById('theaterName').value,
        theaterAddress: document.getElementById('theaterAddress').value,
        theaterPhone: document.getElementById('theaterPhone').value,
        normalTicketPrice: document.getElementById('normalTicketPrice').value,
        vipTicketPrice: document.getElementById('vipTicketPrice').value,
        weekendTicketPrice: document.getElementById('weekendTicketPrice').value,
        emailServer: document.getElementById('emailServer').value,
        emailUsername: document.getElementById('emailUsername').value
    };
    
    // Save to localStorage for demo
    localStorage.setItem('theaterSettings', JSON.stringify(settings));
    showNotification('Đã lưu cài đặt thành công!', 'success');
}

// Modal functions
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto';
    }
}

// Form handlers
function setupFormHandlers() {
    const addMovieForm = document.getElementById('addMovieForm');
    if (addMovieForm) {
        addMovieForm.addEventListener('submit', addMovie);
    }
}

// Search function
function handleGlobalSearch(event) {
    const query = event.target.value.toLowerCase();
    console.log('Searching for:', query);
    
    // Implement search logic based on current section
    switch (currentSection) {
        case 'movies':
            searchMovies(query);
            break;
        case 'bookings':
            searchBookings(query);
            break;
    }
}

function searchMovies(query) {
    const filteredMovies = sampleMovies.filter(movie => 
        movie.title.toLowerCase().includes(query) ||
        movie.genre.toLowerCase().includes(query)
    );
    
    // Update movies table with filtered results
    updateMoviesTable(filteredMovies);
}

function searchBookings(query) {
    const filteredBookings = sampleBookings.filter(booking => 
        booking.customer.toLowerCase().includes(query) ||
        booking.movie.toLowerCase().includes(query) ||
        booking.id.toLowerCase().includes(query)
    );
    
    // Update bookings table with filtered results
    updateBookingsTable(filteredBookings);
}

function updateMoviesTable(movies) {
    const tableBody = document.getElementById('moviesTableBody');
    if (!tableBody) return;
    
    tableBody.innerHTML = movies.map(movie => `
        <tr>
            <td>
                <img src="${movie.poster}" alt="${movie.title}" style="width: 50px; height: 75px; object-fit: cover; border-radius: 0.5rem;">
            </td>
            <td><strong>${movie.title}</strong></td>
            <td>${movie.genre}</td>
            <td>${movie.duration} phút</td>
            <td>
                <span class="status-badge ${movie.status}">
                    ${movie.status === 'showing' ? 'Đang chiếu' : 'Sắp chiếu'}
                </span>
            </td>
            <td>
                <button class="btn btn-secondary" onclick="editMovie(${movie.id})" style="margin-right: 0.5rem;">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-danger" onclick="deleteMovie(${movie.id})">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function updateBookingsTable(bookings) {
    const tableBody = document.getElementById('bookingsTableBody');
    if (!tableBody) return;
    
    tableBody.innerHTML = bookings.map(booking => `
        <tr>
            <td><strong>${booking.id}</strong></td>
            <td>${booking.customer}</td>
            <td>${booking.movie}</td>
            <td>${formatDate(booking.date)}</td>
            <td>${booking.seats}</td>
            <td>${formatCurrency(booking.amount)}</td>
            <td>
                <span class="status-badge ${booking.status}">${getStatusText(booking.status)}</span>
            </td>
            <td>
                <button class="btn btn-secondary" onclick="viewBooking('${booking.id}')" style="margin-right: 0.5rem;">
                    <i class="fas fa-eye"></i>
                </button>
                ${booking.status === 'pending' ? `
                    <button class="btn btn-primary" onclick="confirmBooking('${booking.id}')" style="margin-right: 0.5rem;">
                        <i class="fas fa-check"></i>
                    </button>
                ` : ''}
                <button class="btn btn-danger" onclick="cancelBooking('${booking.id}')">
                    <i class="fas fa-times"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('vi-VN');
}

function getStatusText(status) {
    const statusTexts = {
        'CONFIRMED': 'Đã xác nhận',
        'RESERVED': 'Đã đặt',
        'CANCELLED': 'Đã hủy',
        'confirmed': 'Đã xác nhận',
        'pending': 'Chờ xử lý',
        'cancelled': 'Đã hủy',
        'active': 'Hoạt động',
        'maintenance': 'Bảo trì',
        'showing': 'Đang chiếu',
        'coming-soon': 'Sắp chiếu'
    };
    
    return statusTexts[status] || status;
}

function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div style="
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#10b981' : type === 'warning' ? '#f59e0b' : type === 'error' ? '#ef4444' : '#3b82f6'};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            z-index: 10000;
            animation: slideIn 0.3s ease;
        ">
            <i class="fas fa-${type === 'success' ? 'check' : type === 'warning' ? 'exclamation-triangle' : type === 'error' ? 'times' : 'info'}-circle" style="margin-right: 0.5rem;"></i>
            ${message}
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

function logout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        showNotification('Đăng xuất thành công!', 'success');
        setTimeout(() => {
            window.location.href = '/';
        }, 1000);
    }
}

// Add CSS animation for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
`;
document.head.appendChild(style);
