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

 Date: 28/07/2025 15:52:26
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

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'4', N'Superman', N'150', N'Science Fiction, Adventure, Action', N'Phiên bản mới của siêu anh hùng Superman với câu chuyện khởi nguồn mới.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/f4hJ5yVSiOSnW9S6vtoGlNYvW5J.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'PG-13', N'COMING_SOON')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'5', N'Từ Vũ Trụ John Wick: Ballerina', N'115', N'Action, Thriller, Crime', N'Câu chuyện về Eve Macarro trên hành trình trả thù cho cái chết của gia đình mình.', N'2025-06-04', N'https://image.tmdb.org/t/p/w500/bw7gsWIJgoPyxrAgfSHc8xqVhDA.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'R', N'COMING_SOON')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'6', N'Bí Kíp Luyện Rồng', NULL, N'Fantasy, Family, Action', N'Phiên bản Live Action (người đóng) của studio DreamWorks rất được mong chờ đã ra mắt. Câu chuyện về một chàng trai trẻ với ước mơ trở thành thợ săn rồng, nhưng định mệnh lại đưa đẩy anh đến tình bạn bất ngờ với một chú rồng.', N'2025-06-06', N'https://image.tmdb.org/t/p/w500/sIQRZYHRJN1ZzulxpXuoXEgkkSe.jpg', N'1087192', N'https://image.tmdb.org/t/p/w1280/7HqLLVjdjhXS0Qoz1SgZofhkIpE.jpg', N'en', N'8.097', N'1182', N'976.0125', N'How to Train Your Dragon', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'7', N'M3GAN 2.0', NULL, N'Action, Science Fiction, Thriller', N'Phim lấy bối cảnh 2 năm sau các sự kiện ở phần 1. Lúc này, Gemma phát hiện công nghệ sản xuất MEGAN đã bị đánh cắp. Kẻ gian đã tạo ra một robot AI khác với chức năng tương tự MEGAN, nhưng được trang bị sức mạnh chiến đấu "khủng" hơn mang tên Amelia. Để "đối đầu" với Amelia, Gemma buộc phải "hồi sinh" và cải tiến MEGAN, hứa hẹn một trận chiến "nảy lửa" trên màn ảnh vào năm 2025.', N'2025-06-25', N'https://image.tmdb.org/t/p/w500/psASSoFLAGFoXwyfRg4hDZHgshN.jpg', N'1071585', N'https://image.tmdb.org/t/p/w1280/cEQMqB3ahd4mfeUN6VGC0ouVnZZ.jpg', N'en', N'7.7', N'452', N'697.3743', N'M3GAN 2.0', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'8', N'Thanh Gươm Diệt Quỷ: Vô Hạn Thành', NULL, N'Animation, Action, Fantasy, Thriller', N'Khi các thành viên của Sát Quỷ Đoàn và Trụ Cột tham gia vào chương trình đặc huấn để chuẩn bị cho trận chiến sắp với lũ quỷ, Kibutsuji Muzan xuất hiện tại Dinh thự Ubuyashiki. Khi thủ lĩnh của Sát Quỷ Đoàn gặp nguy hiểm, Tanjiro và các Trụ Cột trở về trụ sở Thế nhưng, Muzan bất ngờ kéo toàn bộ Sát Quỷ Đoàn đến hang ổ cuối cùng của lũ quỷ là Vô Hạn Thành, mở màn cho trận đánh cuối cùng của cả hai phe.', N'2025-07-18', N'https://image.tmdb.org/t/p/w500/nV99ACeAa8fFFso0tQZ3HktEf5X.jpg', N'1311031', N'https://image.tmdb.org/t/p/w1280/1RgPyOhN4DRs225BGTlHJqCudII.jpg', N'ja', N'6.8', N'18', N'474.4508', N'劇場版「鬼滅の刃」無限城編 第一章 猗窩座再来', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'9', N'Superman', NULL, N'Science Fiction, Adventure, Action', N'Mùa hè tới đây, Warner Bros. Pictures sẽ mang “Superman” - phim điện ảnh đầu tiên của DC Studios đến các rạp chiếu trên toàn cầu. Với phong cách riêng biệt của mình, James Gunn sẽ khắc họa người hùng huyền thoại trong vũ trụ DC hoàn toàn mới, với sự kết hợp độc đáo của các yếu tố hành động đỉnh cao, hài hước và vô cùng cảm xúc. Một Superman với lòng trắc ẩn và niềm tin vào sự thiện lương của con người sẽ xuất hiện đầy hứa hẹn trên màn ảnh.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/f4hJ5yVSiOSnW9S6vtoGlNYvW5J.jpg', N'1061474', N'https://image.tmdb.org/t/p/w1280/ApRxyHFuvv5yghedxXPJSm9FEDe.jpg', N'en', N'7.446', N'1116', N'354.5509', N'Superman', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'10', N'Siêu Nhí Karate: Những Câu Chuyện Huyền Thoại', NULL, N'Action, Adventure, Drama', N'', N'2025-05-08', N'https://image.tmdb.org/t/p/w500/jMtD6YLSTCaBlCAsGxGOa4n2Po8.jpg', N'1011477', N'https://image.tmdb.org/t/p/w1280/7Q2CmqIVJuDAESPPp76rWIiA0AD.jpg', N'en', N'7.231', N'526', N'339.016', N'Karate Kid: Legends', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'11', N'Con Đường Băng 2: Trả Đũa', NULL, N'Action, Thriller, Drama', N'Tài xế xe tải đường băng huyền thoại Mike McCann đến Nepal để hoàn thành tâm nguyện cuối cùng của người anh trai quá cố: rải tro cốt trên đỉnh Everest. Nhưng hành trình tưởng như bình yên lại trở thành ác mộng khi chiếc xe buýt chở đầy du khách mà anh đi cùng bị tấn công trên cung đường “Tiến về bầu trời” – một trong những tuyến đường nguy hiểm nhất thế giới. Trên vùng núi cao hiểm trở, McCann và người hướng dẫn leo núi buộc phải chiến đấu với nhóm lính đánh thuê bí ẩn, bảo vệ những người dân vô tội – và một ngôi làng đang đứng bên bờ vực bị xóa sổ.', N'2025-06-27', N'https://image.tmdb.org/t/p/w500/cQN9rZj06rXMVkk76UF1DfBAico.jpg', N'1119878', N'https://image.tmdb.org/t/p/w1280/962KXsr09uK8wrmUg9TjzmE7c4e.jpg', N'en', N'7.025', N'139', N'317.834', N'Ice Road: Vengeance', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'12', N'Cô Dâu Hành Động', NULL, N'Action, Comedy', N'', N'2025-06-19', N'https://image.tmdb.org/t/p/w500/3mExdWLSxAiUCb4NMcYmxSkO7n4.jpg', N'1124619', N'https://image.tmdb.org/t/p/w1280/h6gChZHFpmbwqwV3uQsoakp77p1.jpg', N'en', N'5.68', N'25', N'289.0716', N'Bride Hard', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'13', N'Thế Giới Khủng Long: Tái Sinh', NULL, N'Science Fiction, Adventure, Action', N'Thế Giới Khủng Long: Tái Sinh lấy bối cảnh 5 năm sau phần phim Thế Giới Khủng Long: Lãnh Địa, môi trường Trái đất đã chứng tỏ phần lớn là không phù hợp với khủng long. Nhiều loài thằn lằn tiền sử được tái sinh đã chết. Những con chưa chết đã rút lui đến một vùng nhiệt đới hẻo lánh gần phòng thí nghiệm. Địa điểm đó chính là nơi bộ ba Scarlett Johansson, Mahershala Ali và Jonathan Bailey dấn thân vào một nhiệm vụ cực kỳ hiểm nguy.', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/2IVVciw7dPhUlNmYIaz0s1d56SZ.jpg', N'1234821', N'https://image.tmdb.org/t/p/w1280/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg', N'en', N'6.373', N'783', N'244.2464', N'Jurassic World Rebirth', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'14', N'Bad Boas: Bộ đôi phá án', NULL, N'Action, Comedy, Crime, Mystery', N'Khi một cảnh sát cộng đồng hăng hái quá mức và một cựu thanh tra liều lĩnh buộc phải hợp tác, hàng loạt hỗn loạn bùng nổ trên đường phố Rotterdam.', N'2025-07-10', N'https://image.tmdb.org/t/p/w500/upzsNh9Ue3DmFlGnUlxwXtnEpQc.jpg', N'1374534', N'https://image.tmdb.org/t/p/w1280/9l6bcHNFLR2fcCBSPzEeqxiQhwU.jpg', N'nl', N'5.826', N'92', N'235.3907', N'Bad Boa''s', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'15', N'Thợ săn quỷ Kpop', NULL, N'Animation, Fantasy, Comedy, Music, Family, Action', N'Khi các siêu sao Kpop Rumi, Mira và Zoey không bận trình diễn tại các sân vận động cháy vé, họ sử dụng sức mạnh bí mật để bảo vệ người hâm mộ khỏi những mối đe dọa siêu nhiên.', N'2025-06-20', N'https://image.tmdb.org/t/p/w500/y8OyohPhdTtusY0nXd2XdX4NN8W.jpg', N'803796', N'https://image.tmdb.org/t/p/w1280/l3ycQYwWmbz7p8otwbomFDXIEhn.jpg', N'en', N'8.534', N'769', N'212.9718', N'KPop Demon Hunters', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'16', N'Bộ Tứ Siêu Đẳng: Bước Đi Đầu Tiên', NULL, N'Science Fiction, Adventure', N'Sau một chuyến bay thám hiểm vũ trụ, bốn phi hành gia bất ngờ sở hữu năng lực siêu nhiên và trở thành gia đình siêu anh hùng đầu tiên của Marvel. The Fantastic Four: First Steps là bộ phim mở đầu Kỷ nguyên anh hùng thứ sáu (Phase Six), đặt nền móng cho siêu bom tấn Avengers: Doomsday trong năm sau.', N'2025-07-23', N'https://image.tmdb.org/t/p/w500/n0bqzWiKGJsmnvOlkTiYykhhM4E.jpg', N'617126', N'https://image.tmdb.org/t/p/w1280/3IgJReIyunq95ta86CTSOs9vAht.jpg', N'en', N'7.137', N'168', N'194.6445', N'The Fantastic Four: First Steps', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'17', N'The Old Guard 2', NULL, N'Action, Fantasy', N'Andy và đội chiến binh bất tử chiến đấu với mục đích mới khi họ đương đầu với một kẻ thù mới hùng mạnh đang đe dọa sứ mệnh bảo vệ nhân loại của họ.', N'2025-07-01', N'https://image.tmdb.org/t/p/w500/wqfu3bPLJaEWJVk3QOm0rKhxf1A.jpg', N'846422', N'https://image.tmdb.org/t/p/w1280/fd9K7ZDfzRAcbLh8JlG4HIKbtuR.jpg', N'en', N'6.062', N'537', N'177.9416', N'The Old Guard 2', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'18', N'Nguyên Thủ Đối Đầu', NULL, N'Action, Thriller, Comedy', N'Hai nhà lãnh đạo – Tổng thống Mỹ (John Cena) và Thủ tướng Anh (Idris Elba) – bị rơi vào âm mưu khủng bố khi tham dự hội nghị NATO. Bị lạc ở Belarus, họ buộc phải bắt tay để sinh tồn, dù tính cách trái ngược. Cùng với đặc vụ MI6 (Priyanka Chopra), họ đối đầu kẻ thù quốc tế, qua chuỗi hành động–hài hước kịch tính xuyên châu Âu.', N'2025-07-02', N'https://image.tmdb.org/t/p/w500/lVgE5oLzf7ABmzyASEVcjYyHI41.jpg', N'749170', N'https://image.tmdb.org/t/p/w1280/vJbEUMeI2AxBUZKjP6ZVeVNNTLh.jpg', N'en', N'6.944', N'536', N'164.3775', N'Heads of State', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'19', N'F1 Phim Điện Ảnh', NULL, N'Action, Drama', N'', N'2025-06-25', N'https://image.tmdb.org/t/p/w500/qsn0OsLY2luKOkWr2RbGFrijmoy.jpg', N'911430', N'https://image.tmdb.org/t/p/w1280/lSbblLngbeZIn6G4WXDcyQ6SLhw.jpg', N'en', N'7.614', N'879', N'147.5591', N'F1', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'20', N'Kaiju No.8: Nhiệm Vụ Trinh Sát', NULL, N'Animation, Action, Science Fiction', N'Kaiju No.8: Nhiệm Vụ Trinh Sát là một phần ngoại truyện của bộ manga Kaiju No.8 (Kaijuu 8-gou). Câu chuyện tập trung vào Kafka Hibino, người có khả năng biến hình thành quái vật (Kaiju) và phải giữ bí mật về năng lực này khi gia nhập Lực lượng Phòng vệ Nhật Bản, một tổ chức chuyên tiêu diệt quái vật. Nhiệm vụ của anh là vừa chiến đấu với quái vật, vừa che giấu thân phận thực sự của mình.', N'2025-03-28', N'https://image.tmdb.org/t/p/w500/qp0EuVdQZzb3lBf7acnr5wIOATx.jpg', N'1326106', N'https://image.tmdb.org/t/p/w1280/iZ0ZSnhmHB3k1KDkDzEz65f5iia.jpg', N'ja', N'7.784', N'37', N'142.2022', N'アニメ『怪獣８号』第１期総集編／同時上映「保科の休日」', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'21', N'Ziam', NULL, N'Horror, Thriller, Action', N'Trong cuộc chiến sinh tồn trước đội quân thây ma kinh hoàng, một cựu võ sĩ Muay Thái phải dốc toàn bộ kỹ năng, tốc độ và ý chí để cứu bạn gái.', N'2025-07-09', N'https://image.tmdb.org/t/p/w500/rE5Bf1ejCUuHxmQGIJTZ7W7M13p.jpg', N'1429744', N'https://image.tmdb.org/t/p/w1280/tdMbbFhqyEqOK1QzNTvJjHWKbZX.jpg', N'th', N'6.639', N'115', N'120.6702', N'ปากกัด ตีนถีบ', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'22', N'Khủng Long Xanh Du Hành Thế Giới Truyện Tranh', NULL, N'Animation, Family, Adventure, Fantasy, Comedy', N'', N'2024-10-04', N'https://image.tmdb.org/t/p/w500/8h26apBjkp20NndgK0rSbcOW4uW.jpg', N'947478', N'https://image.tmdb.org/t/p/w1280/wcFV4uOdSbC0cSjs7ecAyOU6t59.jpg', N'en', N'8', N'8', N'120.3385', N'Diplodocus', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'23', N'Một Nửa Hoàn Hảo', NULL, N'Romance, Drama', N'Lucy (Dakota Johnson), một cô gái xinh đẹp làm công việc mai mối ở New York. “Mát tay” trong chuyện mai mối giúp người khác, nhưng trớ trêu Lucy lại “lạc lối” trong câu chuyện tình cảm của chính mình. Bất ngờ đối mặt với ngã rẽ tình cảm khi gặp lại người yêu cũ "không hoàn hảo" (Chris Evans) và một người đàn ông "hoàn hảo" (Pedro Pascal). Cô nàng bị đẩy vào tình thế khó xử. Đứng giữa những lựa chọn cảm xúc đầy mâu thuẫn, lúc này đây, Lucy mới nhận ra việc tìm kiếm tình yêu đích thực chưa bao giờ là điều dễ dàng', N'2025-06-12', N'https://image.tmdb.org/t/p/w500/edSuYya7wFzFPu1PDtwMlU0Em2W.jpg', N'1136867', N'https://image.tmdb.org/t/p/w1280/lqwwGkwJHtz9QgKtz4zeY19YgDg.jpg', N'en', N'6.917', N'145', N'117.3064', N'Materialists', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'24', N'戏台', NULL, N'Drama, Comedy', N'', N'2025-07-12', N'https://image.tmdb.org/t/p/w500/wSFGtkoz8SW6yIgu1Xvxs584QQt.jpg', N'1406607', N'https://image.tmdb.org/t/p/w1280/cfAGn86j4LYzRCKWSkXPnMxoru6.jpg', N'zh', N'10', N'2', N'108.0459', N'戏台', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
GO

