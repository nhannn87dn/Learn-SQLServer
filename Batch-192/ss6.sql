-- tạo bảng categories
use Batch192
GO
CREATE TABLE categories (
	category_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	category_name NVARCHAR(60) NOT NULL,
	description NVARCHAR(255) NULL
)
-- chèn 1 dòng dữ liệu vào table
INSERT categories
	(category_name, description)
VALUES
	('Road', 'Bicycles designed for paved roads')

--Xem dữ liệu của 1 table
SELECT * FROM categories

--Chèn nhiều dòng cùng 1 lúc
INSERT categories
	(category_id, category_name, description)
VALUES
	(1, 'Mountain-update', 'Off-road and trail bicycles')

/*
	IDENTITY(start,step) = IDENTITY(1,1)
	start = giá trị bắt đầu --> nó bắt đầu là 1
	step = bước nhảy --> 1 lần tăng lên 1 đơn vị

*/

CREATE TABLE [dbo].[myTable] (
    Id              INT IDENTITY(1,1),
    Age             TINYINT,
    Price           DECIMAL(18,2),
    ProductName     NVARCHAR(255),
    BirthDay        DATE, --Kiểu ngày yyyy-mm-dd
    CreatedAt       DATETIME2, --kiểu yyyy-mm-dd H:i:s
    StartAt         TIME (0), -- H:i:s
    IsActive        BIT, -- 0 or 1
    Content         NVARCHAR(MAX), --Nội dung dài
)

INSERT myTable
	(Age, Price, ProductName, BirthDay, CreatedAt, StartAt, IsActive, Content)
VALUES
	(20, 100.77, 'Iphone 17 Promax', '2024-01-01', GETDATE(), '18:00:00', 1, N'Bán trả góp Iphone 16 Promax'),
	(20, 100.77, 'Iphone 17 Promax', '2024-01-01', GETDATE(), '18:00:00', 1, N'Bán trả góp Iphone 16 Promax')

SELECT * FROM myTable

-- Thay đổi dữ liệu trong bảng
--TH1L Update có điều kiện
UPDATE myTable SET
	Content = N'bán trả góp iphone 16 lãi suất 0 phần trăm'
WHERE
	Id = 2 -- điều kiện --> chỉ tác động trong giới hạn của điều kiện
--TH 2. Update không có điều kiện
UPDATE myTable SET
	Content = N'bán trả góp iphone 16 lãi suất 0%'
--> Phạm vi tác động là tất cả các rows của table


-- Xóa dữ liệu
-- Th1. Xóa có điều kiện
DELETE 
	myTable
WHERE
	Id = 2 --> phạm vi 1 dòng

-- Th2. Xóa ko có điều kiện
DELETE myTable

--Reset tự tăng
TRUNCATE TABLE myTable

--CONTRAINTS - Ràng buộc
CREATE TABLE products (
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(255) NOT NULL UNIQUE, --chống trùng tên
	price DECIMAL(18, 2) DEFAULT 0 CHECK (price >= 0),
	discount DECIMAL(7, 2) DEFAULT 0 CHECK (discount >=0 AND discount <= 70),
	description NVARCHAR(255) NULL,
	model_year SMALLINT NOT NULL,
	category_id INT NOT NULL,
	brand_id INT NOT NULL
)

ALTER TABLE [dbo].[products]
ADD PRIMARY KEY (product_id);

ALTER TABLE [dbo].[products]
ADD CONSTRAINT [PK_products_product_id] PRIMARY KEY ([product_id]);

ALTER TABLE [dbo].[products]
ADD CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
	CONSTRAINT FK_products_brand_id FOREIGN KEY (brand_id) 
        REFERENCES brands(brand_id) --Khóa ngoại brand_id
		ON DELETE CASCADE

INSERT products
	(product_name, price, model_year, discount, category_id, brand_id)
VALUES
	(N'Điện thoại xiaomi 14', 800, 2025, 60, 1, 2)

SELECT * FROM products

DELETE products

CREATE TABLE brands (
	brand_id INT NOT NULL IDENTITY(1,1),
	brand_name NVARCHAR(60) NOT NULL,
	description NVARCHAR(255) NULL
	CONSTRAINT [PK_brands_brand_id] PRIMARY KEY (brand_id)
)

SELECT * FROM brands

SET IDENTITY_INSERT brands ON; 

INSERT brands 
	(brand_id, brand_name)
VALUES
	(5, 'Cannondale'),
	(6, 'Scott')

SET IDENTITY_INSERT brands OFF; 

DELETE brands WHERE brand_id = 1