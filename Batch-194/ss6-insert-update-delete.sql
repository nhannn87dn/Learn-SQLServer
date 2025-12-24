
SELECt * FROM dbo.categories -- xem dữ liệu của table
--Chèn dữ liệu vào cho Table
INSERT INTO 
dbo.categories (
	category_id,
	category_name,
	description
) 
VALUES 
(
	1,
	'Mobile',
	'No desc'
)

--chèn nhiều records một lần
INSERT INTO 
dbo.categories 
(category_id,category_name, description) 
VALUES 
(2, 'Laptop', 'No desc'),
(3, 'Accessorires', 'No desc');


CREATE TABLE [dbo].test (
    Id              INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- thiết lập khóa chính cho table
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
)
/**
	IDENTITY(1,1) = IDENTITY(start,step)
	1 - bắt đầu là số 1
	1 - mỗi lần tăng 1 đơn vị

*/
DROP TABLE test

SET IDENTITY_INSERT [dbo].test ON; 

INSERT INTO [dbo].test
(Age, Price, Discount, ProductName, BirthDay, CreatedAt, StartAt, EndAt, IsActive, Content)
VALUES
(30, 150.00, 0.10, N'Sản phẩm A', CAST('2000-01-01' AS DATE), CAST('2024-04-03 08:32:34' AS DATETIME2), CAST('08:00:00' AS TIME), CONVERT(TIME, '17:00:00'), 0, N'Nội dung sản phẩm A');

SET IDENTITY_INSERT [dbo].test OFF; 


SELECT * FROM dbo.test


-- Lệnh UPDATE -->  Cập nhật/ thay đổi dư liệu trong bảng
UPDATE dbo.test SET ProductName=N'iPhone 16 Pro max'
WHERE 
	Id = 1 -- phạm vi tác động 1 dòng

UPDATE dbo.test SET ProductName=N'iPhone 16 Pro max'
WHERE 
	Id = 2 OR Id = 4 -- phạm vi tác động rộng hơn với toán tử OR (hoặc)

--Tác động đến tất cả các records đang có trong table t

UPDATE dbo.test SET Content=N'New content'

-- Cập nhật nhiều trường cùng một lúc
UPDATE 
	dbo.test 
SET 
	Content		=	N'New content 18',
	ProductName	=	N'iPhone 18 Pro max',
	isActive	=	0;


-- XÓA dữ liệu trong bảng
--Xóa 1 dòng thôi, phải đi xác định phạm vi xóa
DELETE dbo.test 
WHERE --dùng where để xác định phạm vi xóa
	Id = 14 -- điều kiện cần xóa

SELECt * FROM test

--Xóa phạm vi rộng hơn -- Xóa tất cả id >= 3
DELETE dbo.test 
WHERE --dùng where để xác định phạm vi xóa
	Id >= 3 -- điều kiện cần xóa
--Xóa tất các dòng thì --> ko cần phải xác định phạm vi, ko cần WHERE
DELETE dbo.test -- Xóa hết record trong table, giữ lại chỉ số tự tăng

TRUNCATE TABLE dbo.test -- Xóa hết record trong table, reset lại chỉ số tự tăng

DELETE dbo.orders WHERE status = 'cancel';

DROP TABLE IF EXISTS dbo.products

-- Tạo khóa ngoại category_id, brand_id ngay khi tạo mới Table
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [product_name] NVARCHAR(100) UNIQUE NOT NULL,
  [price] DECIMAL(18,2) DEFAULT 0 CHECK (price >= 0)  NULL,
  [discount] DECIMAL(4,2) DEFAULT 0 CHECK (discount >= 0 AND discount <= 70)  NULL,
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL, --trường này tham chiều đến khóa chính của table
  --mà nó có quan hệ categories
  CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
);

--Thêm khóa ngoại khi table đã tạo
ALTER TABLE [dbo].products
ADD CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
    REFERENCES categories(category_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE;

--Xóa một key dựa vào tên
ALTER TABLE [dbo].products
DROP CONSTRAINT FK_products_category_id;

--Them khóa chính cho table categoires đã tồn tại

ALTER TABLE [dbo].categories
ADD CONSTRAINT [PK_category_id] PRIMARY KEY (category_id)
GO

UPDATE categories SET category_id = 4 WHERE category_id = 1
DELETE categories  WHERE category_id = 4

SELECT * FROM categories
SELECT * FROM products

INSERT INTO
dbo.products
(product_name, price, discount, description, category_id)
VALUES
(N'Iphone 16', 9000, 0, 'No', 1),
(N'Iphone 17', 12000, 10, 'No', 1),
(N'Iphone 18', 14000, 20, 'No', 1),
(N'Iphone 19', 16000, 30, 'No', 1);

INSERT INTO
dbo.products
(product_name, price, discount, description, category_id)
VALUES
(N'Iphone 18', 0, 10, 'No', 2);

-- Create CHECK (price > 0)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_price] CHECK ([price] >= 0);
GO

--Create CHECK (discount >= 0 AND discount <= 90)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_discount] CHECK ([discount] >= 0 AND [discount] <= 70);
GO



UPDATE products SET product_name = N'Laptop Dell', category_id = 2 WHERE product_id = 4


--Tạo UNIQUE ngay khi tạo mới table
CREATE TABLE [dbo].brands (
  [brand_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [brand_name] NVARCHAR(50) UNIQUE NOT NULL, -- UNIQUE
  [description] NVARCHAR(500) NULL,
);
GO

INSERT INTO dbo.brands
(brand_name)
VALUES
('Apple')
SELECT * FROM brands