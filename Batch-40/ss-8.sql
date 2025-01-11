-- 1. Select without FROM
SELECT LEFT('International',5);

SELECT GETDATE();

-- 2. SELECT tất dữ liệu của một table
SELECT * FROM products

-- 3. SELECT các cột theo ý muốn
SELECT product_id, product_name, price FROM products

SELECT
	product_id, -- cột ID
	product_name, -- tên sản phẩm
	price -- giá sản phẩm
FROM
	products

-- 4. SELECT với một biểu thức + Đổi tên cột
SELECT 
	(first_name + ' ' + last_name) AS full_name -- fullname
FROM 
	customers
-- SQL sẽ tự nhận dạng được câu lệnh để biết Tong là tên bạn đặt 
-- khi không có ghi rõ là SELECT  4 + 6 AS Tong
SELECT  4 + 6 Tong

-- 5. SELECT với loại bỏ giá trị trùng lặp - DISTINCT
-- Tất cả các giạ trị của cột state bị trùng lặp
-- Bạn cần một danh sách mà không bị trùng lặp --> DISTINCT
-- DISTINCT ==> khử trùng lặp
SELECT DISTINCT
  state
FROM
	customers

-- 6. SELECT TOP và PERCENT
SELECT * FROM customers
-- customers có 1145 rows, chỉ muốn lấy 5 rows đầu tiên
SELECT
	TOP 5 * -- Lấy tất cả các cột của 5 dòng đầu tiên
	-- TOP 5 customer_id, firstame --> Lấy 2 cột của 5 dòng đầu tiên
FROM
	customers

SELECT 
	TOP 5 PERCENT * -- Lấy tất cả cột của 5% số dòng đầu tiên của bảng customer
FROM 
	customers

-- 7. SELECT với mệnh đề WITH TIES
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price DECIMAL(10, 2)
);

INSERT INTO Product (ProductID, ProductName, Price)
VALUES 
(1, 'Product A', 100),
(2, 'Product B', 200),
(3, 'Product C', 300),
(4, 'Product D', 300),
(5, 'Product E', 300),
(6, 'Product F', 400),
(7, 'Product G', 500);


SELECT 
	TOP 3 WITH TIES -- sẽ liệt kê ra tất cả các giạ trị = với dòng cuối cùng của TOP 3
    ProductID,
    ProductName,
    Price
FROM Product
ORDER BY Price DESC;


-- 8. SELECT với mệnh đề INTO
-- Lấy dữ liệu từ một table khác để tạo mới ==> Hay còn gọi Copy
SELECT * FROM brands
SELECT * FROM brands_backup
-- Bạn muốn tạo ra một table brands_backup và muốn có tất cả dữ liệu của brands
-- thì khi đó bạn cần sử dụng SELECT INTO
SELECT 
	* 
INTO brands_backup -- tên table tạo mới
FROM brands -- tên table cần lấy dữ liệu và cấu trúc bảng

-- 9. SELECT với mệnh đề WHERE
-- Các bạn có thể áp dụng WHERE cho cả lệnh UPDATE / DELETE
SELECT * FROM dbo.products
--9.1 Chỉ lấy những sản phẩm có model_year = 2020 ?
SELECT
	*
FROM
	products
WHERE
	model_year = 2020 -- SMALLINT ==> TOÁN TỬ SO SÁNH =
--9.2 Lấy những sản phẩm có model_year > 2020 ==> TOÁN TỬ SO SÁNH >
SELECT * FROM products WHERE model_year > 2020

-- 9.3 Lấy những sản phẩm có model_year > 2020 VÀ thuộc danh mục category_id = 4
-- VÀ - AND --> TOÁN TỬ LOGIC -- Thõa mãn tất cả các vế
SELECT * FROM products WHERE model_year > 2020 AND category_id = 4

-- 9.4 Lấy những sản phẩm có model_year = 2020 HOẶC model_year = 2026
-- HOẶC - OR --> TOÁN TỬ LOGIC -- Thõa mãn 1 trong các vế
SELECT * FROM products WHERE model_year = 2020 OR model_year = 2026

-- 9.5 TOÁN TỬ IS, THƯỜNG DÙNG TÌM GIÁ TRỊ NULL
SELECT * FROM orders WHERE shipping_city IS NULL -- Tìm dòng NULL
SELECT * FROM orders WHERE shipping_city IS NOT NULL -- Tìm dòng ko NULL

-- 9.6 WHERE với toán tử IN
-- Ví dụ: Lấy những sản phẩm có model_year = 2020 HOẶC model_year = 2026
SELECT * FROM products WHERE model_year IN (2022, 2026)
-- ==>	khớp với MỘT TRONG các giá trị trong ngoặc tròn ~ OR\

-- 9.7 WHERE với toán tử BETWEEN
-- Ví dụ: Tìm những khác hàng có ngày sinh nhật 
-- trong khoảng 01-01-2000 - 01-12-2001
SELECT * FROM customers 
WHERE birthday >= '2000-01-01' AND birthday <= '2001-12-01'
--Còn có thể sử dụng BETWEEN
SELECT * FROM customers 
WHERE birthday BETWEEN 
		CAST('2000-01-01' AS DATE) AND CAST('2000-12-01' AS DATE)
		-- Nên chuyển ngày tháng ở dạng chuỗi thành DATE với hàm CAST
		-- trong những truy vấn liên quan đến thời gian
SELECT CAST('01' AS INT) --> CAST để chuyển đổi kiễu dữ liệu
-- Ngoài ra còn có thêm hàm CONVERT()

-- 9.8 WHERE với toán tử LIKE
--Vd: Tìm những khác hàng có số đuôi ĐT là '553'
SELECT * FROm customers WHERE phone LIKE '%553' 
-- ko quan tâm các kí tự phía là gì, mà chỉ quan tâm kí tự kết thúc là 553.
--Ví dụ; Tìm những sản phẩm mà tên có chứa từ 'Truck'
SELECT * FROM products WHERE product_name LIKE '%Truck%'
/**
Sẽ khớp khi:
1. abc truck djhshdsj
2. truck jkfdfhdfhdjfh
3. fkjdjfkdjfdkfjd truck

*/

-- 10. SELECT với ORDER BY ---> sắp xếp dữ liệu
--VD: Lất tất cả sản phẩm theo model_year tăng dần
SELECT * FROM products 
ORDER BY 
	model_year ASC, -- tăng dần
	price DESC --> giảm dần
-- Có thể sắp xếp theo 1 hoặc nhiều trường một lần

-- 11. SELECT có phân trang
SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY product_id ASC
OFFSET 10 ROWS -- Dòng bắt đầu lấy
FETCH NEXT 10 ROWS ONLY; -- Số lượng dòng cần lấy
---?page = 1 ==> OFFSET 0 và FETCH NEXT 10
---?page = 2 ==> OFFSET 10 và FETCH NEXT 10