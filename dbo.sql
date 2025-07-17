/*
 Navicat Premium Data Transfer

 Source Server         : Java
 Source Server Type    : SQL Server
 Source Server Version : 16001140
 Source Catalog        : cinema_db
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001140
 File Encoding         : 65001

 Date: 17/07/2025 17:58:22
*/


-- ----------------------------
-- Table structure for auditoriums
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[auditoriums]') AND type IN ('U'))
	DROP TABLE [dbo].[auditoriums]
GO

CREATE TABLE [dbo].[auditoriums] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [theater_id] bigint  NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [total_seats] int  NULL
)
GO

ALTER TABLE [dbo].[auditoriums] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of auditoriums
-- ----------------------------
SET IDENTITY_INSERT [dbo].[auditoriums] ON
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'1', N'1', N'Rạp 1', N'50')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'2', N'1', N'Rạp 2', N'150')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'3', N'1', N'Rạp 3', N'200')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'4', N'2', N'Screen A', N'50')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'5', N'2', N'Screen B', N'50')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'6', N'3', N'Phòng chiếu 1', N'160')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'7', N'3', N'Phòng chiếu 2', N'50')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'8', N'4', N'Auditorium 1', N'50')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'9', N'4', N'Auditorium 2', N'180')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats]) VALUES (N'12', N'1', N'Phòng 3', N'50')
GO

SET IDENTITY_INSERT [dbo].[auditoriums] OFF
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
  [screening_id] bigint  NOT NULL
)
GO

ALTER TABLE [dbo].[booked_seats] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of booked_seats
-- ----------------------------
SET IDENTITY_INSERT [dbo].[booked_seats] ON
GO

