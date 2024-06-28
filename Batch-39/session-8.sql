--- Select ko can FROM
SELECT GETDATE()
SELECT LOWER('SQL Tutorial is FUN!');
-- SELECT có FROM
-- Vd1: SELECT * --> Lấy tất cả các trường (cột) của 1 table
SELECT * FROM dbo.brands
-- vd2: Chỉ lấy những cột cần thiết
SELECT
	brand_id,
	brand_name
FROM 
	dbo.brands
--Vd3: Sử dụng expression (biểu thức tính toán) trong SQL
SELECT ( 1 + 10) as phep_tinh
-- 
SELECT
	first_name,
	last_name,
	(first_name + ' ' + last_name) AS full_name
FROM
	dbo.customers

--vd4: Đổi tên một cột trong kết quả trả về
SELECT
	brand_id,
	brand_name AS name, -- Đổi tên
	description
FROM
	dbo.brands

-- vd5: Tính toán giá trị trước khi trả về
SELECT
 order_id,
 quantity,
 price,
 discount,
 (quantity * price) as sub_amount
FROM
	dbo.order_items

-- vd6: DISTINCT -- khử trùng lặp kết quả trả về
-- Lấy ra danh sách các bang mà khách hàng ở
SELECT
 DISTINCT state
FROM
	dbo.customers
-- vd7: SELECT TOP
-- Lấy 10 sản phẩm đầu tiên của một table
SELECT TOP 10 * 
FROM 
	dbo.products

-- vd7: SELECT PERCENT
-- Lấy 5% số record đầu tiên của table 
SELECT TOP 5 PERCENT * 
FROM 
	dbo.products
-- vd8: SELECT với mệnh đề WITH TIES
SELECT TOP 10 WITH TIES product_id, product_name, price 
FROM products
ORDER BY price DESC

-- vd9: SELECT with INTO
-- Lấy tất cả dữ liệu và cấu trúc của  table
-- phía sau FROM --> sao chép ra table mới
-- có tên phía sau INTO
SELECT * INTO 
	customersBackup2019
FROM 
	dbo.customers;
-- ? Khi nào thì dùng ? Khi bạn cần Backup 1 table
SELECT * FROM dbo.customers
SELECT * FROM dbo.customersBackup2019

----///////////////////////////////////
-- SELECT Với WHERE
-- vd: 10.1
SELECT * FROM dbo.products
-- Lấy thông tin sản phẩm có product_id = 5
SELECT 
	* 
FROM dbo.products
WHERE 
	product_id = 5
--Lấy danh sách sản phẩm có model year từ năm 2018 đến nay
SELECT
	*
FROM dbo.products
WHERE
	model_year >= 2018 -- toán tử so sánh
ORDER BY model_year ASC -- sắp xếp tăng dần, DESC giảm dần

-- Lấy danh sách sản phẩm có model year từ năm 2018 đến nay
-- và brand_i = 8
SELECT
	*
FROM dbo.products
WHERE
	model_year >= 2018 -- toán tử so sánh
	AND brand_id = 8 -- toán tử AND
ORDER BY model_year ASC -- sắp xếp tăng dần, DESC giảm dần

-- Lấy danh sách sản phẩm có category_id = 4 hoặc 116
SELECT
 *
FROM
	dbo.products
WHERE
	category_id = 4 OR category_id = 6 -- toán tử OR

SELECT
 *
FROM
	dbo.products
WHERE
	category_id IN (4,6) -- tương đương với OR

-- Lấy danh sách sản phẩm năm sx từ 2019 đến 2024
SELECT
	*
FROM dbo.products
WHERE
	model_year >= 2019
	AND model_year <= 2024
ORDER BY model_year
-- cách dùng
SELECT
	*
FROM dbo.products
WHERE
	model_year BETWEEN 2019 AND 2024 -- giữa 2 mốc giá trị
ORDER BY model_year

-- Tìm kiếm theo khoảng ngày
-- Lấy dánh sách đơn hàng bán ra từ ngày đến ngày
-- 2016-01-01 đến 2016-05-30
SELECT
	*
FROM
	dbo.orders
WHERE
	order_date >= CONVERT(DATE, '2016-01-01')
	AND order_date <= CONVERT(DATE, '2016-05-30')
-- Lưu : dùng hàm convert sang kiểu DATE

-- Lấy tất cả khách hàng có số điện thoại số đuôi 215
SELECT
	*
FROM dbo.customers
WHERE phone LIKE '%215'
-- % ko quân tâm phần đâu
-- kết thức 678

-- Lấy tất cả khách hàng mà tên có chứa từ 'ro'
SELECT
	*
FROM dbo.customers
WHERE 
	first_name LIKE '%ro%' 
	-- chỉ cần xuất hiện ký tự ro trong first_name
UPDATE dbo.customers
SET last_name = N'ngọc Công' WHERE customer_id = 5
SELECT
	*
FROM dbo.customers
WHERE 
	last_name LIKE '%công%'
------------------------------------------
-- SELECT toán tử IS NULL, IS NOT NULL
SELECT
	*
FROM dbo.stores WHERE state IS NULL 
-- Lấy records có state NULL

SELECT
	*
FROM dbo.stores WHERE state IS NOT NULL
-- Lấy records có state khác NULL

UPDATE dbo.stores SET state = NULL WHERE store_id = 3

-- SELECT có phân trang
SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id
OFFSET 0 ROWS -- OFFSET vị trí cần lấy
FETCH NEXT 10 ROWS ONLY; -- FETCH NEXT số lượng cần lấy
--> page=1&limit=10
--> 0-10

SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id
OFFSET 10 ROWS -- OFFSET vị trí cần lấy
FETCH NEXT 10 ROWS ONLY; -- FETCH NEXT số lượng cần lấy
--> page=2&limit=10
--> 11-20

-- SELECT với GROUP BY
SELECT
 order_id,
SUM(quantity * price) AS amount -- aggregate fucntion
FROM dbo.order_items
GROUP BY
	order_id -- liệt kê cột có tồn tại ở SELECT qua
ORDER BY
	order_id
-- Tính tổng giá trị của các đơn hàng

-- SELECT với GROUP BY & HAVING
-- Tính tổng giá trị của các đơn hàng, chỉ lấy đơn hàng
-- có giá trị >= 11.000 
SELECT
 order_id,
SUM(quantity * price) AS amount -- aggregate fucntion
FROM dbo.order_items

GROUP BY
	order_id -- liệt kê cột có tồn tại ở SELECT qua
HAVING
	order_id < 10
ORDER BY
	order_id

--SELECT với COUNT
-- Đếm xem có bao nhiêu sản phẩm sx năm 2019 ?
SELECT 
	COUNT(product_id) total -- đếm theo trường product_id
FROM dbo.products
WHERE
	model_year = 2019
-- Tìm sản phẩm có giá cao nhất
SELECT 
	MAX(price) -- tìm giá cao nhất
FROM dbo.products


SELECT
	*
 FROM dbo.customers
WHERE
	last_name LIKE N'%xiaomi 11%'

UPDATE dbo.customers SET last_name = N'công nguyễn' WHERE customer_id = 7