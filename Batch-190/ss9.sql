
select count(product_id) from products
-- group by cho phep loai bo gia tri trung lap
-- tinh toan tren nhom
SELECT state, count(customer_id)
FROM dbo.customers
WHERE state = 'CA' -- chay truoc khi group by chay
GROUP BY state

SELECT state, count(customer_id)
FROM dbo.customers
GROUP BY state
HAVING -- thực hiện sau  group by 
	state = 'CA'

SELECT shipping_city
FROM orders
GROUP BY shipping_city
ORDER BY shipping_city DESC

-- GROUP BY với các hàm tính toán
-- COUNT
SELECT
COUNT(product_id) AS total
FROM dbo.products WHERE model_year = 2016

SELECT 
SUM(quantity * price) AS amount
FROM order_items
WHERE order_id = 1

SELECT MIN(price) FROM products

SELECT MAX(price) FROM products

-- Lấy thông tin chi tiết các khách hàng có đã mua hàng > 5000 
SELECT * FROM customers WHERE customer_id IN 
(
SELECT 
customer_id
FROM orders
WHERE order_amount > 5000
GROUP BY customer_id
)

SELECT 
customer_id
FROM orders
WHERE order_amount > 5000
ORDER BY customer_id ASC


SELECT
    product_name,
    price
FROM
    dbo.products
WHERE
    price >= ANY (
        SELECT
            AVG (price)
        FROM
            dbo.products
        GROUP BY
            brand_id
    )

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    dbo.customers AS c WHERE EXISTS (SELECT
            customer_id
        FROM
            dbo.orders o
        WHERE  o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017)

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

SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b
    ON fruit_a = fruit_b;

SELECT
* 
FROM categories

SELECT
p.*,
c.category_name
FROM products AS p
INNER JOIN categories AS c ON c.category_id = p.category_id

SELECT p.*, 
		b.brand_name, b.description AS band_desc,
		c.category_name, c.description AS category_desc
FROM products AS p
LEFT JOIN brands AS b ON b.brand_id = p.brand_id
LEFT JOIN categories AS c ON c.category_id = p.category_id

SELECT
	c.*,
	 p.*
FROM categories AS c
FULL JOIN products AS p ON c.category_id = p.category_id