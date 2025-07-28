// Cinema Seat Selection System for Single Cinema with 50 seats per auditorium
// Seat Layout: VIP (A,B) - Standard (C,D,E) - Couple (F)

let selectedSeats = [];
let seatPrices = {
    'STANDARD': 120000,
    'VIP': 180000,      // VIP có giá cao hơn
    'COUPLE': 156000    // COUPLE = 120000 * 1.3
};

// Initialize seat selection when page loads
function initializeSeatSelection() {
    if (typeof screeningData !== 'undefined' && typeof availableSeats !== 'undefined') {
        generateSeatMap();
        setupSeatEventListeners();
        updateBookingSummary();
        displaySeatLegend();
    }
}

// Display seat type legend
function displaySeatLegend() {
    const legendContainer = document.createElement('div');
    legendContainer.className = 'seat-legend';
    legendContainer.innerHTML = `
        <div class="legend-title">Chú thích loại ghế:</div>
        <div class="legend-items">
            <div class="legend-item">
                <div class="seat-sample vip available"></div>
                <span>VIP (Hàng A,B) - ${formatPrice(seatPrices.VIP)}</span>
            </div>
            <div class="legend-item">
                <div class="seat-sample standard available"></div>
                <span>Thường (Hàng C,D,E) - ${formatPrice(seatPrices.STANDARD)}</span>
            </div>
            <div class="legend-item">
                <div class="seat-sample couple available"></div>
                <span>Couple (Hàng F) - ${formatPrice(seatPrices.COUPLE)}</span>
            </div>
            <div class="legend-item">
                <div class="seat-sample booked"></div>
                <span>Đã đặt</span>
            </div>
            <div class="legend-item">
                <div class="seat-sample selected"></div>
                <span>Đang chọn</span>
            </div>
        </div>
    `;
    
    const seatMapContainer = document.getElementById('seatMap');
    if (seatMapContainer && !seatMapContainer.querySelector('.seat-legend')) {
        seatMapContainer.appendChild(legendContainer);
    }
}

// Generate seat map based on database data (50 seats layout)
function generateSeatMap() {
    const seatMapContainer = document.getElementById('seatMap');
    if (!seatMapContainer) return;

    seatMapContainer.innerHTML = '';
    
    // Create seat map container
    const mapContainer = document.createElement('div');
    mapContainer.className = 'seat-map-container';
    
    // Add header info
    const headerDiv = document.createElement('div');
    headerDiv.className = 'seat-map-header';
    headerDiv.innerHTML = `
        <div class="auditorium-info">
            <h3>${screeningData.auditorium.name}</h3>
            <p>Hệ thống âm thanh: ${screeningData.auditorium.soundSystem}</p>
        </div>
        <div class="capacity-info">
            <strong>Sức chứa: ${screeningData.auditorium.totalSeats} ghế</strong><br>
            <small>VIP (20) • Thường (21) • Couple (9)</small>
        </div>
    `;
    mapContainer.appendChild(headerDiv);

    // Add screen
    const screenDiv = document.createElement('div');
    screenDiv.className = 'screen';
    screenDiv.innerHTML = '<i class="fas fa-tv"></i> MÀN HÌNH';
    mapContainer.appendChild(screenDiv);

    // Group seats by row (A, B, C, D, E, F)
    const seatsByRow = groupSeatsByRow(availableSeats);
    
    // Generate rows with specific layout for 50-seat auditorium
    const rowOrder = ['A', 'B', 'C', 'D', 'E', 'F'];
    rowOrder.forEach(rowLetter => {
        if (seatsByRow[rowLetter]) {
            const rowDiv = createSeatRow(rowLetter, seatsByRow[rowLetter]);
            mapContainer.appendChild(rowDiv);
        }
    });

    seatMapContainer.appendChild(mapContainer);
}

// Group seats by row letter
function groupSeatsByRow(seats) {
    const grouped = {};
    
    seats.forEach(seat => {
        const rowLetter = seat.rowNumber;
        if (!grouped[rowLetter]) {
            grouped[rowLetter] = [];
        }
        grouped[rowLetter].push(seat);
    });
    
    // Sort seats within each row by position
    Object.keys(grouped).forEach(row => {
        grouped[row].sort((a, b) => a.seatPosition - b.seatPosition);
    });
    
    return grouped;
}

// Create a seat row
function createSeatRow(rowLetter, seats) {
    const rowDiv = document.createElement('div');
    rowDiv.className = 'seat-row';
    
    // Row label
    const labelDiv = document.createElement('div');
    labelDiv.className = 'row-label';
    labelDiv.textContent = rowLetter;
    rowDiv.appendChild(labelDiv);
    
    // Add seats
    seats.forEach(seat => {
        const seatElement = createSeatElement(seat);
        rowDiv.appendChild(seatElement);
    });
    
    // Add row label on the right side too
    const labelRightDiv = document.createElement('div');
    labelRightDiv.className = 'row-label';
    labelRightDiv.textContent = rowLetter;
    labelRightDiv.style.marginLeft = '15px';
    labelRightDiv.style.marginRight = '0';
    rowDiv.appendChild(labelRightDiv);
    
    return rowDiv;
}

