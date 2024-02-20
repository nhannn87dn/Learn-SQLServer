-- Lấy all dữ liệu có trong table
SELECT * FROM brands
SELECT * FROM dbo.brands
--Lấy các cột cụ thể
SELECT brand_id, brand_name FROM dbo.brands
--select với một biểu thức
SELECT * FROM customers
SELECT customer_id, first_name + ' ' + last_name AS full_name FROM dbo.customers
-- select không có FROM
SELECT GETDATE()
SELECT UPPER('chu thuong')

-- DISTINCT --> loại bỏ giá trị trùng lặp
SELECT
customer_id
FROM 
	orders
ORDER BY
	customer_id ASC
--TOP lấy n dòng dòng đầu tiên trong dữ liệu đang có
SELECT TOP 10 * FROM orders
-- PERCENT 5, --Lấy 5 % các records ngẩu nhiên có trong table
SELECT TOP 5 PERCENT *  FROM orders
-- TOP WITH TIES
SELECT TOP 10 WITH TIES product_id, product_name, price 
FROM products
ORDER BY price DESC
-- SELECT với INTO
SELECT * INTO customersBackup2019
FROM customers;
SELECT * FROM customers
--SELECT với mệnh đề WHERE
SELECT * FROM customers WHERE customer_id = 5
-- Lấy cho tôi sản phẩm có giá > 2000
SELECT * FROM products WHERE price > 2000
-- Lấy cho tôi sản phẩm có giá > 2000 và có model_year = 2019
SELECT * FROM products WHERE price > 2000 AND model_year = 2019
-- Lấy cho tôi tôi sản phẩm có brand_id = 5 hoặc = 8 và category_id = 4
SELECT 
* 
FROM 
	products 
WHERE 
	(brand_id = 5 OR brand_id = 8) AND category_id = 4

-- Lấy cho tôi sản phẩm có brand_id = 5 hoặc = 8
SELECT 
	* 
FROM 
	products 
WHERE
	brand_id = 5 OR brand_id = 8
-- Toán tử IN
SELECT 
	* 
FROM 
	products 
WHERE 
	brand_id IN (5,8)

--Ví dụ: Tìm những đơn đặt hàng từ 2016-01-01 - 2016-05-01
SELECT 
 *
FROM
	orders
WHERE
	order_date >= '2016-01-01'
	AND
	order_date <= '2016-05-01'

SELECT *
FROM orders
WHERE order_date BETWEEN CONVERT(DATE, '2016-01-01') AND CONVERT(DATE, '2016-05-01');

--- Toản tử LIKE
SELECT *
FROM customers
WHERE phone LIKE '%478'
--> TÌm ra khách hàng có số đuôi đt là 478
SELECT *
FROM customers
WHERE
	birthday LIKE '1972%'
ORDER BY
	customer_id DESC


SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
	product_id,
    price,
    product_name 
OFFSET 10 ROWS; -- Vị trí bắt đầu lấy
--1-10 page 1
SELECT
    product_name,
    price
FROM
    dbo.products
ORDER BY
    price,
    product_name 
OFFSET 0 ROWS --bắt đầu lấy từ vị trí số 0
FETCH NEXT 10 ROWS ONLY; --> lấy 10 dòng tiếp tiếp theo
--11-20 page 2
SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
product_id,
    price,
    product_name 
OFFSET 10 ROWS --bắt đầu lấy từ vị trí số 0
FETCH NEXT 10 ROWS ONLY; --> lấy 10 dòng tiếp tiếp theo