INSERT INTO [dbo].[movies] ([id], [title], [duration_min], [genre], [description], [release_date], [poster_url], [tmdb_id], [backdrop_url], [original_language], [vote_average], [vote_count], [popularity], [original_title], [adult], [director], [cast], [country], [language], [overview], [image_url], [rating], [status]) VALUES (N'25', N'Mượn Hồn Đoạt Xác', NULL, N'Horror', N'Sự trở lại của bộ óc sáng tạo đằng sau Talk to Me, Danny và Michael Philippou cùng A24 với một bộ phim kinh dị mới nhất Mượn Hồn Đoạt Xác. Nhiều người tin rằng linh hồn vẫn sẽ ở lại trong thân xác một thời gian trước khi rời đi, đây cũng là niềm tin đáng sợ cho nghi lễ ám ảnh nhất tháng 5.', N'2025-05-28', N'https://image.tmdb.org/t/p/w500/zNNDCFTnSNz7Y5GZDxs8SYO2MIi.jpg', N'1151031', N'https://image.tmdb.org/t/p/w1280/5esDYWV0NoFwqPa1iC0g9akqZo9.jpg', N'en', N'7.4', N'309', N'105.9636', N'Bring Her Back', N'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ACTIVE')
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

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'2', N'STUDENT20', N'Giảm giá 20% cho sinh viên', N'Giảm giá 20% cho sinh viên có thẻ', N'PERCENTAGE', N'20.00', N'.00', N'2025-07-01', N'2025-12-31', N'500', N'0', N'1')
GO

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'3', N'SAVE50K', N'Giảm 50.000đ cho hóa đơn từ 300.000đ', N'Giảm 50.000đ cho hóa đơn từ 300.000đ trở lên', N'FIXED_AMOUNT', N'50000.00', N'300000.00', N'2025-07-01', N'2025-09-30', N'200', N'0', N'1')
GO