SET IDENTITY_INSERT [dbo].[booked_seats] OFF
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
-- Records of booking_promotions
-- ----------------------------

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
  [booking_status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[bookings] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of bookings
-- ----------------------------
SET IDENTITY_INSERT [dbo].[bookings] ON
GO

SET IDENTITY_INSERT [dbo].[bookings] OFF
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
  [rating] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[movies] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of movies
-- ----------------------------
SET IDENTITY_INSERT [dbo].[movies] ON
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'9', N'Oppenheimer', N'180', N'Drama, History', N'Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', N'872585', N'https://image.tmdb.org/t/p/w1280/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg', N'en', N'8.3', N'6247', N'3456.789', N'Oppenheimer', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'10', N'Barbie', N'114', N'Comedy, Adventure', N'Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', N'346698', N'https://image.tmdb.org/t/p/w1280/nHf61UzkfFno5X1ofIhugCPus2R.jpg', N'en', N'7.1', N'5896', N'2543.321', N'Barbie', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'11', N'Spider-Man: Across the Spider-Verse', N'140', N'Animation, Action', N'Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.', N'2023-06-02', N'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', N'569094', N'https://image.tmdb.org/t/p/w1280/VuukZLgaCrho2Ar8Scl9HtV3yD.jpg', N'en', N'8.6', N'4521', N'1987.654', N'Spider-Man: Across the Spider-Verse', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'13', N'LEGO Marvel Avengers: Mission Demolition', N'44', N'Phim Hoạt Hình, Phim Hài, Phim Khoa Học Viễn Tưởng', N'', N'2024-10-17', N'https://image.tmdb.org/t/p/w500/x9Gi93zL1DZCNwcRkzpe1QndNlY.jpg', N'1359227', N'https://image.tmdb.org/t/p/w1280/Al127H6f1RXpESdg0MGNL2g8mzO.jpg', N'en', N'6.478', N'115', N'3.6501', N'LEGO Marvel Avengers: Mission Demolition', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'14', N'Bí Kíp Luyện Rồng', NULL, N'Fantasy, Family, Action', N'Phiên bản Live Action (người đóng) của studio DreamWorks rất được mong chờ đã ra mắt. Câu chuyện về một chàng trai trẻ với ước mơ trở thành thợ săn rồng, nhưng định mệnh lại đưa đẩy anh đến tình bạn bất ngờ với một chú rồng.', N'2025-06-06', N'https://image.tmdb.org/t/p/w500/sIQRZYHRJN1ZzulxpXuoXEgkkSe.jpg', N'1087192', N'https://image.tmdb.org/t/p/w1280/ovZasZ9EeZcp6UsrElkQ63hFCd.jpg', N'en', N'8.069', N'791', N'874.3321', N'How to Train Your Dragon', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'15', N'M3GAN 2.0', NULL, N'Action, Science Fiction, Thriller', N'Phim lấy bối cảnh 2 năm sau các sự kiện ở phần 1. Lúc này, Gemma phát hiện công nghệ sản xuất MEGAN đã bị đánh cắp. Kẻ gian đã tạo ra một robot AI khác với chức năng tương tự MEGAN, nhưng được trang bị sức mạnh chiến đấu "khủng" hơn mang tên Amelia. Để "đối đầu" với Amelia, Gemma buộc phải "hồi sinh" và cải tiến MEGAN, hứa hẹn một trận chiến "nảy lửa" trên màn ảnh vào năm 2025.', N'2025-06-25', N'https://image.tmdb.org/t/p/w500/psASSoFLAGFoXwyfRg4hDZHgshN.jpg', N'1071585', N'https://image.tmdb.org/t/p/w1280/5l3Ge1f3944AsDiiDXWQ3RSZ0Bg.jpg', N'en', N'7.709', N'235', N'650.7798', N'M3GAN 2.0', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'16', N'Siêu Nhí Karate: Những Câu Chuyện Huyền Thoại', NULL, N'Action, Adventure, Drama', N'', N'2025-05-08', N'https://image.tmdb.org/t/p/w500/jMtD6YLSTCaBlCAsGxGOa4n2Po8.jpg', N'1011477', N'https://image.tmdb.org/t/p/w1280/7Q2CmqIVJuDAESPPp76rWIiA0AD.jpg', N'en', N'7.283', N'427', N'565.3801', N'Karate Kid: Legends', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'17', N'Superman', NULL, N'Science Fiction, Adventure, Action', N'', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/f4hJ5yVSiOSnW9S6vtoGlNYvW5J.jpg', N'1061474', N'https://image.tmdb.org/t/p/w1280/ApRxyHFuvv5yghedxXPJSm9FEDe.jpg', N'en', N'7.482', N'755', N'497.0571', N'Superman', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'18', N'Bad Boas: Bộ đôi phá án', NULL, N'Action, Comedy, Crime, Mystery', N'Khi một cảnh sát cộng đồng hăng hái quá mức và một cựu thanh tra liều lĩnh buộc phải hợp tác, hàng loạt hỗn loạn bùng nổ trên đường phố Rotterdam.', N'2025-07-10', N'https://image.tmdb.org/t/p/w500/upzsNh9Ue3DmFlGnUlxwXtnEpQc.jpg', N'1374534', N'https://image.tmdb.org/t/p/w1280/qtSY2SAL5QApuCUD0sXqyzgHYnl.jpg', N'nl', N'5.792', N'60', N'478.381', N'Bad Boa''s', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'19', N'Từ Vũ Trụ John Wick: Ballerina', NULL, N'Action, Thriller, Crime', N'Lấy bối cảnh giữa sự kiện của Sát thủ John Wick: Phần 3 – Chuẩn Bị Chiến Tranh, bộ phim Từ Vũ Trụ John Wick: Ballerina theo chân Eve Macarro (thủ vai bởi Ana de Armas) trên hành trình trả thù cho cái chết của gia đình mình, dưới sự huấn luyện của tổ chức tội phạm Ruska Roma.', N'2025-06-04', N'https://image.tmdb.org/t/p/w500/bw7gsWIJgoPyxrAgfSHc8xqVhDA.jpg', N'541671', N'https://image.tmdb.org/t/p/w1280/sItIskd5xpiE64bBWYwZintkGf3.jpg', N'en', N'7.47', N'1009', N'363.6633', N'Ballerina', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'20', N'Con Đường Băng 2: Trả Đũa', NULL, N'Action, Thriller, Drama', N'Tài xế xe tải đường băng huyền thoại Mike McCann đến Nepal để hoàn thành tâm nguyện cuối cùng của người anh trai quá cố: rải tro cốt trên đỉnh Everest. Nhưng hành trình tưởng như bình yên lại trở thành ác mộng khi chiếc xe buýt chở đầy du khách mà anh đi cùng bị tấn công trên cung đường “Tiến về bầu trời” – một trong những tuyến đường nguy hiểm nhất thế giới. Trên vùng núi cao hiểm trở, McCann và người hướng dẫn leo núi buộc phải chiến đấu với nhóm lính đánh thuê bí ẩn, bảo vệ những người dân vô tội – và một ngôi làng đang đứng bên bờ vực bị xóa sổ.', N'2025-06-27', N'https://image.tmdb.org/t/p/w500/cQN9rZj06rXMVkk76UF1DfBAico.jpg', N'1119878', N'https://image.tmdb.org/t/p/w1280/962KXsr09uK8wrmUg9TjzmE7c4e.jpg', N'en', N'6.991', N'116', N'354.9185', N'Ice Road: Vengeance', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'21', N'Ziam', NULL, N'Horror, Thriller, Action', N'Trong cuộc chiến sinh tồn trước đội quân thây ma kinh hoàng, một cựu võ sĩ Muay Thái phải dốc toàn bộ kỹ năng, tốc độ và ý chí để cứu bạn gái.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/rE5Bf1ejCUuHxmQGIJTZ7W7M13p.jpg', N'1429744', N'https://image.tmdb.org/t/p/w1280/tdMbbFhqyEqOK1QzNTvJjHWKbZX.jpg', N'th', N'6.783', N'92', N'278.9317', N'ปากกัด ตีนถีบ', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'22', N'The Old Guard 2', NULL, N'Action, Fantasy', N'Andy và đội chiến binh bất tử chiến đấu với mục đích mới khi họ đương đầu với một kẻ thù mới hùng mạnh đang đe dọa sứ mệnh bảo vệ nhân loại của họ.', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/wqfu3bPLJaEWJVk3QOm0rKhxf1A.jpg', N'846422', N'https://image.tmdb.org/t/p/w1280/fd9K7ZDfzRAcbLh8JlG4HIKbtuR.jpg', N'en', N'6.096', N'479', N'265.1465', N'The Old Guard 2', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'23', N'Thế Giới Khủng Long: Tái Sinh', NULL, N'Science Fiction, Adventure, Action', N'', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/2IVVciw7dPhUlNmYIaz0s1d56SZ.jpg', N'1234821', N'https://image.tmdb.org/t/p/w1280/fQOV47FHTJdaSuSUNlzP3zXUZWE.jpg', N'en', N'6.4', N'645', N'289.6717', N'Jurassic World Rebirth', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'24', N'Nguyên Thủ Đối Đầu', NULL, N'Action, Thriller, Comedy', N'Hai nhà lãnh đạo – Tổng thống Mỹ (John Cena) và Thủ tướng Anh (Idris Elba) – bị rơi vào âm mưu khủng bố khi tham dự hội nghị NATO. Bị lạc ở Belarus, họ buộc phải bắt tay để sinh tồn, dù tính cách trái ngược. Cùng với đặc vụ MI6 (Priyanka Chopra), họ đối đầu kẻ thù quốc tế, qua chuỗi hành động–hài hước kịch tính xuyên châu Âu.', N'2025-07-02', N'https://image.tmdb.org/t/p/w500/lVgE5oLzf7ABmzyASEVcjYyHI41.jpg', N'749170', N'https://image.tmdb.org/t/p/w1280/xABhldZaMb6wfCH5oigV333OYnb.jpg', N'en', N'6.992', N'455', N'240.9569', N'Heads of State', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'25', N'Thợ săn quỷ Kpop', NULL, N'Animation, Fantasy, Action, Comedy, Music, Family', N'Khi các siêu sao Kpop Rumi, Mira và Zoey không bận trình diễn tại các sân vận động cháy vé, họ sử dụng sức mạnh bí mật để bảo vệ người hâm mộ khỏi những mối đe dọa siêu nhiên.', N'2025-06-20', N'https://image.tmdb.org/t/p/w500/y8OyohPhdTtusY0nXd2XdX4NN8W.jpg', N'803796', N'https://image.tmdb.org/t/p/w1280/rJjhOuRFldNF0OWSuSk4PiCLmeA.jpg', N'en', N'8.614', N'634', N'209.9166', N'KPop Demon Hunters', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'26', N'Dora và Hành Trình Tìm Thành Phố Vàng', NULL, N'Adventure, Comedy, Family', N'Dora and the Search for Sol Dorado (2025) là cuộc phiêu lưu mới của Dora tuổi teen cùng anh họ Diego và nhóm bạn vào rừng Amazon để tìm thành phố vàng huyền thoại Sol Dorado. Họ phải vượt qua cạm bẫy, đối đầu lính đánh thuê và khám phá sức mạnh bản thân.', N'2025-07-02', N'https://image.tmdb.org/t/p/w500/r3d6u2n7iPoWNsSWwlJJWrDblOH.jpg', N'1287536', N'https://image.tmdb.org/t/p/w1280/9A0wQG38VdEu3DYh8HzXKXKhA6g.jpg', N'en', N'7.2', N'60', N'152.762', N'Dora and the Search for Sol Dorado', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'27', N'Z-O-M-B-I-E-S 4: Dawn of the Vampires', NULL, N'Music, Adventure, Romance, Comedy, Family', N'', N'2025-07-10', N'https://image.tmdb.org/t/p/w500/qIipTUGmAVjMH7ERtdzKkPuVYhP.jpg', N'1243341', N'https://image.tmdb.org/t/p/w1280/xScjwsqx8vXzBaKiioVIB5MkDmQ.jpg', N'en', N'6.881', N'59', N'162.3656', N'Z-O-M-B-I-E-S 4: Dawn of the Vampires', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'28', N'F1 Phim Điện Ảnh', NULL, N'Action, Drama', N'', N'2025-06-25', N'https://image.tmdb.org/t/p/w500/qsn0OsLY2luKOkWr2RbGFrijmoy.jpg', N'911430', N'https://image.tmdb.org/t/p/w1280/lkDYN0whyE82mcM20rwtwjbniKF.jpg', N'en', N'7.6', N'780', N'159.7575', N'F1', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'29', N'Mượn Hồn Đoạt Xác', NULL, N'Horror', N'Sự trở lại của bộ óc sáng tạo đằng sau Talk to Me, Danny và Michael Philippou cùng A24 với một bộ phim kinh dị mới nhất Mượn Hồn Đoạt Xác. Nhiều người tin rằng linh hồn vẫn sẽ ở lại trong thân xác một thời gian trước khi rời đi, đây cũng là niềm tin đáng sợ cho nghi lễ ám ảnh nhất tháng 5.', N'2025-05-28', N'https://image.tmdb.org/t/p/w500/zNNDCFTnSNz7Y5GZDxs8SYO2MIi.jpg', N'1151031', N'https://image.tmdb.org/t/p/w1280/U0A4zWh6XbJt1jDAPuGqKcu4ga.jpg', N'en', N'7.442', N'266', N'132.1669', N'Bring Her Back', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'30', N'Madea: Lễ Cưới Khó Quên', NULL, N'Comedy, Drama', N'Madea đã sẵn sàng vui chơi dưới ánh nắng mặt trời tại đám cưới bất ngờ của cháu gái ở Bahamas. Phần tuyệt nhất là người bố không tán thành của cô dâu sẽ chi trả chi phí.', N'2025-07-10', N'https://image.tmdb.org/t/p/w500/jwMwRucnAROgWo9WLLmIqzHmmzi.jpg', N'1246310', N'https://image.tmdb.org/t/p/w1280/57on65zgbTjmiMJSqqKVZ3c355p.jpg', N'en', N'5.8', N'36', N'130.6259', N'Madea''s Destination Wedding', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'31', N'Bức tường bí ẩn', NULL, N'Thriller, Science Fiction', N'Khi một bức tường gạch bí ẩn bao quanh tòa nhà chung cư của họ suốt đêm, Tim và Olivia phải bắt tay với những người hàng xóm đầy cảnh giác để an toàn thoát ra.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/73VFU1frjqS2XmSD8FCvADADf7M.jpg', N'1425045', N'https://image.tmdb.org/t/p/w1280/apNfldKI3RiaukNwJzr8EjRG7Wc.jpg', N'de', N'5.702', N'226', N'127.1822', N'Brick', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating]) VALUES (N'35', N'Xì Trum', N'92', N'Phim Hoạt Hình, Phim Gia Đình, Phim Giả Tượng', N'', N'2025-06-30', N'https://image.tmdb.org/t/p/w500/tUrFbF23xEB6plOUIHSa65F0LS2.jpg', N'936108', N'https://image.tmdb.org/t/p/w1280/nZFgO3BDxpLzTpDXhYbdXBGdUVm.jpg', N'en', N'7.136', N'11', N'36.0984', N'Smurfs', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

SET IDENTITY_INSERT [dbo].[movies] OFF
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
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[payments] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of payments
-- ----------------------------
SET IDENTITY_INSERT [dbo].[payments] ON
GO

SET IDENTITY_INSERT [dbo].[payments] OFF
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
  [discount_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [discount_value] decimal(10,2)  NULL,
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
-- Records of promotions
-- ----------------------------
SET IDENTITY_INSERT [dbo].[promotions] ON
GO

INSERT INTO [dbo].[promotions] ([id], [code], [discount_type], [discount_value], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'1', N'WELCOME10', N'PERCENTAGE', N'10.00', N'2025-07-01', N'2025-12-31', N'1000', N'0', N'1')
GO

INSERT INTO [dbo].[promotions] ([id], [code], [discount_type], [discount_value], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'2', N'STUDENT20', N'PERCENTAGE', N'20.00', N'2025-07-01', N'2025-12-31', N'500', N'0', N'1')
GO

INSERT INTO [dbo].[promotions] ([id], [code], [discount_type], [discount_value], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'3', N'SAVE50K', N'FIXED_AMOUNT', N'50000.00', N'2025-07-01', N'2025-09-30', N'200', N'0', N'1')
GO

INSERT INTO [dbo].[promotions] ([id], [code], [discount_type], [discount_value], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'4', N'WEEKEND15', N'PERCENTAGE', N'15.00', N'2025-07-05', N'2025-07-06', N'100', N'0', N'1')
GO

SET IDENTITY_INSERT [dbo].[promotions] OFF
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
  [ticket_price] decimal(10,2)  NULL
)
GO

ALTER TABLE [dbo].[screenings] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of screenings
-- ----------------------------
SET IDENTITY_INSERT [dbo].[screenings] ON
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price]) VALUES (N'24', N'9', N'1', N'2025-07-25 00:31:00.0000000', N'100000.00')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price]) VALUES (N'25', N'10', N'4', N'2025-07-26 12:06:00.0000000', N'100000.00')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [ticket_price]) VALUES (N'26', N'11', N'1', N'2025-07-26 16:16:00.0000000', N'100000.00')
GO

