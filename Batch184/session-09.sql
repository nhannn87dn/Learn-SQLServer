-- 1.Group by voi WHERE
SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    dbo.orders
WHERE
	customer_id <= 10
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

---
SELECT * FROM dbo.orders

--.2 GROUp BY with NULL
SELECT shipping_city
FROM orders
GROUP BY shipping_city
ORDER BY shipping_city DESC

--3. GROUP BY với ALL

SELECT 
	order_id, 
	customer_id, 
	SUM(order_amount) AS TotalAmount
FROM orders
GROUP BY ALL 
	order_id, 
	customer_id
ORDER BY
	customer_id

--4. GROUP BY với HAVINF
SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    dbo.orders
WHERE
	customer_id <= 10 --WHERE lọc trước  khi GROUP BY
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING  -- Lọc  sau khi đã GROUP BY rồi
	YEAR (order_date) > 2017
ORDER BY
    customer_id;

--5. GROUPING SETs
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            i.quantity * i.price * (1 - i.discount)
        ),
        0
    ) sales INTO dbo.sales_summary
FROM
    dbo.order_items i
INNER JOIN dbo.products p ON p.product_id = i.product_id
INNER JOIN dbo.brands b ON b.brand_id = p.brand_id
INNER JOIN dbo.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

SELECT * FROM dbo.sales_summary
---TH1: NHÓM doanh số theo brand và category
SELECT
	brand,
	category,
	SUM(sales) AS total
FROM dbo.sales_summary
GROUP BY
	brand,
	category
ORDER BY
    brand,
    category;
--TH2: Thống kế doanh số theo brand thôi
SELECT
	brand,
	SUM(sales) AS total
FROM dbo.sales_summary
GROUP BY
	brand
ORDER BY
    brand
-- TH3. Thống kê doanh số bán ra theo Ngành hàng cateogry
SELECT
	category,
	SUM(sales) AS total
FROM dbo.sales_summary
GROUP BY
	category
ORDER BY
    category

-- TH4: Thống kê doanh số bán hàng từ trước đến nay (tức ko nhóm thằng nào cả)
SELECT
    SUM (sales) sales
FROM
    dbo.sales_summary;
--KẾT LUẬN
--GROUPING SET giúp thực hiện 4 TH trên chỉ trong 1 câu lệnh truy vấn
-- NHƯ SAU
SELECT
	brand,
	category,
	SUM (sales) sales
FROM
	dbo.sales_summary
GROUP BY
	GROUPING SETS (
		(brand, category), -- => TH 1
		(brand),  -- => TH 2
		(category),  -- => TH 13
		()  -- => TH 4
	)
ORDER BY
	brand,
	category;

--Phân tích kết quả
-- brand - category
-- NULL  - NULL		==> TH4 (7689115.0000)
-- NULL  - (NOT NULL) ==> TH4 theo category
-- (NOT NULL)  - NULL ==> TH2 theo brand
-- (NOT NULL)  - (NOT NULL) ==> TH1 theo cả brand và category

--GROUPING SET WITH CUBE

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    CUBE(brand, category)
ORDER BY
	brand,
	category;

-- 6. GROUP BY WITH Aggregate Function
--COUNT
SELECT * FROM dbo.products
--ex1: thống kê số lượng sản phẩm theo năm sản xuất
SELECT
	model_year,
	COUNT(product_id) AS countProduct -- thông thường count trên primary key
FROM
	dbo.products
GROUP BY
	model_year
ORDER BY model_year

--SUM
--ex2: Thống kê tổng tiền theo đơn hàng
SELECT * FROM dbo.order_items
SELECT 
	order_id,
	SUM(quantity * price) as total
FROM 
	dbo.order_items
GROUP BY
	order_id
ORDER BY order_id
--hay đơn giản
SELECT SUM( 4 + 6) as tinhTong

--MIN
--tìm giá nhỏ nhất trong các giá bán của product
SELECT MIN(price) FROM dbo.products
--MAX
--tìm giá lớn nhất trong các giá bán của product
SELECT MAX(price) FROM dbo.products

--======================================
--  Sub Query
--======================================
--  Sub Query là khái niệm các câu lệnh truy vấn lồng vào nhau
--ex1: Lấy thông tin danh mục ngàng hàng KÈM số lượng sản phẩm thuộc ngành hàng đó

--Step1: Đếm số lượng sp theo nghàng hàng có cateogory_id =6
SELECT
	COUNT(product_id)
FROM dbo.products
WHERE category_id = 6
-- giữa cateogories và products có quan hệ khóa chính khóa ngoại với categoty_id
SELECT
	c.*,
	(SELECT COUNT(product_id) FROM dbo.products AS p WHERE c.category_id = p.category_id) AS countProducts
FROM dbo.categories AS c
--KẾT LUẬN: SELECT nằm bên trong SELECT ==> gọi đó là subquery


--===================== JOIN ===================
--Tạo bảng a
CREATE TABLE basket_a (
    a INT PRIMARY KEY,
    fruit_a VARCHAR (50) NOT NULL
);
--Tạo bảng b
CREATE TABLE basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR (50) NOT NULL
);
--Chèn dữ liệu vào bảng a
INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');
--Chèn dữ liệu vào bảng b
INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');


SELECT * FROM basket_a
SELECT * FROM basket_b

SELECT 
	a, fruit_a,
	b, fruit_b
FROM basket_a
INNER JOIN basket_b ON fruit_a = fruit_b

--JOINS: INNER JOIN, OUTER JOIN, SEFT JOIN
--INNER JOIN: trả về các records CHUNG (nhiều table đều có) từ các table

--OUTER JOIN: chia làm 2 loại: LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN
-- Viết gọn lại : LEFT JOIN, RIGHT JOIN, FULL JOIN

-- VÍ Dụ có 2 table A _ B

--LEFT JOIN: Trả về ALL các records của A, 
-- nó tìm tương ứng bên B, nếu có thì đưa vào, còn ko thì NULL
SELECT 
	a, fruit_a,
	b, fruit_b
FROM basket_a
LEFT JOIN basket_b ON fruit_a = fruit_b

--RIGHT JOIN: ngược lại với LEFT JOIN
SELECT 
	a, fruit_a,
	b, fruit_b
FROM basket_a
RIGHT JOIN basket_b ON fruit_a = fruit_b

--FULL JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b 
    ON fruit_a = fruit_b;

-- SEFT JOIN quan hệ với chính nó
SELECT * FROM dbo.staffs

SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    dbo.staffs e
LEFT JOIN dbo.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;

---=============== CTE --------------
WITH cte_sales_amounts (staff, sales, year) 
AS 
(SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * price * (1 - discount)),
        YEAR(order_date)
    FROM    
        dbo.orders o
    INNER JOIN dbo.order_items i ON i.order_id = o.order_id
    INNER JOIN dbo.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)
SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

--SUMMARY
--- GROUP BY với hAVING
--- GROUP BY với COUNT, SUM, MIN, MAX
-- CÁC ToÁN TỦ JOINs, UINON, INTERSECT, EXCEPT
-- Ví dụ về JOIn
SELECT
	p.*,
	c.category_name
FROM
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id
