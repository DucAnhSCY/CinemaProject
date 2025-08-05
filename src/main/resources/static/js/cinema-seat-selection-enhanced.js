/**
 * Cinema Seat Selection with Hold Feature
 * Handles seat selection, holding, and price calculation
 */

class CinemaSeatSelection {
    constructor() {
        this.selectedSeats = [];
        this.holdTimer = null;
        this.holdExpiration = null;
        this.ticketPrice = 0;
        this.screeningId = null;
        this.maxSeats = 8;
        
        this.init();
    }

    init() {
        this.loadScreeningInfo();
        this.bindEvents();
        this.updateDisplay();
        this.startSeatStatusCheck();
    }

    loadScreeningInfo() {
        const priceElement = document.querySelector('[data-ticket-price]');
        const screeningElement = document.querySelector('[data-screening-id]');
        
        if (priceElement) {
            // Parse price from currency format (remove commas, currency symbols)
            const priceText = priceElement.getAttribute('data-ticket-price') || 
                             priceElement.textContent;
            this.ticketPrice = this.parsePrice(priceText);
        }
        
        if (screeningElement) {
            this.screeningId = parseInt(screeningElement.getAttribute('data-screening-id'));
        }
    }

    parsePrice(priceString) {
        // Remove all non-numeric characters except decimal point
        const numericString = priceString.replace(/[^\d.]/g, '');
        return parseFloat(numericString) || 0;
    }

    bindEvents() {
        // Seat selection
        document.querySelectorAll('.seat.available').forEach(seat => {
            seat.addEventListener('click', (e) => this.handleSeatClick(e));
        });

        // Booking form submission
        const bookingForm = document.getElementById('bookingForm');
        if (bookingForm) {
            bookingForm.addEventListener('submit', (e) => this.handleBookingSubmit(e));
        }

        // Hold release button
        const releaseBtn = document.getElementById('releaseHoldBtn');
        if (releaseBtn) {
            releaseBtn.addEventListener('click', () => this.releaseHolds());
        }
    }

    handleSeatClick(event) {
        const seat = event.currentTarget;
        const seatId = parseInt(seat.getAttribute('data-seat-id'));
        
        if (seat.classList.contains('booked') || seat.classList.contains('held')) {
            return;
        }

        if (seat.classList.contains('selected')) {
            this.deselectSeat(seat, seatId);
        } else {
            if (this.selectedSeats.length >= this.maxSeats) {
                this.showNotification('Bạn chỉ có thể chọn tối đa ' + this.maxSeats + ' ghế', 'warning');
                return;
            }
            this.selectSeat(seat, seatId);
        }
        
        this.updateDisplay();
        this.requestSeatHold();
    }

    selectSeat(seat, seatId) {
        seat.classList.add('selected');
        this.selectedSeats.push(seatId);
    }

    deselectSeat(seat, seatId) {
        seat.classList.remove('selected');
        this.selectedSeats = this.selectedSeats.filter(id => id !== seatId);
    }

    async requestSeatHold() {
        if (this.selectedSeats.length === 0) {
            this.releaseHolds();
            return;
        }

        const maxRetries = 2;
        let retryCount = 0;

        while (retryCount <= maxRetries) {
            try {
                const response = await fetch('/api/seats/hold', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        screeningId: this.screeningId,
                        seatIds: this.selectedSeats.join(',')
                    })
                });

                const data = await response.json();
                
