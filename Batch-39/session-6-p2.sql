USE BatchRN39
GO
-- Câu lệnh tạo table
CREATE TABLE [Products](
	--khai bao các cột cho table
	-- IDENTITY(start,step)
	-- 1: bắt đầu chạy từ 1
	-- 1: 1 lần tăng lên 1 đơn vị
	product_id INT IDENTITY(1,1) NOT NULL,
	product_name NVARCHAR(255),
	price DECIMAL(12,2), -- 1.000.000.000,00
	discount DECIMAL(4,2), --99,90
	description NVARCHAR(MAX),
	is_active BIT, -- 0 | 1
	created_at DATETIME2,
	category_id INT NOT NULL DEFAULT -1,
	brand_id INT,
	is_delete BIT DEFAULT 0, -- soft delete
	-- tạo khóa chính + đặt tên dễ hiểu
	CONSTRAINT [PK_Products_product_id] PRIMARY KEY ([product_id]),
	-- Khóa ngoại
	CONSTRAINT [FK_Product_category_id] FOREIGN KEY (category_id)
		REFERENCES dbo.Categories(category_id) --Khóa ngoại category_id
		ON DELETE CASCADE
		,
	CONSTRAINT [FK_Product_brand_id] FOREIGN KEY (brand_id)
		REFERENCES dbo.Brands(brand_id), --Khóa ngoại brand_id
)

-- XÓA 1 table
DROP TABLE IF EXISTS dbo.Products
DROP TABLE IF EXISTS dbo.Categories

-- CHÈN DỮ LIỆU VÀO TABLE
-- Chèn 1 dòng (record = bản ghi)
INSERT INTO dbo.Products
(product_name, price, discount, description,is_active, created_at, category_id, brand_id)
VALUES
(N'Iphone 16 Pro Max', 120.55, 8.00, N'Iphone có bán trả góp',1, '2024-06-26', 1, 1)

SET IDENTITY_INSERT dbo.Products ON;

INSERT INTO dbo.Products
(product_id, product_name, price, discount, description,is_active, created_at)
VALUES
(5, N'Iphone 17 Pro Max', 150.00, 0.00, N'Iphone có bán trả góp',1, '2024-06-26')

SET IDENTITY_INSERT dbo.Products OFF;

-- Chèn nhiều recods 1 lúc trong 1 câu lệnh
INSERT INTO dbo.Products
(product_id, product_name, price, discount, description, is_active, created_at)
VALUES
(18, N'Iphone 18 Pro Max', 180.00, 0.00, N'Iphone có bán trả góp', 1, '2024-06-26 19:13:00'), -- yyyy-mm-dd H:m:i
(19, N'Iphone 19 Pro Max', 190.00, 0.00, N'Iphone có bán trả góp', 1, '2024-06-26'),
(20, N'Iphone 20 Pro Max', 200.00, 0.00, N'Iphone có bán trả góp', 1, '2024-06-26')


INSERT INTO dbo.Products
(product_id, product_name, price, discount, description, is_active, created_at)
VALUES
(21, N'Iphone 21 Pro Max', 150.00, 0.00, N'Iphone có bán trả góp',1,CAST('2024-06-26 19:13:00' AS DATETIME2))



-- Xem dữ liệu của table đang có
SELECT * FROM dbo.Products


-- /////////////////////////////////////////
-- UPDATE
UPDATE dbo.Products
SET discount = 10.00 -- update tất cả

-- update 1 điều kiện cụ thể
--VD: update discount = 12, nơi mà có product_id = 21
UPDATE dbo.Products
SET discount = 12.00
WHERE
	product_id = 21

--- ///////////////////////
-- DELETE
-- Xóa all dữ liệu có trong bảng
DELETE FROM dbo.Products
-- Xóa có điều kiện
-- VD: Xóa dòng có product_id = 19
DELETE
FROM dbo.Products
WHERE product_id = 21


CREATE TABLE dbo.Categories(
	category_id INT IDENTITY(1,1) NOT NULL,
	category_name NVARCHAR(50), -- allow null
	description NVARCHAR(255),
	--Định nghĩa khóa chính
	-- [PK_Categories_category_id] --> đặt tên cho khóa chính
	CONSTRAINT [PK_Categories_category_id] PRIMARY KEY ([category_id])
)

INSERT
	dbo.Categories
(
	category_name, 
	description
)
VALUES
(
	N'Road',
	N'Bicycles designed for paved roads'
)

CREATE TABLE dbo.Brands(
	brand_id INT IDENTITY(1,1) NOT NULL,
	brand_name NVARCHAR(50), -- allow null
	description NVARCHAR(255)
	--Định nghĩa khóa chính
	-- [PK_Categories_category_id] --> đặt tên cho khóa chính
	CONSTRAINT [PK_Brands_brand_id] PRIMARY KEY ([brand_id])
)

INSERT
	dbo.Brands
(
	brand_name, 
	description
)
VALUES
(
	N'Trek',
	N'High-quality bikes for all terrains'
)

--============================
-- CONTRAINTS

--PRIMARY KEY

SELECT * FROM dbo.Brands
SELECT * FROM dbo.Categories
SELECT * FROM dbo.Products

DELETE FROM dbo.Categories WHERE category_id = 1

SELECT 
	p.*, 
	c.category_name 
FROM dbo.Products AS p
LEFT JOIN dbo.Categories AS c 
	ON c.category_id = p.category_id


CREATE TABLE dbo.Staffs(
	staff_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	last_name NVARCHAR(50) NOT NULL,
	phone VARCHAR(10) UNIQUE NOT NULL, -- chống trùng lặp
	email VARCHAR(150) UNIQUE NOT NULL,
	age TINYINT CHECK (age >= 18 AND age <= 100),
	active BIT DEFAULT 0, -- mặc định là chưa active
)
DROP TABLE dbo.Staffs

INSERT dbo.Staffs
(first_name, last_name, phone, email, age)
VALUES
('Shara', 'Tim', '0988777999', 'shara@gmail.com', 80)

SELECT * FROM dbo.Staffs


-- Tạo lại bảng Orders và OrderDetails với DEFAULT -1 cho OrderID và ON DELETE SET DEFAULT
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    DetailID INT PRIMARY KEY,
    OrderID INT DEFAULT -1,  -- Đặt giá trị mặc định là -1
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE SET DEFAULT
);

-- Chèn dữ liệu vào bảng Orders và OrderDetails
INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES (1, 101, '2023-01-01'),
       (2, 102, '2023-01-05');

INSERT INTO OrderDetails (DetailID, OrderID, ProductID, Quantity)
VALUES (101, 1, 201, 2),
       (102, 1, 202, 3),
       (103, 2, 203, 1);
-- Xóa bản ghi từ bảng Orders (OrderID = 1)
DELETE FROM Orders WHERE OrderID = 1;

-- Kiểm tra dữ liệu trong bảng OrderDetails sau khi xóa
SELECT * FROM OrderDetails;
