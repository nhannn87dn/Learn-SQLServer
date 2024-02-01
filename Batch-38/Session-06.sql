-- Transact SQL Query Window
-- SSMS

-- Tạo Database mới bằng lệnh
CREATE DATABASE Batch38

USE Batch38
GO
-- Tạo table
CREATE TABLE categories (
	category_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	category_name NVARCHAR(50) NOT NULL, --không cho phép rỗng
	description NVARCHAR(500) NULL -- cho phép rỗng
)
-- Khóa chính:
-- NOT NULL,
-- IDENTITY(1,1) -- Định danh tự tăng, không trùng lặp
-- 1: là bắt đầu là trị 1
-- 1: bước nhảy là 1

select * from sys.tables --Xem danh sách các tables trong database hiện tại

--chèn 2 record mới vào table categories
INSERT dbo.categories 
	(category_name, description) -- trường bắt buộc điền
VALUES 
	('Laptop', 'Description Laptop')

SET IDENTITY_INSERT dbo.categories ON;
INSERT dbo.categories 
	(category_id,category_name, description) -- trường bắt buộc điền
VALUES 
	(5,'Watch', 'Description Watch');

SET IDENTITY_INSERT dbo.categories OFF;

USE Batch38
GO
CREATE TABLE brands (
	brand_id INT PRIMARY KEY NOT NULL,
	brand_name NVARCHAR(50) NOT NULL, --không cho phép rỗng
	description NVARCHAR(500) NULL -- cho phép rỗng
)

-- chèn 1 record vào brands
INSERT dbo.brands
	(brand_id, brand_name)
VALUES
	(1, 'Xiaomi')

-- chèn nhiều record vào brands cùng l lệnh
INSERT dbo.brands
	(brand_id, brand_name)
VALUES
	(2, 'Samsung'),
	(3, 'Oppo'),
	(4, 'LG')

-- chèn nhiều record vào brands với nhiều lệnh đơn
INSERT dbo.brands
	(brand_id, brand_name)
VALUES
	(6, 'Panasonic')

INSERT dbo.brands
	(brand_id, brand_name)
VALUES
	(7, 'Lenovo')


-- Tạo bảng products
-- Cách đặt tên các cột
-- 1: snake case: product_name
-- 2: Pascal Case: ProductName
-- 3: camel Case: productName

CREATE TABLE dbo.products (
	product_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	product_name NVARCHAR (255) NOT NULL,
	price DECIMAL(18, 2) DEFAULT 0,  -- 16 số 9,99
	-- DEFAULT 0 --> thiết lập giá trị mặc định cho trường dữ liệu
	discount DECIMAL(18, 2) DEFAULT 0, 
	category_id INT NOT NULL, 
	brand_id INT NOT NULL, 
	description NVARCHAR(500) NULL,
	model_year SMALLINT,
	create_at DATETIME2 -- ngày thêm mới sản phẩm yy-mm-dd H:i:s
)

-- Xóa table
DROP TABLE dbo.brands

-- Sửa tên cột trong table
EXEC sp_rename 'products.create_date', 'create_at', 'COLUMN';

-- Thay đổi data type cho cột
ALTER TABLE dbo.products
ALTER COLUMN model_year INT

-- Xóa cột
ALTER TABLE dbo.products
DROP COLUMN model_year

--Thêm cột
ALTER TABLE dbo.products
ADD  model_year SMALLINT

--Thêm mới sản phẩm
INSERT dbo.products 
	(product_name, price, model_year, create_at, category_id, brand_id)
VALUES
	('Điện thoại Iphone 15 Pro max', 8000, 2024, '2024-02-01',1, 1)

-- chèn với unicode
INSERT dbo.products 
	(product_name, price, model_year, create_at, category_id, brand_id)
VALUES
	(N'Điện thoại Iphone 16 Pro max', 9000, 2024, '2024-02-01',1, 1)
--Xem data của một table
SELECT * FROM dbo.products

-- UPDATE
select * FROM dbo.products
select * from dbo.brands

UPDATE dbo.products
SET product_name  = N'Điện thoại Iphone 15 Pro max'
WHERE product_id = 2

-- Cập nhật lại giá trị của cột description cho tất cả các records
UPDATE dbo.products
SET [description] = 'Description'

---- Cập nhật lại giá trị của cột description cho dòng có product_id = 3 thôi
UPDATE dbo.products
SET [description] = 'Description'
WHERE product_id = 3

-- DELETE 
select * from brands

-- xóa toàn bộ record có trong brands
DELETE dbo.brands
-- Xóa 1 dòng cụ thể
DELETE dbo.brands
WHERE brand_id = 7


CREATE TABLE dbo.stores (
	store_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	store_name NVARCHAR (100) NOT NULL UNIQUE,
	phone VARCHAR(50) NULL,
	email VARCHAR(150) NULL,
)

INSERT dbo.stores
	(store_name, phone)
VALUES 
	(N'Chi nhánh 06 Hùng Vương', '19008856')

select * from dbo.stores

-- Định nghĩa PRIMARY KEY cho table đã tồn tại
ALTER TABLE [dbo].stores
ADD PRIMARY KEY (store_id);


ALTER TABLE [dbo].stores
ADD CONSTRAINT [PK_stores_store_id] PRIMARY KEY (store_id);


--Tạo khóa ngoại  FOREIGN KEY (category_id) tham chiếu đến khóa chính categories(Id)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_categories] 
	FOREIGN KEY ([category_id]) REFERENCES [dbo].[categories] ([category_id]);
GO
--Tạo khóa ngoại FOREIGN KEY (brand_id) tham chiếu đến khóa chính suppliers(brand_id)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_brands_id] 
	FOREIGN KEY ([brand_id]) REFERENCES [dbo].[brands] ([brand_id])
	ON DELETE CASCADE;

DELETE dbo.brands WHERE brand_id = 1


ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_price] 
CHECK (price >= 0);

DELETE dbo.products
select * from dbo.products

INSERT dbo.products 
	(product_name, price, model_year, create_at, category_id, brand_id)
VALUES
	(N'Điện thoại Iphone 17 Pro max', 100, 2024, '2024-02-01',1, 2)