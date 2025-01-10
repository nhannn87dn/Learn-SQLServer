/* 
Hãy tạo một database quản lý khách sạn:
- Customers (quản lý khách hàng)
- Rooms (Quản danh sách các phòng)
- RoomTypes (Quản lý các loại phòng)
- Booking (các đơn đặt phòng)
-------------------------------
Tự suy nghĩ các trường và kiểu dữ liệu cần thiết
Code cách tạo các table trên bằng lệnh SQL
*/
CREATE DATABASE [BookingHotel]
GO
use [BookingHotel]
GO
CREATE TABLE dbo.Customers(
Id INT NOt NULL,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Gender BIT NOT NULL,
Mobile NVARCHAR(10) NOT NULL,
Email NVARCHAR(255) NOT NULL,
CreatedAt DATETIME2 NOT NULL,
UpdatedAt DATETIME2 NOT NULL,
IsActived BIT NOT NULL, --có kích hoạt hay là khóa tài khoản
)

CREATE TABLE dbo.RoomTypes(
Id INT NOT NULL,
Name NVARCHAR(255) NOT NULL
)

CREATE TABLE dbo.Rooms(
Id INT NOT NULL,
Code NVARCHAR(255) NOT NULL, -- mã phòng
Name NVARCHAR(255) NOT NULL, -- tên phòng
Price DECIMAL(18,2) NOT NULL,
Stock TINYINT NOT NULL, -- số lượng phòng
CreatedAt DATETIME2 NOT NULL,
UpdatedAt DATETIME2 NOT NULL,
IsSale BIT NOT NULL, --có kích hoạt hay là khóa phòng
RoomTypeId INT NOT NULL, -- khóa ngoại
)

CREATE TABLE dbo.Booking(
Id INT NOT NULL,
Code NVARCHAR(255) NOT NULL, --Mã đơn hàng
CreatedAt DATETIME2 NOT NULL,
UpdatedAt DATETIME2 NOT NULL,
CustomerId INT NOT NULL, --Khách hàng nào đặt
)
-- Lưu các phòng của đơn đặt phòng
CREATE TABLE dbo.BookingItem(
BookingId INT NOT NULL,
RoomId INT NOT NULL,
Quanlity TINYINT NOT NULL, -- Số lượng phòng được đặt
Price DECIMAL(18,2) NOT NULL,
Discount DECIMAL(4,2) NOT NULL,
)

CREATE TABLE dbo.categories(
category_id INT NOT NULL,
category_name NVARCHAR(50) NOT NULL,
description NVARCHAR(500) NULL
)