--Group by voi WHERE
select * from products WHERE price > 2000

SELECT 
  discount, 
  price,
  COUNT(product_id) AS Total --- Đếm dựa vào ID và đặt tên là Total
FROM 
	products
WHERE 
	price > 2000
GROUP BY 
	discount,
	price
ORDER BY 
	discount ASC

--group by with NULL
select * from orders

SELECT 
	shipping_city
FROM 
	orders
GROUP BY 
	shipping_city
ORDER BY 
	shipping_city


SELECT 
	order_id, 
	customer_id, 
	SUM(order_amount) AS TotalAmount
FROM orders
GROUP BY ALL 
	order_id, 
	customer_id
HAVING
	SUM(order_amount) > 15000

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

SELECT * FROM sales_summary


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

SELECT
    brand,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    brand
ORDER BY
    brand;

SELECT
    category,
    SUM (sales) sales
FROM
    dbo.sales_summary
GROUP BY
    category
ORDER BY
    category;

SELECT
    SUM (sales) sales
FROM
    dbo.sales_summary;


------

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

----
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
--
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

-- Đếm số lượng sản phẩm theo từng loại giá
SELECT
    price,
    COUNT(product_id) AS 'NumberOfProducts'
FROM products
GROUP BY price

SELECT * FROM products WHERE price = 149.99


-- Tính tổng số lượng tồn kho theo từng nhóm category_id
SELECT
    customer_id,
	SUM(order_amount) AS oAmount
FROM orders
GROUP BY 
	customer_id
ORDER BY 
	customer_id ASC

-- Hiển thị sản phẩm có giá thấp nhất theo từng nhóm category_id
select * from products
SELECT
    category_id, 
    MIN(price) AS 'min_price'
FROM products
GROUP BY category_id


SELECT
    category_id, 
    MAX(price) AS 'max_price'
FROM products
GROUP BY category_id

SELECT
	*
FROM
	categories

SELECT
  c.*, (SELECT COUNT(product_id) FROM dbo.products AS P WHERE p.category_id = c.category_id) AS 'number_product'
FROM dbo.categories AS c

SELECT * FROM dbo.products WHERE category_id = 1

-- Ví dụ, bạn có thể sử dụng subquery để tìm tất cả 
--các khách hàng có đơn hàng với tổng giá trị lớn hơn một ngưỡng nào đó
--Lấy ra danh sách khách hàng đã mua hàng với mức tiền > 10000

SELECT 
 * 
 FROM 
	dbo.customers
WHERE
	customer_id IN (
		SELECT
	customer_id
FROM 
	orders
GROUP BY
	customer_id
HAVING 
	SUM(order_amount) > 10000
	)


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
            dbo.products
        GROUP BY
            brand_id
    )

SELECT
            AVG (price)
        FROM
            dbo.products
        GROUP BY
            brand_id
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
				
--JOIN
SELECT
	p.product_id,
	p.product_name,
	p.price,
	c.category_name
FROM
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id


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

--INNER JOIN
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
INNER JOIN basket_b
    ON fruit_a = fruit_b;

SELECT
	o.order_id,
	o.customer_id,
	c.first_name,
	o.order_amount
FROM 
	orders AS o
LEFT JOIN
	customers AS c ON c.customer_id = o.customer_id


SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b 
    ON fruit_a = fruit_b;

SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    dbo.staffs e
LEFT JOIN dbo.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;

-- Truy vấn và tạo bảng ảo
WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * price * (1 - discount)),
        YEAR(order_date)
    FROM    
        dbo.orders AS o
    INNER JOIN dbo.order_items AS i ON i.order_id = o.order_id
    INNER JOIN dbo.staffs AS s ON s.staff_id = o.staff_id
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

SELECT first_name, last_name FROM customers
UNION
SELECT first_name, last_name FROM staffs