                if (data.success) {
                    this.startHoldTimer(data.expiresIn || 600); // 10 minutes default
                    this.showNotification('Ghế đã được giữ chỗ trong 10 phút', 'success');
                    return; // Success, exit retry loop
                } else {
                    if (retryCount < maxRetries && data.message.includes('người khác')) {
                        // Retry for conflicts
                        retryCount++;
                        await new Promise(resolve => setTimeout(resolve, 100 + (retryCount * 100))); // Progressive delay
                        continue;
                    } else {
                        this.showNotification(data.message || 'Không thể giữ chỗ ghế', 'error');
                        this.refreshSeatStatus();
                        return;
                    }
                }
            } catch (error) {
                console.error('Error holding seats:', error);
                
                if (retryCount < maxRetries) {
                    retryCount++;
                    await new Promise(resolve => setTimeout(resolve, 100 + (retryCount * 100)));
                    continue;
                } else {
                    this.showNotification('Lỗi kết nối. Vui lòng thử lại.', 'error');
                    this.refreshSeatStatus();
                    return;
                }
            }
        }
    }

    async releaseHolds() {
        try {
            await fetch('/api/seats/release', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            });
            
            this.clearHoldTimer();
            this.clearSelectedSeats();
            this.updateDisplay();
            this.refreshSeatStatus();
        } catch (error) {
            console.error('Error releasing holds:', error);
        }
    }

    startHoldTimer(seconds) {
        this.clearHoldTimer();
        this.holdExpiration = new Date(Date.now() + seconds * 1000);
        
        this.holdTimer = setInterval(() => {
            const remaining = Math.max(0, this.holdExpiration.getTime() - Date.now());
            
            if (remaining <= 0) {
                this.clearHoldTimer();
                this.clearSelectedSeats();
                this.updateDisplay();
                this.refreshSeatStatus();
                this.showNotification('Hết thời gian giữ chỗ. Vui lòng chọn lại ghế.', 'warning');
                return;
            }
            
            this.updateHoldTimerDisplay(remaining);
        }, 1000);
    }

    clearHoldTimer() {
        if (this.holdTimer) {
            clearInterval(this.holdTimer);
            this.holdTimer = null;
            this.holdExpiration = null;
        }
        this.updateHoldTimerDisplay(0);
    }

    updateHoldTimerDisplay(milliseconds) {
        const timerElement = document.getElementById('holdTimer');
        if (!timerElement) return;
        
        if (milliseconds <= 0) {
            timerElement.style.display = 'none';
            return;
        }
        
        const minutes = Math.floor(milliseconds / 60000);
        const seconds = Math.floor((milliseconds % 60000) / 1000);
        
        timerElement.innerHTML = `
            <i class="fas fa-clock text-warning"></i>
            Thời gian giữ chỗ: ${minutes}:${seconds.toString().padStart(2, '0')}
        `;
        timerElement.style.display = 'block';
    }

    clearSelectedSeats() {
        document.querySelectorAll('.seat.selected').forEach(seat => {
            seat.classList.remove('selected');
        });
        this.selectedSeats = [];
    }

    async refreshSeatStatus() {
        try {
            const response = await fetch(`/api/seats/status/${this.screeningId}`);
            const seats = await response.json();
            
            // Update seat status in DOM
            seats.forEach(seat => {
                const seatElement = document.querySelector(`[data-seat-id="${seat.id}"]`);
                if (seatElement) {
                    seatElement.classList.remove('available', 'booked', 'held');
                    if (seat.booked) {
                        seatElement.classList.add('booked');
                    } else {
                        seatElement.classList.add('available');
                    }
                }
            });
        } catch (error) {
            console.error('Error refreshing seat status:', error);
        }
    }

    startSeatStatusCheck() {
        // Check seat status every 30 seconds
        setInterval(() => {
            if (this.selectedSeats.length === 0) {
                this.refreshSeatStatus();
            }
        }, 30000);
    }

    updateDisplay() {
        this.updateSelectedSeatsDisplay();
        this.updateTotalPrice();
        this.updateBookingButton();
    }

    updateSelectedSeatsDisplay() {
        const container = document.getElementById('selectedSeats');
        if (!container) return;

        if (this.selectedSeats.length === 0) {
            container.innerHTML = '<span class="text-muted">Chưa chọn ghế</span>';
            return;
        }

        const seatLabels = this.selectedSeats.map(seatId => {
            const seatElement = document.querySelector(`[data-seat-id="${seatId}"]`);
            if (seatElement) {
                const row = seatElement.getAttribute('data-row');
                const position = seatElement.getAttribute('data-position');
                return `${row}${position}`;
            }
            return seatId;
        });

        container.innerHTML = seatLabels.map(label => 
            `<span class="badge bg-primary me-1">${label}</span>`
        ).join('');
    }

    updateTotalPrice() {
        const totalPrice = this.selectedSeats.length * this.ticketPrice;
        const element = document.getElementById('totalPrice');
        if (element) {
            element.textContent = this.formatCurrency(totalPrice);
        }
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0,
            useGrouping: true
        }).format(amount).replace(/\./g, ',') + ' VND';
    }

    updateBookingButton() {
        const button = document.getElementById('bookingBtn');
        const seatIdsInput = document.getElementById('seatIds');
        
        if (button) {
            button.disabled = this.selectedSeats.length === 0;
        }
        
        if (seatIdsInput) {
            seatIdsInput.value = this.selectedSeats.join(',');
        }
    }

    handleBookingSubmit(event) {
        if (this.selectedSeats.length === 0) {
            event.preventDefault();
            this.showNotification('Vui lòng chọn ít nhất một ghế', 'warning');
            return;
        }

        // Show loading state
        const submitBtn = event.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
        }
    }

    showNotification(message, type = 'info') {
        // Remove existing notifications
        document.querySelectorAll('.seat-notification').forEach(el => el.remove());
        
        const alertClass = {
            success: 'alert-success',
            error: 'alert-danger',
            warning: 'alert-warning',
            info: 'alert-info'
        }[type] || 'alert-info';
        
        const notification = document.createElement('div');
        notification.className = `alert ${alertClass} alert-dismissible fade show seat-notification`;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.style.minWidth = '300px';
        
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(notification);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.seatSelection = new CinemaSeatSelection();
});

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (window.seatSelection) {
        window.seatSelection.releaseHolds();
    }
});
