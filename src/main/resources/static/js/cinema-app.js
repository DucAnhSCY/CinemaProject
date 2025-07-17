// Cinema Booking Application JavaScript

// Global variables
let currentMovie = null;
let selectedTheater = null;
let selectedDate = null;
let selectedTime = null;
let selectedSeats = [];
let bookedSeats = [];

// Movie data (simulated)
const moviesData = [
  {
    id: 1,
    title: "Avatar: The Way of Water",
    genre: "Sci-Fi/Adventure",
    rating: 4.8,
    duration: "192 phút",
    description:
      "Jake Sully sống cùng gia đình mới trên hành tinh Pandora. Khi một mối đe dọa quen thuộc trở lại để hoàn thành những gì đã bắt đầu trước đây, Jake phải làm việc với Neytiri và quân đội của chủng tộc Na'vi để bảo vệ hành tinh của họ.",
    poster: "https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg",
    theaters: [
      {
        id: 1,
        name: "CGV Vincom Center",
        location: "Ba Đình, Hà Nội",
        showtimes: {
          "2024-12-15": ["09:00", "12:30", "16:00", "19:30", "22:45"],
          "2024-12-16": ["09:30", "13:00", "16:30", "20:00", "23:15"],
          "2024-12-17": ["10:00", "13:30", "17:00", "20:30"],
        },
      },
      {
        id: 2,
        name: "Lotte Cinema Landmark",
        location: "Cầu Giấy, Hà Nội",
        showtimes: {
          "2024-12-15": ["10:15", "14:00", "17:30", "21:00"],
          "2024-12-16": ["10:45", "14:30", "18:00", "21:30"],
          "2024-12-17": ["11:00", "15:00", "18:30", "22:00"],
        },
      },
    ],
  },
  {
    id: 2,
    title: "Spider-Man: No Way Home",
    genre: "Action/Adventure",
    rating: 4.9,
    duration: "148 phút",
    description:
      "Peter Parker đối mặt với thử thách lớn nhất khi danh tính Spider-Man của anh bị tiết lộ. Khi anh nhờ Doctor Strange giúp đỡ, họ vô tình mở ra một vết nứt trong đa vũ trụ.",
    poster: "https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
    theaters: [
      {
        id: 1,
        name: "CGV Vincom Center",
        location: "Ba Đình, Hà Nội",
        showtimes: {
          "2024-12-15": ["08:30", "11:45", "15:15", "18:45", "22:00"],
          "2024-12-16": ["09:00", "12:15", "15:45", "19:15", "22:30"],
          "2024-12-17": ["09:30", "12:45", "16:15", "19:45"],
        },
      },
    ],
  },
];

// DOM Content Loaded
document.addEventListener("DOMContentLoaded", function () {
  initializeApp();
  loadMovies();
  setupEventListeners();
});

// Initialize application
function initializeApp() {
  console.log("Cinema Booking App initialized");
  generateDates();
}

// Load movies into the grid
function loadMovies() {
  const moviesGrid = document.getElementById("moviesGrid");
  if (!moviesGrid) return;

  moviesGrid.innerHTML = "";

  moviesData.forEach((movie) => {
    const movieCard = createMovieCard(movie);
    moviesGrid.appendChild(movieCard);
  });
}

// Create movie card element
function createMovieCard(movie) {
  const card = document.createElement("div");
  card.className = "movie-card";
  card.onclick = () => openMovieModal(movie.id);

  card.innerHTML = `
        <img src="${movie.poster}" alt="${
    movie.title
  }" class="movie-poster" loading="lazy">
        <div class="movie-info">
            <h3 class="movie-title">${movie.title}</h3>
            <p class="movie-genre">${movie.genre}</p>
            <div class="movie-rating">
                <div class="rating-stars">
                    ${generateStars(movie.rating)}
                </div>
                <span class="rating-text">${movie.rating}</span>
            </div>
            <p class="movie-description">${movie.description.substring(
              0,
              100
            )}...</p>
            <button class="btn-book">
                <i class="fas fa-ticket-alt"></i> Đặt Vé
            </button>
        </div>
    `;

  return card;
}

