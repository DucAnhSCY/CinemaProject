/**
 * Security Module - Bảo vệ frontend khỏi truy cập trái phép
 */
class SecurityManager {
    constructor() {
        this.init();
    }

    init() {
        this.disableDevTools();
        this.disableRightClick();
        this.disableTextSelection();
        this.monitorUnauthorizedAccess();
        this.setupCSRFProtection();
    }

    /**
     * Vô hiệu hóa Developer Tools
     */
    disableDevTools() {
        // Disable F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U
        document.addEventListener('keydown', (e) => {
            if (
                e.key === 'F12' || 
                (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J')) ||
                (e.ctrlKey && e.key === 'U') ||
                (e.ctrlKey && e.shiftKey && e.key === 'C')
            ) {
                e.preventDefault();
                this.showSecurityWarning('Chức năng này đã bị vô hiệu hóa vì lý do bảo mật.');
                return false;
            }
        });

        // Detect if DevTools is open
        let devtools = {
            open: false,
            orientation: null
        };

        setInterval(() => {
            if (window.outerHeight - window.innerHeight > 200 || window.outerWidth - window.innerWidth > 200) {
                if (!devtools.open) {
                    devtools.open = true;
                    this.handleDevToolsDetection();
                }
            } else {
                devtools.open = false;
            }
        }, 500);
    }

    /**
     * Vô hiệu hóa right-click context menu
     */
    disableRightClick() {
        document.addEventListener('contextmenu', (e) => {
            e.preventDefault();
            this.showSecurityWarning('Chuột phải đã bị vô hiệu hóa vì lý do bảo mật.');
            return false;
        });
    }

    /**
     * Vô hiệu hóa text selection cho nội dung nhạy cảm
     */
    disableTextSelection() {
        const sensitiveElements = document.querySelectorAll('.admin-content, .security-sensitive');
        sensitiveElements.forEach(element => {
            element.style.webkitUserSelect = 'none';
            element.style.mozUserSelect = 'none';
            element.style.msUserSelect = 'none';
            element.style.userSelect = 'none';
        });
    }

    /**
     * Theo dõi các nỗ lực truy cập trái phép
     */
    monitorUnauthorizedAccess() {
        // Check if user has proper role
        const userRole = document.querySelector('meta[name="user-role"]')?.content;
        const requiredRole = document.querySelector('meta[name="required-role"]')?.content;

        if (requiredRole && userRole !== requiredRole && !this.hasPermission(userRole, requiredRole)) {
            this.redirectToAccessDenied();
        }

        // Monitor for suspicious activities
        let suspiciousActivity = 0;
        
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.altKey || e.metaKey) {
                suspiciousActivity++;
                if (suspiciousActivity > 10) {
                    this.logSecurityEvent('Suspicious keyboard activity detected');
                }
            }
        });
    }

    /**
     * Thiết lập bảo vệ CSRF
     */
    setupCSRFProtection() {
        const token = document.querySelector('meta[name="_csrf"]')?.content;
        const header = document.querySelector('meta[name="_csrf_header"]')?.content;

        if (token && header) {
            // Add CSRF token to all AJAX requests
            const originalFetch = window.fetch;
            window.fetch = function(url, options = {}) {
                if (!options.headers) {
                    options.headers = {};
                }
                options.headers[header] = token;
                return originalFetch(url, options);
            };

            // Add CSRF token to all forms
            document.addEventListener('submit', (e) => {
                const form = e.target;
                if (form.tagName === 'FORM' && form.method.toUpperCase() === 'POST') {
                    if (!form.querySelector(`input[name="${header}"]`)) {
                        const csrfInput = document.createElement('input');
                        csrfInput.type = 'hidden';
                        csrfInput.name = header;
                        csrfInput.value = token;
                        form.appendChild(csrfInput);
                    }
                }
            });
        }
    }

    /**
     * Kiểm tra quyền truy cập
     */
    hasPermission(userRole, requiredRole) {
        const roleHierarchy = {
            'ADMIN': 3,
            'THEATER_MANAGER': 2,
            'CUSTOMER': 1
        };

        return roleHierarchy[userRole] >= roleHierarchy[requiredRole];
    }

    /**
     * Xử lý khi phát hiện DevTools
     */
    handleDevToolsDetection() {
        this.logSecurityEvent('Developer tools detected');
        this.showSecurityWarning('Đã phát hiện Developer Tools. Hành động này đã được ghi lại.');
        
        // Optional: Redirect after multiple violations
        const violations = parseInt(localStorage.getItem('security_violations') || '0') + 1;
        localStorage.setItem('security_violations', violations.toString());
        
        if (violations >= 3) {
            this.redirectToAccessDenied('Quá nhiều vi phạm bảo mật');
        }
    }

    /**
     * Hiển thị cảnh báo bảo mật
     */
    showSecurityWarning(message) {
        const warning = document.createElement('div');
        warning.className = 'alert alert-danger alert-dismissible security-warning';
        warning.style.position = 'fixed';
        warning.style.top = '20px';
        warning.style.right = '20px';
        warning.style.zIndex = '9999';
        warning.style.maxWidth = '400px';
        warning.innerHTML = `
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Cảnh báo bảo mật:</strong> ${message}
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        
        document.body.appendChild(warning);
        
        setTimeout(() => {
            if (warning.parentElement) {
                warning.remove();
            }
        }, 5000);
    }

    /**
     * Ghi lại sự kiện bảo mật
     */
    logSecurityEvent(event) {
        const logData = {
            event: event,
            timestamp: new Date().toISOString(),
            userAgent: navigator.userAgent,
            url: window.location.href,
            user: document.querySelector('meta[name="user"]')?.content || 'anonymous'
        };

        // Send to server if endpoint exists
        if (window.location.pathname.includes('/admin/')) {
            fetch('/api/admin/security-log', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(logData)
            }).catch(() => {
                // Fail silently if endpoint doesn't exist
            });
        }

        console.warn('Security Event:', logData);
    }

    /**
     * Chuyển hướng đến trang Access Denied
     */
    redirectToAccessDenied(reason = 'Unauthorized access') {
        this.logSecurityEvent(`Access denied: ${reason}`);
        window.location.href = '/access-denied';
    }

    /**
     * Vô hiệu hóa tất cả các nút và form cho user không có quyền
     */
    disableUnauthorizedElements() {
        const userRole = document.querySelector('meta[name="user-role"]')?.content;
        
        if (userRole !== 'ADMIN') {
            // Disable all buttons except logout and back to home
            document.querySelectorAll('button, input[type="submit"], input[type="button"]').forEach(btn => {
                if (!btn.classList.contains('allow-customer') && 
                    !btn.closest('.logout-section') && 
                    !btn.closest('.home-section')) {
                    btn.disabled = true;
                    btn.classList.add('security-disabled');
                    btn.title = 'Bạn không có quyền thực hiện hành động này';
                }
            });

            // Disable all forms except logout
            document.querySelectorAll('form').forEach(form => {
                if (!form.classList.contains('allow-customer') && 
                    !form.action.includes('logout')) {
                    form.addEventListener('submit', (e) => {
                        e.preventDefault();
                        this.showSecurityWarning('Bạn không có quyền thực hiện hành động này');
                    });
                }
            });

            // Disable all links except allowed ones
            document.querySelectorAll('a').forEach(link => {
                if (!link.classList.contains('allow-customer') && 
                    !link.href.includes('logout') && 
                    !link.href.includes('/') && 
                    link.href.includes('admin')) {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        this.showSecurityWarning('Bạn không có quyền truy cập vào trang này');
                    });
                    link.classList.add('security-disabled');
                }
            });
        }
    }
}

// Initialize security when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.securityManager = new SecurityManager();
    window.securityManager.disableUnauthorizedElements();
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SecurityManager;
}
