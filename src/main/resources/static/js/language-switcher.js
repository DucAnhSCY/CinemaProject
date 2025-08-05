// Language Switcher for Cinema Project
// Provides client-side language switching between Vietnamese and English

// Language translations object
const translations = {
    vi: {
        // Navigation
        movies: "Phim",
        theaters: "Rạp Chiếu",
        promotions: "Khuyến Mãi",
        profile: "Hồ Sơ Cá Nhân",
        myBookings: "Vé Đã Đặt",
        admin: "Quản Trị",
        userManagement: "Quản Lý Người Dùng",
        login: "Đăng Nhập",
        register: "Đăng Ký",
        logout: "Đăng Xuất",
        currentLanguage: "Tiếng Việt",
        
        // Movie Detail Page
        bookTicket: "Đặt vé",
        movieDetails: "Chi Tiết Phim",
        duration: "Thời lượng",
        genre: "Thể loại",
        releaseDate: "Ngày khởi chiếu",
        rating: "Đánh giá",
        overview: "Tóm tắt",
        showtimes: "Lịch chiếu",
        theater: "Rạp",
        hall: "Phòng",
        time: "Giờ",
        date: "Ngày",
        price: "Giá vé",
        contact: "Liên hệ",
        
        // Booking
        seatSelection: "Chọn ghế",
        standardSeat: "Ghế thường",
        vipSeat: "Ghế VIP",
        coupleSeat: "Ghế đôi",
        bookingConfirmation: "Xác nhận đặt vé",
        totalAmount: "Tổng tiền",
        
        // Common
        back: "Quay lại",
        confirm: "Xác nhận",
        cancel: "Hủy",
        loading: "Đang tải...",
        error: "Lỗi",
        success: "Thành công",
        noInformation: "Chưa có thông tin"
    },
    en: {
        // Navigation
        movies: "Movies",
        theaters: "Theaters",
        promotions: "Promotions",
        profile: "Profile",
        myBookings: "My Bookings",
        admin: "Admin",
        userManagement: "User Management",
        login: "Login",
        register: "Register",
        logout: "Logout",
        currentLanguage: "English",
        
        // Movie Detail Page
        bookTicket: "Book Ticket",
        movieDetails: "Movie Details",
        duration: "Duration",
        genre: "Genre",
        releaseDate: "Release Date",
        rating: "Rating",
        overview: "Overview",
        showtimes: "Showtimes",
        theater: "Theater",
        hall: "Hall",
        time: "Time",
        date: "Date",
        price: "Price",
        contact: "Contact",
        
        // Booking
        seatSelection: "Seat Selection",
        standardSeat: "Standard Seat",
        vipSeat: "VIP Seat",
        coupleSeat: "Couple Seat",
        bookingConfirmation: "Booking Confirmation",
        totalAmount: "Total Amount",
        
        // Common
        back: "Back",
        confirm: "Confirm",
        cancel: "Cancel",
        loading: "Loading...",
        error: "Error",
        success: "Success",
        noInformation: "No information available"
    }
};

// Current language state
let currentLang = localStorage.getItem('language') || 'vi';

// Initialize language on page load
document.addEventListener('DOMContentLoaded', function() {
    initializeLanguage();
});

// Initialize language based on saved preference
function initializeLanguage() {
    applyLanguage(currentLang);
    updateLanguageSelector();
}

// Change language function
function changeLanguage(lang) {
    if (lang !== currentLang) {
        currentLang = lang;
        localStorage.setItem('language', lang);
        applyLanguage(lang);
        updateLanguageSelector();
        
        // Show success notification
        showNotification(translations[lang].success + '! ' + 
                        (lang === 'vi' ? 'Đã chuyển sang tiếng Việt' : 'Switched to English'));
    }
}

// Apply language to page elements
function applyLanguage(lang) {
    const langData = translations[lang];
    
    // Update elements with data-translate attribute
    document.querySelectorAll('[data-translate]').forEach(element => {
        const key = element.getAttribute('data-translate');
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

// Export functions for use in other scripts
window.changeLanguage = changeLanguage;
window.getCurrentLanguage = getCurrentLanguage;