SET IDENTITY_INSERT [dbo].[screenings] OFF
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
  [seat_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[seats] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of seats
-- ----------------------------
SET IDENTITY_INSERT [dbo].[seats] ON
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1', N'1', N'A', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'2', N'1', N'A', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'3', N'1', N'A', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'4', N'1', N'A', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'5', N'1', N'A', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'6', N'1', N'A', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'7', N'1', N'A', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'8', N'1', N'A', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'9', N'1', N'A', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'10', N'1', N'A', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'11', N'1', N'A', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'12', N'1', N'A', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'13', N'1', N'B', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'14', N'1', N'B', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'15', N'1', N'B', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'16', N'1', N'B', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'17', N'1', N'B', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'18', N'1', N'B', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'19', N'1', N'B', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'20', N'1', N'B', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'21', N'1', N'B', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'22', N'1', N'B', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'23', N'1', N'B', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'24', N'1', N'B', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'25', N'1', N'C', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'26', N'1', N'C', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'27', N'1', N'C', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'28', N'1', N'C', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'29', N'1', N'C', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'30', N'1', N'C', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'31', N'1', N'C', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'32', N'1', N'C', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'33', N'1', N'C', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'34', N'1', N'C', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'35', N'1', N'C', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'36', N'1', N'C', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'37', N'1', N'D', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'38', N'1', N'D', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'39', N'1', N'D', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'40', N'1', N'D', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'41', N'1', N'D', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'42', N'1', N'D', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'43', N'1', N'D', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'44', N'1', N'D', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'45', N'1', N'D', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'46', N'1', N'D', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'47', N'1', N'D', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'48', N'1', N'D', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'49', N'1', N'E', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'50', N'1', N'E', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'51', N'1', N'E', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'52', N'1', N'E', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'53', N'1', N'E', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'54', N'1', N'E', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'55', N'1', N'E', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'56', N'1', N'E', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'57', N'1', N'E', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'58', N'1', N'E', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'59', N'1', N'E', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'60', N'1', N'E', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'61', N'1', N'F', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'62', N'1', N'F', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'63', N'1', N'F', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'64', N'1', N'F', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'65', N'1', N'F', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'66', N'1', N'F', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'67', N'1', N'F', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'68', N'1', N'F', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'69', N'1', N'F', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'70', N'1', N'F', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'71', N'1', N'F', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'72', N'1', N'F', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'73', N'1', N'G', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'74', N'1', N'G', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'75', N'1', N'G', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'76', N'1', N'G', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'77', N'1', N'G', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'78', N'1', N'G', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'79', N'1', N'G', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'80', N'1', N'G', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'81', N'1', N'G', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'82', N'1', N'G', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'83', N'1', N'G', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'84', N'1', N'G', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'85', N'1', N'H', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'86', N'1', N'H', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'87', N'1', N'H', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'88', N'1', N'H', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'89', N'1', N'H', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'90', N'1', N'H', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'91', N'1', N'H', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'92', N'1', N'H', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'93', N'1', N'H', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'94', N'1', N'H', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'95', N'1', N'H', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'96', N'1', N'H', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'97', N'1', N'I', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'98', N'1', N'I', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'99', N'1', N'I', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'100', N'1', N'I', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'101', N'1', N'I', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'102', N'1', N'I', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'103', N'1', N'I', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'104', N'1', N'I', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'105', N'1', N'I', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'106', N'1', N'I', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'107', N'1', N'I', N'11', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'108', N'1', N'I', N'12', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'109', N'1', N'J', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'110', N'1', N'J', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'111', N'1', N'J', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'112', N'1', N'J', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'113', N'1', N'J', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'114', N'1', N'J', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'115', N'1', N'J', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'116', N'1', N'J', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'117', N'1', N'J', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'118', N'1', N'J', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'119', N'1', N'J', N'11', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'120', N'1', N'J', N'12', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'121', N'2', N'A', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'122', N'2', N'A', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'123', N'2', N'A', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'124', N'2', N'A', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'125', N'2', N'A', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'126', N'2', N'A', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'127', N'2', N'A', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'128', N'2', N'A', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'129', N'2', N'A', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'130', N'2', N'A', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'131', N'2', N'A', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'132', N'2', N'A', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'133', N'2', N'A', N'13', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'134', N'2', N'B', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'135', N'2', N'B', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'136', N'2', N'B', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'137', N'2', N'B', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'138', N'2', N'B', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'139', N'2', N'B', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'140', N'2', N'B', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'141', N'2', N'B', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'142', N'2', N'B', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'143', N'2', N'B', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'144', N'2', N'B', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'145', N'2', N'B', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'146', N'2', N'B', N'13', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'147', N'2', N'C', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'148', N'2', N'C', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'149', N'2', N'C', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'150', N'2', N'C', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'151', N'2', N'C', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'152', N'2', N'C', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'153', N'2', N'C', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'154', N'2', N'C', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'155', N'2', N'C', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'156', N'2', N'C', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'157', N'2', N'C', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'158', N'2', N'C', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'159', N'2', N'C', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'171', N'2', N'D', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'172', N'2', N'D', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'173', N'2', N'E', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'174', N'2', N'E', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'175', N'2', N'E', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'176', N'2', N'E', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'177', N'2', N'E', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'178', N'2', N'E', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'179', N'2', N'E', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'180', N'2', N'E', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'181', N'2', N'E', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'182', N'2', N'E', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'183', N'2', N'E', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'184', N'2', N'E', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'185', N'2', N'E', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'186', N'2', N'F', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'187', N'2', N'F', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'188', N'2', N'F', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'189', N'2', N'F', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'190', N'2', N'F', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'191', N'2', N'F', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'192', N'2', N'F', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'193', N'2', N'F', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'194', N'2', N'F', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'195', N'2', N'F', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'196', N'2', N'F', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'197', N'2', N'F', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'198', N'2', N'F', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'199', N'2', N'G', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'200', N'2', N'G', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'201', N'2', N'G', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'202', N'2', N'G', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'203', N'2', N'G', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'204', N'2', N'G', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'205', N'2', N'G', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'206', N'2', N'G', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'207', N'2', N'G', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'208', N'2', N'G', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'209', N'2', N'G', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'210', N'2', N'G', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'211', N'2', N'G', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'212', N'2', N'H', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'213', N'2', N'H', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'214', N'2', N'H', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'215', N'2', N'H', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'216', N'2', N'H', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'217', N'2', N'H', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'218', N'2', N'H', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'219', N'2', N'H', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'220', N'2', N'H', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'221', N'2', N'H', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'222', N'2', N'H', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'223', N'2', N'H', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'224', N'2', N'H', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'225', N'2', N'I', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'226', N'2', N'I', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'227', N'2', N'I', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'228', N'2', N'I', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'229', N'2', N'I', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'230', N'2', N'I', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'231', N'2', N'I', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'232', N'2', N'I', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'233', N'2', N'I', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'234', N'2', N'I', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'235', N'2', N'I', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'236', N'2', N'I', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'237', N'2', N'I', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'238', N'2', N'J', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'239', N'2', N'J', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'240', N'2', N'J', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'241', N'2', N'J', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'242', N'2', N'J', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'243', N'2', N'J', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'244', N'2', N'J', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'245', N'2', N'J', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'246', N'2', N'J', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'247', N'2', N'J', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'248', N'2', N'J', N'11', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'249', N'2', N'K', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'250', N'2', N'K', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'251', N'2', N'K', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'252', N'2', N'K', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'253', N'2', N'K', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'254', N'2', N'K', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'255', N'2', N'K', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'256', N'2', N'K', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'257', N'2', N'K', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'258', N'2', N'K', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'259', N'2', N'K', N'11', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'260', N'2', N'L', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'261', N'2', N'L', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'262', N'2', N'L', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'263', N'2', N'L', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'264', N'2', N'L', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'265', N'2', N'L', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'266', N'2', N'L', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'267', N'2', N'L', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'268', N'2', N'L', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'269', N'2', N'L', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'270', N'2', N'L', N'11', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'271', N'6', N'A', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'272', N'6', N'A', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'273', N'6', N'A', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'274', N'6', N'A', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'275', N'6', N'A', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'276', N'6', N'A', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'277', N'6', N'A', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'278', N'6', N'A', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'279', N'6', N'A', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'280', N'6', N'A', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'281', N'6', N'A', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'282', N'6', N'A', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'283', N'6', N'A', N'13', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'284', N'6', N'B', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'285', N'6', N'B', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'286', N'6', N'B', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'287', N'6', N'B', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'288', N'6', N'B', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'289', N'6', N'B', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'290', N'6', N'B', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'291', N'6', N'B', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'292', N'6', N'B', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'293', N'6', N'B', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'294', N'6', N'B', N'11', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'295', N'6', N'B', N'12', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'296', N'6', N'B', N'13', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'297', N'6', N'C', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'298', N'6', N'C', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'299', N'6', N'C', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'300', N'6', N'C', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'301', N'6', N'C', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'302', N'6', N'C', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'303', N'6', N'C', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'304', N'6', N'C', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'305', N'6', N'C', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'306', N'6', N'C', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'307', N'6', N'C', N'11', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'308', N'6', N'C', N'12', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'309', N'6', N'C', N'13', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1551', N'12', N'A', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1552', N'12', N'A', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1553', N'12', N'A', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1554', N'12', N'A', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1555', N'12', N'A', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1556', N'12', N'A', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1557', N'12', N'A', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1558', N'12', N'A', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1559', N'12', N'A', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1560', N'12', N'A', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1561', N'12', N'B', N'1', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1562', N'12', N'B', N'2', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1563', N'12', N'B', N'3', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1564', N'12', N'B', N'4', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1565', N'12', N'B', N'5', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1566', N'12', N'B', N'6', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1567', N'12', N'B', N'7', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1568', N'12', N'B', N'8', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1569', N'12', N'B', N'9', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1570', N'12', N'B', N'10', N'VIP')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1571', N'12', N'C', N'1', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1572', N'12', N'C', N'2', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1573', N'12', N'C', N'3', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1574', N'12', N'C', N'4', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1575', N'12', N'C', N'5', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1576', N'12', N'C', N'6', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1577', N'12', N'C', N'7', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1578', N'12', N'C', N'8', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1579', N'12', N'C', N'9', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1580', N'12', N'C', N'10', N'STANDARD')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1581', N'12', N'D', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1582', N'12', N'D', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1583', N'12', N'D', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1584', N'12', N'D', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1585', N'12', N'D', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1586', N'12', N'D', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1587', N'12', N'D', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1588', N'12', N'D', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1589', N'12', N'D', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1590', N'12', N'D', N'10', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1591', N'12', N'E', N'1', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1592', N'12', N'E', N'2', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1593', N'12', N'E', N'3', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1594', N'12', N'E', N'4', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1595', N'12', N'E', N'5', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1596', N'12', N'E', N'6', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1597', N'12', N'E', N'7', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1598', N'12', N'E', N'8', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1599', N'12', N'E', N'9', N'COUPLE')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type]) VALUES (N'1600', N'12', N'E', N'10', N'COUPLE')
GO

