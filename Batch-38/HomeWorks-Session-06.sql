--tạo table customers
CREATE TABLE dbo.customers (
	customer_id INT  IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	first_name NVARCHAR(50) NOT NULL, --ngoc
	last_name NVARCHAR(50) NOT NULL, --nhan
	phone VARCHAR(15) NOT NULL UNIQUE, --0988777666
	email VARCHAR(50) NOT NULL UNIQUE,
	zip_code VARCHAR(4) NULL, -- cho phép rỗng
)
ALTER TABLE dbo.customers
ADD city NVARCHAR(50) NOT NULL

ALTER TABLE dbo.customers
ADD sate NVARCHAR(50) NOT NULL

SELECT * FROM dbo.customers

--chèn dữ liệu vào table
INSERT INTO dbo.customers
(first_name, last_name, email, phone, city, state, street)
VALUES
('John', N'Nhân', 'john.doe@example.com','123-456-7890','Anytown','CA', '123 Main St')

INSERT INTO dbo.customers
(first_name, last_name, email, phone, city, state, street)
VALUES
('John', N'Nhân 2', 'john2.doe@example.com','123-456-7891','Anytown','CA', '123 Main St'),
('John', N'Nhân 3', 'john3.doe@example.com','123-456-7892','Anytown','CA', '123 Main St'),
('John', N'Nhân 4', 'john4.doe@example.com','123-456-7893','Anytown','CA', '123 Main St')

UPDATE 
	dbo.customers 
SET 
	first_name = N'David', 
	zip_code = '123'  
WHERE 
	customer_id = 3;

SELECT * FROM customers

DELETE dbo.customers --xóa all
DELETE dbo.customers WHERE customer_id = 9 -- chỉ xóa customer_id = 9

--Homeworks C
--1. Hiển thị tất cả các sản phẩm có giảm giá (discount) <= 1
SELECT * FROM products WHERE discount <= 1
SELECT * FROM products WHERE discount = 0
--3
SELECT * FROM products WHERE (price - (price*discount)/100) <= 100
--4
SELECT * FROM products WHERE category_id = 4 AND brand_id = 9
--6 
--Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME ON;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO ON;
 -- Truy vấn SQL của bạn ở đây
SELECT 
	* 
FROM 
	products 
WHERE
	model_year >= 2017
	AND model_year <= 2020
ORDER BY 
	model_year
--Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME OFF;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO OFF;
 -- Truy vấn SQL của bạn ở đây

	--Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME ON;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO ON;
 -- Truy vấn SQL của bạn ở đây
SELECT 
	* 
FROM 
	products 
WHERE
	model_year BETWEEN 2017 AND 2020
ORDER BY 
	model_year
--Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME OFF;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO OFF;
 -- Truy vấn SQL của bạn ở đây
SELECT GETDATE()
 SELECT MONTH(GETDATE()) --thang hien tai
 SELECT DAY(GETDATE()) -- ngay hien tai
 SELECT * FROM customers 
 WHERE 
	MONTH(birthday) = MONTH(GETDATE()) AND
	DAY(birthday) = DAY(GETDATE())
SELECT * FROM orders WHERE shipping_city = 'Houston'

SELECT * FROM brands WHERE brand_name NOT IN ('Heller', 'Trek')

SELECT 
	discount,
	COUNT(product_id) AS countProducts
FROM
	products
GROUP BY 
	discount
HAVING
	discount >= 5
ORDER BY 
	discount DESC

--35
SELECT * FROM customers WHERE customer_id = 75

SELECT 
DATEDIFF(year, birthday, GETDATE()) AS age,
COUNT (customer_id) AS countPerson
FROM 
customers
GROUP BY
	DATEDIFF(year, birthday, GETDATE())
ORDER BY
	age ASC

