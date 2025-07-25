/*
 Single Cinema Database Setup
 
 Cơ sở dữ liệu đã được điều chỉnh cho hệ thống 1 rạp chiếu phim duy nhất
 - Đơn giản hóa bảng theaters (chỉ 1 rạp)
 - Tối ưu hóa cho việc quản lý đặt vé tại 1 địa điểm
 - Có thể mở rộng thành đa rạp sau này

 Date: 25/07/2025
*/

-- ----------------------------
-- Table structure for theaters (chỉ 1 rạp duy nhất)
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
-- Records of theaters (1 rạp duy nhất)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[theaters] ON
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address], [phone], [email], [description], [opening_hours]) 
VALUES (N'1', N'Cinema Paradise', N'Đà Nẵng', N'123 Lê Duẩn, Quận Hải Châu, Đà Nẵng', N'0236.3888.999', N'info@cinemaparadise.vn', N'Rạp chiếu phim hiện đại với công nghệ âm thanh và hình ảnh tối tân', N'8:00 - 23:00 hàng ngày')
GO

SET IDENTITY_INSERT [dbo].[theaters] OFF
GO

-- ----------------------------
-- Table structure for auditoriums (phòng chiếu của rạp)
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[auditoriums]') AND type IN ('U'))
	DROP TABLE [dbo].[auditoriums]
GO

CREATE TABLE [dbo].[auditoriums] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [theater_id] bigint  NOT NULL DEFAULT 1, -- Luôn = 1 vì chỉ có 1 rạp
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [total_seats] int  NULL,
  [screen_type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL, -- 2D, 3D, IMAX, 4DX
  [sound_system] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL -- Dolby Atmos, DTS, THX
)
GO

ALTER TABLE [dbo].[auditoriums] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Records of auditoriums (5 phòng chiếu đa dạng)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[auditoriums] ON
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'1', N'1', N'Phòng VIP', N'50', N'2D/3D', N'Dolby Atmos')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'2', N'1', N'Phòng Standard', N'120', N'2D', N'DTS')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'3', N'1', N'Phòng IMAX', N'200', N'IMAX', N'IMAX Sound')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'4', N'1', N'Phòng 4DX', N'80', N'4DX', N'4DX Sound')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'5', N'1', N'Phòng Family', N'150', N'2D/3D', N'THX')
GO

SET IDENTITY_INSERT [dbo].[auditoriums] OFF
GO

-- ----------------------------
-- Table structure for seats
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[seats]') AND type IN ('U'))
	DROP TABLE [dbo].[seats]
GO

CREATE TABLE [dbo].[seats] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [auditorium_id] bigint  NOT NULL,
  [row_number] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [seat_position] int  NULL,
  [seat_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL, -- VIP, STANDARD, COUPLE
  [price_modifier] decimal(5,2) DEFAULT 1.0 NULL -- Hệ số nhân giá (VIP = 1.5, Standard = 1.0, Couple = 1.2)
)
GO

ALTER TABLE [dbo].[seats] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Tạo ghế mẫu cho Phòng VIP (50 ghế)
-- ----------------------------
SET IDENTITY_INSERT [dbo].[seats] ON
GO

-- Phòng VIP - Hàng A (10 ghế VIP)
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'1', N'1', N'A', N'1', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'2', N'1', N'A', N'2', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'3', N'1', N'A', N'3', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'4', N'1', N'A', N'4', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5', N'1', N'A', N'5', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'6', N'1', N'A', N'6', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'7', N'1', N'A', N'7', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'8', N'1', N'A', N'8', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'9', N'1', N'A', N'9', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'10', N'1', N'A', N'10', N'VIP', N'1.5')
GO

