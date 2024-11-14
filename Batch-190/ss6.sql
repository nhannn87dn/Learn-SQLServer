USE Batch190

-- Để lấy tất cả dữ liệu của một table
SELECT * FROM categories
-- Chèn 1 dòng/row/record vào một table
INSERT INTO categories (
	category_id,
	category_name,
	description
)
VALUES (
	3,
	'Tablet',
	'Tablet gia re co ban tra gop'
)

INSERT INTO categories (
	category_id,
	category_name
	
)
VALUES (
	4,
	'Tablet v2'
)
-- Chèn nhiều dòng cùng lúc
INSERT INTO categories 
	(category_id,category_name)
VALUES 
	(5,'Tablet v5'),
	(6,'Tablet v6'),
	(7,'Tablet v7'),
	(8,'Tablet v8')


CREATE TABLE [dbo].[myTable] (
    Id              INT,
    Age             TINYINT,
    Price           DECIMAL(18,2),
    Discount        DECIMAL(4,2),
    ProductName     NVARCHAR(255),
    BirthDay        DATE, --Kiểu ngày yyyy-mm-dd
    CreatedAt       DATETIME2, --kiểu yyyy-mm-dd H:i:s
    StartAt         TIME (0), -- H:i:s
    EndAt           TIME (0), -- H:i:s
    IsActive        BIT, -- 0 or 1
    Content         NVARCHAR(MAX), --Nội dung dài
    ModuleId        UNIQUEIDENTIFIER DEFAULT NEWID()
)

INSERT INTO [dbo].[myTable]
(Id, Age, Price, Discount, ProductName, BirthDay, CreatedAt, StartAt, EndAt, IsActive, Content, ModuleId)
VALUES
(1, 30, 150.00, 0.10, N'Sản phẩm A', '2000-01-01', '2024-04-03 08:32:34', '08:00:00', '17:00:00', 1, N'Nội dung sản phẩm A', NEWID());

--- CHÈN dữ liệu vào một table có khóa chính
/* IDENTITY (param1, param 2)
	param1: là giá trị khởi tạo
	param2: bước nhảy
*/
CREATE TABLE dbo.brands (
	brand_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	brand_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL
)

CREATE TABLE dbo.brands (
	brand_id INT IDENTITY(1,1)  NOT NULL,
	brand_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL
	-- PK_brands_brand_id là tên mà đặt cho khóa chính
	CONSTRAINT PK_brands_brand_id PRIMARY KEY (brand_id)
)


SELECT * FROM dbo.brands

SET IDENTITY_INSERT dbo.brands ON;
INSERT dbo.brands 
	(brand_name) 
VALUES
	(N'Xiaomi 1'),
	(N'Xiaomi 2'),
	(N'Xiaomi 3')

SET IDENTITY_INSERT dbo.brands OFF;

INSERT dbo.brands 
	(brand_name) 
VALUES
	(N'Samsung'),
	(N'Samsung 1'),
	(N'Samsung 2')

--- lệnh UPDATE dữ liệu
UPDATE 
	dbo.brands 
SET 
	description = N'Samsung của hàn quốc 8',
	brand_name = N'Samsung 8'
WHERE 
	brand_id = 8

-- lệnh xóa dữ liệu trong bảng
DELETE dbo.brands -- Xóa tất cả các dòng dữ liệu có trong bảng brand
DELETE dbo.brands WHERE brand_id = 1 -- xóa 1 dòng nơi có brand_id = 1 thôi
TRUNCATE TABLE dbo.brands -- Xóa tất cả các dòng dữ liệu có trong bảng brand + reset tự tăng


-- Lấy dữ liệu từ brands đổ vào cho brands_bk
SET IDENTITY_INSERT dbo.brands_bk ON;
INSERT INTO dbo.brands_bk (brand_id, brand_name, description)
SELECT brand_id, brand_name, description FROM dbo.brands
SET IDENTITY_INSERT dbo.brands_bk OFF;

SELECT * FROM brands
SELECT * FROM brands_bk

--thêm khóa chính cho tablet có sẳn
ALTER TABLE dbo.categories
ADD CONSTRAINT PK_categories_category_id PRIMARY KEY (category_id);

SELECT * FROM categories
DELETE FROm categories WHERE category_id = 3

-- XÓA KHÓA CHÍNH ĐÃ TẠO	
ALTER TABLE categories
DROP CONSTRAINT PK_categories_category_id

-- Thiết lập khóa ngoại cho product có quan hệ MANY T0 ONE với brand
CREATE TABLE dbo.products (
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(255) UNIQUE NOT NULL, -- UNIQUE chống trùng tên
	price DECIMAL(18,2) DEFAULT 0 CHECK (price >= 0), --mặc định nếu ko truyền thì giá = 0
	discount DECIMAL(4,2) CHECK (discount >=0 AND discount <= 49), --99,99%
	CONSTRAINT PK_products_product_id PRIMARY KEY (product_id),
	--nó có quan hệ với brand --> xác định sp này thuộc thương hiệu nào
	brand_id INT NOT NULL, -- test chưa thiết lập khóa ngoại
)
TRUNCATE TABLE [dbo].[products]
-- them khoa ngoai cho table co san
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_brands_id] FOREIGN KEY ([brand_id]) 
	REFERENCES [dbo].[brands] ([brand_id])
	ON DELETE SET NULL --

ALTER TABLE [dbo].[products]
ALTER COLUMN brand_id INT NULL
-- giúp đảm bảo tính toàn vẹn dữ liệu
-- BUT truy vấn sẽ bị chậm đi

INSERT dbo.products
(product_name, price, discount, brand_id)
VALUES
(N'Xiaomi Readmi Note 15', 2000, 30, 5)

SELECT * FROM products
SELECT * FROM brands
DELETE brands WHERE brand_id= 5