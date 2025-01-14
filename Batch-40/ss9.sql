SELECT * FROM order_items
--TInh  Tong tien cua moi don

SELECT 
	order_id,
	SUM(quantity * price) as amount
FROM 
	order_items
GROUP BY -- nhóm lại bởi một hoặc nhiều trường nào đó
	order_id
ORDER BY order_id
-- GROUP BY là một lệnh đề nhóm một trường đó thành 1 nhóm
-- Loại bỏ giá trị trùng lặp
-- Cho phép tính toán trên nhóm đó: SUM, COUNT, MIN, MAX

-- Ví dụ: Tính số lượng sản phẩm có trong mỗi đơn hàng
SELECT
	order_id,
	COUNT(order_id) AS totalItem
FROM order_items
GROUP BY
	order_id
ORDER BY order_id ASC

-- Ví dụ: Tìm xem sp nào có giá bán thấp nhất trong mỗi đơn hàng
SELECT 
	order_id,
	product_id,
	MIN(price) AS minPrice
FROM order_items
GROUP BY order_id, product_id
ORDER BY order_id

-- GROUO BY với HAVING
--Ví dụ: Liệt kê các đơn hàng có tổng tiền mua hàng > 11.000

SELECT 
	order_id,
	SUM(quantity * price) as amount
FROM 
	order_items
GROUP BY -- nhóm lại bởi một hoặc nhiều trường nào đó
	order_id
HAVING -- Lọc lại kết quả theo một điều kiện nào đó, sau khi GROUP BY
	SUM(quantity * price) > 11000 -- điều kiện lấy
ORDER BY order_id

-- GROUP BY với WHERE
SELECT * FROM products
-- Liệt kê xem có bao nhiêu mức chiết khấu từ cho các sản phẩm 2016 - 2018
SELECT
	discount,
	COUNT(product_id) AS total
FROM products
WHERE model_year BETWEEN 2016 AND 2018 -- lọc trước khi đem đi GROUP BY
GROUP BY discount
HAVING COUNT(product_id) > 50 -- lọc sau khi GROUP BY
ORDER BY discount ASC

-- COUNT(*) trả về tổng số bản ghi của một table theo điều kiện nào đó.
SELECT COUNT(*) AS totalRecords FROM products -- ko có điều kiện
--Đếm xem bao nhiêu sp có model year = 2016  --> có điều kiện
SELECT COUNT(*) AS totalRecords FROM products WHERE model_year = 2016

--- SUB QUERY
-- Các câu lệnh query (sELECT) nó lồng vào nhau
--Ví dụ: Lấy thông tin đơn hàng của tất cả khách hàng ở New York


SELECT * FROM orders 
WHERE customer_id IN (SELECT customer_id FROM customers WHERE city = 'New York')

SELECT * FROM orders 
WHERE customer_id = 16

SELECT * FROM products WHERE model_year IN (2016, 2018)
-- Liệt kê sp có năm sản xuất 2016 và 2018

-- JOIN
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

SELECt * FROM basket_a
SELECt * FROM basket_b

SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM basket_a INNER JOIN basket_b
ON fruit_a = fruit_b -- điều kiện kết hợp

-- LEFT JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a -- bảng bên trái
LEFT JOIN 
basket_b -- bảng bên phải
   ON fruit_a = fruit_b;

SELECT
    b,
    fruit_b,
	a,
    fruit_a
FROM
    basket_b -- bảng bên trái
FULL JOIN 
basket_a -- bảng bên phải
   ON fruit_a = fruit_b;

--ÁP dụng Left JOIN
SELECT 
	 p.product_id,
	 p.product_name,
	 c.category_name,
	 b.brand_name
FROM products AS p
LEFT JOIN categories AS c
	ON p.category_id = c.category_id
LEFT JOIN brands AS b ON b.brand_id = p.brand_id

SELECT * FROM products
UPDATE products SET category_id = 8 WHERE product_id = 321
SELECT * FROM categories

SELECT * FROM products
LEFT JOIN stocks ON quantity <= 5

SELECT * FROM stocks
LEFT JOIN products ON stocks.product_id = products.product_id
WHERE stocks.quantity <= 5


SELECT 
	s.staff_id,
	s.first_name,
	SUM(oI.quantity*oI.price) AS total_amount
FROM orders AS o
LEFT JOIN staffs AS s
ON o.staff_id = s.staff_id
LEFT JOIN order_items AS oI
ON o.order_id = oI.order_id
WHERE o.order_status = 4
GROUP BY s.staff_id, s.first_name


SELECT * FROM products WHERE product_id NOT IN (
SELECT 
	oi.product_id 
FROM orders AS o
LEFT JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_status = 4
GROUP BY oi.product_id)



SELECT 
	oi.product_id 
FROM order_items AS oi
INNER JOIN orders AS o ON o.order_id = oi.order_id
WHERE o.order_status = 4 AND oi.product_id = 1
GROUP BY oi.product_id
ORDER BY oi.product_id


-- Truy vấn và tạo bảng ảo
WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT
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
-- Câu lệnh SELECT này phải thực hiện đồng thời với câu lệnh trên.
SELECT
    staff,
    sales,
	year
FROM
    cte_sales_amounts
WHERE
    year = 2018;