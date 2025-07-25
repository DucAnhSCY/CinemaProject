-- Script để cập nhật bảng users với các cột còn thiếu
USE cinema_db;
GO

-- Kiểm tra và thêm cột auth_provider nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'auth_provider')
BEGIN
    ALTER TABLE [dbo].[users] ADD [auth_provider] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'LOCAL' NULL;
    PRINT 'Added auth_provider column';
END
ELSE
    PRINT 'auth_provider column already exists';

-- Kiểm tra và thêm cột provider_id nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider_id')
BEGIN
    ALTER TABLE [dbo].[users] ADD [provider_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
    PRINT 'Added provider_id column';
END
ELSE
    PRINT 'provider_id column already exists';

-- Kiểm tra và thêm cột avatar_url nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'avatar_url')
BEGIN
    ALTER TABLE [dbo].[users] ADD [avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
    PRINT 'Added avatar_url column';
END
ELSE
    PRINT 'avatar_url column already exists';

-- Kiểm tra và thêm cột last_login nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'last_login')
BEGIN
    ALTER TABLE [dbo].[users] ADD [last_login] datetime2(7) NULL;
    PRINT 'Added last_login column';
END
ELSE
    PRINT 'last_login column already exists';

-- Kiểm tra và thêm cột is_enabled nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'is_enabled')
BEGIN
    ALTER TABLE [dbo].[users] ADD [is_enabled] bit DEFAULT 1 NULL;
    PRINT 'Added is_enabled column';
END
ELSE
    PRINT 'is_enabled column already exists';

-- Cập nhật dữ liệu cho các user hiện tại (chỉ nếu cột đã tồn tại)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'auth_provider')
    AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'is_enabled')
BEGIN
    UPDATE [dbo].[users] 
    SET [auth_provider] = 'LOCAL', [is_enabled] = 1 
    WHERE [auth_provider] IS NULL OR [is_enabled] IS NULL;
    PRINT 'Updated existing user data';
END

-- Kiểm tra và thêm cột ticket_price vào bảng screenings nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'screenings' AND COLUMN_NAME = 'ticket_price')
BEGIN
    -- Nếu có cột base_price, copy dữ liệu sang ticket_price
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'screenings' AND COLUMN_NAME = 'base_price')
    BEGIN
        ALTER TABLE [dbo].[screenings] ADD [ticket_price] decimal(10,2) NULL;
        UPDATE [dbo].[screenings] SET [ticket_price] = [base_price];
        PRINT 'Added ticket_price column and copied data from base_price';
    END
    ELSE
    BEGIN
        ALTER TABLE [dbo].[screenings] ADD [ticket_price] decimal(10,2) NULL;
        PRINT 'Added ticket_price column';
    END
END
ELSE
    PRINT 'ticket_price column already exists';

PRINT 'Database update completed successfully!';