-- Phòng VIP - Hàng B (10 ghế VIP)
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'11', N'1', N'B', N'1', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'12', N'1', N'B', N'2', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'13', N'1', N'B', N'3', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'14', N'1', N'B', N'4', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'15', N'1', N'B', N'5', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'16', N'1', N'B', N'6', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'17', N'1', N'B', N'7', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'18', N'1', N'B', N'8', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'19', N'1', N'B', N'9', N'VIP', N'1.5')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'20', N'1', N'B', N'10', N'VIP', N'1.5')
GO

-- Phòng VIP - Hàng C (15 ghế Standard)
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'21', N'1', N'C', N'1', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'22', N'1', N'C', N'2', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'23', N'1', N'C', N'3', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'24', N'1', N'C', N'4', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'25', N'1', N'C', N'5', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'26', N'1', N'C', N'6', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'27', N'1', N'C', N'7', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'28', N'1', N'C', N'8', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'29', N'1', N'C', N'9', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'30', N'1', N'C', N'10', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'31', N'1', N'C', N'11', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'32', N'1', N'C', N'12', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'33', N'1', N'C', N'13', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'34', N'1', N'C', N'14', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'35', N'1', N'C', N'15', N'STANDARD', N'1.0')
GO

-- Phòng VIP - Hàng D (15 ghế Standard)
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'36', N'1', N'D', N'1', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'37', N'1', N'D', N'2', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'38', N'1', N'D', N'3', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'39', N'1', N'D', N'4', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'40', N'1', N'D', N'5', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'41', N'1', N'D', N'6', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'42', N'1', N'D', N'7', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'43', N'1', N'D', N'8', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'44', N'1', N'D', N'9', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'45', N'1', N'D', N'10', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'46', N'1', N'D', N'11', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'47', N'1', N'D', N'12', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'48', N'1', N'D', N'13', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'49', N'1', N'D', N'14', N'STANDARD', N'1.0')
GO
INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'50', N'1', N'D', N'15', N'STANDARD', N'1.0')
GO

SET IDENTITY_INSERT [dbo].[seats] OFF
GO

-- ----------------------------
-- Table structure for movies (giữ nguyên)
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
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL -- ACTIVE, INACTIVE, COMING_SOON
)
GO

ALTER TABLE [dbo].[movies] SET (LOCK_ESCALATION = TABLE)
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
  [end_time] datetime2(7)  NULL, -- Tự động tính từ start_time + duration
  [ticket_price] decimal(10,2)  NULL, -- Giá vé cơ bản
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL -- ACTIVE, CANCELLED, FULL
)
GO