// Generate star rating
function generateStars(rating) {
  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 !== 0;
  let stars = "";

  for (let i = 0; i < fullStars; i++) {
    stars += '<i class="fas fa-star"></i>';
  }

  if (hasHalfStar) {
    stars += '<i class="fas fa-star-half-alt"></i>';
  }

  const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
  for (let i = 0; i < emptyStars; i++) {
    stars += '<i class="far fa-star"></i>';
  }

  return stars;
}

// Setup event listeners
function setupEventListeners() {
  // Search functionality
  const searchInput = document.getElementById("searchInput");
  if (searchInput) {
    searchInput.addEventListener("input", debounce(searchMovies, 300));
    searchInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter") {
        searchMovies();
      }
    });
  }

  // Close modal when clicking outside
  document.addEventListener("click", function (e) {
    if (e.target.classList.contains("modal-overlay")) {
      closeModal();
    }
  });

  // ESC key to close modal
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      closeModal();
      closePaymentModal();
      closeSuccessModal();
    }
  });
}

// Search movies
function searchMovies() {
  const searchInput = document.getElementById("searchInput");
  const query = searchInput ? searchInput.value.toLowerCase() : "";

  if (query.length === 0) {
    loadMovies();
    return;
  }

  const filteredMovies = moviesData.filter(
    (movie) =>
      movie.title.toLowerCase().includes(query) ||
      movie.genre.toLowerCase().includes(query) ||
      movie.description.toLowerCase().includes(query)
  );

  displayFilteredMovies(filteredMovies);
}

// Display filtered movies
function displayFilteredMovies(movies) {
  const moviesGrid = document.getElementById("moviesGrid");
  if (!moviesGrid) return;

  moviesGrid.innerHTML = "";

  if (movies.length === 0) {
    moviesGrid.innerHTML = `
            <div style="grid-column: 1 / -1; text-align: center; padding: 2rem;">
                <i class="fas fa-search fa-3x" style="color: #666; margin-bottom: 1rem;"></i>
                <h3 style="color: white;">Không tìm thấy phim nào</h3>
                <p style="color: #ccc;">Thử tìm kiếm với từ khóa khác</p>
            </div>
        `;
    return;
  }

  movies.forEach((movie) => {
    const movieCard = createMovieCard(movie);
    moviesGrid.appendChild(movieCard);
  });
}

// Open movie modal
function openMovieModal(movieId) {
  currentMovie = moviesData.find((movie) => movie.id === movieId);
  if (!currentMovie) return;

  const modal = document.getElementById("movieModal");
  if (!modal) {
    createMovieModal();
    return openMovieModal(movieId);
  }

  updateMovieModal();
  modal.classList.add("active");
  document.body.style.overflow = "hidden";
}

