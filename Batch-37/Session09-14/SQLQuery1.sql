SELECT 
  discount, 
  price,
  COUNT(product_id) AS Total --- Đếm dựa vào ID và đặt tên là Total
FROM products
WHERE price > 5000
GROUP BY discount, price
HAVING COUNT(product_id) >=2
ORDER BY discount ASC


SELECT shipping_city
FROM orders
GROUP BY shipping_city 
ORDER BY shipping_city DESC


SELECT order_id, customer_id, SUM(order_amount) AS TotalAmount
FROM orders
GROUP BY ALL order_id, customer_id
ORDER BY customer_id ASC


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

	select * from [dbo].[sales_summary]
-- nhóm theo brand, category
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    brand,
    category
ORDER BY
    brand,
    category;
--chỉ nhóm theo brand
SELECT
    brand,  
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    brand
ORDER BY
    brand

--chỉ nhóm theo category
SELECT
    category,  
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    category
ORDER BY
    category

SELECT
    SUM (sales) sales
FROM
    dbo.sales_summary;


SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    brand,
    category
UNION ALL
SELECT
    brand,
    NULL,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    brand
UNION ALL
SELECT
    NULL,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    category
UNION ALL
SELECT
    NULL,
    NULL,
    SUM (sales)
FROM
    dbo.sales_summary
ORDER BY brand, category;


SELECT
	brand,
	category,
	SUM (sales) sales
FROM
	dbo.sales_summary
GROUP BY
	GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
	)
ORDER BY
	brand,
	category;

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

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    ROLLUP(brand, category);

--GROUP BY với MIN
select * from products WHERE category_id = 1 ORDER BY price ASC

-- Tìm ra sản phẩm nào có giá bán thấp nhất của mỗi danh mục
select * from categories

select 
category_id,
min(price) as minPrice
from products
group by category_id

-- Tìm ra sản phẩm nào có giá bán cao nhất của mỗi danh mục
select 
category_id,
max(price) as minPrice
from products
group by category_id

--Liệt kê danh sách khách hàng (tên, phone), có tổng giá trị đơn hàng hàng > 20000
select * from orders

--1.
select 
	customer_id
	--sum(order_amount) as Total
FROm orders
group by
 customer_id
HAVING 
	sum(order_amount) > 20000

select * from customers WHERE customer_id = 1 OR customer_id = 2
select * from customers WHERE customer_id IN (1,2)

select first_name, phone from customers WHERE customer_id IN (
select 
	customer_id
FROm orders
group by
 customer_id
HAVING 
	sum(order_amount) > 20000
	)

--Lấy thông tin đơn hàng của tất cả khách hàng ở New York
select * from orders WHERE customer_id IN (select customer_id from customers WHERE city = 'New York')

SELECT
    product_name,
    price
FROM
    dbo.products
WHERE
    -- Nếu price >= với bất kì giá trị nào
    -- trong kết quả SELECT thì WHERE thực thi
    price >= ANY (
        SELECT
            AVG (price)
        FROM
            products
        GROUP BY
            brand_id
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
        AND YEAR (order_date) = 2024
    )
ORDER BY
    first_name,
    last_name;

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
--Liệt kê ra những trái cây mà cả 2 giỏ đều có

select a,
	fruit_a,
	b,
	fruit_b
FROM basket_a
INNER JOIN basket_b ON fruit_a = fruit_b

select 
	 p.product_name, 
	 p.price,
	 p.category_id
from 
	products As p
INNER JOIN categories As c
	ON c.category_id = p.category_id


	--LEFT JOIN
	SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b 
   ON fruit_a = fruit_b;

--RIGHT JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
RIGHT JOIN basket_b 
   ON fruit_a = fruit_b;

 -- Đảo vế
SELECT
    b,
    fruit_b,
    a,
    fruit_a
FROM
    basket_b
LEFT JOIN basket_a 
   ON fruit_a = fruit_b;

--FULL JOIN
SELECT
    b,
    fruit_b,
    a,
    fruit_a
FROM
    basket_b
FULL JOIN basket_a 
   ON fruit_a = fruit_b;

-- Seft JOIN
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    dbo.staffs e
LEFT JOIN dbo.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;

select 
	o.order_id, 
	c.customer_id,
	c.first_name,
	c.last_name,
	o.order_amount
from orders AS o
left JOIN customers AS c
	ON c.customer_id = o.customer_id


--CTE

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

SELECT * FROM cte_sales_amounts WHERE year = 2018

select * FROM basket_a
UNION 
select * FROM basket_b

SELECT
    first_name, phone
FROM dbo.staffs
UNION 
SELECT
    first_name, last_name
FROM
    dbo.customers;
-- chuyen 100$ tu a --> b
nguyen van a 
id - blance 
1 - 250


nguyen van b
id - blance 
2 - 0
--1.tru tien a
UPDATE bank SET blance = blance - 100 WHERE id = 1
--2. cong tien ong b
UPDATE bank SET blance = blance + 100 WHERE id = 2

CREATE TABLE bank
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20),
    balance DECIMAL(10,2)
)
--Ghi log giao dich
CREATE TABLE bank_log
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    note NVARCHAR(500)
)

--chèn dữ liệu ban đầu cho a và b
INSERT bank
    (name,balance)
VALUES
    ('a', 250),
    ('b', 0)

SET XACT_ABORT ON
BEGIN TRANSACTION;
--b1. Trừ tiền người a: 50
UPDATE bank SET balance = balance - 50 WHERE name = 'a';
--b2. Ghi log lịch sử giao dịch
INSERT bank_log
    (note)
VALUES
    ('Chuyen tien tu a sang b, 50USD')
--b3. Cộng tiền người b: 50
UPDATE bank SET balance = balance + 50 WHERE name = 'b';
--b4. Ghi log lịch sử giao dịch
INSERT bank_log
    (id, note)
VALUES
    (2, 'Nhan tien tu nguoi a, 50USD');
COMMIT TRANSACTION;


SELECT *
FROM bank

SELECT *
FROM bank_log

DECLARE @xact_abort_status VARCHAR(3);
SET @xact_abort_status = CASE WHEN (64 & @@OPTIONS) = 64 THEN 'ON' ELSE 'OFF' END;
SELECT @xact_abort_status AS XACT_ABORT_Status;


-- Hóa đơn
CREATE TABLE invoices (
  id int IDENTITY(1,1) PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);
-- Chi tiết các mục ghi vào hóa đơn
CREATE TABLE invoice_items (
  id int IDENTITY(1,1),
  invoice_id int NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(18, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id),
  FOREIGN KEY (invoice_id) REFERENCES invoices (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

select * from invoices
select * from invoice_items

-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
INSERT INTO dbo.invoices (customer_id, total)
VALUES (100, 0);
-- Thêm vào invoice_items
 INSERT INTO dbo.invoice_items (id, invoice_id, item_name, amount, tax)
VALUES (3, 1, 'Keyboard v2 ', 70, 0.08),
       (4, 1, 'Mouse v2 ', 50, 0.08);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT


--Giả lập hiện tượng Lock trong SQL Serever
BEGIN TRAN

UPDATE bank SET balance = 500 
WHERE name = 'a'