ALTER TABLE [dbo].[screenings] SET (LOCK_ESCALATION = TABLE)
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
  [booking_status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'PENDING' NULL, -- PENDING, CONFIRMED, CANCELLED, COMPLETED
  [booking_code] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL, -- Mã đặt vé duy nhất
  [customer_name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [customer_phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [customer_email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[bookings] SET (LOCK_ESCALATION = TABLE)
GO

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
  [seat_price] decimal(10,2)  NULL -- Giá ghế tại thời điểm đặt
)
GO

ALTER TABLE [dbo].[booked_seats] SET (LOCK_ESCALATION = TABLE)
GO

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
  [role] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'CUSTOMER' NULL, -- ADMIN, THEATER_MANAGER, CUSTOMER
  [full_name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [auth_provider] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'LOCAL' NULL, -- LOCAL, GOOGLE, GITHUB
  [provider_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [date_of_birth] date  NULL,
  [created_at] datetime2(7) DEFAULT getdate() NULL,
  [last_login] datetime2(7)  NULL,
  [is_enabled] bit DEFAULT 1 NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL -- ACTIVE, INACTIVE, BLOCKED
)
GO

ALTER TABLE [dbo].[users] SET (LOCK_ESCALATION = TABLE)
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
  [discount_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL, -- PERCENTAGE, FIXED_AMOUNT
  [discount_value] decimal(10,2)  NULL,
  [minimum_amount] decimal(10,2) DEFAULT 0 NULL, -- Số tiền tối thiểu để áp dụng
  [start_date] date  NULL,
  [end_date] date  NULL,
  [max_uses] int  NULL,
  [current_uses] int DEFAULT 0 NULL,
  [active] bit DEFAULT 1 NULL
)
GO

ALTER TABLE [dbo].[promotions] SET (LOCK_ESCALATION = TABLE)
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
-- Table structure for payments
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[payments]') AND type IN ('U'))
	DROP TABLE [dbo].[payments]
GO

CREATE TABLE [dbo].[payments] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [booking_id] bigint  NOT NULL,
  [amount] decimal(10,2)  NULL,
  [payment_method] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL, -- CASH, CARD, BANK_TRANSFER, MOMO, VNPAY
  [payment_time] datetime2(7)  NULL,
  [transaction_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'PENDING' NULL -- PENDING, SUCCESS, FAILED, REFUNDED
)
GO

ALTER TABLE [dbo].[payments] SET (LOCK_ESCALATION = TABLE)
GO

-- ----------------------------
-- Dữ liệu mẫu cho movies
-- ----------------------------
SET IDENTITY_INSERT [dbo].[movies] ON
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [rating], [status]) 
VALUES 
(N'1', N'Oppenheimer', N'180', N'Drama, History', N'Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', N'R', N'ACTIVE'),
(N'2', N'Barbie', N'114', N'Comedy, Adventure', N'Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', N'PG-13', N'ACTIVE'),
(N'3', N'Spider-Man: Across the Spider-Verse', N'140', N'Animation, Action', N'Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.', N'2023-06-02', N'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', N'PG', N'ACTIVE'),
(N'4', N'Superman', N'150', N'Science Fiction, Adventure, Action', N'Phiên bản mới của siêu anh hùng Superman với câu chuyện khởi nguồn mới.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/f4hJ5yVSiOSnW9S6vtoGlNYvW5J.jpg', N'PG-13', N'COMING_SOON'),
(N'5', N'Từ Vũ Trụ John Wick: Ballerina', N'115', N'Action, Thriller, Crime', N'Câu chuyện về Eve Macarro trên hành trình trả thù cho cái chết của gia đình mình.', N'2025-06-04', N'https://image.tmdb.org/t/p/w500/bw7gsWIJgoPyxrAgfSHc8xqVhDA.jpg', N'R', N'COMING_SOON')
GO

SET IDENTITY_INSERT [dbo].[movies] OFF
GO

-- ----------------------------
-- Dữ liệu mẫu cho screenings
-- ----------------------------
SET IDENTITY_INSERT [dbo].[screenings] ON
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price], [status]) 
VALUES 
(N'1', N'1', N'1', N'2025-07-26 09:00:00.0000000', N'120000.00', N'ACTIVE'),
(N'2', N'1', N'1', N'2025-07-26 14:00:00.0000000', N'120000.00', N'ACTIVE'),
(N'3', N'1', N'1', N'2025-07-26 19:00:00.0000000', N'150000.00', N'ACTIVE'),
(N'4', N'2', N'2', N'2025-07-26 10:00:00.0000000', N'100000.00', N'ACTIVE'),
(N'5', N'2', N'2', N'2025-07-26 15:00:00.0000000', N'100000.00', N'ACTIVE'),
(N'6', N'2', N'2', N'2025-07-26 20:00:00.0000000', N'120000.00', N'ACTIVE'),
(N'7', N'3', N'3', N'2025-07-26 11:00:00.0000000', N'200000.00', N'ACTIVE'),
(N'8', N'3', N'3', N'2025-07-26 16:00:00.0000000', N'200000.00', N'ACTIVE'),
(N'9', N'3', N'3', N'2025-07-26 21:00:00.0000000', N'250000.00', N'ACTIVE')
GO

SET IDENTITY_INSERT [dbo].[screenings] OFF
GO

-- ----------------------------
-- Dữ liệu mẫu cho users
-- ----------------------------
SET IDENTITY_INSERT [dbo].[users] ON
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [auth_provider], [is_enabled], [status]) 
VALUES 
(N'1', N'admin', N'admin@cinemaparadise.vn', N'$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', N'ADMIN', N'Administrator', N'0236.3888.999', N'LOCAL', N'1', N'ACTIVE'),
(N'2', N'staff1', N'staff1@cinemaparadise.vn', N'$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', N'THEATER_MANAGER', N'Nhân viên 1', N'0236.3888.998', N'LOCAL', N'1', N'ACTIVE'),
(N'3', N'customer1', N'customer1@gmail.com', N'$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', N'CUSTOMER', N'Khách hàng 1', N'0901234567', N'LOCAL', N'1', N'ACTIVE')
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO

