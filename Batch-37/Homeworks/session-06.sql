--Sử dụng DB này
USE Batch37
--Tạo table categories
CREATE TABLE categories (
	category_id int not null, -- bắt buộc điền
	category_name nvarchar(50) not null,
	description nvarchar(500) null --cho phép ko điền
)

--Chèn data vào cho categories
INSERT INTO dbo.categories (
	category_id,category_name,description
)
VALUES (1, N'Road', N'Bicycles designed for paved roads'),
(2, N'Mountain', N'Off-road and trail bicycles'),
(3, N'Hybrid', N'Versatile bikes for various terrains'),
(4, N'Cruiser', N'Comfortable and stylish bikes for leisurely rides'),
(5, N'Electric', N'Bicycles powered by electric motors')

select * from categories

/*
PRIMARY KEY
*/
-- 1.Định nghĩa primary key ngay khi tạo bảng
CREATE TABLE brands (
	-- khóa chính tự tăng, 
	-- IDENTITY(1,1): ==> tính duy nhất, unique
	-- Tham số 1: bắt đầu bằng giá trị 1
	-- Tham số 2: Bước nhảy mặc định là 1
	brand_id INT IDENTITY(1,1) PRIMARY KEY not null,
	brand_name nvarchar(30) not null,
	description nvarchar (500) null
)
--Đối với table đã tạo rồi, đã có sẵn như categories
-- Định nghĩa PRIMARY KEY cho table đã tồn tại
ALTER TABLE [dbo].categories
ADD PRIMARY KEY (category_id); --thêm từ khóa chính vào table
--Hoặc cách thứ 2 , có đặt tên cụ thể
ALTER TABLE [dbo].categories
ADD CONSTRAINT [PK_categories_category_id] PRIMARY KEY (category_id);
/*
Cách đặt tên: theo cú pháp: PK_tablename_columnname
*/

--KẾT LUẬN: Khi tạo 1 table thì làm 2 bước
--Bước 1: Xác định cấu trúc table
CREATE TABLE categoriesV2 (
	category_id int IDENTITY(1,1) not null, -- bắt buộc điền
	category_name nvarchar(50) not null,
	description nvarchar(500) null --cho phép ko điền
)
--Bước 2: đi set các contraints
ALTER TABLE [dbo].categories
ADD CONSTRAINT  [PK_categories_category_id] PRIMARY KEY  (category_id);

---TH chạy nhiều câu lệnh INSERT khi brand_id đã set tự tăng
-- và trong câu lệnh INSERT bạn chỉ định luôn giá trị cho brand_id
--Cần set IDENTITY_INSERT, ở đầu và cuối các dòng lệnh

SET IDENTITY_INSERT brands ON

INSERT brands (
brand_id,
	brand_name,
	description
)
VALUES (
3,
N'Specialized',
N'Innovative designs for cycling enthusiasts'
)

INSERT brands (
brand_id,
	brand_name,
	description
)
VALUES (
4,
N'Cannondale',
N'Known for its performance-oriented bicycles'
)

SET IDENTITY_INSERT brands OFF

--Tạo table products
CREATE TABLE [dbo].[products] (
	product_id INT IDENTITY(1,1) not null, --ko đưa PRIMARY KEY vào
	product_name nvarchar(255) not null,
	price DECIMAL(18, 2) DEFAULT 0, --Mặc định price = 0, khi không truyền
	discount DECIMAL(18, 2) DEFAULT 0,
	category_id INT not null, --khóa ngoại
	brand_id INT not null, --khóa ngoại
	description nvarchar(max) null, --nội dung bài viết mô tả
	model_year SMALLINT not null,
	
)
--Bước 2: định nghĩa khóa chính, khóa ngoại
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [PK_products_product_id] PRIMARY KEY (product_id);
--Khóa ngoại của category_id trong products có quan hệ 
--với khóa chính category_id của table categories
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_category_id] FOREIGN KEY (category_id)
	REFERENCES [dbo].[categories] (category_id);
--khóa ngoại brand_id
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_brand_id] FOREIGN KEY (brand_id)
	REFERENCES [dbo].[brands] (brand_id)
	ON DELETE CASCADE;
-- Khi set ON DELETE CASCADE
-- =>  Mỗi khi xóa 1 dòng bên brands, thì nó xóa luôn tất những 
-- dòng bên products mà có brand_id tương ứng
/*
Ví dụ brands có một record có brand_id = 4
bên products có 2 records có brand_id = 4
==> Khi xóa brand_id = 4 bên brands ==> All các dòng bên products
-- có brand_id = 4 được xóa Cùng.

== NẾU ON DELETE SET NULL
==> Khi xóa brand_id = 4 bên brands ==> All các dòng bên products
-- có brand_id = 4 được cập nhật lại brand_id = null
*/

INSERT products (
[product_name],
[price],
category_id,
brand_id,
model_year,
discount
)
VALUES (
N'Mountain Bike v2',
600,
2,
1,
2024,
98
)

--COntraint UNIQUE
ALTER TABLE [dbo].[categories]
ADD CONSTRAINT [UQ_categories_category_name] UNIQUE (category_name); 

--
select * from categories

INSERT categories (
category_id,
category_name
)
VALUES (
7, 
N'Classic'
)


-- Create CHECK (price > 0)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_price] CHECK ([price] > 0);
GO

--Create CHECK (discount >= 0 AND discount <= 90)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_discount] CHECK ([discount] >= 0 AND [discount] <= 90);
GO
