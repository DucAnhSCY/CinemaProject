/*
 Cinema Database - Single Theater with 4 Auditoriums
 Each auditorium has 50 seats (VIP, Standard, Couple)
 
 Date: 28/07/2025 16:00:00
*/

-- ----------------------------
-- Table structure for auditoriums
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[auditoriums]') AND type IN ('U'))
	DROP TABLE [dbo].[auditoriums]
GO

CREATE TABLE [dbo].[auditoriums] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [theater_id] bigint DEFAULT 1 NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [total_seats] int  NULL,
  [screen_type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [sound_system] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[auditoriums] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Records of auditoriums (4 phòng cho 1 rạp)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[auditoriums] ON
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'1', N'1', N'Phòng 1', N'50', N'2D/3D', N'Dolby Atmos')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'2', N'1', N'Phòng 2', N'50', N'2D/3D', N'DTS')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'3', N'1', N'Phòng 3', N'50', N'2D/3D', N'THX')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'4', N'1', N'Phòng 4', N'50', N'2D/3D', N'Standard')
GO

SET IDENTITY_INSERT [dbo].[auditoriums] OFF
GO

-- ----------------------------
-- Table structure for seats (50 ghế cho mỗi phòng)
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[seats]') AND type IN ('U'))
	DROP TABLE [dbo].[seats]
GO

CREATE TABLE [dbo].[seats] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [auditorium_id] bigint  NOT NULL,
  [row_number] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [seat_position] int  NULL,
  [seat_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [price_modifier] decimal(5,2) DEFAULT 1.0 NULL
)
GO

ALTER TABLE [dbo].[seats] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Records of seats (Tạo 50 ghế cho mỗi phòng)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[seats] ON
GO

-- Phòng 1 (Auditorium ID = 1) - 50 ghế
-- Hàng A, B: VIP (20 ghế) - price_modifier 1.5
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'1', N'1', N'A', N'1', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'2', N'1', N'A', N'2', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'3', N'1', N'A', N'3', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'4', N'1', N'A', N'4', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5', N'1', N'A', N'5', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'6', N'1', N'A', N'6', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'7', N'1', N'A', N'7', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'8', N'1', N'A', N'8', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'9', N'1', N'A', N'9', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'10', N'1', N'A', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'11', N'1', N'B', N'1', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'12', N'1', N'B', N'2', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'13', N'1', N'B', N'3', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'14', N'1', N'B', N'4', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'15', N'1', N'B', N'5', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'16', N'1', N'B', N'6', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'17', N'1', N'B', N'7', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'18', N'1', N'B', N'8', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'19', N'1', N'B', N'9', N'VIP', N'1.50')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'20', N'1', N'B', N'10', N'VIP', N'1.50')
GO

-- Hàng C, D, E: STANDARD (20 ghế) - price_modifier 1.0
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'21', N'1', N'C', N'1', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'22', N'1', N'C', N'2', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'23', N'1', N'C', N'3', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'24', N'1', N'C', N'4', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'25', N'1', N'C', N'5', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'26', N'1', N'C', N'6', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'27', N'1', N'C', N'7', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'28', N'1', N'D', N'1', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'29', N'1', N'D', N'2', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'30', N'1', N'D', N'3', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'31', N'1', N'D', N'4', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'32', N'1', N'D', N'5', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'33', N'1', N'D', N'6', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'34', N'1', N'D', N'7', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'35', N'1', N'E', N'1', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'36', N'1', N'E', N'2', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'37', N'1', N'E', N'3', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'38', N'1', N'E', N'4', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'39', N'1', N'E', N'5', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'40', N'1', N'E', N'6', N'STANDARD', N'1.00')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'41', N'1', N'E', N'7', N'STANDARD', N'1.00')
GO

-- Hàng F: COUPLE (10 ghế = 5 cặp) - price_modifier 1.3
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'42', N'1', N'F', N'1', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'43', N'1', N'F', N'2', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'44', N'1', N'F', N'3', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'45', N'1', N'F', N'4', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'46', N'1', N'F', N'5', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'47', N'1', N'F', N'6', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'48', N'1', N'F', N'7', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'49', N'1', N'F', N'8', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'50', N'1', N'F', N'9', N'COUPLE', N'1.30')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'51', N'1', N'F', N'10', N'COUPLE', N'1.30')
GO

-- Tương tự cho các phòng 2, 3, 4 (sẽ được tạo tự động bởi code)

SET IDENTITY_INSERT [dbo].[seats] OFF
GO

-- ----------------------------
-- Table structure for theaters (Chỉ 1 rạp)
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[theaters]') AND type IN ('U'))
	DROP TABLE [dbo].[theaters]
