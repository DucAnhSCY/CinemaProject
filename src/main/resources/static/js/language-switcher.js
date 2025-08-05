// Language Switcher for Cinema Paradise
let currentLang = localStorage.getItem('language') || 'vi';

// Translation data
const translations = {
    vi: {
        // Navigation
        home: 'Trang Chủ',
        movies: 'Phim',
        theaters: 'Rạp Chiếu',
        promotions: 'Khuyến Mãi',
        profile: 'Hồ Sơ',
        myBookings: 'Vé Đã Đặt',
        login: 'Đăng Nhập',
        register: 'Đăng Ký',
        logout: 'Đăng Xuất',
        admin: 'Quản Trị',
        currentLanguage: 'Tiếng Việt',
        
        // Common
        search: 'Tìm kiếm',
        searchPlaceholder: 'Tìm kiếm phim, rạp...',
        viewDetail: 'Xem Chi Tiết',
        bookNow: 'Đặt Vé Ngay',
        back: 'Quay Lại',
        next: 'Tiếp Theo',
        confirm: 'Xác Nhận',
        cancel: 'Hủy Bỏ',
        save: 'Lưu',
        edit: 'Chỉnh Sửa',
        delete: 'Xóa',
        
        // Movie details
        genre: 'Thể Loại',
        duration: 'Thời Lượng',
        releaseDate: 'Ngày Phát Hành',
        director: 'Đạo Diễn',
        cast: 'Diễn Viên',
        rating: 'Đánh Giá',
        overview: 'Tóm Tắt',
        screenings: 'Lịch Chiếu',
        
        // Booking
        selectSeats: 'Chọn Ghế',
        selectedSeats: 'Ghế Đã Chọn',
        totalPrice: 'Tổng Tiền',
        paymentMethod: 'Phương Thức Thanh Toán',
        bookingConfirmation: 'Xác Nhận Đặt Vé',
        
        // Profile
        personalInfo: 'Thông Tin Cá Nhân',
        bookingHistory: 'Lịch Sử Đặt Vé',
        changePassword: 'Đổi Mật Khẩu',
        
        // Admin
        movieManagement: 'Quản Lý Phim',
        theaterManagement: 'Quản Lý Rạp',
        screeningManagement: 'Quản Lý Lịch Chiếu',
        userManagement: 'Quản Lý Người Dùng',
        dashboard: 'Bảng Điều Khiển',
        
        // Messages
        loginSuccess: 'Đăng nhập thành công!',
        loginFailed: 'Đăng nhập thất bại!',
        bookingSuccess: 'Đặt vé thành công!',
        bookingFailed: 'Đặt vé thất bại!',
        languageChanged: 'Đã chuyển sang Tiếng Việt'
    },
    en: {
        // Navigation
        home: 'Home',
        movies: 'Movies',
        theaters: 'Theaters',
        promotions: 'Promotions',
        profile: 'Profile',
        myBookings: 'My Bookings',
        login: 'Login',
        register: 'Register',
        logout: 'Logout',
        admin: 'Admin',
        currentLanguage: 'English',
        
        // Common
        search: 'Search',
        searchPlaceholder: 'Search movies, theaters...',
        viewDetail: 'View Details',
        bookNow: 'Book Now',
        back: 'Back',
        next: 'Next',
        confirm: 'Confirm',
        cancel: 'Cancel',
        save: 'Save',
        edit: 'Edit',
        delete: 'Delete',
        
        // Movie details
        genre: 'Genre',
        duration: 'Duration',
        releaseDate: 'Release Date',
        director: 'Director',
        cast: 'Cast',
        rating: 'Rating',
        overview: 'Overview',
        screenings: 'Screenings',
        
        // Booking
        selectSeats: 'Select Seats',
        selectedSeats: 'Selected Seats',
        totalPrice: 'Total Price',
        paymentMethod: 'Payment Method',
        bookingConfirmation: 'Booking Confirmation',
        
        // Profile
        personalInfo: 'Personal Information',
        bookingHistory: 'Booking History',
        changePassword: 'Change Password',
        
        // Admin
        movieManagement: 'Movie Management',
        theaterManagement: 'Theater Management',
        screeningManagement: 'Screening Management',
        userManagement: 'User Management',
        dashboard: 'Dashboard',
        
        // Messages
        loginSuccess: 'Login successful!',
        loginFailed: 'Login failed!',
        bookingSuccess: 'Booking successful!',
        bookingFailed: 'Booking failed!',
        languageChanged: 'Language changed to English'
    }
};

// Change language function
function changeLanguage(lang) {
    currentLang = lang;
    localStorage.setItem('language', lang);
    applyLanguage(lang);
    updateLanguageSelector();
    
    // Show notification
    const message = translations[lang].languageChanged;
    showNotification(message, 'success');
}

// Apply language to page
function applyLanguage(lang) {
    const langData = translations[lang];
    
    // Update all elements with data-lang-key attribute
    document.querySelectorAll('[data-lang-key]').forEach(element => {
        const key = element.getAttribute('data-lang-key');
        if (langData[key]) {
            if (element.tagName === 'INPUT' && element.type === 'button') {
                element.value = langData[key];
            } else if (element.tagName === 'INPUT' && element.placeholder !== undefined) {
                element.placeholder = langData[key];
            } else {
                element.textContent = langData[key];
            }
        }
    });
    
    // Update HTML lang attribute
    document.documentElement.lang = lang;
    
    // Update page title if it has translation
    const title = document.title;
    if (lang === 'en') {
        document.title = title.replace('Cinema Paradise', 'Cinema Paradise')
                             .replace('Chi Tiết Phim', 'Movie Details')
                             .replace('Đặt Vé', 'Book Tickets')
                             .replace('Hồ Sơ', 'Profile')
                             .replace('Vé Đã Đặt', 'My Bookings');
    } else {
        document.title = title.replace('Movie Details', 'Chi Tiết Phim')
                             .replace('Book Tickets', 'Đặt Vé')
                             .replace('Profile', 'Hồ Sơ')
                             .replace('My Bookings', 'Vé Đã Đặt');
    }
}

// Update language selector display
function updateLanguageSelector() {
    const currentLanguageSpan = document.getElementById('currentLanguage');
    if (currentLanguageSpan) {
        currentLanguageSpan.textContent = translations[currentLang].currentLanguage;
    }
}

// Show notification function
function showNotification(message, type = 'success') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 80px; right: 20px; z-index: 9999; min-width: 300px;';
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 3000);
}

// Get current language
function getCurrentLanguage() {
    return currentLang;
}

// Initialize language on page load
document.addEventListener('DOMContentLoaded', function() {
    applyLanguage(currentLang);
    updateLanguageSelector();
});

// Export functions for use in other scripts
window.changeLanguage = changeLanguage;
window.getCurrentLanguage = getCurrentLanguage;
