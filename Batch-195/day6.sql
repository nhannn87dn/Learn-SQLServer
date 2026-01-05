-- GROUP BY ?
SELECT * FROM products
-- Đếm xem có bao nhiêu sp đang khuyến mãi ?
SELECT 
 COUNT(product_id)
FROM 
	products WHERE discount > 0
-- Thống kê số lượng sp theo từng mức chiết khấu
SELECT 
	discount,
 COUNT(product_id) -- Chính hàm a
FROM 
	products WHERE discount > 0
GROUP BY discount
	-- Nhóm các giá trị trong một cột lại 1 nhóm và nó loại bỏ giá trị trùng lặp
	-- nó cho phép tính toán dựa trên nhóm (aggregate function): COUNT, SUM, MIN, MAX...

SELECT 
	order_id,
	SUM(quantity * price) AS amount
FROM 
order_items
GROUP BY order_id
ORDER BY order_id
	

SELECT shipping_city
FROM orders
GROUP BY shipping_city
ORDER BY shipping_city


-- Đếm số lượng sản phẩm theo từng loại giá
SELECT
    price,
    COUNT(product_id) AS 'NumberOfProducts'
FROM products
GROUP BY price


-- Hiển thị sản phẩm có giá thấp nhất theo từng nhóm category_id
SELECT
    product_id,
    MIN(price) AS 'min_price'
FROM products
GROUP BY category_id

--Liệt kê danh sách danh mục kèm số lượng sản phẩm có trong danh mục đó
SELECT
  c.*, (SELECT COUNT(product_id) FROM dbo.products AS P WHERE p.category_id = c.category_id) AS 'number_product'
FROM dbo.categories AS c


-- Liệt kê thông tin khách hàng mua hàng trong tháng 1-2016.

-- sub query
SELECT * FROM customers
WHERE customer_id IN (SELECT 
customer_id
FROM orders
WHERE order_date BETWEEN '2016-01-01' AND  '2016-01-30')



CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    is_active BIT NOT NULL DEFAULT 1
);


INSERT INTO users (email, password, is_active) VALUES
('user1@example.com', '123', 1),
('user2@example.com', '123', 0),
('admin@example.com', '123', 1);

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
        AND YEAR (order_date) = 2026
    )
ORDER BY
    first_name,
    last_name;


SELECT
            customer_id
        FROM
            dbo.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017


SELECT 
* 
FROM products
LEFT JOIN brands ON brands.brand_id = products.brand_id


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
    basket_a INNER JOIN basket_b ON fruit_a = fruit_b;


SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b
   ON fruit_a = fruit_b;