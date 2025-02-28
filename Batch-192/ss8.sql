SELECT * FROM categories
-- 1. SELECT Không có (without) FROM
SELECT GETDATE() --lấy ngày giờ hiện tại -- date function
SELECT LOWER('SQL Tutorial is FUN!'); --string function

-- 2. Lấy tất cả dữ liệu của 1 table
-- Dấu * ==> lấy tất cả các cột của một table
SELECT * FROM products

--3. Chỉ lấy một số cột cần thiết
SELECT 
	product_id, 
	product_name, --tên sản phẩm 
	price --giá sản phẩm
FROM 
	products

--4. SELECT với biểu thức
SELECT 4 + 4 -- biểu thức toán học
SELECT 'Hello' + ' ' + 'World' -- nối chuỗi
SELECt * FROM staffs

UPDATE 
	products 
SET 
	discount = discount - 1 -- biểu thức
WHERE 
	product_id = 1

SELECT
	staff_id,
	first_name + ' ' + last_name AS full_name, -- AS dùng để đặt tên cho cột
	email,
	phone
FROM
	staffs

-- 5. SELECT với mệnh đề DISTINCT
-- YC: Liệt kê danh sách các bang đang có trong dữ liệu khách hàng
SELECT 
	DISTINCT state -- Loại bỏ giá trị trùng lặp của cột state
FROM customers

--6. SELECT với mệnh đề TOP & TOP PERCENT
-- Y/c: Lấy ra 10 dòng đầu tiên trong dữ liệu khách hàng -customers
SELECT TOP 10 -- 10 dòng đầu
	* -- lấy tất cả các cột
FROM
	customers

-- Y/c Lấy 5% dữ liệu đầu tiên của khách hàng
SELECT TOP 5 PERCENT -- 10 dòng đầu
	* -- lấy tất cả các cột
FROM
	customers

--7. SELECT với mệnh đề WITH TIES

CREATE TABLE demo_product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);
GO
INSERT INTO demo_product (ProductID, ProductName, Price) VALUES
(1, 'Product A', 100),
(2, 'Product B', 200),
(3, 'Product C', 300),
(4, 'Product D', 300),
(5, 'Product E', 300),
(6, 'Product F', 400),
(7, 'Product G', 500);

SELECT * FROM demo_product
--Y/c Liệt kê TOP 3 sản phẩm theo giá
SELECT TOP 3 WITH TIES
	*
FROM demo_product
ORDER BY price

--8. SELECT với ORDER BY -- Sắp xếp theo một trật tự nào đó
--Y/c: Sắp xếp danh sách sản phẩm theo giá tăng dần
SELECT * FROM products
ORDER BY price ASC
--Y/c: Sắp xếp danh sách sản phẩm tên tăng dần, giá giảm dần
SELECT * FROM products
ORDER BY 
	product_name ASC, --ASC (ascending) tăng dần
	price DESC --(descending) giảm dần

--9. SELECT với mệnh đề WHERE
-- WHERE xác định phạm vi cần lấy		trong SELECT
-- WHERE xác định phạm vi cần thay đổi	trong UPDATE
-- WHERE xác định phạm vi cần xóa		trong DELETE

--9.1 Liệt kê danh sách sản phẩm có năm SX (model_year) =  2018
SELECT
	*
FROM products
WHERE model_year = 2018 -- Toán tử so sánh =

--9.2 Liệt kê danh sách sản phẩm có năm SX (model_year) >  2022
SELECT
	*
FROM products
WHERE model_year > 2022
ORDER BY model_year ASC
	
-- 9.3 Liệt kê danh sách sản phẩm có năm SX (model_year) >  2022 VÀ thuộc danh
-- mục sản phẩm (category_id) = 3.
SELECT
	*
FROM products
WHERE model_year > 2022 AND category_id = 3 -- toán tử AND
ORDER BY model_year ASC
--9.4 Liệt kê danh sách sản phẩm có năm SX (model_year) = 2025 HOẶC 2028
SELECT
	*
FROM products
WHERE model_year = 2025 OR model_year = 2028 -- toán tử OR
ORDER BY model_year ASC

SELECT
	*
FROM products
WHERE model_year IN (2025, 2028) -- toán tử IN <==> OR
ORDER BY model_year ASC
-- Ngoài IN thì còn NOT IN --> Phủ định lại = ngược lại
SELECT
	*
FROM products
WHERE model_year NOT IN (2025, 2028) -- toán tử IN <==> OR
ORDER BY model_year ASC

--9.5 Liệt kê danh sách đơn hàng bán ra từ 01-01-2016 đến 30-01-2016
SELECT 
	*
FROm orders
WHERE order_date >= CAST('2016-01-01' AS DATE) 
	AND order_date <= CAST('2016-01-30' AS DATE)

SELECT 
	*
FROm orders
WHERE order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-01-30' AS DATE)

--9.6 Liệt kê những đơn hàng không có địa chỉ giao hàng (shipping_address)
SELECT * FROM orders WHERE shipping_address IS NULL 
/*
(NULL tức ko có giá trị) ==> ko thể shipping_address = NULL
*/

--10. SELECT với toán tử LIKE
--10.1 Liệt kê danh sách khách hàng có số đuôi điện thoại là 278
SELECt * FROM customers
WHERE phone LIKE '%278' 
--> % đại diện cho bất kỳ ký tự nào ở đầu, chỉ cần có 278 ở cuối chuỗi.

--10.2 Liệt kê danh sách khách hàng có số đầu là 098
SELECt * FROM customers
WHERE phone LIKE '098%'
--10.3 Liệt kê danh sách khách hàng có số ĐT chứa 3 số 108
SELECt * FROM customers
WHERE phone LIKE '%108%'
--10.3 Liệt kê danh sách sản phẩm có tên chứa kí tự: 'bike'
SELECt * FROM products
WHERE product_name LIKE '%bike%'


--11. Phân trang

SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
	product_id 
OFFSET 20 ROWS -- vị trí bắt đầu lấy
FETCH NEXT 20 ROWS ONLY; -- FETCH NEXT --> số dòng cần lấy

-- OFFSET 0, FETCH NEXT 20 --> page 1 --> sp từ 0 - 20
-- OFFSET 20, FETCH NEXT 20 --> page 2 -->  sp tư 21 - 40