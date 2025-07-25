-- Script đơn giản để thêm từng cột
USE cinema_db;
GO

-- Thêm cột auth_provider
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'auth_provider')
BEGIN
    ALTER TABLE [dbo].[users] ADD [auth_provider] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'LOCAL' NULL;
    PRINT 'Added auth_provider column';
END

-- Thêm cột provider_id
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider_id')
BEGIN
    ALTER TABLE [dbo].[users] ADD [provider_id] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
    PRINT 'Added provider_id column';
END

-- Thêm cột avatar_url
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'avatar_url')
BEGIN
    ALTER TABLE [dbo].[users] ADD [avatar_url] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
    PRINT 'Added avatar_url column';
END

-- Thêm cột last_login
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'last_login')
BEGIN
    ALTER TABLE [dbo].[users] ADD [last_login] datetime2(7) NULL;
    PRINT 'Added last_login column';
END

-- Thêm cột is_enabled
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'is_enabled')
BEGIN
    ALTER TABLE [dbo].[users] ADD [is_enabled] bit DEFAULT 1 NULL;
    PRINT 'Added is_enabled column';
END

PRINT 'User table update completed!';
