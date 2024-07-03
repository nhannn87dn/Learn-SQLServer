--4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5

SELECT 
 p.*,
 s.quantity
FROM dbo.products AS p
LEFT JOIN dbo.stocks AS s ON s.product_id = p.product_id
WHERE s.quantity <= 5
ORDER BY 
	s.quantity

-- Hiển thị tất cả các đơn hàng cùng với thông tin
--chi tiết khách hàng Customer

SELECT
	o.*,
	c.first_name AS customer_first_name,
	s.first_name AS staff_first_name
FROM dbo.orders AS o
INNER JOIN dbo.customers AS c ON c.customer_id = o.customer_id
LEFT JOIN dbo.staffs AS s ON s.staff_id = o.staff_id

-- 10. Hiển thị tất cả các sản phẩm được bán 
--trong khoảng từ ngày, đến ngày (2016-01-01 - 2016-01-30)
SELECT
	oi.product_id
FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi ON oi.order_id = o.order_id
INNER JOIN dbo.products AS p ON p.product_id = oi.product_id
WHERE 
	o.order_status = 4
	AND o.order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-01-30' AS DATE)  

--15. Tim san pham chua ban duoc.
--chua ban 43
SELECT * FROM dbo.products
WHERE product_id NOT IN (SELECT
	oi.product_id
FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi ON oi.order_id = o.order_id
INNER JOIN dbo.products AS p ON p.product_id = oi.product_id
WHERE 
o.order_status = 4 
GROUP BY 
	oi.product_id
)