// Create individual seat element
function createSeatElement(seat) {
    const seatDiv = document.createElement('div');
    seatDiv.className = 'seat';
    seatDiv.dataset.seatId = seat.id;
    seatDiv.dataset.seatType = seat.seatType;
    seatDiv.dataset.seatNumber = seat.seatPosition;
    seatDiv.dataset.rowNumber = seat.rowNumber;
    seatDiv.dataset.price = seatPrices[seat.seatType];
    
    // Add seat type class
    seatDiv.classList.add(seat.seatType.toLowerCase());
    
    // Check if seat is booked
    if (seat.isBooked) {
        seatDiv.classList.add('booked');
    } else {
        seatDiv.classList.add('available');
    }
    
    // Set seat display text
    seatDiv.textContent = seat.seatPosition;
    
    return seatDiv;
}

// Setup event listeners for seats
function setupSeatEventListeners() {
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('seat') && e.target.classList.contains('available')) {
            toggleSeatSelection(e.target);
        }
    });
}

// Toggle seat selection
function toggleSeatSelection(seatElement) {
    const seatId = parseInt(seatElement.dataset.seatId);
    const seatType = seatElement.dataset.seatType;
    const rowNumber = seatElement.dataset.rowNumber;
    const seatNumber = seatElement.dataset.seatNumber;
    const price = parseInt(seatElement.dataset.price);
    
    if (seatElement.classList.contains('selected')) {
        // Deselect seat
        seatElement.classList.remove('selected');
        selectedSeats = selectedSeats.filter(seat => seat.id !== seatId);
    } else {
        // Check seat limit
        if (selectedSeats.length >= 8) {
            showNotification('Bạn chỉ có thể chọn tối đa 8 ghế', 'warning');
            return;
        }
        
        // Select seat
        seatElement.classList.add('selected');
        selectedSeats.push({
            id: seatId,
            type: seatType,
            row: rowNumber,
            number: seatNumber,
            price: price,
            displayName: `${rowNumber}${seatNumber}`
        });
    }
    
    updateBookingSummary();
    updateSeatIds();
}

// Update booking summary
function updateBookingSummary() {
    const selectedSeatsDiv = document.getElementById('selectedSeats');
    const totalAmountDiv = document.getElementById('totalAmount');
    const confirmBtn = document.getElementById('confirmBtn');
    
    if (selectedSeats.length === 0) {
        selectedSeatsDiv.innerHTML = '<p class="text-muted">Chưa chọn ghế nào</p>';
        totalAmountDiv.textContent = '0 VNĐ';
        confirmBtn.disabled = true;
        return;
    }
    
    // Update selected seats display
    const seatsHtml = selectedSeats.map(seat => 
        `<span class="selected-seat-tag ${seat.type.toLowerCase()}">
            ${seat.displayName} 
            <span class="seat-price">(${formatPrice(seat.price)})</span>
        </span>`
    ).join('');
    
    selectedSeatsDiv.innerHTML = seatsHtml;
    
    // Calculate total
    const total = selectedSeats.reduce((sum, seat) => sum + seat.price, 0);
    totalAmountDiv.textContent = formatPrice(total);
    
    // Enable confirm button
    confirmBtn.disabled = false;
}

// Update hidden seat IDs input
function updateSeatIds() {
    const seatIdsInput = document.getElementById('seatIds');
    if (seatIdsInput) {
        const seatIds = selectedSeats.map(seat => seat.id).join(',');
        seatIdsInput.value = seatIds;
    }
}

// Format price to Vietnamese currency
function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0
    }).format(price);
}

// Show notification
function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 3000);
}

// Validate seat selection before form submission
function validateSeatSelection() {
    if (selectedSeats.length === 0) {
        showNotification('Vui lòng chọn ít nhất một ghế', 'warning');
        return false;
    }
    
    // Check for valid seat selection
    const invalidSeats = selectedSeats.filter(seat => !seat.id);
    if (invalidSeats.length > 0) {
        showNotification('Có lỗi với ghế đã chọn, vui lòng thử lại', 'error');
        return false;
    }
    
    return true;
}

// Enhanced form submission
document.addEventListener('DOMContentLoaded', function() {
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function(e) {
            if (!validateSeatSelection()) {
                e.preventDefault();
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            // Allow form to submit normally
            // The loading state will be cleared when page navigates
        });
    }
});

// Quick seat selection helpers
function selectBestSeats(count = 2) {
    // Clear current selection
    clearSeatSelection();
    
    // Find best available seats (middle rows, center positions)
    const availableSeats = document.querySelectorAll('.seat.available:not(.booked)');
    const seatsByRow = {};
    
    availableSeats.forEach(seat => {
        const row = seat.dataset.rowNumber;
        if (!seatsByRow[row]) seatsByRow[row] = [];
        seatsByRow[row].push(seat);
    });
    
    // Find center rows and seats
    const rows = Object.keys(seatsByRow).sort();
    const middleRowIndex = Math.floor(rows.length / 2);
    const targetRow = rows[middleRowIndex];
    
    if (seatsByRow[targetRow] && seatsByRow[targetRow].length >= count) {
        const rowSeats = seatsByRow[targetRow];
        const startIndex = Math.floor((rowSeats.length - count) / 2);
        
        for (let i = 0; i < count && i + startIndex < rowSeats.length; i++) {
            const seat = rowSeats[startIndex + i];
            toggleSeatSelection(seat);
        }
    }
}

function clearSeatSelection() {
    selectedSeats.forEach(seat => {
        const seatElement = document.querySelector(`[data-seat-id="${seat.id}"]`);
        if (seatElement) {
            seatElement.classList.remove('selected');
        }
    });
    selectedSeats = [];
    updateBookingSummary();
    updateSeatIds();
}

// Export functions for global access
window.selectBestSeats = selectBestSeats;
window.clearSeatSelection = clearSeatSelection;
window.initializeSeatSelection = initializeSeatSelection;
