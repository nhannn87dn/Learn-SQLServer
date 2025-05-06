--1. Review lai lenh tao Table
use Batch193
GO
CREATE TABLE brands (
	--khai bao cac cot o day
	brand_id INT NOT NULL,
	brand_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL
)
GO


--2. Lênh chèn dữ liệu vào bảng
--2.1 chèn với 1 dòng đơn
INSERT INTO dbo.categories
	(category_id, category_name, description)
VALUES
	(1, 'Road', 'Bicycles designed for paved roads')

--Lệnh để xem dữ liệu của 1 table
SELECT * FROM dbo.categories
--2.2 chèn nhiều dòng 1 lúc
INSERT INTO dbo.categories
	(category_id, category_name, description)
VALUES
	(2, 'Mountain', 'Off-road and trail bicycles'),
	(3, 'Hybrid', 'Versatile bikes for various terrains');


INSERT INTO [dbo].[myTable]
(Id, Age, Price, Discount, ProductName, BirthDay, CreatedAt, StartAt, EndAt, IsActive, Content, ModuleId)
VALUES
(1, 30, 150.00, 0.10, N'Sản phẩm A', '2000-01-01', '2024-04-03 08:32:34', '08:00:00', '17:00:00', 1, N'Nội dung sản phẩm A', NEWID());

SELECT * FROM [dbo].[myTable]

--Lưu ý: đối với các trường khai báo là nchar, nvarchar, ntext

INSERT INTO dbo.categories
	(category_id, category_name, description)
VALUES
	(4, 'Điện thoại', 'Bicycles designed for paved roads')



--fix unicode
INSERT INTO dbo.categories
	(category_id, category_name, description)
VALUES
	(15, N'Điện thoại', N'Bicycles designed for paved roads')

--3. Tạo khóa chính Primary key
DROP TABLE dbo.categories

DELETE  FROM dbo.categories

CREATE TABLE categories (
	--khai bao cac cot o day
	category_id INT PRIMARY KEY NOT NULL, -- khai báo khóa chính là category_id
	category_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL
)

--4. Khai báo khóa chính tự tăng
CREATE TABLE categories (
	--khai bao cac cot o day
	category_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- khai báo khóa chính tự tăng là category_id
	category_name NVARCHAR(50) NOT NULL,
	description NVARCHAR(255) NULL
)
/**
	IDENTITY(1,1) --> IDENTITY(start,step)
	- start là giá trị bắt đầu
	- step: là bước nhảy, mỗi lần chèn nó tăng step đơn vị
*/

INSERT INTO dbo.categories
	(
		category_name, -- ten danh muc
		description -- mo ta ngan cua dan danh muc
	)
VALUES
	(
	'Hybrid',
	N'Versatile bikes for various terrains'
	)

INSERT INTO dbo.categories
	(
		category_name, -- ten danh muc
		description -- mo ta ngan cua dan danh muc
	)
VALUES
	(
	N'Phụ kiện',
	N'Phụ kiện giá rẻ nhất đà nẵng'
	)

-- TH có khóa chính tự tăng ==> vẫn muốn chủ động điền ID
INSERT INTO dbo.categories
	(	
		category_name, -- ten danh muc
		description -- mo ta ngan cua dan danh muc
	)
VALUES
	(
	'Electric',
	N'Comfortable and stylish bikes for leisurely rides'
	)
-- Có thể nhưng cần phải đổi lại cách thực hiện nhưu sau:
SET IDENTITY_INSERT dbo.categories ON; 
INSERT INTO dbo.categories
	(	
		category_id,
		category_name, -- ten danh muc
		description -- mo ta ngan cua dan danh muc
	)
VALUES
	(
	15,
	'Tai nghe',
	N'Comfortable and stylish bikes for leisurely rides'
	)
SET IDENTITY_INSERT dbo.categories OFF; 


SELECT * FROM dbo.categories


--5. UPDATE --> cập nhật dữ liệu
--5.1 UPDATE With WHERE
UPDATE 
	dbo.categories
SET
	category_name = N'Phụ kiện', -- thay đổi giá trị mới
	description = N'Phụ kiện giá tốt nhất việt nam'
WHERE -- điều kiện, phạm vi tác động
	category_id = 16

--5.2 UPDATE Without WHERE ==> 
UPDATE 
	dbo.categories
SET
	description = N'balala'
	--> tất cả các dòng dữ liệu sẽ thay đổi giá trị tại cột đã cập nhật
	--> Phạm vi tác động là TOÀN BỘ BẢNG dữ liệu ==> NGUY HIỂM

--6 DELETE --> Xóa dữ liệu
-- 6.1 DELETE without WHERE --> Xóa ko có điều kiện
DELETE FROM dbo.categories 
--> Xóa toàn bộ các dòng dữ liệu của bảng, giữ nguyên tự tăng ==> CỰC NGUY HIỂM
SELECT * FROM dbo.categories
-- 6.2 DELETE with WHERE --> Xóa có điều kiện --> giới hạn phạm vi tác động lại
DELETE FROM dbo.categories
WHERE 
	category_id = 18 -- điều kiện cần đáp ứng <==> phạm vi tác động
-- 6.2 Xóa toàn bộ dữ liệu của bảng, reset tự tăng
TRUNCATE TABLE dbo.categories


--7. PRIMARY KEY

ALTER TABLE [dbo].brands
ADD PRIMARY KEY (brand_id);
-- Theo cách này là mình chủ động đặt tên cho CONSTRAINT primary key
ALTER TABLE [dbo].brands
ADD CONSTRAINT [PK_brands_brand_id] PRIMARY KEY ([brand_id]);


--8. FOREIGN KEY
CREATE TABLE products (
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(255)  NOT NULL, --UNIQUE --> chống trùng lặp giá trị
	/**
		- người ta có thể ko nhập giá khi nhập liệu sản phẩm, mặc định giá = 0
		- giá bán phải >=0
	*/
	price DECIMAL(12,2) DEFAULT 0 CHECK (price >= 0), --
	/**
		- Nếu ko giảm giá thì mặc định discount = 0
		- Không được giảm trên 50%
	*/
	discount DECIMAL(4,2) DEFAULT 0 CHECK (discount <= 50), -- chiết khấu giảm giá

	--Đặt tên cho khóa chính
	CONSTRAINT [PK_products_product_id] PRIMARY KEY ([product_id]),
	CONSTRAINT [UQ_products_product_name] UNIQUE (product_name), -- chống trùng lặp tên

	-- Khóa ngoại
	category_id INT NULL,
	CONSTRAINT [FK_products_category_id] FOREIGN KEY ([category_id]) 
		REFERENCES [dbo].[categories] ([category_id]) --> tham chiếu tới khóa chính của [categories]
		ON DELETE SET NULL -- tùy chọn khi xóa
)

DROP TABLE dbo.products

SELECT * FROM categories
--chèn dữ liệu cho product
INSERT INTO dbo.products
	(
	product_name,
	price,
	discount,
	category_id
	)
VALUES
	(
	N'Iphone 18 pro max',
	555.00,
	40.00,
	1
	)
SELECT * FROM products
SELECT * FROM categories

INSERT INTO products (product_name, price, discount, category_id) 
VALUES 
('Iphone 17 pro max', 888.00, 0.00, 2),
('Iphone 16 pro max', 588.00, 22.50, 2),
('Iphone 18 pro max', 955.00, 40.00, 2);

--Khi thiết lập khóa ngoại với tùy chọn ON DELETE CASCADE
DELETE FROM dbo.categories WHERE category_id = 2