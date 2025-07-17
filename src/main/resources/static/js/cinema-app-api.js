/**
 * Cinema Booking App - Enhanced JavaScript with TMDB Integration
 * Handles all customer-facing functionality with modern API integration
 */

const API_BASE_URL = '/api';

class CinemaApp {
    constructor() {
        this.selectedMovie = null;
        this.selectedTheater = null;
        this.selectedDate = null;
        this.selectedTime = null;
        this.selectedSeats = [];
        this.currentScreening = null;
        this.currentUser = null;
        this.init();
    }

    init() {
        this.loadCurrentUser();
        this.loadMovies();
        this.setupEventListeners();
        this.setupModals();
    }

    async loadCurrentUser() {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/current-user`);
            if (response.ok) {
                this.currentUser = await response.json();
            }
        } catch (error) {
            console.log('User not authenticated or error loading user data');
        }
    }

    setupEventListeners() {
        // Search functionality
        const searchForm = document.getElementById('movieSearchForm');
        if (searchForm) {
            searchForm.addEventListener('submit', (e) => this.handleSearch(e));
        }

        // Global search functionality
        const searchInput = document.querySelector('.search-input');
        const searchBtn = document.querySelector('.search-btn');
        
        if (searchInput && searchBtn) {
            searchBtn.addEventListener('click', () => this.performSearch(searchInput.value));
            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') this.performSearch(searchInput.value);
            });
        }
    }

    async loadMovies() {
        try {
            console.log('Loading movies...');
            this.showLoading();
            
            // Load movies from integrated database (includes TMDB data)
            const response = await fetch(`${API_BASE_URL}/movies`);
            console.log('Response status:', response.status);
            
            if (!response.ok) {
                throw new Error('Failed to load movies');
            }
            
            const movies = await response.json();
            console.log('Movies loaded:', movies);
            this.displayMovies(movies);
            
        } catch (error) {
            console.error('Error loading movies:', error);
            this.showError('Không thể tải danh sách phim. Vui lòng thử lại sau.');
        } finally {
            this.hideLoading();
        }
    }

    displayMovies(movies) {
        console.log('Displaying movies:', movies);
        const container = document.getElementById('moviesContainer');
        console.log('Container found:', container);
        if (!container) {
            console.warn('Movies container not found');
            return;
        }

        if (!movies || movies.length === 0) {
            console.log('No movies to display');
            container.innerHTML = '';
            this.showNoMovies();
            return;
        }

        // Convert container to Bootstrap row if needed
        container.className = 'row';
        container.innerHTML = movies.map(movie => this.createMovieCard(movie)).join('');
        console.log('Movies displayed successfully, count:', movies.length);
        this.hideNoMovies();
        
        // Add hover effects for movie cards
        this.addMovieCardEffects();
    }

    createMovieCard(movie) {
        const imageUrl = movie.posterUrl || movie.imageUrl || movie.backdropUrl || '/images/no-poster.jpg';
        const rating = movie.voteAverage ? movie.voteAverage.toFixed(1) : 'N/A';
        const year = movie.releaseDate ? new Date(movie.releaseDate).getFullYear() : '';
        
        return `
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="card movie-card h-100 fade-in" onclick="app.showMovieDetail(${movie.id})" style="cursor: pointer;">
                    <div class="movie-poster-container position-relative">
                        <img src="${imageUrl}" alt="${movie.title}" class="card-img-top movie-poster" style="height: 300px; object-fit: cover;">
                        <div class="movie-overlay position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center" style="background: rgba(0,0,0,0.7); opacity: 0; transition: opacity 0.3s;">
                            <button class="btn btn-primary">
                                <i class="fas fa-play me-2"></i>Xem Chi Tiết
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title movie-title">${movie.title}</h5>
                        <p class="card-text text-muted movie-genre">${movie.genre || 'Đang cập nhật'}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="movie-rating">
                                <span class="rating-stars text-warning">
                                    ${this.generateStars(rating)}
                                </span>
                                <small class="text-muted ms-1">${rating}/10</small>
                            </div>
                            <div class="movie-meta">
                                <small class="text-muted">${year}</small>
                                ${movie.tmdbId ? '<span class="badge bg-info ms-2">TMDB</span>' : ''}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    generateStars(rating) {
        const stars = Math.round(rating / 2); // Convert 10-point to 5-star
        let starsHtml = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= stars) {
                starsHtml += '<i class="fas fa-star"></i>';
            } else {
                starsHtml += '<i class="far fa-star"></i>';
            }
        }
        return starsHtml;
    }

    async showMovieDetail(movieId) {
        try {
            // Load movie details
            const movieResponse = await fetch(`${API_BASE_URL}/movies/${movieId}`);
            if (!movieResponse.ok) {
                throw new Error('Movie not found');
            }
            
            const movie = await movieResponse.json();
            
            // Load theaters and screenings
            const theatersResponse = await fetch(`${API_BASE_URL}/theaters`);
            const theaters = theatersResponse.ok ? await theatersResponse.json() : [];
            
            const screeningsResponse = await fetch(`${API_BASE_URL}/screenings/movie/${movieId}`);
            const screenings = screeningsResponse.ok ? await screeningsResponse.json() : [];
            
            this.showMovieModal(movie, theaters, screenings);
            
        } catch (error) {
            console.error('Error loading movie details:', error);
            this.showError('Không thể tải thông tin phim.');
        }
    }

    showMovieModal(movie, theaters, screenings) {
        // Create and show movie detail modal
        const modalHtml = this.createMovieModalHtml(movie, theaters, screenings);
        
        // Remove existing modal if any
        const existingModal = document.getElementById('movieModal');
        if (existingModal) {
            existingModal.remove();
        }
        
        // Add modal to page
        document.body.insertAdjacentHTML('beforeend', modalHtml);
        
        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('movieModal'));
        modal.show();
        
        // Setup modal event listeners
        this.setupModalEventListeners();
    }

    createMovieModalHtml(movie, theaters, screenings) {
        const imageUrl = movie.imageUrl || movie.backdropUrl || '/images/no-poster.jpg';
        const rating = movie.voteAverage ? movie.voteAverage.toFixed(1) : 'N/A';
        
        return `
            <div class="modal fade" id="movieModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">${movie.title}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <img src="${imageUrl}" alt="${movie.title}" class="img-fluid rounded">
                                </div>
                                <div class="col-md-8">
                                    <h4>${movie.title}</h4>
                                    ${movie.originalTitle && movie.originalTitle !== movie.title ? 
                                        `<p class="text-muted">${movie.originalTitle}</p>` : ''}
                                    
                                    <div class="mb-3">
                                        <span class="badge bg-primary me-2">${movie.genre || 'Đang cập nhật'}</span>
                                        <span class="rating text-warning">
                                            <i class="fas fa-star"></i> ${rating}/10
                                        </span>
                                    </div>
                                    
                                    <p>${movie.description || 'Đang cập nhật mô tả phim...'}</p>
                                    
                                    <div class="row mb-3">
                                        <div class="col-sm-6">
                                            <strong>Ngày phát hành:</strong><br>
                                            ${movie.releaseDate ? new Date(movie.releaseDate).toLocaleDateString('vi-VN') : 'Đang cập nhật'}
                                        </div>
                                        <div class="col-sm-6">
                                            <strong>Thời lượng:</strong><br>
                                            ${movie.duration || 'Đang cập nhật'} phút
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <hr>
                            
                            <!-- Booking Section -->
                            <div id="bookingSection">
                                ${this.currentUser ? this.createBookingSection(theaters, screenings) : this.createLoginPrompt()}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    createBookingSection(theaters, screenings) {
        return `
            <h5>Đặt Vé</h5>
            <div class="row">
                <div class="col-md-6">
                    <label class="form-label">Chọn rạp:</label>
                    <select class="form-select" id="theaterSelect">
                        <option value="">-- Chọn rạp --</option>
                        ${theaters.map(theater => 
                            `<option value="${theater.id}">${theater.name} - ${theater.location}</option>`
                        ).join('')}
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Chọn ngày:</label>
                    <input type="date" class="form-control" id="dateSelect" min="${new Date().toISOString().split('T')[0]}">
                </div>
            </div>
            
            <div class="row mt-3">
                <div class="col-12">
                    <label class="form-label">Chọn suất chiếu:</label>
                    <div id="timeSlots" class="d-flex flex-wrap gap-2">
                        <small class="text-muted w-100">Vui lòng chọn rạp và ngày để xem suất chiếu</small>
                    </div>
                </div>
            </div>
            
            <div class="mt-3">
                <button class="btn btn-primary" id="proceedBooking" disabled>
                    <i class="fas fa-ticket-alt me-2"></i>Tiếp Tục Đặt Vé
                </button>
            </div>
        `;
    }

    createLoginPrompt() {
        return `
            <div class="text-center">
                <h5>Đăng nhập để đặt vé</h5>
                <p class="text-muted">Bạn cần đăng nhập để có thể đặt vé xem phim</p>
                <a href="/auth/login" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt me-2"></i>Đăng Nhập
                </a>
                <a href="/auth/register" class="btn btn-outline-primary ms-2">
                    <i class="fas fa-user-plus me-2"></i>Đăng Ký
                </a>
            </div>
        `;
    }

    setupModalEventListeners() {
        const theaterSelect = document.getElementById('theaterSelect');
        const dateSelect = document.getElementById('dateSelect');
        const proceedButton = document.getElementById('proceedBooking');
        
        if (theaterSelect) {
            theaterSelect.addEventListener('change', () => this.updateTimeSlots());
        }
        
        if (dateSelect) {
            dateSelect.addEventListener('change', () => this.updateTimeSlots());
        }
        
        if (proceedButton) {
            proceedButton.addEventListener('click', () => this.proceedToBooking());
        }
    }

    async updateTimeSlots() {
        const theaterId = document.getElementById('theaterSelect')?.value;
        const selectedDate = document.getElementById('dateSelect')?.value;
        const timeSlotsContainer = document.getElementById('timeSlots');
        
        if (!theaterId || !selectedDate || !timeSlotsContainer) return;
        
        try {
            const response = await fetch(`${API_BASE_URL}/screenings/theater/${theaterId}/date/${selectedDate}`);
            if (!response.ok) throw new Error('Failed to load screenings');
            
            const screenings = await response.json();
            
            if (screenings.length === 0) {
                timeSlotsContainer.innerHTML = '<small class="text-muted">Không có suất chiếu cho ngày này</small>';
                return;
            }
            
            timeSlotsContainer.innerHTML = screenings.map(screening => `
                <button class="btn btn-outline-primary btn-sm time-slot" 
                        data-screening-id="${screening.id}" 
                        data-time="${screening.startTime}">
                    ${new Date(screening.startTime).toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'})}
                </button>
            `).join('');
            
            // Add click handlers for time slots
            document.querySelectorAll('.time-slot').forEach(button => {
                button.addEventListener('click', (e) => this.selectTimeSlot(e.target));
            });
            
        } catch (error) {
            console.error('Error loading time slots:', error);
            timeSlotsContainer.innerHTML = '<small class="text-danger">Lỗi khi tải suất chiếu</small>';
        }
    }

    selectTimeSlot(button) {
        // Remove active class from other buttons
        document.querySelectorAll('.time-slot').forEach(btn => btn.classList.remove('active'));
        
        // Add active class to selected button
        button.classList.add('active');
        
        // Store selected screening
        this.currentScreening = {
            id: button.dataset.screeningId,
            time: button.dataset.time
        };
        
        // Enable proceed button
        const proceedButton = document.getElementById('proceedBooking');
        if (proceedButton) {
            proceedButton.disabled = false;
        }
    }

    proceedToBooking() {
        if (!this.currentScreening) return;
        
        // Close modal and redirect to booking page
        const modal = bootstrap.Modal.getInstance(document.getElementById('movieModal'));
        modal.hide();
        
        // Redirect to seat selection page
        window.location.href = `/booking/screening/${this.currentScreening.id}`;
    }

    async handleSearch(event) {
        event.preventDefault();
        
        const formData = new FormData(event.target);
        const searchParams = Object.fromEntries(formData);
        
        await this.searchMovies(searchParams);
    }

    async searchMovies(searchParams) {
        try {
            this.showLoading();
            
            const queryString = new URLSearchParams(searchParams).toString();
            const response = await fetch(`${API_BASE_URL}/movies/search?${queryString}`);
            
            if (!response.ok) {
                throw new Error('Search failed');
            }
            
            const movies = await response.json();
            this.displayMovies(movies);
            
        } catch (error) {
            console.error('Search error:', error);
            this.showError('Lỗi khi tìm kiếm phim.');
        } finally {
            this.hideLoading();
        }
    }

    setupModals() {
        // Setup any global modal behaviors
    }

    showLoading() {
        const loadingElement = document.getElementById('loadingSpinner');
        if (loadingElement) {
            loadingElement.classList.remove('d-none');
        }
    }

    hideLoading() {
        const loadingElement = document.getElementById('loadingSpinner');
        if (loadingElement) {
            loadingElement.classList.add('d-none');
        }
    }

    showNoMovies() {
        const noMoviesElement = document.getElementById('noMoviesMessage');
        if (noMoviesElement) {
            noMoviesElement.classList.remove('d-none');
        }
    }

    hideNoMovies() {
        const noMoviesElement = document.getElementById('noMoviesMessage');
        if (noMoviesElement) {
            noMoviesElement.classList.add('d-none');
        }
    }

    showError(message) {
        // Create and show error alert
        const alertHtml = `
            <div class="alert alert-danger alert-dismissible fade show alert-fixed" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        `;
        
        document.body.insertAdjacentHTML('beforeend', alertHtml);
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            const alert = document.querySelector('.alert-fixed');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }

    addMovieCardEffects() {
        // Add hover effects to movie cards
        document.querySelectorAll('.movie-card').forEach(card => {
            const overlay = card.querySelector('.movie-overlay');
            
            card.addEventListener('mouseenter', function() {
                if (overlay) overlay.style.opacity = '1';
            });
            
            card.addEventListener('mouseleave', function() {
                if (overlay) overlay.style.opacity = '0';
            });
        });
    }
}

// Initialize the app
let app;
document.addEventListener('DOMContentLoaded', function() {
    app = new CinemaApp();
    
    // Make app available globally for onclick handlers
    window.CinemaApp = app;
    window.app = app;
    
    // Setup search form if exists
    const searchForm = document.getElementById('movieSearchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const searchParams = Object.fromEntries(formData);
            app.searchMovies(searchParams);
        });
    }
});
