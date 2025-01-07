-- Lenh tao Database moi
-- co ten: Batch40
-- Ghi chu trong SQL
CREATE DATABASE Batch40
CREATE DATABASE [Batch 41]
-- Xoa 1 Database
DROP DATABASE Batch40

-- Sử dụng tên database
USE Batch40
--tao Table bang lenh SQL

CREATE TABLE demo(
 --liệt kê tất cả các trường cần khai báo
 -- cú pháp:
 -- [Tên cột] [Data Type] [OPTIONs]
 id INT NOT NULL, -- int
 first_name NVARCHAR(50) NULL, --string, NULL là ko yêu cầu điên
 LastName  NVARCHAR(50) NULL, 
 age TINYINT, -- 0 -> 255
 email NVARCHAR(50) NOT NULL, -- NOT NULL là bắt buộc điền
 /*
	DECIMAL(4,2) = 99.00 
	--> Tổng độ rộng kí tự là 4
	--> Chứa 2 kí tự thập phân
 */
 discount DECIMAL(4,2) NOT NULL,
 birth_date DATE NOT NULL, -- yyyy-mm-dd
 created_at DATETIME2, -- yyyy-mm-dd HH:ii:ss
 is_hidden BIT NOT NULL, -- 1 OR 0
 content NTEXT NULL, -- Lưu bài viết dài 2GB dữ liệu
)

CREATE TABLE [test](
 [Id] INT NOT NULL,
 [họ và tên] NVARCHAR(50) NULL,
)

-- Lệnh xóa Table
use Batch40
GO -- đợi lệnh trước nó thực thi xong, chạy tiếp
DROP TABLE IF EXISTS demo2 -- nếu tồn tại thì xóa
DROP TABLE demo2 -- Nếu ko tồn tại mà xóa --> báo lỗi

-- Các lệnh chỉnh sửa cấu trúc table
-- 1. Thêm cột mới vào table
ALTER TABLE demo
ADD mobile NVARCHAR(10) NOT NULL

--2. Xóa bớt 1 cột
ALTER TABLE demo
DROP COLUMN mobile

--3. Thay đổi data type của một cột
ALTER TABLE demo
ALTER COLUMN discount DECIMAL(8,2) NOT NULL
--4. Thay đổi tên cột
EXEC sp_rename 'demo.birth_date', 'BirthDate', 'COLUMN';

--- BẢNG TẠM
CREATE TABLE #tmp_products  -- bắt đầu với kí tự #
(
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);
INSERT INTO #tmp_products
VALUES(
'iphone', 12)
SELECT * FROM #tmp_products