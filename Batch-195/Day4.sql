-- I. INSERT  Chèn dữ liệu

USE Batch195
GO
--Xem dữ liệu trong một table
SELECT * FROM dbo.categories

--1. INSERT - Chèn dữ liệu vào table
--1.1 Chèn 1 lần 1 dòng dữ liệu

INSERT INTO dbo.categories (
	--category_id,	--id
	category_name,	--tên danh mục
	description		-- mô tả ngắn
) 
VALUES (
	--1,
	'Road',
	'Bicycles designed for paved roads'
)

INSERT dbo.categories ( category_name, description)
VALUES ('Mountain', 'Off-road and trail bicycles')

--1.2 Chèn 1 lần nhiều dòng

INSERT INTO dbo.categories (
	category_id,	--id
	category_name,	--tên danh mục
	description		-- mô tả ngắn
) 
VALUES 
	(3,'Hybrid','Versatile bikes for various terrains'),
	(4,'Cruiser','Comfortable and stylish bikes for leisurely rides'),
	(5,'Electric','Bicycles powered by electric motors')


INSERT INTO [dbo].[myTable]
(Id, Age, Price, Discount, ProductName, BirthDay, CreatedAt, StartAt, EndAt, IsActive, Content, ModuleId)
VALUES
(2, 30, 150.00, 0.10, N'Sản phẩm A', '2000-01-01', '2024-04-03 08:32:34', '08:00:00', '17:00:00', 1, N'Nội dung sản phẩm A', NEWID());

INSERT INTO [dbo].[myTable]
(Id, Age, Price, Discount, ProductName, BirthDay, CreatedAt, StartAt, EndAt, IsActive, Content, ModuleId)
VALUES
(3, 30, 150.00, 0.10, N'Sản phẩm A', CAST('2000-01-01' AS Date), CAST('2024-04-03 08:32:34' AS datetime2), CAST('08:00:00' AS time), CAST('17:00:00' as time), 1, N'Nội dung sản phẩm A', NEWID());


SELECT * FROM myTable

--2. Cách để định nghĩa khóa chính PRIMARY KEY
--2.1 Thêm khi định nghĩa table
--Ví dụ: brands

/**
	IDENTITY(1,1)
	1: start, điểm bắt đầu
	1: step: bước nhảy (kể cả khi xảy ra lỗi ko insert được thì nó vẫn tự tăng)

*/

CREATE TABLE [brands] (
	brand_id INT NOT NULL IDENTITY(1,1), --- Khóa chính tự tăng
	brand_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL,
	--Tạo khóa chính
	CONSTRAINT [PK_brands_brand_id] PRIMARY KEY (brand_id)
)

DROP TABLE IF EXISTS dbo.brands
DROP TABLE IF EXISTS dbo.categories

CREATE TABLE categories (
	category_id INT NOT NULL IDENTITY(1,1), --- Khóa chính tự tăng
	category_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL,
	--Tạo khóa chính
	CONSTRAINT [PK_categories_category_id] PRIMARY KEY (category_id)
)

--2.2 Cho table đã tồn tại
-- Định nghĩa PRIMARY KEY cho table đã tồn tại
ALTER TABLE [dbo].[categories]
ADD PRIMARY KEY (category_id);
-- Hoặc, bạn có thể đặt tên cho contraint là [PK_categories_category_id]
--Khuyên dùng cách này để xảy ra lỗi thì dễ dàng nhận biết vì có tên
ALTER TABLE [dbo].[categories]
ADD CONSTRAINT [PK_categories_category_id] PRIMARY KEY (category_id);

--3. INSERT Dữ liệu khi table có PRIMARY KEY
INSERT dbo.brands 
(
	brand_name,
	description
)
VALUES 
(
	'Trek',
	'High-quality bikes for all terrains'
)

--Chèn khi đã có khóa chính tự tăng
SET IDENTITY_INSERT [dbo].brands ON;
INSERT brands 
	(brand_id, brand_name, description) 
VALUES 
	(2, 'Giant', 'Specializing in road and mountain bikes')

SET IDENTITY_INSERT [dbo].brands OFF;

INSERT dbo.brands 
(
	brand_id,
	brand_name,
	description
)
VALUES 
(
	2,
	'Giant',
	'Specializing in road and mountain bikes'
)

SELECt * FROM brands


-- II. UPDATE
-- 1. Thay thế, cập nhật dữ liệu cho all các dòng (records)

UPDATE 
	dbo.brands 
SET 
	description = NULL
	
-- > Phạm vi tác động toàn bộ table

-- 2. Thay thế, cập nhật dữ liệu cho 1 dòng/ nhiều dòng cụ thể
UPDATE 
	dbo.brands 
SET 
	description = 'High-quality bikes for all terrains'
WHERE 
	brand_id =  1 OR brand_id =  2 -- Phạm vi tác động


-- III. DELETE - Xóa dữ liệu cho table
-- 1. Xóa các dòng chỉ định
DELETE dbo.brands WHERE brand_id = 2; --Chỉ xóa dòng có brand_id = 2
-- 2. Xóa toàn bộ dữ liệu trong table
SELECT * FROM categories

--Xóa dữ liệu nhưng giử nguyên tự tăng
DELETE dbo.categories -- Phạm vi tác động cả table
DELETE dbo.brands
-- 3. Xóa với trancate - xóa dữ liệu + reset tự tăng
TRUNCATE TABLE brands;


---IV. CONSTRAINS
CREATE TABLE dbo.products (
	product_id INT NOT NULL IDENTITY(1,1),
	product_name NVARCHAR(50) NOT NULL UNIQUE,  --chống trùng tên sp
	price DECIMAL(18,2) DEFAULT 0 CHECK (price >= 0), -- mặc định giá bán = 0, nếu câu lệnh insert ko điền
	discount DECIMAL(4,2) DEFAULT 0 CHECK (discount >= 0), --những sp ko có km thì mặc định là 0,
	category_id INT NOT NULL,
	-- khóa chính
	CONSTRAINT [PK_PRODUCTS_product_id] PRIMARY KEY (product_id),
	--khóa ngoại
	CONSTRAINT [FK_PRODUCTS_category_id] FOREIGN KEY ([category_id]) 
		REFERENCES [dbo].[categories] ([category_id])
		ON DELETE CASCADE
)

DROP TABLE IF EXISTS products 

INSERT dbo.products
 (product_name, price)
VALUES
 ('Iphone 20 Promax', -800.50)

 INSERT dbo.products
 (product_name)
VALUES
 ('Iphone 19 Promax')



SELECT * FROM dbo.categories
SELECT * FROM dbo.products

TRUNCATE TABLE dbo.products
ALTER TABLE dbo.products
ADD category_id INT NOT NULL

INSERT dbo.products
	(product_name, price, category_id)
VALUES
	('Road Bike Pro', 1200, 3)

INSERT dbo.products
	(product_name, price, category_id)
VALUES
	('Road Bike', 500, 3)

-- Sự cần thiết của thiết lập ràng buộc khóa khoại
DELETE dbo.categories
--Nhưng nếu mà để tạo ràng buộc khóa ngoại --> gây ra hiệu suất truy vấn chậm
DELETE dbo.categories WHERE category_id = 3