SET IDENTITY_INSERT [dbo].[seats] OFF
GO


-- ----------------------------
-- Table structure for theaters
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[theaters]') AND type IN ('U'))
	DROP TABLE [dbo].[theaters]
GO

CREATE TABLE [dbo].[theaters] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [city] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [address] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[theaters] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of theaters
-- ----------------------------
SET IDENTITY_INSERT [dbo].[theaters] ON
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address]) VALUES (N'1', N'CGV Vincom Đà Nẵng', N'Đà Nẵng', N'238-240-242 Lê Thánh Tôn, Phường Máy Chai, Quận Ngô Quyền, Hải Phòng')
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address]) VALUES (N'2', N'Lotte Cinema Đà Nẵng', N'Đà Nẵng', N'Tầng 3, Lotte Mart Đà Nẵng, 6 Năm Thắng, Quận Hải Châu, Đà Nẵng')
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address]) VALUES (N'3', N'Galaxy Cinema Đà Nẵng', N'Đà Nẵng', N'Tầng 3, Vincom Plaza Đà Nẵng, 910A Ngô Quyền, Quận Sơn Trà, Đà Nẵng')
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address]) VALUES (N'4', N'CGV Vincom Hà Nội', N'Hà Nội', N'191 Bà Triệu, Hai Bà Trưng, Hà Nội')
GO

