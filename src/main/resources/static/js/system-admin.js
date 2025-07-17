/**
 * System Admin Dashboard JavaScript
 * Handles all system administration functionality
 */

class SystemAdminApp {
    constructor() {
        this.currentPage = 'dashboard';
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadDashboardData();
        this.setupModal();
    }

    setupEventListeners() {
        // Navigation menu
        document.querySelectorAll('.sidebar .nav-item').forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const page = e.currentTarget.dataset.page;
                this.switchPage(page);
            });
        });

        // User management
        document.getElementById('addUserBtn')?.addEventListener('click', () => this.showAddUserModal());
        document.getElementById('addTheaterBtn')?.addEventListener('click', () => this.showAddTheaterModal());
        document.getElementById('addAdminBtn')?.addEventListener('click', () => this.showAddAdminModal());

        // Form submissions
        document.getElementById('userForm')?.addEventListener('submit', (e) => this.handleUserForm(e));
        document.getElementById('theaterForm')?.addEventListener('submit', (e) => this.handleTheaterForm(e));
        document.getElementById('adminForm')?.addEventListener('submit', (e) => this.handleAdminForm(e));

        // Search functionality
        document.getElementById('userSearch')?.addEventListener('input', (e) => this.searchUsers(e.target.value));
        document.getElementById('theaterSearch')?.addEventListener('input', (e) => this.searchTheaters(e.target.value));
        document.getElementById('adminSearch')?.addEventListener('input', (e) => this.searchAdmins(e.target.value));

        // Filter functionality
        document.getElementById('userStatusFilter')?.addEventListener('change', (e) => this.filterUsers(e.target.value));
        document.getElementById('theaterStatusFilter')?.addEventListener('change', (e) => this.filterTheaters(e.target.value));
    }

    switchPage(page) {
        // Update active navigation
        document.querySelectorAll('.sidebar .nav-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-page="${page}"]`)?.classList.add('active');

        // Hide all pages
        document.querySelectorAll('.page-content').forEach(content => {
            content.style.display = 'none';
        });

        // Show selected page
        const pageElement = document.getElementById(`${page}Page`);
        if (pageElement) {
            pageElement.style.display = 'block';
            this.currentPage = page;
            this.loadPageData(page);
        }
    }

    loadPageData(page) {
        switch (page) {
            case 'dashboard':
                this.loadDashboardData();
                break;
            case 'users':
                this.loadUsersData();
                break;
            case 'theaters':
                this.loadTheatersData();
                break;
            case 'admins':
                this.loadAdminsData();
                break;
            case 'reports':
                this.loadReportsData();
                break;
            case 'system':
                this.loadSystemData();
                break;
        }
    }

    async loadDashboardData() {
        try {
            // Simulate API calls for dashboard statistics
            const stats = await this.fetchDashboardStats();
            this.updateDashboardStats(stats);
            this.loadRecentActivities();
            this.loadSystemHealth();
        } catch (error) {
            console.error('Error loading dashboard data:', error);
            this.showError('Không thể tải dữ liệu dashboard');
        }
    }

    async fetchDashboardStats() {
        // Simulate API call - replace with actual endpoint
        return new Promise(resolve => {
            setTimeout(() => {
                resolve({
                    totalUsers: 15847,
                    totalTheaters: 125,
                    totalBookings: 98453,
                    totalRevenue: 2345000000,
                    activeUsers: 8954,
                    activeTheaters: 118,
                    todayBookings: 1250,
                    todayRevenue: 45000000
                });
            }, 500);
        });
    }

    updateDashboardStats(stats) {
        document.getElementById('totalUsers').textContent = stats.totalUsers.toLocaleString();
        document.getElementById('totalTheaters').textContent = stats.totalTheaters.toLocaleString();
        document.getElementById('totalBookings').textContent = stats.totalBookings.toLocaleString();
        document.getElementById('totalRevenue').textContent = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(stats.totalRevenue);

        document.getElementById('activeUsers').textContent = stats.activeUsers.toLocaleString();
        document.getElementById('activeTheaters').textContent = stats.activeTheaters.toLocaleString();
        document.getElementById('todayBookings').textContent = stats.todayBookings.toLocaleString();
        document.getElementById('todayRevenue').textContent = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(stats.todayRevenue);
    }

    async loadUsersData() {
        try {
            this.showLoading('usersTable');
            const users = await this.fetchUsers();
            this.renderUsersTable(users);
        } catch (error) {
            console.error('Error loading users:', error);
            this.showError('Không thể tải danh sách người dùng');
        }
    }

    async fetchUsers() {
        // Simulate API call - replace with actual endpoint
        return new Promise(resolve => {
            setTimeout(() => {
                resolve([
                    {
                        id: 1,
                        username: 'nguyenvan_a',
                        email: 'nguyenvana@email.com',
                        fullName: 'Nguyễn Văn A',
                        phone: '0901234567',
                        status: 'active',
                        role: 'customer',
                        registeredDate: '2024-01-15',
                        lastLogin: '2024-12-20'
                    },
                    {
                        id: 2,
                        username: 'tranthib',
                        email: 'tranthib@email.com',
                        fullName: 'Trần Thị B',
                        phone: '0902345678',
                        status: 'active',
                        role: 'customer',
                        registeredDate: '2024-02-10',
                        lastLogin: '2024-12-19'
                    },
                    {
                        id: 3,
                        username: 'admin_hcm',
                        email: 'admin.hcm@cinema.com',
                        fullName: 'Lê Văn C',
                        phone: '0903456789',
                        status: 'active',
                        role: 'theater_admin',
                        registeredDate: '2024-01-01',
                        lastLogin: '2024-12-20'
                    }
                ]);
            }, 800);
        });
    }

    renderUsersTable(users) {
        const tbody = document.querySelector('#usersTable tbody');
        if (!tbody) return;

        tbody.innerHTML = users.map(user => `
            <tr>
                <td>${user.id}</td>
                <td>
                    <div class="user-info">
                        <strong>${user.fullName}</strong>
                        <small>${user.username}</small>
                    </div>
                </td>
                <td>${user.email}</td>
                <td>${user.phone}</td>
                <td>
                    <span class="badge badge-${user.status === 'active' ? 'success' : 'danger'}">
                        ${user.status === 'active' ? 'Hoạt động' : 'Tạm khóa'}
                    </span>
                </td>
                <td>
                    <span class="badge badge-info">
                        ${this.getRoleDisplayName(user.role)}
                    </span>
                </td>
                <td>${this.formatDate(user.lastLogin)}</td>
                <td>
                    <div class="action-buttons">
                        <button class="btn btn-sm btn-outline-primary" onclick="systemAdmin.editUser(${user.id})">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-${user.status === 'active' ? 'warning' : 'success'}" 
                                onclick="systemAdmin.toggleUserStatus(${user.id})">
                            <i class="fas fa-${user.status === 'active' ? 'lock' : 'unlock'}"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger" onclick="systemAdmin.deleteUser(${user.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    async loadTheatersData() {
        try {
            this.showLoading('theatersTable');
            const theaters = await this.fetchTheaters();
            this.renderTheatersTable(theaters);
        } catch (error) {
            console.error('Error loading theaters:', error);
            this.showError('Không thể tải danh sách rạp chiếu');
        }
    }

    async fetchTheaters() {
        // Simulate API call - replace with actual endpoint
        return new Promise(resolve => {
            setTimeout(() => {
                resolve([
                    {
                        id: 1,
                        name: 'CGV Vincom Center',
                        location: 'Quận 1, TP.HCM',
                        address: '70-72 Lê Thánh Tôn, Quận 1, TP.HCM',
                        phone: '028-1234567',
                        manager: 'Nguyễn Văn Manager',
                        status: 'active',
                        auditoriums: 8,
                        totalSeats: 1200,
                        revenue: 150000000
                    },
                    {
                        id: 2,
                        name: 'Lotte Cinema Landmark',
                        location: 'Quận 3, TP.HCM',
                        address: '720A Điện Biên Phủ, Quận 3, TP.HCM',
                        phone: '028-2345678',
                        manager: 'Trần Thị Manager',
                        status: 'active',
                        auditoriums: 10,
                        totalSeats: 1500,
                        revenue: 200000000
                    }
                ]);
            }, 800);
        });
    }

    renderTheatersTable(theaters) {
        const tbody = document.querySelector('#theatersTable tbody');
        if (!tbody) return;

        tbody.innerHTML = theaters.map(theater => `
            <tr>
                <td>${theater.id}</td>
                <td>
                    <div class="theater-info">
                        <strong>${theater.name}</strong>
                        <small>${theater.location}</small>
                    </div>
                </td>
                <td>${theater.address}</td>
                <td>${theater.phone}</td>
                <td>${theater.manager}</td>
                <td>
                    <span class="badge badge-${theater.status === 'active' ? 'success' : 'danger'}">
                        ${theater.status === 'active' ? 'Hoạt động' : 'Tạm đóng'}
                    </span>
                </td>
                <td>${theater.auditoriums}</td>
                <td>${theater.totalSeats}</td>
                <td>${new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(theater.revenue)}</td>
                <td>
                    <div class="action-buttons">
                        <button class="btn btn-sm btn-outline-primary" onclick="systemAdmin.editTheater(${theater.id})">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-info" onclick="systemAdmin.viewTheaterDetails(${theater.id})">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-${theater.status === 'active' ? 'warning' : 'success'}" 
                                onclick="systemAdmin.toggleTheaterStatus(${theater.id})">
                            <i class="fas fa-${theater.status === 'active' ? 'pause' : 'play'}"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    // Modal management
    setupModal() {
        const modal = document.getElementById('adminModal');
        const closeBtn = modal?.querySelector('.close');
        
        closeBtn?.addEventListener('click', () => this.hideModal());
        
        modal?.addEventListener('click', (e) => {
            if (e.target === modal) this.hideModal();
        });
    }

    showModal(title, content) {
        const modal = document.getElementById('adminModal');
        const modalTitle = modal?.querySelector('.modal-title');
        const modalBody = modal?.querySelector('.modal-body');
        
        if (modalTitle) modalTitle.textContent = title;
        if (modalBody) modalBody.innerHTML = content;
        
        modal?.style.setProperty('display', 'block');
        setTimeout(() => modal?.classList.add('show'), 10);
    }

    hideModal() {
        const modal = document.getElementById('adminModal');
        modal?.classList.remove('show');
        setTimeout(() => modal?.style.setProperty('display', 'none'), 300);
    }

    showAddUserModal() {
        const content = `
            <form id="userForm">
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="userFullName">Họ tên *</label>
                        <input type="text" class="form-control" id="userFullName" required>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="userUsername">Tên đăng nhập *</label>
                        <input type="text" class="form-control" id="userUsername" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="userEmail">Email *</label>
                        <input type="email" class="form-control" id="userEmail" required>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="userPhone">Số điện thoại *</label>
                        <input type="tel" class="form-control" id="userPhone" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="userRole">Vai trò *</label>
                        <select class="form-control" id="userRole" required>
                            <option value="customer">Khách hàng</option>
                            <option value="theater_admin">Quản lý rạp</option>
                            <option value="system_admin">Quản trị viên</option>
                        </select>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="userPassword">Mật khẩu *</label>
                        <input type="password" class="form-control" id="userPassword" required>
                    </div>
                </div>
                <div class="form-group">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="sendWelcomeEmail" checked>
                        <label class="form-check-label" for="sendWelcomeEmail">
                            Gửi email chào mừng
                        </label>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="systemAdmin.hideModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
                </div>
            </form>
        `;
        this.showModal('Thêm tài khoản mới', content);
    }

    // Utility methods
    getRoleDisplayName(role) {
        const roleMap = {
            'customer': 'Khách hàng',
            'theater_admin': 'Quản lý rạp',
            'system_admin': 'Quản trị viên'
        };
        return roleMap[role] || role;
    }

    formatDate(dateString) {
        return new Date(dateString).toLocaleDateString('vi-VN');
    }

    showLoading(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.innerHTML = `
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin"></i>
                    <span>Đang tải...</span>
                </div>
            `;
        }
    }

    showError(message) {
        // Simple error notification
        const notification = document.createElement('div');
        notification.className = 'error-notification';
        notification.textContent = message;
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 5000);
    }

    showSuccess(message) {
        // Simple success notification
        const notification = document.createElement('div');
        notification.className = 'success-notification';
        notification.textContent = message;
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    // CRUD operations
    async editUser(id) {
        try {
            const user = await this.fetchUserById(id);
            // Show edit modal with user data
            console.log('Edit user:', user);
        } catch (error) {
            this.showError('Không thể tải thông tin người dùng');
        }
    }

    async toggleUserStatus(id) {
        if (confirm('Bạn có chắc chắn muốn thay đổi trạng thái người dùng này?')) {
            try {
                // API call to toggle status
                this.showSuccess('Đã cập nhật trạng thái người dùng');
                this.loadUsersData();
            } catch (error) {
                this.showError('Không thể cập nhật trạng thái người dùng');
            }
        }
    }

    async deleteUser(id) {
        if (confirm('Bạn có chắc chắn muốn xóa người dùng này? Hành động này không thể hoàn tác.')) {
            try {
                // API call to delete user
                this.showSuccess('Đã xóa người dùng');
                this.loadUsersData();
            } catch (error) {
                this.showError('Không thể xóa người dùng');
            }
        }
    }

    searchUsers(query) {
        // Implement user search functionality
        console.log('Search users:', query);
    }

    filterUsers(status) {
        // Implement user filtering functionality
        console.log('Filter users by status:', status);
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.systemAdmin = new SystemAdminApp();
});
