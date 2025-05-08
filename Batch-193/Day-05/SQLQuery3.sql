select * from dbo.products

---1. select without from
SELECT GETDATE(); -- lay thoi gian hien tai cua server
SELECT LOWER('NHAN'); -- bien chuoi thanh chu thuong
SELECT LEFT('SQL Tutorial', 3); -- lay 3 ki tu tu huong trai -left
SELECT TRIM(' dsdsds   ');

---2. select * --> lay tat ca du lieu cua 1 table
SELECT * FROM dbo.products
--3. Select mot so truong cu the
-- vi du: chi lay product_id, product_name, price
SELECT
	product_id,
	product_name, -- ten san pham
	price
FROM
	dbo.products

--3.  SELECT với một biểu thức
SELECT 3 + 5; -- bieu thuc toan hoc
SELECT 'nhan' + ' ' + 'nguyen'; -- noi chuoi
SELECT
	 customer_id,
	first_name + ' ' + last_name AS full_name
FROM dbo.customers

--4. SELECT với mệnh đề DISTINCT

--Y/c: Liệt kê danh sách các bang trong dữ liệu khách hàng --> 3 bang
SELECT
	DISTINCT state -- khử bỏ trùng lặp cho cột state
FROM dbo.customers

--5. SELECT với mệnh đề TOP & TOP PERCENT
SELECT * FROM dbo.customers
--Y/c: Lấy 10 khách hàng đầu tiên trong danh sách
SELECT
	TOP 10 * -- lấy 10 dòng, lấy tất cả các cột
FROM dbo.customers
ORDER BY
	customer_id DESC --- ASC = tang dan | DESC = giam dan

-- 6. SELECT với ORDER BY: --- ASC = tang dan | DESC = giam dan
SELECT * FROM dbo.products
ORDER BY
	product_name ASC -- Neu la chuoi thi sap xep theo Alphabet
-- Lưu ý: có thể sắp xếp nhiều trường trong 1 truy vấn
SELECT * FROM dbo.products
ORDER BY
	product_name ASC, -- tang dan
	model_year DESC -- giam dan

--7. SELECT với mệnh đề WITH TIES
CREATE TABLE test (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price INT
);

INSERT INTO test (ProductID, ProductName, Price) VALUES
(1, 'Product A', 100),
(2, 'Product B', 200),
(3, 'Product C', 300),
(4, 'Product D', 300),
(5, 'Product E', 300),
(6, 'Product F', 400),
(7, 'Product G', 500);

SELECT * FROM test

SELECT TOP 3 WITH TIES
	ProductName
FROM test
ORDER BY
	Price DESC

-- 8. SELECT với mệnh đề WHERE
SELECT * FROM dbo.products
--8.1 Liệt kê danh sách sp (có năm sx model_year = 2018) --> ĐIỀU KIỆN LẤY
SELECT * FROM dbo.products WHERE model_year = 2018 -- SO SÁNH =
--8.2 Liệt kê danh sách sp (có năm sx model_year > 2020)
SELECT * FROM dbo.products WHERE model_year > 2020 -- SO SÁNH >
SELECT * FROM dbo.products WHERE model_year <> 2016 --> so sánh khác
--8.3 Liệt kê danh sách sp 
-- (có năm sx model_year > 2020 VÀ thuộc danh mục category_id = 3) 
SELECT * FROM dbo.products WHERE model_year > 2020 AND category_id = 3
--8.4 Liệt kê danh sách sp 
-- (có năm sx model_year = 2090 hoặc 2026)
SELECT * FROM dbo.products WHERE model_year = 2090 OR model_year = 2026
--8.5 Liệt kê danh sách đơn hàng không có địa chỉ giao hàng ==> NULL
SELECT * FROM dbo.orders WHERE shipping_address IS NULL
-- Note: NULL không phải là giá trị --> ko thể so sánh = NULL
--8.6 Liệt kê danh sách đơn hàng có địa chỉ giao hàng ==> khác NULL
SELECT * FROM dbo.orders WHERE shipping_address IS NOT NULL
--8.7 Liệt kê đơn hàng bán ra từ ngày 2016-01-01 đến 2016-01-30
SELECT * FROM dbo.orders 
WHERE order_date > CAST('2016-01-01' AS DATE) AND order_date < CAST('2016-01-30' AS DATE)
ORDER BY order_date ASC
-- Ngoài cách dùng toán tử so sánh >< thì còn có cách khác BETWEEN
SELECT * FROM dbo.orders 
WHERE 
	order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-01-30' AS DATE)
--8.8 toán tử IN
SELECT * FROM dbo.products
-- Liệt kê danh sách sp có brand_id là 8 hoặc 9
SELECT * FROM dbo.products WHERE brand_id = 8 OR brand_id = 9
SELECT * FROM dbo.products WHERE brand_id IN (8,9) --> thuộc nhóm này
-- Liệt kê danh sách sp có brand_id khác 8 và 9
-- Danh sách toán tử so sánh: = <>, >, >=, <=
SELECT * FROM dbo.products WHERE brand_id <> 8 AND brand_id <> 9
SELECT * FROM dbo.products WHERE brand_id NOT IN (8,9) -- phủ định lại của IN

--8.9 -- LIKE
SELECt * FROM customers
--8.9.1 Liệt kê danh sách kh có số đuôi phone là '372'
SELECt * FROM customers WHERE phone LIKE '%372' -- Wildcard
--8.9.2 Liệt kê danh sách kh có số đầu phone là '0968'
SELECt * FROM customers WHERE phone LIKE '0968%'
--8.9.2 Liệt kê danh sách sp có chứa keyword: 'carbor'
SELECt * FROM products WHERE LOWER(product_name) LIKE '%carbon%'
SELECt * FROM products WHERE description LIKE '%FOR%'

--8.10 SELET có phân trang
SELECT product_id, product_name, price
FROM dbo.products
ORDER BY product_id ASC
OFFSET 0 ROWS  -- ví trị bắt đầu lấy
FETCH NEXT 10 ROWS ONLY; -- lấy bao nhiêu record bản ghi
--==> trang 1
SELECT product_id, product_name, price
FROM dbo.products
ORDER BY product_id ASC
OFFSET 10 ROWS  -- tịnh tiến điểm cần lấy lên 10
FETCH NEXT 10 ROWS ONLY;
--> trang 2

SELECT * FROM customers WHERE birthday LIKE '1990%'
SELECT MONTH(GETDATE())

SELECT  first_name, DATEDIFF(year, birthday, GETDATE()) As age FROM customers WHERE DATEDIFF(year, birthday, GETDATE()) BETWEEN 20 AND 30
ORDER BY DATEDIFF(year, birthday, GETDATE()) ASC