SET IDENTITY_INSERT [dbo].[theaters] OFF
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
  [role] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [full_name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [auth_provider] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'LOCAL' NULL,
  [provider_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [created_at] datetime2(7) DEFAULT getdate() NULL,
  [last_login] datetime2(7)  NULL,
  [is_enabled] bit DEFAULT 1 NULL
)
GO

ALTER TABLE [dbo].[users] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of users
-- ----------------------------
SET IDENTITY_INSERT [dbo].[users] ON
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'1', N'admin', N'admin@cinema.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'ADMIN', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 22:54:25.6833333', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'2', N'john.doe', N'john.doe@example.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'CUSTOMER', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 22:54:25.6833333', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'3', N'jane.smith', N'jane.smith@example.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'CUSTOMER', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 22:54:25.6833333', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'4', N'bob.wilson', N'bob.wilson@example.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'CUSTOMER', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 22:54:25.6833333', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'5', N'manager1', N'manager1@cinema.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'THEATER_MANAGER', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 22:54:25.6833333', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'6', N'BIT230014', N'phungducanh2k5@gmail.com', N'$2a$10$BJmGs4wMnUxlWqFXwLZrHe6SktiRURUPmbb1CFZY9NHegG9tW9ZhO', N'CUSTOMER', NULL, NULL, N'LOCAL', NULL, N'2025-07-04 23:52:08.1618461', NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [avatar_url], [auth_provider], [provider_id], [created_at], [last_login], [is_enabled]) VALUES (N'7', N'DucAnh808', N'ducanh.aoa@gmail.com', N'$2a$10$uamhJjVN7lXrtoSCncqlT.bH4Vsn1uq1XpGpg1vnni9Sgz.uyxWVq', N'CUSTOMER', NULL, NULL, N'LOCAL', NULL, N'2025-07-16 11:54:08.5273791', NULL, N'1')
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO


