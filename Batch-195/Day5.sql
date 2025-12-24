--1. SELECT without FROM
-- Trả về ngày hiện tại
SELECT GETDATE() 
-- Lấy 3 kí tự bên trái của chuỗi
SELECT LEFT('SQL Tutorial', 3) AS ExtractString;
-- Chuyển chuỗi thành kí tự thường
SELECT LOWER('SQL Tutorial is FUN!');
-- tạo số ngẩu nhiên
SELECT RAND() AS random;

--2. SELECT *  ---> xem tất cả cột của 1 table
SELECT * FROM dbo.categories
SELECT * FROM dbo.orders

-- 3. SELECT cụ thể columns cần lấy
SELECT product_id, product_name, model_year FROM dbo.products

SELECT 
	product_id, 
	product_name, 
	model_year 
FROM 
	dbo.products

-- 4. SELECT với một biểu thức
SELECT  1 + 1  AS total
SELECT first_name + ' '  + last_name AS full_name  FROM customers

-- 5. Thay thế tên cột trong kết quả trả về
SELECT 
	product_id AS id, 
	product_name, 
	model_year AS nam_san_xuat 
FROM 
	dbo.products

--6. SELECT với mệnh đề DISTINCT
-- Liệt kê danh sách các bang trong dữ liệu khách hàng
SELECT 
	DISTINCT state -- loại bỏ giá trị trùng lặp
FROM dbo.customers

--7. SELECT với mệnh đề TOP & TOP PERCENT
SELECT TOP 10 * -- lấy 10 dòng đầu tiên
FROM products

SELECT TOP 5 PERCENT * -- lấy tương đối 5% trên tổng số record của 1 table
FROM products

---8. SELECT với mệnh đề WITH TIES
CREATE TABLE product_test (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price INT NOT NULL
);


INSERT INTO product_test (ProductID, ProductName, Price) VALUES
(1, 'Product A', 100),
(2, 'Product B', 200),
(3, 'Product C', 300),
(4, 'Product D', 300),
(5, 'Product E', 300),
(6, 'Product F', 400),
(7, 'Product G', 500);

SELECT * FROM product_test;

SELECT TOP 3 WITH TIES
    ProductID,
    ProductName,
    Price
FROM
    product_test
ORDER BY
    Price DESC;

--9. SELECT với mệnh đề WHERE

--9.1 Chỉ lấy những sp có model_year = 2020
SELECT 
	*
FROM dbo.products
WHERE
	model_year = 2020 -- điều kiện truy vấp == SO SÁNH BẰNG
--9.2 Chỉ lấy những sp có model_year > 2025
SELECT 	* FROM dbo.products WHERE model_year > 2025 -- == SO SÁNH Lớn hơn

--9.3 Chỉ lấy những sp có model_year > 2025 VÀ < 2028 ==> TOÁN TỬ AND (VÀ)
SELECT 	* FROM dbo.products 
WHERE model_year > 2025 AND model_year < 2028
--9.4 Chỉ lấy những sp có model_year = 2025 HOẶC 2028 ==> TOÁN TỬ OR (HOẶC)
SELECT 	* FROM dbo.products 
WHERE model_year = 2025 OR model_year = 2028

--9.5 Kết hợp nhiều điều kiện: thuộc danh mục = 3, và năm sản xuất > 2026
SELECT 	* FROM dbo.products 
WHERE
	category_id = 3 AND model_year > 2026 -- thoả mãn các điều kiện

SELECT * FROM orders WHERE shipping_city IS NOT NULL


SELECT * FROM products WHERE category_id = 2 OR category_id = 3
SELECT * FROM products WHERE category_id IN (2,3)


SELECT *
FROM orders
WHERE order_date BETWEEN CONVERT(DATE, '2016-01-01') AND CONVERT(DATE, '2016-01-30');


SELECT *
FROM customers
WHERE phone LIKE '%478' -- kết thúc chuỗi là 478

SELECT *
FROM customers
WHERE phone LIKE '094%' -- bắt đầu bằng 094

SELECT *
FROM customers
WHERE phone LIKE '%511%' -- Số điện thoại có chứa 3 kí tự 511


--SELECT với mệnh đề ORDER BY
SELECT * FROM products
ORDER BY
	--model_year ASC -- ASC là tăng dần
	price DESC -- DESC là giảm dần

--Có thể sắp xếp cùng lúc nhiều cột
SELECT * FROM products
ORDER BY
	category_id ASC,
	price DESC

--SELECT  có phân trang
SELECT * FROM products

SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id
	
-- limit 10 là số lượng cần lấy
--offset = (page - 1) * limit

--OFFSET 0 ROWS  -- OFFSET có vị trí bắt đầu lấy
--FETCH NEXT 10 ROWS ONLY; -- FETCH số lượng record cần lấy -->  10 sp đầu của page = 1


OFFSET 10 ROWS  -- OFFSET có vị trí bắt đầu lấy
FETCH NEXT 10 ROWS ONLY; -- FETCH số lượng record cần lấy -->  10 sp đầu của page = 2