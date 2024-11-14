-- 1. select without from
SELECT 
    LOWER('TEST') result;

SELECT RAND() as result;

-- 2. select with from
-- 2.1 Lấy tất cả dữ liệu của table brands
SELECT * FROM dbo.brands -- dấu * dại diện tất cả các cột của table đang có
-- 2.2 Lấy một trường cụ thể của table --> liệt kê các trường cần lấy, 
-- cách nhau = dấu phẩy
SELECT product_id, product_name, price FROM dbo.products

-- 2.3 Select với một biểu thức
SELECT (2 + 5) As total;
SELECT
	customer_id AS id, -- id thôi
	(first_name + ' ' + last_name) AS full_name
FROM 
	dbo.customers
-- 2.4  SELECT với DISTINCT
-- Liệt kê danh sách các bang (state) trong dữ liệu customers
SELECT 
DISTINCT state -- DISTINCT loại bỏ các dòng có giá trị trùng lặp
FROM
	dbo.customers
SELECT 
DISTINCT shipping_city 
FROM 
orders
-- 2.5 SELECT với mệnh đề TOP & TOP PERCENT
-- Lấy 5 sp trong danh sách sản phẩm
SELECT
TOP 5
  *
FROM
	dbo.products
-- Lấy 5% số dòng dữ liệu của table products đang có
SELECT
TOP 5 PERCENT -- = 5%
  *
FROM
	dbo.products


-- 2.6 SELECT với mệnh đề WITH TIES
-- 2.7 SELECT với mệnh đề WHERE
-- 2.7.1 Chỉ lấy những sp có model_year năm 2018
SELECT 
	*
FROM dbo.products
WHERE model_year = 2018 -- TOÁN TỬ SO SÁNH =
-- 2.7.2  Lấy những sp có model year > 2022
SELECT 
	*
FROM dbo.products
WHERE model_year > 2022
-- 2.7.3 SELECT với TOÁN TỬ AND (Kết hợp nhiều điều kiện)
-- Lấy những sp có category_id = 2 và brand_id = 7
SELECT * FROM dbo.products
WHERE category_id = 2 AND brand_id = 7 -- Thõa mản tất các vế của AND
-- 2.7.4  SELLECT với TOÁN TỬ OR (Hoặc = 1 trong các điều kiện)
-- Liệt kê dssp có model_year = 2025 hoặc 2028
SELECT * FROM dbo.products
WHERE model_year = 2025 OR model_year = 2028
-- 2.7.5  SELLECT với TOÁN TỬ IN (1 trong các điều kiện == OR)
SELECT * FROM dbo.products
WHERE model_year IN (2025, 2028) -- tương đương với OR ở 2.7.4
-- 2.7.6  SELLECT với BETWEEN
-- Liệt kê DSSP có năm sx (model_year) từ 2025-2028
SELECT * FROM dbo.products
WHERE model_year >= 2025 AND model_year <= 2028
SELECT * FROM dbo.products
WHERE model_year BETWEEN 2025 AND 2028

-- 2.7.7  SELECT với TOÁN TỬ LIKE
-- Tìm all sản phẩm mà tên có chứa từ 'Sun'
SELECT
 *
FROM dbo.products
WHERE product_name LIKE '%sun%'

SELECT
 *
FROM dbo.products
WHERE product_name LIKE 'sun%' -- bắt đầu là sun

SELECT
 *
FROM dbo.products
WHERE product_name LIKE '%sun' -- kết thúc là sun

-- Tìm tất cả khách có số điện thoại có số đuôi là 553
SELECT * FROM dbo.customers
WHERE phone LIKE '%553'

-- 2.7.8  SELECT với kiểu dữ liệu ngày tháng
-- Tìm tất cả khách hàng có sinh nhật tháng 9
SELECT MONTH(CAST('2016-06-01' AS DATE)) as m
SELECT *
FROM dbo.customers
WHERE MONTH(birthday)= 9
-- Tìm tất cả đơn hàng bán ra từ ngày đến ngày
SELECT 
*
FROM orders
WHERE 
	order_date >= CAST('2016-01-01' AS DATE) AND order_date <= CAST('2016-01-30' AS DATE)
	-- Tìm tất cả đơn hàng bán ra năm 2018

-- 2.7.8 SELECT với mệnh đề ORDER BY
-- Dùng để sắp xếp chiều tăng dần, giảm dần
SELECT * FROM dbo.products
ORDER BY product_name ASC, price ASC -- tăng dần

SELECT * FROM dbo.products
ORDER BY price	DESC -- giảm dần

-- 2.7.9  SELECT với mệnh đề OFFSET-FETCH --> phân trang
-- Mục đích của phân trang --> giảm tải cho server

SELECT
	product_id,product_name,price
FROM
    dbo.products
ORDER BY product_id
OFFSET 10 ROWS  --  OFFSET = vị trí lấy
FETCH NEXT 10 ROWS ONLY; -- mỗi lần lấy 10

-- 2.7.10  SELECT với GROUP BY
-- Thống kê xem có bn khách hàng ở mỗi bang

SELECT 
DISTINCT state -- DISTINCT loại bỏ các dòng có giá trị trùng lặp
FROM
	dbo.customers

SELECT 
	state,
	COUNT(customer_id) -- đếm số lượng trên group đã nhóm
FROM
	dbo.customers
GROUP BY -- khử trùng lặp, cho phép tính toán trên nhóm
	state
-- Thống kê số tiền đã mua của mỗi khách hàng ?
SELECT * FROM orders WHERE order_id = 1

SELECT 
 order_id,
 SUM(quantity * price)
FROM order_items WHERE order_id = 1
GROUP BY order_id


SELECT * FROM order_items