// Create movie modal
function createMovieModal() {
  const modalHTML = `
        <div class="modal-overlay" id="movieModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 id="modalMovieTitle">Movie Title</h3>
                    <button class="close-btn" onclick="closeModal()" title="Đóng">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-content">
                    <div class="movie-info">
                        <img id="modalMoviePoster" src="" alt="Movie Poster" class="modal-poster">
                        <div class="movie-details">
                            <div id="modalMovieDetails"></div>
                        </div>
                    </div>
                    
                    <!-- Theater Selection -->
                    <div class="theater-selection">
                        <h4>Chọn Rạp Chiếu</h4>
                        <div class="theater-list" id="theaterList"></div>
                    </div>

                    <!-- Date Selection -->
                    <div class="date-selection">
                        <h4>Chọn Ngày</h4>
                        <div class="date-list" id="dateList"></div>
                    </div>

                    <!-- Time Selection -->
                    <div class="time-selection">
                        <h4>Chọn Suất Chiếu</h4>
                        <div class="time-list" id="timeList"></div>
                    </div>

                    <!-- Seat Selection -->
                    <div class="seat-selection" id="seatSelection" style="display: none;">
                        <h4>Chọn Ghế</h4>
                        <div class="screen">
                            <div class="screen-text">Màn Hình</div>
                        </div>
                        <div class="seat-map" id="seatMap"></div>
                        <div class="seat-legend">
                            <div class="legend-item">
                                <div class="seat available"></div>
                                <span>Trống</span>
                            </div>
                            <div class="legend-item">
                                <div class="seat selected"></div>
                                <span>Đã chọn</span>
                            </div>
                            <div class="legend-item">
                                <div class="seat occupied"></div>
                                <span>Đã đặt</span>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Summary -->
                    <div class="booking-summary" id="bookingSummary" style="display: none;">
                        <h4>Thông Tin Đặt Vé</h4>
                        <div class="summary-details" id="summaryDetails"></div>
                        <button class="btn btn-primary" onclick="proceedToPayment()">
                            <i class="fas fa-credit-card"></i> Thanh Toán
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

  document.body.insertAdjacentHTML("beforeend", modalHTML);
}

// Update movie modal content
function updateMovieModal() {
  document.getElementById("modalMovieTitle").textContent = currentMovie.title;
  document.getElementById("modalMoviePoster").src = currentMovie.poster;
  document.getElementById("modalMoviePoster").alt = currentMovie.title;

  const detailsHTML = `
        <p><strong>Thể loại:</strong> ${currentMovie.genre}</p>
        <p><strong>Thời lượng:</strong> ${currentMovie.durationMin}</p>
        <p><strong>Đánh giá:</strong> ${currentMovie.rating}/5</p>
        <p><strong>Mô tả:</strong> ${currentMovie.description}</p>
    `;
  document.getElementById("modalMovieDetails").innerHTML = detailsHTML;

  loadTheaters();
  resetSelections();
}

// Load theaters
function loadTheaters() {
  const theaterList = document.getElementById("theaterList");
  theaterList.innerHTML = "";

  currentMovie.theaters.forEach((theater) => {
    const theaterItem = document.createElement("div");
    theaterItem.className = "theater-item";
    theaterItem.onclick = () => selectTheater(theater.id);
    theaterItem.innerHTML = `
            <strong>${theater.name}</strong><br>
            <small>${theater.location}</small>
        `;
    theaterList.appendChild(theaterItem);
  });
}

// Select theater
function selectTheater(theaterId) {
  selectedTheater = currentMovie.theaters.find((t) => t.id === theaterId);

  // Update UI
  document.querySelectorAll(".theater-item").forEach((item) => {
    item.classList.remove("selected");
  });
  event.target.closest(".theater-item").classList.add("selected");

  loadDates();
  hideElements(["timeList", "seatSelection", "bookingSummary"]);
}

// Generate and load dates
function generateDates() {
  const dates = [];
  const today = new Date();

  for (let i = 0; i < 7; i++) {
    const date = new Date(today);
    date.setDate(today.getDate() + i);
    dates.push(date);
  }

  return dates;
}

function loadDates() {
  const dateList = document.getElementById("dateList");
  dateList.innerHTML = "";

  const dates = generateDates();
  const availableDates = Object.keys(selectedTheater.showtimes);

  dates.forEach((date) => {
    const dateStr = date.toISOString().split("T")[0];
    const isAvailable = availableDates.includes(dateStr);

    if (isAvailable) {
      const dateItem = document.createElement("div");
      dateItem.className = "date-item";
      dateItem.onclick = () => selectDate(dateStr);
      dateItem.innerHTML = `
                <strong>${date.toLocaleDateString("vi-VN", {
                  weekday: "short",
                })}</strong><br>
                <span>${date.getDate()}/${date.getMonth() + 1}</span>
            `;
      dateList.appendChild(dateItem);
    }
  });
}

// Select date
function selectDate(dateStr) {
  selectedDate = dateStr;

  // Update UI
  document.querySelectorAll(".date-item").forEach((item) => {
    item.classList.remove("selected");
  });
  event.target.closest(".date-item").classList.add("selected");

  loadTimes();
  hideElements(["seatSelection", "bookingSummary"]);
}

// Load showtimes
function loadTimes() {
  const timeList = document.getElementById("timeList");
  timeList.innerHTML = "";

  const times = selectedTheater.showtimes[selectedDate] || [];

  times.forEach((time) => {
    const timeItem = document.createElement("div");
    timeItem.className = "time-item";
    timeItem.onclick = () => selectTime(time);
    timeItem.textContent = time;
    timeList.appendChild(timeItem);
  });
}

// Select time
function selectTime(time) {
  selectedTime = time;

  // Update UI
  document.querySelectorAll(".time-item").forEach((item) => {
    item.classList.remove("selected");
  });
  event.target.closest(".time-item").classList.add("selected");

  generateSeatMap();
  showElement("seatSelection");
}

// Generate seat map
function generateSeatMap() {
  const seatMap = document.getElementById("seatMap");
  seatMap.innerHTML = "";

  // Generate random booked seats for demo
  bookedSeats = generateBookedSeats();
  selectedSeats = [];

  // Create 10x10 seat grid
  for (let i = 0; i < 100; i++) {
    const seat = document.createElement("div");
    seat.className = "seat";
    seat.dataset.seatNumber = i + 1;

    if (bookedSeats.includes(i + 1)) {
      seat.classList.add("occupied");
    } else {
      seat.classList.add("available");
      seat.onclick = () => toggleSeat(i + 1);
    }

    seatMap.appendChild(seat);
  }
}

// Generate random booked seats
function generateBookedSeats() {
  const booked = [];
  const numBooked = Math.floor(Math.random() * 20) + 10; // 10-30 seats

  while (booked.length < numBooked) {
    const seat = Math.floor(Math.random() * 100) + 1;
    if (!booked.includes(seat)) {
      booked.push(seat);
    }
  }

  return booked;
}

// Toggle seat selection
function toggleSeat(seatNumber) {
  const seat = document.querySelector(`[data-seat-number="${seatNumber}"]`);

  if (seat.classList.contains("selected")) {
    seat.classList.remove("selected");
    seat.classList.add("available");
    selectedSeats = selectedSeats.filter((s) => s !== seatNumber);
  } else {
    if (selectedSeats.length >= 8) {
      alert("Bạn chỉ có thể chọn tối đa 8 ghế");
      return;
    }
    seat.classList.remove("available");
    seat.classList.add("selected");
    selectedSeats.push(seatNumber);
  }

  updateBookingSummary();
}

// Update booking summary
function updateBookingSummary() {
  if (selectedSeats.length === 0) {
    hideElement("bookingSummary");
    return;
  }

  const ticketPrice = 120000; // 120,000 VND per ticket
  const total = selectedSeats.length * ticketPrice;

  const summaryHTML = `
        <p><strong>Phim:</strong> ${currentMovie.title}</p>
        <p><strong>Rạp:</strong> ${selectedTheater.name}</p>
        <p><strong>Ngày:</strong> ${new Date(selectedDate).toLocaleDateString(
          "vi-VN"
        )}</p>
        <p><strong>Suất:</strong> ${selectedTime}</p>
        <p><strong>Ghế:</strong> ${selectedSeats.join(", ")}</p>
        <p><strong>Số lượng:</strong> ${selectedSeats.length} vé</p>
        <hr>
        <p style="font-size: 1.2rem;"><strong>Tổng tiền: ${total.toLocaleString(
          "vi-VN"
        )} VNĐ</strong></p>
    `;

  document.getElementById("summaryDetails").innerHTML = summaryHTML;
  showElement("bookingSummary");
}

// Proceed to payment
function proceedToPayment() {
  if (selectedSeats.length === 0) {
    alert("Vui lòng chọn ít nhất một ghế");
    return;
  }

  closeModal();
  openPaymentModal();
}

// Open payment modal
function openPaymentModal() {
  let paymentModal = document.getElementById("paymentModal");

  if (!paymentModal) {
    createPaymentModal();
    paymentModal = document.getElementById("paymentModal");
  }

  paymentModal.classList.add("active");
  document.body.style.overflow = "hidden";
}

// Create payment modal
function createPaymentModal() {
  const modalHTML = `
        <div class="modal-overlay" id="paymentModal">
            <div class="modal">
                <div class="modal-header">
                    <h3>Thanh Toán</h3>
                    <button class="close-btn" onclick="closePaymentModal()" title="Đóng">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-content">
                    <div class="payment-form">
                        <form id="paymentForm" onsubmit="processPayment(event)">
                            <div class="form-group">
                                <label for="cardNumber">Số thẻ</label>
                                <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="expiryDate">Ngày hết hạn</label>
                                    <input type="text" id="expiryDate" placeholder="MM/YY" required>
                                </div>
                                <div class="form-group">
                                    <label for="cvv">CVV</label>
                                    <input type="text" id="cvv" placeholder="123" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="cardName">Tên trên thẻ</label>
                                <input type="text" id="cardName" placeholder="NGUYEN VAN A" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" placeholder="example@email.com" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại</label>
                                <input type="tel" id="phone" placeholder="0123456789" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-pay">
                                <i class="fas fa-lock"></i>
                                Thanh Toán ${(
                                  selectedSeats.length * 120000
                                ).toLocaleString("vi-VN")} VNĐ
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    `;

  document.body.insertAdjacentHTML("beforeend", modalHTML);
}

// Process payment
function processPayment(event) {
  event.preventDefault();

  // Show loading state
  const submitBtn = event.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
  submitBtn.disabled = true;

  // Simulate payment processing
  setTimeout(() => {
    closePaymentModal();
    showSuccessModal();

    // Reset button
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }, 2000);
}

// Show success modal
function showSuccessModal() {
  let successModal = document.getElementById("successModal");

  if (!successModal) {
    createSuccessModal();
    successModal = document.getElementById("successModal");
  }

  updateSuccessModal();
  successModal.classList.add("active");
  document.body.style.overflow = "hidden";
}

// Create success modal
function createSuccessModal() {
  const modalHTML = `
        <div class="modal-overlay" id="successModal">
            <div class="modal success-modal">
                <div class="modal-content">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3>Đặt vé thành công!</h3>
                    <p>Vé của bạn đã được đặt thành công. Thông tin chi tiết đã được gửi qua email.</p>
                    <div class="ticket-info" id="ticketInfo"></div>
                    <button class="btn btn-primary" onclick="closeSuccessModal()">
                        <i class="fas fa-home"></i> Về Trang Chủ
                    </button>
                </div>
            </div>
        </div>
    `;

  document.body.insertAdjacentHTML("beforeend", modalHTML);
}

// Update success modal
function updateSuccessModal() {
  const bookingId = "BK" + Date.now().toString().slice(-6);
  const ticketInfo = `
        <p><strong>Mã đặt vé:</strong> ${bookingId}</p>
        <p><strong>Phim:</strong> ${currentMovie.title}</p>
        <p><strong>Rạp:</strong> ${selectedTheater.name}</p>
        <p><strong>Ngày:</strong> ${new Date(selectedDate).toLocaleDateString(
          "vi-VN"
        )}</p>
        <p><strong>Suất:</strong> ${selectedTime}</p>
        <p><strong>Ghế:</strong> ${selectedSeats.join(", ")}</p>
        <p><strong>Tổng tiền:</strong> ${(
          selectedSeats.length * 120000
        ).toLocaleString("vi-VN")} VNĐ</p>
    `;

  document.getElementById("ticketInfo").innerHTML = ticketInfo;
}

// Close modals
function closeModal() {
  const modal = document.getElementById("movieModal");
  if (modal) {
    modal.classList.remove("active");
    document.body.style.overflow = "auto";
    resetSelections();
  }
}

function closePaymentModal() {
  const modal = document.getElementById("paymentModal");
  if (modal) {
    modal.classList.remove("active");
    document.body.style.overflow = "auto";
  }
}

function closeSuccessModal() {
  const modal = document.getElementById("successModal");
  if (modal) {
    modal.classList.remove("active");
    document.body.style.overflow = "auto";
  }
}

// Utility functions
function resetSelections() {
  selectedTheater = null;
  selectedDate = null;
  selectedTime = null;
  selectedSeats = [];
  hideElements(["seatSelection", "bookingSummary"]);
}

function hideElements(elementIds) {
  elementIds.forEach((id) => hideElement(id));
}

function hideElement(id) {
  const element = document.getElementById(id);
  if (element) {
    element.style.display = "none";
  }
}

function showElement(id) {
  const element = document.getElementById(id);
  if (element) {
    element.style.display = "block";
  }
}

function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Smooth scrolling for navigation links
document.addEventListener("DOMContentLoaded", function () {
  const navLinks = document.querySelectorAll('.nav-link[href^="#"]');

  navLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
      e.preventDefault();

      const targetId = this.getAttribute("href");
      
      // Kiểm tra nếu targetId hợp lệ
      if (targetId && targetId.length > 1 && targetId.startsWith('#')) {
        const targetElement = document.querySelector(targetId);

        if (targetElement) {
          targetElement.scrollIntoView({
            behavior: "smooth",
            block: "start",
          });

          // Update active nav link
          navLinks.forEach((nl) => nl.classList.remove("active"));
          this.classList.add("active");
        }
      }
    });
  });
});