GO

CREATE TABLE [dbo].[theaters] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [city] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [address] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [description] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [opening_hours] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[theaters] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Records of theaters (Chỉ 1 rạp)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[theaters] ON
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address], [phone], [email], [description], [opening_hours]) VALUES (N'1', N'Cinema Paradise', N'Đà Nẵng', N'123 Lê Duẩn, Quận Hải Châu, Đà Nẵng', N'0236.3888.999', N'info@cinemaparadise.vn', N'Rạp chiếu phim hiện đại với 4 phòng chiếu, mỗi phòng có 50 ghế được chia thành 3 loại: VIP, Thường và Couple', N'8:00 - 23:00 hàng ngày')
GO

SET IDENTITY_INSERT [dbo].[theaters] OFF
GO

-- ----------------------------
-- Continue with other tables from original database...
-- ----------------------------

-- ----------------------------
-- Table structure for booked_seats
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[booked_seats]') AND type IN ('U'))
	DROP TABLE [dbo].[booked_seats]
GO

CREATE TABLE [dbo].[booked_seats] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [booking_id] bigint  NOT NULL,
  [seat_id] bigint  NOT NULL,
  [screening_id] bigint  NOT NULL,
  [seat_price] decimal(10,2)  NULL
)
GO

ALTER TABLE [dbo].[booked_seats] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Table structure for booking_promotions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[booking_promotions]') AND type IN ('U'))
	DROP TABLE [dbo].[booking_promotions]
GO

CREATE TABLE [dbo].[booking_promotions] (
  [booking_id] bigint  NOT NULL,
  [promotion_id] bigint  NOT NULL,
  [discount_applied] decimal(10,2)  NULL
)
GO

ALTER TABLE [dbo].[booking_promotions] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Table structure for bookings
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[bookings]') AND type IN ('U'))
	DROP TABLE [dbo].[bookings]
GO

CREATE TABLE [dbo].[bookings] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [user_id] bigint  NOT NULL,
  [screening_id] bigint  NOT NULL,
  [booking_time] datetime2(7) DEFAULT getdate() NOT NULL,
  [total_amount] decimal(10,2)  NULL,
  [booking_status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'PENDING' NULL,
  [booking_code] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [customer_name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [customer_phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [customer_email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[bookings] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Table structure for movies
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[movies]') AND type IN ('U'))
	DROP TABLE [dbo].[movies]
GO

CREATE TABLE [dbo].[movies] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [title] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [duration_min] int  NULL,
  [genre] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [description] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [release_date] date  NULL,
  [poster_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [tmdb_id] bigint  NULL,
  [backdrop_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [original_language] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [vote_average] float(53)  NULL,
  [vote_count] int  NULL,
  [popularity] float(53)  NULL,
  [original_title] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [adult] bit  NULL,
  [director] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [cast] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [country] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [language] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [overview] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [image_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [rating] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL
)
GO

ALTER TABLE [dbo].[movies] SET (LOCK_ESCALATION = TABLE)
GO

-- Sample movies data
SET IDENTITY_INSERT [dbo].[movies] ON
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [rating], [status]) VALUES (N'1', N'Oppenheimer', N'180', N'Drama, History', N'Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', N'R', N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [rating], [status]) VALUES (N'2', N'Barbie', N'114', N'Comedy, Adventure', N'Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', N'PG-13', N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [rating], [status]) VALUES (N'3', N'Spider-Man: Across the Spider-Verse', N'140', N'Animation, Action', N'Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.', N'2023-06-02', N'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', N'PG', N'ACTIVE')
GO

SET IDENTITY_INSERT [dbo].[movies] OFF
GO

-- ----------------------------
-- Table structure for screenings
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[screenings]') AND type IN ('U'))
	DROP TABLE [dbo].[screenings]
GO

CREATE TABLE [dbo].[screenings] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [movie_id] bigint  NOT NULL,
  [auditorium_id] bigint  NOT NULL,
  [start_time] datetime2(7)  NOT NULL,
  [end_time] datetime2(7)  NULL,
  [ticket_price] decimal(10,2)  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL
)
GO

ALTER TABLE [dbo].[screenings] SET (LOCK_ESCALATION = TABLE)
GO

-- Sample screenings data
SET IDENTITY_INSERT [dbo].[screenings] ON
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price], [status]) VALUES (N'1', N'1', N'1', N'2025-07-29 09:00:00.0000000', N'120000.00', N'ACTIVE')
GO
INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price], [status]) VALUES (N'2', N'1', N'2', N'2025-07-29 14:00:00.0000000', N'120000.00', N'ACTIVE')
GO
INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price], [status]) VALUES (N'3', N'2', N'3', N'2025-07-29 19:00:00.0000000', N'150000.00', N'ACTIVE')
GO
INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price], [status]) VALUES (N'4', N'3', N'4', N'2025-07-29 21:00:00.0000000', N'200000.00', N'ACTIVE')
GO