-- ----------------------------
-- Dữ liệu mẫu cho promotions
-- ----------------------------
SET IDENTITY_INSERT [dbo].[promotions] ON
GO

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) 
VALUES 
(N'1', N'WELCOME10', N'Giảm giá 10% cho khách hàng mới', N'Giảm giá 10% cho lần đầu đặt vé', N'PERCENTAGE', N'10.00', N'0', N'2025-07-01', N'2025-12-31', N'1000', N'0', N'1'),
(N'2', N'STUDENT20', N'Giảm giá 20% cho sinh viên', N'Giảm giá 20% cho sinh viên có thẻ', N'PERCENTAGE', N'20.00', N'0', N'2025-07-01', N'2025-12-31', N'500', N'0', N'1'),
(N'3', N'SAVE50K', N'Giảm 50.000đ cho hóa đơn từ 300.000đ', N'Giảm 50.000đ cho hóa đơn từ 300.000đ trở lên', N'FIXED_AMOUNT', N'50000.00', N'300000.00', N'2025-07-01', N'2025-09-30', N'200', N'0', N'1'),
(N'4', N'WEEKEND15', N'Giảm giá 15% cuối tuần', N'Giảm giá 15% cho các suất chiếu cuối tuần', N'PERCENTAGE', N'15.00', N'0', N'2025-07-05', N'2025-12-31', N'1000', N'0', N'1')
GO

SET IDENTITY_INSERT [dbo].[promotions] OFF
GO

-- ----------------------------
-- Primary Keys
-- ----------------------------
ALTER TABLE [dbo].[theaters] ADD CONSTRAINT [PK_theaters] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [PK_auditoriums] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[seats] ADD CONSTRAINT [PK_seats] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[movies] ADD CONSTRAINT [PK_movies] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [PK_screenings] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [PK_bookings] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [PK_booked_seats] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [PK_promotions] PRIMARY KEY CLUSTERED ([id])
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [PK_booking_promotions] PRIMARY KEY CLUSTERED ([booking_id], [promotion_id])
GO

ALTER TABLE [dbo].[payments] ADD CONSTRAINT [PK_payments] PRIMARY KEY CLUSTERED ([id])
GO

