-- Lệnh tạo Database
/*
 ghi chú nhiều dòng
 HR_ABC_HRManagment1
 HR_DEF_HRManagment2
 EC_CDF_EcommecerTech
*/
--CREATE DATABASE [Batch195_Test]

-- Xoá database
--DROP DATABASE [Batch194V2]

-- Tạo Table bằng lệnh
USE Batch195 -- chọn DB cần chạy lệnh
GO --đợi cho dòng lệnh trước chạy xong
CREATE TABLE [subjects] (
	--Khai báo các cột
	id		INT NOT NULL,
	name	NVARCHAR(50)
)

-- Schema (name = dbo)

CREATE TABLE [dbo].[myTable] (
    Id              INT,
    Age             TINYINT,
    Price           DECIMAL(18,2), -- 999999999999999.99
    Discount        DECIMAL(4,2), --99.99
    ProductName     NVARCHAR(255),
    BirthDay        DATE, --Kiểu ngày yyyy-mm-dd
    CreatedAt       DATETIME2, --kiểu yyyy-mm-dd H:i:s
    StartAt         TIME (0), -- H:i:s
    EndAt           TIME (0), -- H:i:s
    IsActive        BIT, -- 0 or 1
    Content         NVARCHAR(MAX), --Nội dung dài
	LongContent	    NTEXT,
    ModuleId        UNIQUEIDENTIFIER DEFAULT NEWID()
)

-- Xóa bảng
USE Batch195
GO
DROP TABLE IF EXISTS [myTable]


-- them cột
ALTER TABLE [dbo].[myTable]
ADD email varchar(255);


ALTER TABLE [dbo].[myTable]
ALTER COLUMN Price DECIMAL(12,2);


CREATE TABLE [categories] (
	category_id INT NOT NULL,
	category_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(500) NULL
)