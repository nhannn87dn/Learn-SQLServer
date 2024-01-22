--1. Hiển thị tất cả các sản phẩm cùng với tên danh mục (category_name).
SELECT 
	p.*,--tất cả các cột của products
	c.category_name
FROM 
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id

select * from categories
--3. Hiển thị tất cả các sản phẩm cùng với thông tin chi tiết của categories và brands

SELECT 
	p.product_id,
	p.product_name,
	p.model_year,
	p.price,
	p.description AS product_description,
	c.category_id AS cat_id,
	c.category_name,
	c.description AS c_description,
	b.brand_id AS bid,
	b.brand_name,
	b.description AS brand_description
FROM dbo.products AS p
LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id
lEFT JOIN dbo.brands AS b ON b.brand_id = p.brand_id

-- 4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
--Cach 1: Sub query
SELECT 
*
FROM 
	dbo.products
WHERE product_id IN (select product_id from stocks WHERE quantity <= 5)

--Cach 2:
SELECT 
*
FROM 
	dbo.stocks AS s
LEFT JOIN 
	dbo.products AS p ON p.product_id = s.product_id
WHERE s.quantity <= 5



select * from stocks WHERE quantity <= 5

--5. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer.
SELECT 
	*
FROM orders AS o
LEFT JOIN 
	customers AS c ON c.customer_id = o.customer_id

--8. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục
SELECT 
	c.category_id,
	c.category_name,
	COUNT(p.product_id) AS numberProduct
FROM categories AS c
INNER JOIN  
	products AS p ON p.category_id = c.category_id
GROUP BY
	c.category_id,
	c.category_name
ORDER BY 
	c.category_id ASC;