-- ----------------------------
-- Foreign Keys
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [FK_auditoriums_theaters] FOREIGN KEY ([theater_id]) REFERENCES [dbo].[theaters] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[seats] ADD CONSTRAINT [FK_seats_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_movies] FOREIGN KEY ([movie_id]) REFERENCES [dbo].[movies] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_seats] FOREIGN KEY ([seat_id]) REFERENCES [dbo].[seats] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK_booking_promotions_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK_booking_promotions_promotions] FOREIGN KEY ([promotion_id]) REFERENCES [dbo].[promotions] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[payments] ADD CONSTRAINT [FK_payments_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
-- Indexes
-- ----------------------------
CREATE UNIQUE INDEX [UQ_users_username] ON [dbo].[users] ([username])
GO

CREATE UNIQUE INDEX [UQ_users_email] ON [dbo].[users] ([email])
GO

CREATE UNIQUE INDEX [UQ_promotions_code] ON [dbo].[promotions] ([code])
GO

CREATE UNIQUE INDEX [UQ_bookings_code] ON [dbo].[bookings] ([booking_code])
GO

CREATE INDEX [IX_screenings_start_time] ON [dbo].[screenings] ([start_time])
GO

CREATE INDEX [IX_bookings_booking_time] ON [dbo].[bookings] ([booking_time])
GO

-- ----------------------------
-- Views để dễ dàng query
-- ----------------------------

-- View để xem thông tin suất chiếu đầy đủ
CREATE VIEW [dbo].[v_screening_details] AS
SELECT 
    s.id as screening_id,
    s.start_time,
    s.end_time,
    s.ticket_price,
    s.status as screening_status,
    m.title as movie_title,
    m.duration_min,
    m.genre,
    m.rating,
    m.poster_url,
    a.name as auditorium_name,
    a.total_seats,
    a.screen_type,
    a.sound_system,
    t.name as theater_name
FROM [dbo].[screenings] s
JOIN [dbo].[movies] m ON s.movie_id = m.id
JOIN [dbo].[auditoriums] a ON s.auditorium_id = a.id  
JOIN [dbo].[theaters] t ON a.theater_id = t.id
GO

-- View để xem thông tin đặt vé đầy đủ
CREATE VIEW [dbo].[v_booking_details] AS
SELECT 
    b.id as booking_id,
    b.booking_code,
    b.booking_time,
    b.total_amount,
    b.booking_status,
    b.customer_name,
    b.customer_phone,
    b.customer_email,
    u.username,
    u.full_name as user_full_name,
    s.start_time as screening_time,
    m.title as movie_title,
    a.name as auditorium_name,
    STRING_AGG(CONCAT(se.row_number, se.seat_position), ', ') as seat_numbers
FROM [dbo].[bookings] b
JOIN [dbo].[users] u ON b.user_id = u.id
JOIN [dbo].[screenings] s ON b.screening_id = s.id
JOIN [dbo].[movies] m ON s.movie_id = m.id
JOIN [dbo].[auditoriums] a ON s.auditorium_id = a.id
LEFT JOIN [dbo].[booked_seats] bs ON b.id = bs.booking_id
LEFT JOIN [dbo].[seats] se ON bs.seat_id = se.id
GROUP BY b.id, b.booking_code, b.booking_time, b.total_amount, b.booking_status,
         b.customer_name, b.customer_phone, b.customer_email, u.username, u.full_name,
         s.start_time, m.title, a.name
GO

-- Stored Procedure để tạo mã đặt vé tự động
CREATE PROCEDURE [dbo].[sp_generate_booking_code]
AS
BEGIN
    DECLARE @code NVARCHAR(10)
    DECLARE @counter INT = 1
    DECLARE @exists BIT = 1
    
    WHILE @exists = 1
    BEGIN
        SET @code = 'CP' + FORMAT(DATEPART(year, GETDATE()), '00') + 
                    FORMAT(DATEPART(month, GETDATE()), '00') + 
                    FORMAT(DATEPART(day, GETDATE()), '00') + 
                    FORMAT(@counter, '000')
        
        IF NOT EXISTS (SELECT 1 FROM [dbo].[bookings] WHERE booking_code = @code)
            SET @exists = 0
        ELSE
            SET @counter = @counter + 1
    END
    
    SELECT @code AS booking_code
END
GO

PRINT 'Single Cinema Database created successfully!'
PRINT 'Key Features:'
PRINT '- 1 Theater: Cinema Paradise'
PRINT '- 5 Auditoriums: VIP, Standard, IMAX, 4DX, Family'
PRINT '- Enhanced seat types with price modifiers'
PRINT '- Comprehensive booking system'
PRINT '- Promotion system'
PRINT '- Payment tracking'
PRINT '- Ready for future multi-cinema expansion'
