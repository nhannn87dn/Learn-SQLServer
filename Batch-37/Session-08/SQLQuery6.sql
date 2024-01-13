
USE BikeStores;
GO
-- Lấy ra tất cả các trường dữ liệu có trong table products
SELECT * FROM dbo.products

-- Muốn lấy một số trường cụ thể
SELECT 
	product_id,
	product_name
FROM
	products

--Lấy sản phẩm có product_id = 5
SELECT * FROM dbo.products WHERE product_id = 5;
--Lấy sản phẩm có brand_id = 9
SELECT * FROM dbo.products WHERE brand_id = 9;
--Lấy sản phẩm có giá bán price > 3000USD
SELECT * FROM dbo.products WHERE price > 3000;
-- Lấy sản phẩm có giá bán price > 3000USD VÀ sản xuất năm model_year = 2017 
SELECT * FROM dbo.products WHERE price > 3000 AND model_year = 2017;
--Tìm sản phẩm có tên là: Trek Fuel EX 9.8 29 - 2017 => giá trị kiểu chuỗi
SELECT * FROM dbo.products WHERE product_name = N'Trek Fuel EX 9.8 29 - 2017';
-- Tìm sản phẩm có thương hiệu brand_id = 5 hoặc brand_id = 8;
SELECT * FROM dbo.products WHERE brand_id = 5 OR brand_id = 8;
-- Tìm sản phẩm có thương hiệu brand_id = 8 và thuộc danh mục category_id = 4
SELECT * FROM dbo.products WHERE brand_id = 8 AND category_id = 4;
-- Tìm cho tôi các sản phẩm thuộc các danh mục  category_id = 4 hoặc 2;
SELECT * FROM dbo.products WHERE category_id = 2 OR category_id = 4;
SELECT * FROM dbo.products WHERE category_id IN(2,4)

-- Tìm những sản phẩm có năm sản xuất 2017<= model_year <= 2020
SELECT * FROM dbo.products WHERE model_year >= 2017 AND model_year <= 2020;
SELECT * FROM dbo.products WHERE model_year BETWEEN 2017 AND 2020;



--ASC: tăng dần
--DESC: giảm dần
SELECT * FROM dbo.customers
ORDER BY first_name ASC, last_name ASC;

-- SELECT với một biểu thức
SELECT customer_id, (first_name + ' ' + last_name) AS fullname FROM dbo.customers;

--TÌm khách hàng có 3 số cuối điện thoại là 500 ?
SELECT * FROM dbo.customers WHERE phone LIKE '%500';

--TÌm khách hàng có năm sinh là 1989 ?
SELECT * FROM dbo.customers WHERE birthday LIKE '1989%';

--Lấy danh sách sản phẩm kể từ sản dòng thứ 10 trở đi trong bảng products
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
OFFSET 10 ROWS;

--Trang 1: 0 - 10	==> OFFSET 0 FETCH 10
--Trang 2: 11  - 20 ==> OFFSET 10 FETCH 20

--Trang 1:
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
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;



--Trang 2:
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
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY; --==> Lấy 10 record, kể từ dòng thứ 10

-- Liệt kê danh sách năm sản xuất có trong bảng products
-- Và khử trùng lặp
SELECT model_year FROM dbo.products
--
SELECT DISTINCT model_year FROM dbo.products;

SELECT * FROM orders
--Lấy ra danh sách khách hàng đã mua
SELECT DISTINCT customer_id FROM dbo.orders;

-- khử trùng lặp với GROUP BY 
SELECT 
	customer_id,
	SUM(order_amount) as Total
FROM 
	dbo.orders
GROUP BY 
	customer_id
ORDER BY customer_id ASC;

SELECT 
	customer_id,
	order_amount
FROM 
	dbo.orders
WHERE customer_id = 1
ORDER BY customer_id ASC;

-- Thống kế danh sách khách hàng đã mua, và đã mua bao nhiêu đơn
SELECT 
	customer_id,
	COUNT(order_id) as numbers_order
FROM 
	dbo.orders
GROUP BY 
	customer_id
ORDER BY customer_id ASC;

-- Lấy 10 khách hàng đầu tiên
SELECT TOP 10 * FROM dbo.customers

SELECT TOP 10 WITH TIES product_id, product_name, price 
FROM products
ORDER BY price DESC


SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) AS order_count
FROM
    orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING COUNT (order_id) >= 2
ORDER BY
    customer_id;