INSERT INTO [dbo].[promotions] ([id], [code], [name], [description], [discount_type], [discount_value], [minimum_amount], [start_date], [end_date], [max_uses], [current_uses], [active]) VALUES (N'4', N'WEEKEND15', N'Giảm giá 15% cuối tuần', N'Giảm giá 15% cho các suất chiếu cuối tuần', N'PERCENTAGE', N'15.00', N'.00', N'2025-07-05', N'2025-12-31', N'1000', N'0', N'1')
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

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'1', N'1', N'1', N'2025-07-26 09:00:00.0000000', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'2', N'1', N'1', N'2025-07-26 14:00:00.0000000', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'3', N'1', N'1', N'2025-07-26 19:00:00.0000000', NULL, N'150000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'4', N'2', N'2', N'2025-07-26 10:00:00.0000000', NULL, N'100000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'5', N'2', N'2', N'2025-07-26 15:00:00.0000000', NULL, N'100000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'6', N'2', N'2', N'2025-07-26 20:00:00.0000000', NULL, N'120000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'7', N'3', N'3', N'2025-07-26 11:00:00.0000000', NULL, N'200000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'8', N'3', N'3', N'2025-07-26 16:00:00.0000000', NULL, N'200000.00', N'ACTIVE')
GO

INSERT INTO [dbo].[screenings] ([id], [movie_id], [auditorium_id], [start_time], [end_time], [ticket_price], [status]) VALUES (N'9', N'3', N'3', N'2025-07-26 21:00:00.0000000', NULL, N'250000.00', N'ACTIVE')
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

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'28', N'1', N'C', N'8', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'29', N'1', N'C', N'9', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'30', N'1', N'C', N'10', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'31', N'1', N'C', N'11', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'32', N'1', N'C', N'12', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'33', N'1', N'C', N'13', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'34', N'1', N'C', N'14', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'35', N'1', N'C', N'15', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'36', N'1', N'D', N'1', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'37', N'1', N'D', N'2', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'38', N'1', N'D', N'3', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'39', N'1', N'D', N'4', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'40', N'1', N'D', N'5', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'41', N'1', N'D', N'6', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'42', N'1', N'D', N'7', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'43', N'1', N'D', N'8', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'44', N'1', N'D', N'9', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'45', N'1', N'D', N'10', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'46', N'1', N'D', N'11', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'47', N'1', N'D', N'12', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'48', N'1', N'D', N'13', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'49', N'1', N'D', N'14', N'STANDARD', N'1.00')
GO