SET IDENTITY_INSERT [dbo].[screenings] OFF
GO

-- Continue with other tables (users, payments, promotions, etc.)...

-- ----------------------------
-- Table structure for users
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[users]') AND type IN ('U'))
	DROP TABLE [dbo].[users]
GO

CREATE TABLE [dbo].[users] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [username] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [password_hash] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [role] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'CUSTOMER' NULL,
  [full_name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [date_of_birth] date  NULL,
  [created_at] datetime2(7) DEFAULT getdate() NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL,
  [auth_provider] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'LOCAL' NULL,
  [provider_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [last_login] datetime2(7)  NULL,
  [is_enabled] bit DEFAULT 1 NULL
)
GO

-- Sample users
SET IDENTITY_INSERT [dbo].[users] ON
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [created_at], [status], [is_enabled]) VALUES (N'1', N'admin', N'admin@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'ADMIN', N'Administrator', N'0236.3888.999', GETDATE(), N'ACTIVE', N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [created_at], [status], [is_enabled]) VALUES (N'2', N'staff1', N'staff1@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'STAFF', N'Nhân viên 1', N'0236.3888.998', GETDATE(), N'ACTIVE', N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [created_at], [status], [is_enabled]) VALUES (N'3', N'customer1', N'customer1@gmail.com', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'CUSTOMER', N'Khách hàng 1', N'0901234567', GETDATE(), N'ACTIVE', N'1')
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO

-- ----------------------------
-- Table structure for payments
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[payments]') AND type IN ('U'))
	DROP TABLE [dbo].[payments]
GO

CREATE TABLE [dbo].[payments] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [booking_id] bigint  NOT NULL,
  [amount] decimal(10,2)  NULL,
  [payment_method] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [payment_time] datetime2(7)  NULL,
  [transaction_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'PENDING' NULL
)
GO

-- ----------------------------
-- Table structure for promotions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[promotions]') AND type IN ('U'))
	DROP TABLE [dbo].[promotions]
GO

CREATE TABLE [dbo].[promotions] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [code] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [description] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [discount_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [discount_value] decimal(10,2)  NULL,
  [minimum_amount] decimal(10,2) DEFAULT 0 NULL,
  [start_date] date  NULL,
  [end_date] date  NULL,
  [max_uses] int  NULL,
  [current_uses] int DEFAULT 0 NULL,
  [active] bit DEFAULT 1 NULL
)
GO

-- Sample promotions
SET IDENTITY_INSERT [dbo].[promotions] ON
GO

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'1', N'WELCOME10', N'Giảm giá 10% cho khách hàng mới', N'Giảm giá 10% cho lần đầu đặt vé', N'PERCENTAGE', N'10.00', N'0.00', N'2025-07-01', N'2025-12-31', N'1000', N'0', N'1')
GO

SET IDENTITY_INSERT [dbo].[promotions] OFF
GO

-- ----------------------------
-- Primary Keys and Constraints
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [PK_auditoriums] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[seats] ADD CONSTRAINT [PK_seats] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[theaters] ADD CONSTRAINT [PK_theaters] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [PK_booked_seats] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [PK_booking_promotions] PRIMARY KEY CLUSTERED ([booking_id], [promotion_id])
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [PK_bookings] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[movies] ADD CONSTRAINT [PK_movies] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [PK_screenings] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[payments] ADD CONSTRAINT [PK_payments] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [PK_promotions] PRIMARY KEY CLUSTERED ([id])
GO

-- ----------------------------
-- Foreign Keys
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [FK_auditoriums_theaters] FOREIGN KEY ([theater_id]) REFERENCES [dbo].[theaters] ([id])
GO

ALTER TABLE [dbo].[seats] ADD CONSTRAINT [FK_seats_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id])
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_movies] FOREIGN KEY ([movie_id]) REFERENCES [dbo].[movies] ([id])
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id])
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id])
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id])
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_seats] FOREIGN KEY ([seat_id]) REFERENCES [dbo].[seats] ([id])
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id])
GO

ALTER TABLE [dbo].[payments] ADD CONSTRAINT [FK_payments_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id])
GO

-- ----------------------------
-- Indexes
-- ----------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ_users_username] ON [dbo].[users] ([username] ASC)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_users_email] ON [dbo].[users] ([email] ASC)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_promotions_code] ON [dbo].[promotions] ([code] ASC)
GO