-- ----------------------------
-- Auto increment value for auditoriums
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[auditoriums]', RESEED, 12)
GO


-- ----------------------------
-- Primary Key structure for table auditoriums
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [PK__auditori__3213E83FD77C8F9E] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for booked_seats
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[booked_seats]', RESEED, 7)
GO


-- ----------------------------
-- Indexes structure for table booked_seats
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_booked_seats_screening_id]
ON [dbo].[booked_seats] (
  [screening_id] ASC
)
GO


-- ----------------------------
-- Uniques structure for table booked_seats
-- ----------------------------
ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [UQ__booked_s__B41A99F1794D474C] UNIQUE NONCLUSTERED ([seat_id] ASC, [screening_id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table booked_seats
-- ----------------------------
ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [PK__booked_s__3213E83FB1128BFA] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table booking_promotions
-- ----------------------------
ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [PK__booking___FF2830E760C21942] PRIMARY KEY CLUSTERED ([booking_id], [promotion_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for bookings
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[bookings]', RESEED, 3)
GO


-- ----------------------------
-- Indexes structure for table bookings
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_bookings_user_id]
ON [dbo].[bookings] (
  [user_id] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_bookings_screening_id]
ON [dbo].[bookings] (
  [screening_id] ASC
)
GO


-- ----------------------------
-- Checks structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [CK__bookings__bookin__4BAC3F29] CHECK ([booking_status]='EXPIRED' OR [booking_status]='CANCELLED' OR [booking_status]='CONFIRMED' OR [booking_status]='RESERVED')
GO


-- ----------------------------
-- Primary Key structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [PK__bookings__3213E83F1D41F623] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for movies
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[movies]', RESEED, 35)
GO


-- ----------------------------
-- Indexes structure for table movies
-- ----------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_movies_tmdb_id]
ON [dbo].[movies] (
  [tmdb_id] ASC
)
WHERE ([tmdb_id] IS NOT NULL)
GO


-- ----------------------------
-- Primary Key structure for table movies
-- ----------------------------
ALTER TABLE [dbo].[movies] ADD CONSTRAINT [PK__movies__3213E83FA23DAEB3] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for payments
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[payments]', RESEED, 3)
GO


-- ----------------------------
-- Uniques structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [UQ__payments__5DE3A5B0CAF1A2E4] UNIQUE NONCLUSTERED ([booking_id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Checks structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [CK__payments__paymen__60A75C0F] CHECK ([payment_method]='CASH' OR [payment_method]='BANK_TRANSFER' OR [payment_method]='E_WALLET' OR [payment_method]='DEBIT_CARD' OR [payment_method]='CREDIT_CARD')
GO

ALTER TABLE [dbo].[payments] ADD CONSTRAINT [CK__payments__status__619B8048] CHECK ([status]='REFUNDED' OR [status]='FAILED' OR [status]='COMPLETED' OR [status]='PENDING')
GO


-- ----------------------------
-- Primary Key structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [PK__payments__3213E83FD3E1188A] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for promotions
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[promotions]', RESEED, 4)
GO


-- ----------------------------
-- Uniques structure for table promotions
-- ----------------------------
ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [UQ__promotio__357D4CF940850233] UNIQUE NONCLUSTERED ([code] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Checks structure for table promotions
-- ----------------------------
ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [CK__promotion__disco__571DF1D5] CHECK ([discount_type]='FIXED_AMOUNT' OR [discount_type]='PERCENTAGE')
GO


-- ----------------------------
-- Primary Key structure for table promotions
-- ----------------------------
ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [PK__promotio__3213E83FE74F4B29] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for screenings
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[screenings]', RESEED, 26)
GO


-- ----------------------------
-- Indexes structure for table screenings
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_screenings_movie_id]
ON [dbo].[screenings] (
  [movie_id] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_screenings_auditorium_id]
ON [dbo].[screenings] (
  [auditorium_id] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_screenings_start_time]
ON [dbo].[screenings] (
  [start_time] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table screenings
-- ----------------------------
ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [PK__screenin__3213E83FA53D88D7] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for seats
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[seats]', RESEED, 1600)
GO


-- ----------------------------
-- Indexes structure for table seats
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_seats_auditorium_id]
ON [dbo].[seats] (
  [auditorium_id] ASC
)
GO


-- ----------------------------
-- Uniques structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [UQ_seats_position] UNIQUE NONCLUSTERED ([auditorium_id] ASC, [row_number] ASC, [seat_position] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Checks structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [CK__seats__seat_type__3E52440B] CHECK ([seat_type]='COUPLE' OR [seat_type]='VIP' OR [seat_type]='STANDARD')
GO


-- ----------------------------
-- Primary Key structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [PK__seats__3213E83FC23F79A9] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for theaters
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[theaters]', RESEED, 6)
GO


-- ----------------------------
-- Primary Key structure for table theaters
-- ----------------------------
ALTER TABLE [dbo].[theaters] ADD CONSTRAINT [PK__theaters__3213E83FB9FE8408] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for users
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[users]', RESEED, 8)
GO


-- ----------------------------
-- Indexes structure for table users
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_users_provider]
ON [dbo].[users] (
  [auth_provider] ASC,
  [provider_id] ASC
)
GO


-- ----------------------------
-- Uniques structure for table users
-- ----------------------------
ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ__users__AB6E6164B7DD1979] UNIQUE NONCLUSTERED ([email] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ__users__F3DBC5721E544740] UNIQUE NONCLUSTERED ([username] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Checks structure for table users
-- ----------------------------
ALTER TABLE [dbo].[users] ADD CONSTRAINT [CK__users__role__47DBAE45] CHECK ([role]='THEATER_MANAGER' OR [role]='ADMIN' OR [role]='CUSTOMER')
GO

ALTER TABLE [dbo].[users] ADD CONSTRAINT [CHK_users_auth_provider] CHECK ([auth_provider]='GITHUB' OR [auth_provider]='GOOGLE' OR [auth_provider]='LOCAL')
GO


-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK__users__3213E83F5F479D5C] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Foreign Keys structure for table auditoriums
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [FK__auditoriu__theat__3B75D760] FOREIGN KEY ([theater_id]) REFERENCES [dbo].[theaters] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table booked_seats
-- ----------------------------
ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK__booked_se__booki__5165187F] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK__booked_se__seat___52593CB8] FOREIGN KEY ([seat_id]) REFERENCES [dbo].[seats] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK__booked_se__scree__534D60F1] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table booking_promotions
-- ----------------------------
ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK__booking_p__booki__5BE2A6F2] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK__booking_p__promo__5CD6CB2B] FOREIGN KEY ([promotion_id]) REFERENCES [dbo].[promotions] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK__bookings__user_i__4CA06362] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK__bookings__screen__4D94879B] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [FK__payments__bookin__628FA481] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table screenings
-- ----------------------------
ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK__screening__movie__4222D4EF] FOREIGN KEY ([movie_id]) REFERENCES [dbo].[movies] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK__screening__audit__4316F928] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [FK__seats__auditoriu__3F466844] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

