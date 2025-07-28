/*
 Navicat Premium Data Transfer

 Source Server         : Java
 Source Server Type    : SQL Server
 Source Server Version : 16001140
 Source Catalog        : cinema
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001140
 File Encoding         : 65001

 Date: 28/07/2025 17:34:29
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
-- Records of auditoriums
-- ----------------------------
SET IDENTITY_INSERT [dbo].[auditoriums] ON
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'105', N'27', N'Phòng 1', N'50', N'2D/3D', N'Dolby Atmos')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'106', N'27', N'Phòng 2', N'50', N'2D/3D', N'DTS')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'107', N'27', N'Phòng 3', N'50', N'2D/3D', N'THX')
GO

INSERT INTO [dbo].[auditoriums] ([id], [theater_id], [name], [total_seats], [screen_type], [sound_system]) VALUES (N'108', N'27', N'Phòng 4', N'50', N'2D/3D', N'Standard')
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
  [screening_id] bigint  NOT NULL,
  [seat_price] decimal(10,2)  NULL
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
  [rating] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL
)
GO

ALTER TABLE [dbo].[movies] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of movies
-- ----------------------------
SET IDENTITY_INSERT [dbo].[movies] ON
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'1', N'Oppenheimer', N'180', N'Drama, History', N'Câu chuyện về J. Robert Oppenheimer, nhà khoa học được giao nhiệm vụ phát triển bom nguyên tử trong Thế chiến II.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'R', N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'2', N'Barbie', N'114', N'Comedy, Adventure', N'Barbie và Ken đang có một ngày tuyệt vời ở thế giới màu hồng, hoàn hảo của họ trong Barbieland.', N'2023-07-21', N'https://image.tmdb.org/t/p/w500/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'PG-13', N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'3', N'Spider-Man: Across the Spider-Verse', N'140', N'Animation, Action', N'Sau khi đoàn tụ với Gwen Stacy, Spider-Man thân thiện của Brooklyn được thúc đẩy khắp Đa vũ trụ.', N'2023-06-02', N'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'PG', N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'4', N'Bí Kíp Luyện Rồng', NULL, N'Fantasy, Family, Action', N'Phiên bản Live Action (người đóng) của studio DreamWorks rất được mong chờ đã ra mắt. Câu chuyện về một chàng trai trẻ với ước mơ trở thành thợ săn rồng, nhưng định mệnh lại đưa đẩy anh đến tình bạn bất ngờ với một chú rồng.', N'2025-06-06', N'https://image.tmdb.org/t/p/w500/sIQRZYHRJN1ZzulxpXuoXEgkkSe.jpg', N'1087192', N'https://image.tmdb.org/t/p/w1280/8J6UlIFcU7eZfq9iCLbgc8Auklg.jpg', N'en', N'8.082', N'1281', N'793.171', N'How to Train Your Dragon', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'5', N'Thanh Gươm Diệt Quỷ: Vô Hạn Thành', NULL, N'Animation, Action, Fantasy, Thriller', N'Khi các thành viên của Sát Quỷ Đoàn và Trụ Cột tham gia vào chương trình đặc huấn để chuẩn bị cho trận chiến sắp với lũ quỷ, Kibutsuji Muzan xuất hiện tại Dinh thự Ubuyashiki. Khi thủ lĩnh của Sát Quỷ Đoàn gặp nguy hiểm, Tanjiro và các Trụ Cột trở về trụ sở Thế nhưng, Muzan bất ngờ kéo toàn bộ Sát Quỷ Đoàn đến hang ổ cuối cùng của lũ quỷ là Vô Hạn Thành, mở màn cho trận đánh cuối cùng của cả hai phe.', N'2025-07-18', N'https://image.tmdb.org/t/p/w500/nV99ACeAa8fFFso0tQZ3HktEf5X.jpg', N'1311031', N'https://image.tmdb.org/t/p/w1280/1RgPyOhN4DRs225BGTlHJqCudII.jpg', N'ja', N'6.7', N'34', N'675.0133', N'劇場版「鬼滅の刃」無限城編 第一章 猗窩座再来', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'6', N'Lilo và Stitch', NULL, N'Family, Science Fiction, Comedy, Adventure', N'Cuộc sống của hai chị em bị xáo trộn khi Lilo nhận nuôi một "con chó" kỳ lạ từ trại cứu hộ động vật. Con vật đó thực chất là Thí nghiệm 626, hay còn gọi là Stitch (lồng tiếng bởi Chris Sanders, người lồng tiếng cho Stitch trong bản hoạt hình gốc), một sinh vật ngoài hành tinh được tạo ra bởi nhà khoa học điên rồ Dr. Jumba Jookiba (Zach Galifianakis) với mục đích gây hỗn loạn. Stitch là một "quả bóng hủy diệt" không thể kiểm soát, nhưng Lilo lại coi cậu bé là người bạn thân nhất mà cô hằng mong ước.', N'2025-05-17', N'https://image.tmdb.org/t/p/w500/aOfmWQHIdunw4Xnc4ZL7DUDDgNl.jpg', N'552524', N'https://image.tmdb.org/t/p/w1280/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg', N'en', N'7.347', N'1124', N'633.1745', N'Lilo & Stitch', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'7', N'M3GAN 2.0', NULL, N'Action, Science Fiction, Thriller', N'Phim lấy bối cảnh 2 năm sau các sự kiện ở phần 1. Lúc này, Gemma phát hiện công nghệ sản xuất MEGAN đã bị đánh cắp. Kẻ gian đã tạo ra một robot AI khác với chức năng tương tự MEGAN, nhưng được trang bị sức mạnh chiến đấu "khủng" hơn mang tên Amelia. Để "đối đầu" với Amelia, Gemma buộc phải "hồi sinh" và cải tiến MEGAN, hứa hẹn một trận chiến "nảy lửa" trên màn ảnh vào năm 2025.', N'2025-06-25', N'https://image.tmdb.org/t/p/w500/psASSoFLAGFoXwyfRg4hDZHgshN.jpg', N'1071585', N'https://image.tmdb.org/t/p/w1280/cEQMqB3ahd4mfeUN6VGC0ouVnZZ.jpg', N'en', N'7.626', N'518', N'505.6093', N'M3GAN 2.0', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'8', N'Bộ Tứ Siêu Đẳng: Bước Đi Đầu Tiên', NULL, N'Science Fiction, Adventure', N'Sau một chuyến bay thám hiểm vũ trụ, bốn phi hành gia bất ngờ sở hữu năng lực siêu nhiên và trở thành gia đình siêu anh hùng đầu tiên của Marvel. The Fantastic Four: First Steps là bộ phim mở đầu Kỷ nguyên anh hùng thứ sáu (Phase Six), đặt nền móng cho siêu bom tấn Avengers: Doomsday trong năm sau.', N'2025-07-23', N'https://image.tmdb.org/t/p/w500/n0bqzWiKGJsmnvOlkTiYykhhM4E.jpg', N'617126', N'https://image.tmdb.org/t/p/w1280/s94NjfKkcSczZ1FembwmQZwsuwY.jpg', N'en', N'7.335', N'460', N'416.2964', N'The Fantastic 4: First Steps', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'9', N'Cô Dâu Hành Động', NULL, N'Action, Comedy', N'', N'2025-06-19', N'https://image.tmdb.org/t/p/w500/3mExdWLSxAiUCb4NMcYmxSkO7n4.jpg', N'1124619', N'https://image.tmdb.org/t/p/w1280/h6gChZHFpmbwqwV3uQsoakp77p1.jpg', N'en', N'6.059', N'34', N'398.7898', N'Bride Hard', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'10', N'Người Đàn Ông Không Có Quá Khứ', NULL, N'Action, Drama', N'Người đàn ông mất trí nhớ tỉnh dậy ở một thành phố xa lạ, tìm kiếm sự thật về quá khứ. Được đồng minh hỗ trợ, thâm nhập vào băng đảng hùng mạnh, tham gia vào trận chiến vượt thời gian trong khi số phận đang rình rập.', N'2025-01-13', N'https://image.tmdb.org/t/p/w500/eWHvROuznSzcxBAAkzX1X0Rmzoe.jpg', N'1315986', N'https://image.tmdb.org/t/p/w1280/8or4S9BPhkeYK0vlKsPFee4JVWI.jpg', N'en', N'6.413', N'40', N'326.2724', N'Man with No Past', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'11', N'Superman', NULL, N'Science Fiction, Adventure, Action', N'Mùa hè tới đây, Warner Bros. Pictures sẽ mang “Superman” - phim điện ảnh đầu tiên của DC Studios đến các rạp chiếu trên toàn cầu. Với phong cách riêng biệt của mình, James Gunn sẽ khắc họa người hùng huyền thoại trong vũ trụ DC hoàn toàn mới, với sự kết hợp độc đáo của các yếu tố hành động đỉnh cao, hài hước và vô cùng cảm xúc. Một Superman với lòng trắc ẩn và niềm tin vào sự thiện lương của con người sẽ xuất hiện đầy hứa hẹn trên màn ảnh.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/f4hJ5yVSiOSnW9S6vtoGlNYvW5J.jpg', N'1061474', N'https://image.tmdb.org/t/p/w1280/ApRxyHFuvv5yghedxXPJSm9FEDe.jpg', N'en', N'7.4', N'1229', N'320.7292', N'Superman', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'12', N'Siêu Nhí Karate: Những Câu Chuyện Huyền Thoại', NULL, N'Action, Adventure, Drama', N'', N'2025-05-08', N'https://image.tmdb.org/t/p/w500/jMtD6YLSTCaBlCAsGxGOa4n2Po8.jpg', N'1011477', N'https://image.tmdb.org/t/p/w1280/7Q2CmqIVJuDAESPPp76rWIiA0AD.jpg', N'en', N'7.218', N'554', N'306.2789', N'Karate Kid: Legends', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'13', N'Con Đường Băng 2: Trả Đũa', NULL, N'Action, Thriller, Drama', N'Tài xế xe tải đường băng huyền thoại Mike McCann đến Nepal để hoàn thành tâm nguyện cuối cùng của người anh trai quá cố: rải tro cốt trên đỉnh Everest. Nhưng hành trình tưởng như bình yên lại trở thành ác mộng khi chiếc xe buýt chở đầy du khách mà anh đi cùng bị tấn công trên cung đường “Tiến về bầu trời” – một trong những tuyến đường nguy hiểm nhất thế giới. Trên vùng núi cao hiểm trở, McCann và người hướng dẫn leo núi buộc phải chiến đấu với nhóm lính đánh thuê bí ẩn, bảo vệ những người dân vô tội – và một ngôi làng đang đứng bên bờ vực bị xóa sổ.', N'2025-06-27', N'https://image.tmdb.org/t/p/w500/cQN9rZj06rXMVkk76UF1DfBAico.jpg', N'1119878', N'https://image.tmdb.org/t/p/w1280/962KXsr09uK8wrmUg9TjzmE7c4e.jpg', N'en', N'6.912', N'147', N'307.8691', N'Ice Road: Vengeance', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'14', N'Gilmore, tay golf cừ khôi 2', NULL, N'Comedy', N'Cú đánh xa. Nóng tính. Không thể thua? Happy Gilmore không vung gậy đánh golf trong nhiều năm, nhưng để giúp đỡ gia đình, anh phải thực hiện màn lội ngược dòng ngoạn mục.', N'2025-07-25', N'https://image.tmdb.org/t/p/w500/ynT06XivgBDkg7AtbDbX1dJeBGY.jpg', N'1263256', N'https://image.tmdb.org/t/p/w1280/88DDOXggxZLxobBolSRRLkaS8h7.jpg', N'en', N'6.774', N'215', N'372.098', N'Happy Gilmore 2', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'15', N'Thiên Thần Sa Ngã: Những Chiến Binh Hòa Bình', NULL, N'Horror, Action, Fantasy, Adventure', N'', N'2024-07-09', N'https://image.tmdb.org/t/p/w500/dKdKUSGQ9E0G73WPr9xIHrofpkT.jpg', N'1058537', N'https://image.tmdb.org/t/p/w1280/xVcffNU61CclEGgtiWP7KLIE2dm.jpg', N'en', N'5.838', N'34', N'281.3527', N'Angels Fallen: Warriors of Peace', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'16', N'Từ Vũ Trụ John Wick: Ballerina', NULL, N'Action, Thriller, Crime', N'Lấy bối cảnh giữa sự kiện của Sát thủ John Wick: Phần 3 – Chuẩn Bị Chiến Tranh, bộ phim Từ Vũ Trụ John Wick: Ballerina theo chân Eve Macarro (thủ vai bởi Ana de Armas) trên hành trình trả thù cho cái chết của gia đình mình, dưới sự huấn luyện của tổ chức tội phạm Ruska Roma.', N'2025-06-04', N'https://image.tmdb.org/t/p/w500/bw7gsWIJgoPyxrAgfSHc8xqVhDA.jpg', N'541671', N'https://image.tmdb.org/t/p/w1280/oPgXVSdGR9dGwbmvIToOCMmsdc2.jpg', N'en', N'7.5', N'1170', N'245.5089', N'Ballerina', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'17', N'Thế Giới Khủng Long: Tái Sinh', NULL, N'Science Fiction, Adventure, Action', N'Thế Giới Khủng Long: Tái Sinh lấy bối cảnh 5 năm sau phần phim Thế Giới Khủng Long: Lãnh Địa, môi trường Trái đất đã chứng tỏ phần lớn là không phù hợp với khủng long. Nhiều loài thằn lằn tiền sử được tái sinh đã chết. Những con chưa chết đã rút lui đến một vùng nhiệt đới hẻo lánh gần phòng thí nghiệm. Địa điểm đó chính là nơi bộ ba Scarlett Johansson, Mahershala Ali và Jonathan Bailey dấn thân vào một nhiệm vụ cực kỳ hiểm nguy.', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/2IVVciw7dPhUlNmYIaz0s1d56SZ.jpg', N'1234821', N'https://image.tmdb.org/t/p/w1280/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg', N'en', N'6.333', N'818', N'250.4601', N'Jurassic World Rebirth', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'18', N'Thợ săn quỷ Kpop', NULL, N'Animation, Fantasy, Comedy, Music, Family, Action', N'Khi các siêu sao Kpop Rumi, Mira và Zoey không bận trình diễn tại các sân vận động cháy vé, họ sử dụng sức mạnh bí mật để bảo vệ người hâm mộ khỏi những mối đe dọa siêu nhiên.', N'2025-06-20', N'https://image.tmdb.org/t/p/w500/y8OyohPhdTtusY0nXd2XdX4NN8W.jpg', N'803796', N'https://image.tmdb.org/t/p/w1280/l3ycQYwWmbz7p8otwbomFDXIEhn.jpg', N'en', N'8.486', N'828', N'218.7749', N'KPop Demon Hunters', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'19', N'Biệt Đội Sấm Sét*', NULL, N'Action, Science Fiction, Adventure', N'Sau khi thấy mình bị mắc kẹt trong một cái bẫy chết người, bảy người bị bỏ rơi vỡ mộng phải bắt tay vào một nhiệm vụ nguy hiểm sẽ buộc họ phải đối mặt với những góc đen tối nhất trong quá khứ của họ.', N'2025-04-30', N'https://image.tmdb.org/t/p/w500/8SHwKExQ9dkR8xEmtT3y2vrHZEY.jpg', N'986056', N'https://image.tmdb.org/t/p/w1280/rthMuZfFv4fqEU4JVbgSW9wQ8rs.jpg', N'en', N'7.405', N'2028', N'216.9315', N'Thunderbolts*', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'20', N'Bad Boas: Bộ đôi phá án', NULL, N'Action, Comedy, Crime, Mystery', N'Khi một cảnh sát cộng đồng hăng hái quá mức và một cựu thanh tra liều lĩnh buộc phải hợp tác, hàng loạt hỗn loạn bùng nổ trên đường phố Rotterdam.', N'2025-07-10', N'https://image.tmdb.org/t/p/w500/upzsNh9Ue3DmFlGnUlxwXtnEpQc.jpg', N'1374534', N'https://image.tmdb.org/t/p/w1280/9l6bcHNFLR2fcCBSPzEeqxiQhwU.jpg', N'nl', N'5.85', N'103', N'209.5423', N'Bad Boa''s', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'21', N'Lưỡi hái tử thần 6: Huyết thống', NULL, N'Horror, Mystery', N'Thương hiệu kinh dị đình đám Hollywood Final Destination sẽ trở lại với phần phim mới, hứa hẹn khuấy đảo phòng vé mùa hè 2025. Final Destination: Bloodlines là phần thứ 6 trong series, và cho đến hiện tại, các thông tin về nội dung phần phim này vẫn đang được giữ kín. Bộ đôi Zach Lipovsky và Adam Stein được chọn từ hơn 200 ứng viên để ngồi ghế đạo diễn, trong khi Guy Busick – biên kịch của Ready or Not sẽ chấp bút cho bộ phim. Tony Todd – gương mặt quen thuộc của series cũng sẽ trở lại trong phần 6 với vai diễn William Bludworth.', N'2025-05-14', N'https://image.tmdb.org/t/p/w500/6WxhEvFsauuACfv8HyoVX6mZKFj.jpg', N'574475', N'https://image.tmdb.org/t/p/w1280/uIpJPDNFoeX0TVml9smPrs9KUVx.jpg', N'en', N'7.174', N'1757', N'213.8732', N'Final Destination Bloodlines', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'22', N'Giờ Thả Máu', NULL, N'Horror, Thriller', N'', N'2025-06-05', N'https://image.tmdb.org/t/p/w500/mClqoQYzgmro8C4TXnVqgiXSxl3.jpg', N'1285965', N'https://image.tmdb.org/t/p/w1280/dUGIhpvAVoX0YtKcjLHCGtNYq4p.jpg', N'en', N'6.569', N'87', N'198.0632', N'Dangerous Animals', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'23', N'The Old Guard 2', NULL, N'Action, Fantasy', N'Andy và đội chiến binh bất tử chiến đấu với mục đích mới khi họ đương đầu với một kẻ thù mới hùng mạnh đang đe dọa sứ mệnh bảo vệ nhân loại của họ.', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/wqfu3bPLJaEWJVk3QOm0rKhxf1A.jpg', N'846422', N'https://image.tmdb.org/t/p/w1280/fd9K7ZDfzRAcbLh8JlG4HIKbtuR.jpg', N'en', N'6.039', N'567', N'166.9309', N'The Old Guard 2', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'24', N'Xì Trum', N'102', N'Phim Hoạt Hình, Phim Gia Đình, Phim Phiêu Lưu, Phim Hài, Phim Giả Tượng', N'Lão phù thủy độc ác Gargamel rượt đưổi các chú xì - trum ra khỏi ngôi làng của mình. Tình cờ họ đã vô tình lạc vào hang động cấm mà không biết đó chính là Blue moon , một cánh cửa thần kỳ giúp đưa các xì trum đến thời hiện tại ở công viên Trung tâm New York. Họ đã phải nương náu tại nhà của một cặp đôi mới cưới và tìm cách quay trở lại ngôi làng của họ trước khi lão Gargamel tóm gọn.', N'2011-07-29', N'https://image.tmdb.org/t/p/w500/r1avMYngCKgbQ5OaRhgW3voiSEd.jpg', N'41513', N'https://image.tmdb.org/t/p/w1280/iYLimHUF0C0R61v1ofg79SUIja9.jpg', N'en', N'5.761', N'3848', N'12.0573', N'The Smurfs', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

SET IDENTITY_INSERT [dbo].[movies] OFF
GO


-- ----------------------------
-- Table structure for oauth2_configs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[oauth2_configs]') AND type IN ('U'))
	DROP TABLE [dbo].[oauth2_configs]
GO

CREATE TABLE [dbo].[oauth2_configs] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [provider_name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [client_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [client_secret] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [authorization_uri] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [token_uri] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [user_info_uri] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [redirect_uri] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [scope] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [is_enabled] bit DEFAULT 1 NOT NULL,
  [created_at] datetime2(7) DEFAULT getdate() NOT NULL,
  [updated_at] datetime2(7) DEFAULT getdate() NOT NULL
)
GO

ALTER TABLE [dbo].[oauth2_configs] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of oauth2_configs
-- ----------------------------
SET IDENTITY_INSERT [dbo].[oauth2_configs] ON
GO

INSERT INTO [dbo].[oauth2_configs] ([id], [provider_name], [client_id], [client_secret], [authorization_uri], [token_uri], [user_info_uri], [redirect_uri], [scope], [is_enabled], [created_at], [updated_at]) VALUES (N'1', N'google', N'725122679388-icmijjb52pu5c3kq0s67mv8a906c3vh8.apps.googleusercontent.com', N'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', N'https://accounts.google.com/o/oauth2/auth', N'https://oauth2.googleapis.com/token', N'https://www.googleapis.com/oauth2/v2/userinfo', N'http://localhost:8080/login/oauth2/code/google', N'openid,profile,email', N'1', N'2025-07-28 17:21:27.3533333', N'2025-07-28 17:25:27.3500000')
GO

INSERT INTO [dbo].[oauth2_configs] ([id], [provider_name], [client_id], [client_secret], [authorization_uri], [token_uri], [user_info_uri], [redirect_uri], [scope], [is_enabled], [created_at], [updated_at]) VALUES (N'2', N'github', N'Ov23liBYyO6ZWco7KmCH', N'ed56a2be94fe4d9703ac617e6a2c31a1babb23ee', N'https://github.com/login/oauth/authorize', N'https://github.com/login/oauth/access_token', N'https://api.github.com/user', N'http://localhost:8080/login/oauth2/code/github', N'user:email', N'1', N'2025-07-28 17:21:27.3533333', N'2025-07-28 17:25:27.3733333')
GO

SET IDENTITY_INSERT [dbo].[oauth2_configs] OFF
GO


-- ----------------------------
-- Table structure for oauth2_user_profiles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[oauth2_user_profiles]') AND type IN ('U'))
	DROP TABLE [dbo].[oauth2_user_profiles]
GO

CREATE TABLE [dbo].[oauth2_user_profiles] (
  [id] bigint  IDENTITY(1,1) NOT NULL,
  [user_id] bigint  NOT NULL,
  [provider_name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [provider_user_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [provider_username] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [provider_email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [provider_name_display] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [provider_avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [provider_profile_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [access_token] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [refresh_token] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [token_expires_at] datetime2(7)  NULL,
  [raw_attributes] ntext COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [first_login] datetime2(7) DEFAULT getdate() NOT NULL,
  [last_login] datetime2(7) DEFAULT getdate() NOT NULL,
  [login_count] int DEFAULT 0 NOT NULL,
  [is_active] bit DEFAULT 1 NOT NULL,
  [created_at] datetime2(7) DEFAULT getdate() NOT NULL,
  [updated_at] datetime2(7) DEFAULT getdate() NOT NULL
)
GO

ALTER TABLE [dbo].[oauth2_user_profiles] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of oauth2_user_profiles
-- ----------------------------
SET IDENTITY_INSERT [dbo].[oauth2_user_profiles] ON
GO

SET IDENTITY_INSERT [dbo].[oauth2_user_profiles] OFF
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

ALTER TABLE [dbo].[promotions] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of promotions
-- ----------------------------
SET IDENTITY_INSERT [dbo].[promotions] ON
GO

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'1', N'WELCOME10', N'Giảm giá 10% cho khách hàng mới', N'Giảm giá 10% cho lần đầu đặt vé', N'PERCENTAGE', N'10.00', N'.00', N'2025-07-01', N'2025-12-31', N'1000', N'0', N'1')
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
  [end_time] datetime2(7)  NULL,
  [ticket_price] decimal(10,2)  NULL,
  [status] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'ACTIVE' NULL
)
GO

ALTER TABLE [dbo].[screenings] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of screenings
-- ----------------------------
SET IDENTITY_INSERT [dbo].[screenings] ON
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'804', N'1', N'105', N'2025-07-28 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'805', N'1', N'105', N'2025-07-28 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'806', N'1', N'105', N'2025-07-28 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'807', N'2', N'106', N'2025-07-28 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'808', N'2', N'106', N'2025-07-28 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'809', N'2', N'106', N'2025-07-28 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'810', N'3', N'107', N'2025-07-28 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'811', N'3', N'107', N'2025-07-28 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'812', N'3', N'107', N'2025-07-28 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'813', N'4', N'108', N'2025-07-28 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'814', N'4', N'108', N'2025-07-28 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'815', N'4', N'108', N'2025-07-28 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'816', N'1', N'105', N'2025-07-29 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'817', N'1', N'105', N'2025-07-29 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'818', N'1', N'105', N'2025-07-29 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'819', N'2', N'106', N'2025-07-29 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'820', N'2', N'106', N'2025-07-29 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'821', N'2', N'106', N'2025-07-29 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'822', N'3', N'107', N'2025-07-29 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'823', N'3', N'107', N'2025-07-29 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'824', N'3', N'107', N'2025-07-29 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'825', N'4', N'108', N'2025-07-29 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'826', N'4', N'108', N'2025-07-29 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'827', N'4', N'108', N'2025-07-29 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'828', N'1', N'105', N'2025-07-30 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'829', N'1', N'105', N'2025-07-30 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'830', N'1', N'105', N'2025-07-30 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'831', N'2', N'106', N'2025-07-30 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'832', N'2', N'106', N'2025-07-30 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'833', N'2', N'106', N'2025-07-30 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'834', N'3', N'107', N'2025-07-30 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'835', N'3', N'107', N'2025-07-30 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'836', N'3', N'107', N'2025-07-30 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'837', N'4', N'108', N'2025-07-30 09:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'838', N'4', N'108', N'2025-07-30 14:00:00.4596970', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'839', N'4', N'108', N'2025-07-30 19:00:00.4596970', NULL, N'150000.00', N'ACTIVE')
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
  [seat_type] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [price_modifier] decimal(5,2) DEFAULT 1.0 NULL
)
GO

ALTER TABLE [dbo].[seats] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of seats
-- ----------------------------
SET IDENTITY_INSERT [dbo].[seats] ON
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5052', N'105', N'A', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5053', N'105', N'A', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5054', N'105', N'A', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5055', N'105', N'A', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5056', N'105', N'A', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5057', N'105', N'A', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5058', N'105', N'A', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5059', N'105', N'A', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5060', N'105', N'A', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5061', N'105', N'A', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5062', N'105', N'B', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5063', N'105', N'B', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5064', N'105', N'B', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5065', N'105', N'B', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5066', N'105', N'B', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5067', N'105', N'B', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5068', N'105', N'B', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5069', N'105', N'B', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5070', N'105', N'B', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5071', N'105', N'B', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5072', N'105', N'C', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5073', N'105', N'C', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5074', N'105', N'C', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5075', N'105', N'C', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5076', N'105', N'C', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5077', N'105', N'C', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5078', N'105', N'C', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5079', N'105', N'D', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5080', N'105', N'D', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5081', N'105', N'D', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5082', N'105', N'D', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5083', N'105', N'D', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5084', N'105', N'D', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5085', N'105', N'D', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5086', N'105', N'E', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5087', N'105', N'E', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5088', N'105', N'E', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5089', N'105', N'E', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5090', N'105', N'E', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5091', N'105', N'E', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5092', N'105', N'E', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5093', N'105', N'F', N'1', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5094', N'105', N'F', N'2', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5095', N'105', N'F', N'3', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5096', N'105', N'F', N'4', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5097', N'105', N'F', N'5', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5098', N'105', N'F', N'6', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5099', N'105', N'F', N'7', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5100', N'105', N'F', N'8', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5101', N'105', N'F', N'9', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5102', N'106', N'A', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5103', N'106', N'A', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5104', N'106', N'A', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5105', N'106', N'A', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5106', N'106', N'A', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5107', N'106', N'A', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5108', N'106', N'A', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5109', N'106', N'A', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5110', N'106', N'A', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5111', N'106', N'A', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5112', N'106', N'B', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5113', N'106', N'B', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5114', N'106', N'B', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5115', N'106', N'B', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5116', N'106', N'B', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5117', N'106', N'B', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5118', N'106', N'B', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5119', N'106', N'B', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5120', N'106', N'B', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5121', N'106', N'B', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5122', N'106', N'C', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5123', N'106', N'C', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5124', N'106', N'C', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5125', N'106', N'C', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5126', N'106', N'C', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5127', N'106', N'C', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5128', N'106', N'C', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5129', N'106', N'D', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5130', N'106', N'D', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5131', N'106', N'D', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5132', N'106', N'D', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5133', N'106', N'D', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5134', N'106', N'D', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5135', N'106', N'D', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5136', N'106', N'E', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5137', N'106', N'E', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5138', N'106', N'E', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5139', N'106', N'E', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5140', N'106', N'E', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5141', N'106', N'E', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5142', N'106', N'E', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5143', N'106', N'F', N'1', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5144', N'106', N'F', N'2', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5145', N'106', N'F', N'3', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5146', N'106', N'F', N'4', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5147', N'106', N'F', N'5', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5148', N'106', N'F', N'6', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5149', N'106', N'F', N'7', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5150', N'106', N'F', N'8', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5151', N'106', N'F', N'9', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5152', N'107', N'A', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5153', N'107', N'A', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5154', N'107', N'A', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5155', N'107', N'A', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5156', N'107', N'A', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5157', N'107', N'A', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5158', N'107', N'A', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5159', N'107', N'A', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5160', N'107', N'A', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5161', N'107', N'A', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5162', N'107', N'B', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5163', N'107', N'B', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5164', N'107', N'B', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5165', N'107', N'B', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5166', N'107', N'B', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5167', N'107', N'B', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5168', N'107', N'B', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5169', N'107', N'B', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5170', N'107', N'B', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5171', N'107', N'B', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5172', N'107', N'C', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5173', N'107', N'C', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5174', N'107', N'C', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5175', N'107', N'C', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5176', N'107', N'C', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5177', N'107', N'C', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5178', N'107', N'C', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5179', N'107', N'D', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5180', N'107', N'D', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5181', N'107', N'D', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5182', N'107', N'D', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5183', N'107', N'D', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5184', N'107', N'D', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5185', N'107', N'D', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5186', N'107', N'E', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5187', N'107', N'E', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5188', N'107', N'E', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5189', N'107', N'E', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5190', N'107', N'E', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5191', N'107', N'E', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5192', N'107', N'E', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5193', N'107', N'F', N'1', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5194', N'107', N'F', N'2', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5195', N'107', N'F', N'3', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5196', N'107', N'F', N'4', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5197', N'107', N'F', N'5', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5198', N'107', N'F', N'6', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5199', N'107', N'F', N'7', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5200', N'107', N'F', N'8', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5201', N'107', N'F', N'9', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5202', N'108', N'A', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5203', N'108', N'A', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5204', N'108', N'A', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5205', N'108', N'A', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5206', N'108', N'A', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5207', N'108', N'A', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5208', N'108', N'A', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5209', N'108', N'A', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5210', N'108', N'A', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5211', N'108', N'A', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5212', N'108', N'B', N'1', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5213', N'108', N'B', N'2', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5214', N'108', N'B', N'3', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5215', N'108', N'B', N'4', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5216', N'108', N'B', N'5', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5217', N'108', N'B', N'6', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5218', N'108', N'B', N'7', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5219', N'108', N'B', N'8', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5220', N'108', N'B', N'9', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5221', N'108', N'B', N'10', N'VIP', N'1.50')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5222', N'108', N'C', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5223', N'108', N'C', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5224', N'108', N'C', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5225', N'108', N'C', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5226', N'108', N'C', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5227', N'108', N'C', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5228', N'108', N'C', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5229', N'108', N'D', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5230', N'108', N'D', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5231', N'108', N'D', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5232', N'108', N'D', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5233', N'108', N'D', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5234', N'108', N'D', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5235', N'108', N'D', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5236', N'108', N'E', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5237', N'108', N'E', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5238', N'108', N'E', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5239', N'108', N'E', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5240', N'108', N'E', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5241', N'108', N'E', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5242', N'108', N'E', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5243', N'108', N'F', N'1', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5244', N'108', N'F', N'2', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5245', N'108', N'F', N'3', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5246', N'108', N'F', N'4', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5247', N'108', N'F', N'5', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5248', N'108', N'F', N'6', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5249', N'108', N'F', N'7', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5250', N'108', N'F', N'8', N'COUPLE', N'1.30')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'5251', N'108', N'F', N'9', N'COUPLE', N'1.30')
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
-- Records of theaters
-- ----------------------------
SET IDENTITY_INSERT [dbo].[theaters] ON
GO

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address], [phone], [email], [description], [opening_hours]) VALUES (N'27', N'Cinema Paradise', N'Đà Nẵng', N'123 Lê Duẩn, Quận Hải Châu, Đà Nẵng', N'0236.3888.999', N'info@cinemaparadise.vn', N'Rạp chiếu phim hiện đại với 4 phòng chiếu, mỗi phòng có 50 ghế được chia thành 3 loại: VIP, Thường và Couple', N'8:00 - 23:00 hàng ngày')
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

ALTER TABLE [dbo].[users] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of users
-- ----------------------------
SET IDENTITY_INSERT [dbo].[users] ON
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'1', N'admin', N'admin@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'ADMIN', N'Administrator', N'0236.3888.999', NULL, N'2025-07-28 16:00:55.8866667', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'2', N'staff1', N'staff1@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'STAFF', N'Nhân viên 1', N'0236.3888.998', NULL, N'2025-07-28 16:00:55.8866667', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'3', N'customer1', N'customer1@gmail.com', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'CUSTOMER', N'Khách hàng 1', N'0901234567', NULL, N'2025-07-28 16:00:55.8866667', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'4', N'DucAnh808', N'ducanh.aoa@gmail.com', N'$2a$10$ty5dKA6OpsVovmG01EzDE.jG7oSHDHMpk4JGo8bCagxiCuVBx27Oq', N'CUSTOMER', NULL, NULL, NULL, N'2025-07-28 16:36:41.3574050', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO


-- ----------------------------
-- Auto increment value for auditoriums
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[auditoriums]', RESEED, 108)
GO


-- ----------------------------
-- Primary Key structure for table auditoriums
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [PK_auditoriums] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for booked_seats
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[booked_seats]', RESEED, 4)
GO


-- ----------------------------
-- Primary Key structure for table booked_seats
-- ----------------------------
ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [PK_booked_seats] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table booking_promotions
-- ----------------------------
ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [PK_booking_promotions] PRIMARY KEY CLUSTERED ([booking_id], [promotion_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for bookings
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[bookings]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [PK_bookings] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for movies
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[movies]', RESEED, 24)
GO


-- ----------------------------
-- Primary Key structure for table movies
-- ----------------------------
ALTER TABLE [dbo].[movies] ADD CONSTRAINT [PK_movies] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for oauth2_configs
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[oauth2_configs]', RESEED, 2)
GO


-- ----------------------------
-- Indexes structure for table oauth2_configs
-- ----------------------------
CREATE NONCLUSTERED INDEX [IDX_oauth2_configs_provider_enabled]
ON [dbo].[oauth2_configs] (
  [provider_name] ASC,
  [is_enabled] ASC
)
GO


-- ----------------------------
-- Triggers structure for table oauth2_configs
-- ----------------------------
CREATE TRIGGER [dbo].[TRG_oauth2_configs_updated_at]
ON [dbo].[oauth2_configs]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
    UPDATE [oauth2_configs]
    SET [updated_at] = GETDATE()
    FROM [oauth2_configs] o
    INNER JOIN [inserted] i ON o.[id] = i.[id];
END;
GO


-- ----------------------------
-- Uniques structure for table oauth2_configs
-- ----------------------------
ALTER TABLE [dbo].[oauth2_configs] ADD CONSTRAINT [UK_oauth2_configs_provider] UNIQUE NONCLUSTERED ([provider_name] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table oauth2_configs
-- ----------------------------
ALTER TABLE [dbo].[oauth2_configs] ADD CONSTRAINT [PK_oauth2_configs] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for oauth2_user_profiles
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[oauth2_user_profiles]', RESEED, 1)
GO


-- ----------------------------
-- Indexes structure for table oauth2_user_profiles
-- ----------------------------
CREATE NONCLUSTERED INDEX [IDX_oauth2_user_profiles_provider]
ON [dbo].[oauth2_user_profiles] (
  [provider_name] ASC
)
GO

CREATE NONCLUSTERED INDEX [IDX_oauth2_user_profiles_provider_email]
ON [dbo].[oauth2_user_profiles] (
  [provider_name] ASC,
  [provider_email] ASC
)
GO

CREATE NONCLUSTERED INDEX [IDX_oauth2_user_profiles_last_login]
ON [dbo].[oauth2_user_profiles] (
  [last_login] ASC
)
GO

CREATE NONCLUSTERED INDEX [IDX_oauth2_user_profiles_active]
ON [dbo].[oauth2_user_profiles] (
  [is_active] ASC
)
GO


-- ----------------------------
-- Triggers structure for table oauth2_user_profiles
-- ----------------------------
CREATE TRIGGER [dbo].[TRG_oauth2_user_profiles_updated_at]
ON [dbo].[oauth2_user_profiles]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
    UPDATE [oauth2_user_profiles]
    SET [updated_at] = GETDATE()
    FROM [oauth2_user_profiles] o
    INNER JOIN [inserted] i ON o.[id] = i.[id];
END;
GO


-- ----------------------------
-- Uniques structure for table oauth2_user_profiles
-- ----------------------------
ALTER TABLE [dbo].[oauth2_user_profiles] ADD CONSTRAINT [UK_oauth2_user_profiles_provider_user] UNIQUE NONCLUSTERED ([provider_name] ASC, [provider_user_id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

ALTER TABLE [dbo].[oauth2_user_profiles] ADD CONSTRAINT [UK_oauth2_user_profiles_user] UNIQUE NONCLUSTERED ([user_id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table oauth2_user_profiles
-- ----------------------------
ALTER TABLE [dbo].[oauth2_user_profiles] ADD CONSTRAINT [PK_oauth2_user_profiles] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for payments
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[payments]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [PK_payments] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for promotions
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[promotions]', RESEED, 1)
GO


-- ----------------------------
-- Indexes structure for table promotions
-- ----------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ_promotions_code]
ON [dbo].[promotions] (
  [code] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table promotions
-- ----------------------------
ALTER TABLE [dbo].[promotions] ADD CONSTRAINT [PK_promotions] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for screenings
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[screenings]', RESEED, 839)
GO


-- ----------------------------
-- Primary Key structure for table screenings
-- ----------------------------
ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [PK_screenings] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for seats
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[seats]', RESEED, 5251)
GO


-- ----------------------------
-- Primary Key structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [PK_seats] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for theaters
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[theaters]', RESEED, 27)
GO


-- ----------------------------
-- Primary Key structure for table theaters
-- ----------------------------
ALTER TABLE [dbo].[theaters] ADD CONSTRAINT [PK_theaters] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for users
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[users]', RESEED, 5)
GO


-- ----------------------------
-- Indexes structure for table users
-- ----------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ_users_username]
ON [dbo].[users] (
  [username] ASC
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_users_email]
ON [dbo].[users] (
  [email] ASC
)
GO


-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Foreign Keys structure for table auditoriums
-- ----------------------------
ALTER TABLE [dbo].[auditoriums] ADD CONSTRAINT [FK_auditoriums_theaters] FOREIGN KEY ([theater_id]) REFERENCES [dbo].[theaters] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table booked_seats
-- ----------------------------
ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_seats] FOREIGN KEY ([seat_id]) REFERENCES [dbo].[seats] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booked_seats] ADD CONSTRAINT [FK_booked_seats_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table oauth2_user_profiles
-- ----------------------------
ALTER TABLE [dbo].[oauth2_user_profiles] ADD CONSTRAINT [FK_oauth2_user_profiles_user] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table payments
-- ----------------------------
ALTER TABLE [dbo].[payments] ADD CONSTRAINT [FK_payments_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table screenings
-- ----------------------------
ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_movies] FOREIGN KEY ([movie_id]) REFERENCES [dbo].[movies] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[screenings] ADD CONSTRAINT [FK_screenings_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table seats
-- ----------------------------
ALTER TABLE [dbo].[seats] ADD CONSTRAINT [FK_seats_auditoriums] FOREIGN KEY ([auditorium_id]) REFERENCES [dbo].[auditoriums] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

