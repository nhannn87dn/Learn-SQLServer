SELECT * FROM customers
-- Liệt kê danh sách các bang kèm tổng số khách hàng của mỗi bang.

SELECT
DISTINCT state
FROM customers --> ko thể tính toán trên nhóm

SELECT
	state,
	COUNT(customer_id) -- sử dụng các hàm Aggregate Functions với GROUP BY
FROM 
	customers
GROUP BY -- nhóm lại bởi một hoặc nhiều trường nào đó
	state --> trên SELECT đang liệt kê trường nào, thì GROUP BY liệt kê
			-- bấy nhiêu
--1. Nhóm lại một nhóm bởi 1 hoặc nhiều trường
--2. Nó cho phép tính toán bằng các hàm Aggregate Functions trên nhóm đó

-- Ví dụ 2 về GROUP BY với SUM



SELECT 
	order_id AS id,
	SUM(quantity * price) AS amount
FROM order_items
GROUP BY 
	order_id
ORDER BY order_id


-- Ví dụ 3 về GROUP BY với MIN or MAX
SELECT
	MAX(price) -- tìm giá trị nhỏ nhất của cột price
FROM products
	
-- Ví dụ 4: Đến tổng số lượng sản phẩm có trong  kho hàng
SELECT COUNT(product_id) FROM products

-- GROUP BY với WHERE

SELECT * FROM products
--Y/c: Kiệt danh sách các năm sản xuất và số lượng sản phẩm ứng với
-- từng năm của các năm >= 2020
SELECT 
	model_year,
	COUNT(product_id) AS total
FROM products
WHERE
	model_year >= 2020 --> Lọc dữ liệu trước khi đem GROUP
GROUP BY
	model_year
HAVING 
	COUNT(product_id) > 5 
-- GROUP BY với HAVING ==> lọc bớt dữ liệu sau khi GROUP
--> chỉ lấy những giá trị total > 5

-- GROUP BY với NULL

SELECT shipping_city
FROM orders
GROUP BY shipping_city
ORDER BY shipping_city DESC -- sử dụng order by để sắp xếp giá trị null
-- xuất hiện đầu hay cuối

--SUB QUERY
--Y/c: tìm tất cả các khách hàng có đơn hàng với tổng giá trị 
-- lớn hơn > 11.000 USD


SELECT * FROM customers WHERE customer_id IN (
SELECT customer_id FROM orders 
WHERE customer_id IN (
SELECT 
	order_id
FROM order_items
GROUP BY 
	order_id
HAVING SUM(quantity * price) > 11000
)
)

-- Ví dụ: Lấy thông tin khách hàng, có đơn hàng mua vào năm 2017.


SELECT
    c.*
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


-- JOINs

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

--Áp dụng thực tế: Liệt danh sách thông tin chi tiết đơn hàng kèm tổng tiền của mỗi đơn
SELECT * FROM orders
SELECT
	o.order_id,
	o.order_date,
	o.shipping_address,
	SUM(oi.quantity * oi.price) as totalAmount
FROM order_items AS oi
INNER JOIN orders AS o ON o.order_id = oi.order_id
GROUP BY
	o.order_id,
	o.order_date,
	o.shipping_address
ORDER BY o.order_id

-- Muốn lấy thêm tên danh mục vào
SELECT 
	p.*,
	c.category_name,
	c.description AS category_description,
	c.category_id
FROM products AS p
INNER JOIN categories AS c ON c.category_id = p.category_id


SELECT 
	p.*,
	c.category_name,
	c.description AS category_description
FROM products AS p
LEFT JOIN categories AS c ON c.category_id = p.category_id

SELECT * FROM products

SELECT * FROM categories

UPDATE products SET category_id = 8 WHERE product_id = 321

SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b
   ON fruit_a = fruit_b;

