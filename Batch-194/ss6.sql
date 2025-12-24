--Sử dụng lệnh để tạo DB
CREATE DATABASE [Batch194V2]

-- Xoa DB
DROP DATABASE IF EXISTS [Batch194V3]

-- Tạo table bằng lệnh
USE Batch194
GO
CREATE TABLE staffs (
	--Single commen, 
	--khai báo danh sách các trường từ đây
	id INT, --mỗi trường cách nhau dấu phẩy
	fullName NVARCHAR(50),
	email VARCHAR(50),
	gender TINYINT,
	lastLogin DATETIME2, --YYYY/MM/DD H:S:I
	createdAt DATETIME2,
	updatedAt timestamp, -- 11 con số theo thời gian
)

--Thêm cột vào table có sẵn
ALTER TABLE staffs
ADD password NVARCHAR(255)

-- thay đổi type cho cột
ALTER TABLE customers
ALTER column id INT

-- xóa ccootj
ALTER TABLE customers
DROP column createdAt



CREATE TABLE categories (
  category_id INT NOT NULL,
  category_name NVARCHAR(50) NOT NULL,
  description NVARCHAR(255) NULL
)