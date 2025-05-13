-- 1.  SELECT với mệnh đề GROUP BY,GROUP BY với HAVING
SELECT * FROM dbo.customers
---1.2 liệt kê danh sách các bang trong dữ liệu khách hàng
SELECT
	DISTINCT state
FROM dbo.customers
---1.3 Khử trùng lặp với GROUP BY
SELECT
	state
FROM dbo.customers
GROUP BY state
---1.3 Khi nào thì sử dụng GROUP BY
--1.3.1 Khi cần loại bỏ giá trị trùng lặp

SELECT 
	model_year,
	COUNT(product_id) -- dem tren nhom
FROM dbo.products
GROUP BY
	model_year
-- Tim nam san xuat lon nhat
select 
	order_id,
	SUM(quantity * price) AS total_amount
fROM order_items
WHERE order_id < 100
GROUP BY order_id
HAVING SUM(quantity * price) > 11000 --> lọc lại kết quả sau khi nhóm
--> Chỉ lấy những đơn có tổng tiền > 11.000

SELECT * FROM orders WHERE order_id = 1

SELECT 
	discount,
	COUNT(product_id)
FROM dbo.products
GROUP BY
	discount
ORDER BY discount

--Đếm tổng số records của một table
SELECT COUNT(product_id) as totalRecords FROM dbo.products
-- tìm giá nhỏ nhất
SELECT MIN(price) as minPrice FROM dbo.products
-- tìm giá lớn nhất
SELECT MAX(price) as maxPrice FROM dbo.products

--2. Sub Query
-- Lấy danh sách khách hàng có đơn hàng với tổng giá trị lớn hơn 12.000
SELECT 
	order_id,
	SUM(quantity * price)
FROM order_items
GROUP BY order_id
HAVING SUM(quantity * price) > 12000

SELECT 
	customer_id
FROM orders
WHERE order_amount > 12000

SELECT * FROM dbo.customers WHERE customer_id IN (
	SELECT 
		customer_id
	FROM orders
	WHERE order_amount > 12000
)


SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    dbo.customers c
WHERE
    EXISTS (
        -- Đi tìm những khách hàng mua hàng năm 2017
        SELECT
            customer_id
        FROM
            dbo.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;

SELECT * FROM orders WHERE customer_id = 75


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
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
INNER JOIN basket_b
    ON fruit_a = fruit_b;

SELECT * FROM categories
INSERT dbo.categories
(category_name, description)
VALUES
(N'new Categoroy',  N' new category description')
SELECt 
	category_id
FROM products
GROUP BY category_id

SELECT 
	p.product_id,
	p.product_name,
	p.price,
	p.description AS product_description,
	c.category_name,
	c.description AS category_description
FROM products AS p
INNER JOIN categories AS c ON c.category_id = p.category_id


SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a LEFT JOIN basket_b ON fruit_a = fruit_b;

	SELECT 
	p.product_id,
	p.product_name,
	p.price,
	p.description AS product_description,
	c.category_name,
	c.description AS category_description
FROM products AS p
LEFT JOIN categories AS c ON c.category_id = p.category_id

UPDATE products SET category_id = 9 WhERE product_id = 321

SELECT 
	p.*,
	c.category_name
FROM products AS p
LEFT JOIN categories AS c ON c.category_id = p.category_id

SELECT * FROM orders

SELECT * FROM products WHERE product_id NOT IN (
SELECT 
	oi.product_id
FROM order_items AS oi
INNER JOIN orders AS o ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY oi.product_id
)



/*
 |---------------------------------------xxxxxxxxxxxxxxxxxxxxxxxxx|
*/