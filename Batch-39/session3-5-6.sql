-- Ghi chú:
-- Tạo database
CREATE DATABASE batchRN39

-- Câu lệnh tạo table trong SQL server

CREATE TABLE Customers (
	-- khai báo các cột (trường) của table
	Id INT,
	first_name NVARCHAR(20),
	last_name NVARCHAR(20)
)
ON SALE

GO --THỰC THI DÒNG LÊN TRƯỚC KHI SANG CÁI THỨ 2

-- DBO --> schema name, nhóm phần quyền người dùng

-- Sửa cấu trúc table bằng lệnh
-- vd1: Sửa kiểu dữ liệu của cột
ALTER TABLE Customers
	ALTER COLUMN first_name NVARCHAR(20)
--FirstName
--ma_sv

--vd2: Thêm mới một cột vào table
ALTER TABLE Customers
	ADD email NVARCHAR(50)

--vd3: Đổi tên một cột bằng lệnh
EXEC sp_rename 'Customers.phone', 'mobile', 'COLUMN';


ALTER TABLE Customers
	ADD baba NVARCHAR(50)

--vd4: xóa một cột
ALTER TABLE Customers
	DROP COLUMN baba


--vd5: Xóa một table
USE BatchRN39 -- sử dụng datable muốn xóa
GO
DROP TABLE IF EXISTS Customers
GO

USE BatchRN39
GO

CREATE TABLE [Categories] (
 category_id INT,
 category_name NVARCHAR(50),
 description NVARCHAR(500)
)