INSERT INTO [dbo].[seats] ([id], [auditorium_id], [row_number], [seat_position], [seat_type], [price_modifier]) VALUES (N'50', N'1', N'D', N'15', N'STANDARD', N'1.00')
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

INSERT INTO [dbo].[theaters] ([id], [name], [city], [address], [phone], [email], [description], [opening_hours]) VALUES (N'1', N'Cinema Paradise', N'Đà Nẵng', N'123 Lê Duẩn, Quận Hải Châu, Đà Nẵng', N'0236.3888.999', N'info@cinemaparadise.vn', N'Rạp chiếu phim hiện đại với công nghệ âm thanh và hình ảnh tối tân', N'8:00 - 23:00 hàng ngày')
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

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'1', N'admin', N'admin@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'ADMIN', N'Administrator', N'0236.3888.999', NULL, N'2025-07-25 07:49:45.3700000', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'2', N'staff1', N'staff1@cinemaparadise.vn', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'STAFF', N'Nhân viên 1', N'0236.3888.998', NULL, N'2025-07-25 07:49:45.3700000', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

INSERT INTO [dbo].[users] ([id], [username], [email], [password_hash], [role], [full_name], [phone], [date_of_birth], [created_at], [status], [auth_provider], [provider_id], [avatar_url], [last_login], [is_enabled]) VALUES (N'3', N'customer1', N'customer1@gmail.com', N'$2a$12$ql7t3dfII28oIf.6sUe/Uuomu.ClsPplwpbY8pMo83JAI6VwSn5Ra', N'CUSTOMER', N'Khách hàng 1', N'0901234567', NULL, N'2025-07-25 07:49:45.3700000', N'ACTIVE', N'LOCAL', NULL, NULL, NULL, N'1')
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO


-- ----------------------------
-- View structure for v_booking_details
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[v_booking_details]') AND type IN ('V'))
	DROP VIEW [dbo].[v_booking_details]
GO

CREATE VIEW [dbo].[v_booking_details] AS SELECT 
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


-- ----------------------------
-- View structure for v_screening_details
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[v_screening_details]') AND type IN ('V'))
	DROP VIEW [dbo].[v_screening_details]
GO

CREATE VIEW [dbo].[v_screening_details] AS SELECT 
    s.id as screening_id,
    s.start_time,
    s.end_time,
    s.base_price,
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


-- ----------------------------
-- procedure structure for sp_generate_booking_code
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_generate_booking_code]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_generate_booking_code]
GO

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


-- ----------------------------
-- Auto increment value for auditoriums
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[auditoriums]', RESEED, 5)
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
DBCC CHECKIDENT ('[dbo].[booked_seats]', RESEED, 1)
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
-- Indexes structure for table bookings
-- ----------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ_bookings_code]
ON [dbo].[bookings] (
  [booking_code] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_bookings_booking_time]
ON [dbo].[bookings] (
  [booking_time] ASC
)
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
DBCC CHECKIDENT ('[dbo].[movies]', RESEED, 25)
GO


-- ----------------------------
-- Primary Key structure for table movies
-- ----------------------------
ALTER TABLE [dbo].[movies] ADD CONSTRAINT [PK_movies] PRIMARY KEY CLUSTERED ([id])
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
DBCC CHECKIDENT ('[dbo].[promotions]', RESEED, 4)
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
DBCC CHECKIDENT ('[dbo].[screenings]', RESEED, 9)
GO


-- ----------------------------
-- Indexes structure for table screenings
-- ----------------------------
CREATE NONCLUSTERED INDEX [IX_screenings_start_time]
ON [dbo].[screenings] (
  [start_time] ASC
)
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
DBCC CHECKIDENT ('[dbo].[seats]', RESEED, 50)
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
DBCC CHECKIDENT ('[dbo].[theaters]', RESEED, 1)
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
DBCC CHECKIDENT ('[dbo].[users]', RESEED, 3)
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
-- Foreign Keys structure for table booking_promotions
-- ----------------------------
ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK_booking_promotions_bookings] FOREIGN KEY ([booking_id]) REFERENCES [dbo].[bookings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[booking_promotions] ADD CONSTRAINT [FK_booking_promotions_promotions] FOREIGN KEY ([promotion_id]) REFERENCES [dbo].[promotions] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table bookings
-- ----------------------------
ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[bookings] ADD CONSTRAINT [FK_bookings_screenings] FOREIGN KEY ([screening_id]) REFERENCES [dbo].[screenings] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
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

