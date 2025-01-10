use Batch40
GO
CREATE TABLE dbo.categories(
category_id INT NOT NULL,
category_name NVARCHAR(50) NOT NULL,
description NVARCHAR(500) NULL
)

--CHÈN DỮ LIỆU VÀO TABLE
-- Chèn 1 lần 1 dòng (row)/ 1 record
INSERT dbo.categories (
	category_id, 
	category_name,
	description
)
VALUES
(
	1,
	'Road',
	'Bicycles designed for paved roads'
)
--Chèn nhiều dòng 1 lần

INSERT dbo.categories (
	category_id,category_name,description
)
VALUES 
	(2, 'Mountain', 'Off-road and trail bicycles'),
	(3, 'Hybrid', 'Versatile bikes for various terrains')
	-- Mỗi cặp (...) --> chèn vào 1 dòng

-- Lệnh để xem dữ liệu của 1 table
SELECT * FROM dbo.categories

SELECT * FROM dbo.demo

INSERT dbo.demo 
	(id, first_name, LastName, age, email, discount, birth_date, created_at, is_hidden, content, mobile)
VALUES
	(1, 'Tien', 'Manh', 19, 'tienmanh@gmail.com', 50.5,'2025-01-09', '2025-01-09', 0, 
	N'Nội dung rất là dài', --thêm N trước nháy đơn/kép
	'0988777666'
	)
-- Xóa dữ liệu từ 1 table
DELETE 
FROM dbo.demo 
WHERE 
	id = 1 -- Xóa tất cả các row có id = 1
--  Xóa tất tất cả dữ liệu của 1 table
DELETE FROM dbo.demo -- ko có điều kiện where để giới hạn phạm vi tác động

-- Cập nhật dữ liệu
UPDATE 
	dbo.demo
SET
	-- Liệt kê các trường dữ liệu cần thay đổi giá trị
	age = 20,
	discount = 10,
	mobile = '0977666555'
WHERE -- xác định phạm vi tác động
	id = 2 -- chỉ có dòng có id = 2 được xử lý

--UPDATE mà ko có WHERE
UPDATE 
	dbo.demo
SET
	content = N'Cách để lưu tiếng việt'
--> Phạm tác động = tất cả các dòng

-- Chèn dữ liệu với các trường mà được phép NULL
-- Nếu bạnh muốn chèn dữ liệu cho các trường NULL thì liệt kê
-- Ngược lại thì ko cần, và khi nó mặc định giá trị tại ô đó = NULL
INSERT dbo.demo 
	(id, first_name, email, birth_date,  mobile, discount)
VALUES
	(5, 'Hai', 'nhan@gmail.com','2025-01-08', '0988777111', 70
	)
SELECT * FROM dbo.demo

--- COntrant DEFAULT
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
 discount DECIMAL(4,2) NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 50), -- Mặc định = 0 khi ko truyền
 birth_date DATE NOT NULL, -- yyyy-mm-dd
 created_at DATETIME2, -- yyyy-mm-dd HH:ii:ss
 is_hidden BIT NOT NULL DEFAULT 0, -- 1 OR 0
 content NTEXT NULL, -- Lưu bài viết dài 2GB dữ liệu
)

ALTER TABLE [dbo].demo
ADD CONSTRAINT [CK_demo_discount] CHECK (discount >= 0 AND discount <= 60);
GO

-- Thêm default cho cột đã tồn tại
ALTER TABLE [dbo].demo
ADD CONSTRAINT DF_demo_discount
DEFAULT 0 FOR discount;

ALTER TABLE [dbo].demo
ADD CONSTRAINT DF_demo_is_hidden
DEFAULT 0 FOR is_hidden;


---	 CONSTRAINT
SELECT * FROm dbo.categories

INSERT dbo.categories (
	category_id,category_name,description
)
VALUES 
	(2, 'Mountain', 'Off-road and trail bicycles'),
	(3, 'Hybrid', 'Versatile bikes for various terrains')

-- Tạo khóa chính ngay khi tạo table
/*
	IDENTITY(start,step)
	start: giá trị khởi tạo ban đầu
	step là bước nhảy
	IDENTITY(1,1): --bắt đầu là 1, và mỗi lần sẽ tăng lên 1 đơn vị

*/
CREATE TABLE dbo.brands (
	brand_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- chỉ định brand_id làm khóa chính
	brand_name NVARCHAR(50) NOT NULL UNIQUE,
	description NVARCHAR(255) NULL
)

ALTER TABLE [dbo].brands
ADD CONSTRAINT [UQ_brands_brand_name] UNIQUE (brand_name); 
GO

UPDATE dbo.brands SET brand_name = 'ba' WHERE brand_id = 5

INSERT dbo.brands
	(brand_name, description)
VALUES
	('Trek', 'High-quality bikes for all terrains')

INSERT dbo.brands
	(brand_name)
VALUES
	('Specialized')

SELECT * FROM dbo.brands
-- Cách để SQL nó tự điền giá trị ID cho bạn
-- Có thể tự điền id khi đã cấu hình IDENTITY không? --> CÓ

SET IDENTITY_INSERT dbo.brands ON; 
INSERT dbo.brands
	(brand_id, brand_name)
VALUES
	(6, 'Scott')
SET IDENTITY_INSERT dbo.brands OFF; 


CREATE TABLE phuhuynh(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	name NVARCHAR(50) NOT NULL
)

CREATE TABLE treem(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	name NVARCHAR(50) NOT NULL,
	ph_id INT NOT NULL, -- khóa ngoại
	CONSTRAINT FK_treem_ph_id FOREIGN KEY (ph_id) -- khóa ngoại cho trường ph_id 
        REFERENCES phuhuynh(id) -- tham chiếu tới khóa chính của table phuhuynh
		ON DELETE CASCADE
)

DROP TABLE IF EXISTS treem

INSERT phuhuynh 
	(name)
VALUES
	('Tuan'),
	('Minh')


INSERT treem 
	(name, ph_id)
VALUES
	('Ti', 1),
	('Bo', 1)

SELECT * FROM phuhuynh
SELECT * FROM treem

DELETE FROM phuhuynh WHERE id = 1