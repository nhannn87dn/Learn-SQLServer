--create table
-- first_name: snake case
-- FirstName: Pascal case
-- firstName: camleCase
CREATE TABLE [dbo].[categories] (
	category_id INT IDENTITY(1,1) NOT NULL,
	category_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(500) NULL
)
-- Tao constrain va dat ten cho khoa chinh
ALTER TABLE [dbo].[categories]
ADD CONSTRAINT [PK_categories_category_id] PRIMARY KEY ([category_id]);

CREATE TABLE [dbo].[products] (
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(50) NOT NULL,
	price DECIMAL(18,2), -- 1.200.000,00 >= 0
	discount DECIMAL(4,2), --70,50%
	description NVARCHAR(500) NULL,
	model_year SMALLINT, --2024
	category_id INT NULL, --default null, 0
)

--Thiết lập lại khóa chính
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [PK_products_product_id] PRIMARY KEY ([product_id]);

--Tạo khóa ngoại  FOREIGN KEY (category_id) 
--tham chiếu đến khóa chính categories(category_id)
--ALTER TABLE [dbo].[products]
--ADD CONSTRAINT [FK_products_categories] FOREIGN KEY ([category_id])
--	REFERENCES [dbo].[categories] ([category_id]);

ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_categories] FOREIGN KEY ([category_id])
	REFERENCES [dbo].[categories] ([category_id])
	ON DELETE SET NULL --SET DEFAULT

-- delete table
DROP TABLE dbo.categories
DROP TABLE dbo.products

--===============================================================

-- INSERT DATA into TABLE
-- Chen 1 lan 1 record
INSERT INTO [dbo].[categories] 
	(
	--category_id,
	category_name,
	description
	)
VALUES
	(
	--1,
	N'Speaker',
	N'Ban speaker tra gop'
	)

--Chen 1 luc nhieu records
INSERT INTO [dbo].[categories] 
	(category_id,category_name,description)
VALUES
	(2,N'Laptop',N'Ban Lapop tra gop'),
	(3,N'Watch',N'Ban Watch tra gop'),
	(4,N'Access',N'Ban Access gia re')


--SELECT De xem du lieu trong bang
SELECT 
 category_id,
 description,
 category_name
FROM [dbo].[categories]

-- Cap nhat du lieu trong Table

--vd1: Cập nhật cột description tất cả các dòng thành: 'description'
UPDATE 
	dbo.categories
SET
	description = N'description'

--vd2: Cập nhật có dieu kien
-- Cập nhật cột description = 'laptop gia re' --> noi ma category_id = 2
UPDATE 
	dbo.categories
SET
	description = N'laptop gia re'
WHERE
	category_id = 2

--KET LUAN KHI UPDATE
--1. Neu khong co WHERE thi no tac dong den all cac records
--2. Neu co WHERE thi no chi tac dong trong pham vi da chi dinh

--===============================================================

-- DELETE -- Xoa du lieu trong table
--vd1. Xoa all record trong table
DELETE dbo.categories

--vd2: Xoa voi dieu kien cu the
-- Xoa record co category_id = 4
DELETE dbo.categories WHERE category_id = 4
-- Xoa record co Category_name = Watch
DELETE dbo.categories WHERE category_name = N'watch' 


--===============================================================
--			CONSTRAINTS = RANG BUOC
--===============================================================
SELECT * FROM dbo.categories
SELECT * FROM dbo.products

INSERT INTO [dbo].products
	(product_name,price,description, model_year, category_id)
VALUES
	(N'Laptop Asus XL560',900,N'Ban Lapop tra gop',2024, 3)
	

DELETE dbo.categories WHERE category_id = 1

--ADD NOT NULL
ALTER TABLE [dbo].[products]
ALTER COLUMN [price] DECIMAL(18,2) NOT NULL

ALTER TABLE [dbo].[products]
ALTER COLUMN [discount] NOT NULL 

--ADD UNIQUE
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [UQ_product_product_name] UNIQUE ([product_name]);

-- --ADD DEFAULT
ALTER TABLE [dbo].[products]
ADD CONSTRAINT DF_products_price
DEFAULT 0 FOR price;

ALTER TABLE [dbo].[products]
ADD CONSTRAINT DF_products_discount
DEFAULT 0 FOR discount;