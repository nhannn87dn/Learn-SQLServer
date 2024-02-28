---3.Hiển thị tất cả các sản phẩm cùng với thông tin chi tiết của categories và brands
SELECT
	*
FROM
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id
LEFT JOIN
	dbo.brands AS b ON b.brand_id = p.brand_id

---4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
--- Liên quan 2 table producs và stocks

SELECT 
	p.*,
	s.quantity AS stock_quantity
FROM
	dbo.products AS p
INNER JOIN
	dbo.stocks AS s ON s.product_id = p.product_id
WHERE
	s.quantity <=5

---8. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục
---C1. Dùng INNER JOIN + GROUP BY với lệnh COUNT

SELECT
	c.category_id,
	c.category_name,
	c.description,
	COUNT(p.product_id) as count_product
FROM
	dbo.categories as c
INNER JOIN
	dbo.products as p ON p.category_id = c.category_id
GROUP BY
	c.category_id,
	c.category_name,
	c.description
---C2.Dùng SubQuery với lệnh COUNT

SELECT
	c.category_id,
	c.category_name,
	c.description,
	(SELECT COUNT(*) FROM dbo.products as p WHERE c.category_id = p.category_id) AS count_product
FROM
	dbo.categories AS c

--- 10. Hiển thị tất cả các sản phẩm được bán trong khoảng từ ngày, đến ngày

SELECT
	oi.product_id,
	p.product_name,
	o.order_date
FROM
	dbo.order_items AS oi
INNER JOIN
	dbo.orders AS o ON o.order_id = oi.order_id
INNER JOIN
	dbo.products AS p ON p.product_id = oi.product_id
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'
ORDER BY
	p.product_id ASC


--- 10. Hiển thị tất cả các khách hàng mua hàng trong khoảng từ ngày, đến ngày
SELECT
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date
FROM
	dbo.orders AS o
INNER JOIN
	dbo.customers AS c ON c.customer_id = o.customer_id		
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'

--- 12. Hiển thị tất cả các khách hàng mua hàng (với tổng số tiền) trong khoảng từ ngày, đến ngày
--- Chúng ta không nên dựa vào trường order_amount ở bảng orders, mà tính toán dựa trên order_items

SELECT
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date,
	SUM((oi.price * (100 - oi.discount) / 100) * oi.quantity) AS total_amount
FROM
	dbo.orders AS o
INNER JOIN
	dbo.customers AS c ON c.customer_id = o.customer_id	
INNER JOIN 
	dbo.order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-30'
GROUP BY
	o.customer_id,
	c.first_name,
	c.last_name,
	o.order_date

---13. Hiển thị tất cả đơn hàng với tổng số tiền của đơn hàng đó
--- Chúng ta không nên dựa vào trường order_amount, mà tính toán dựa trên order_items
--- Để đảm bảo tính khách quan

SELECT
	o.order_id,
	SUM((oi.price * (100 - oi.discount) / 100) * oi.quantity) AS total_amount
FROM
	dbo.orders AS o
INNER JOIN
	dbo.order_items AS oi ON oi.order_id = o.order_id
GROUP BY
	o.order_id
ORDER BY
	o.order_id

---15. Hiển thị tất cả các sản phẩm không bán được
/*
Tất cả sản phẩm thì liên quan đến products
bán được hay không bán được thì liên quan đến order_items
*/
SELECT 
	p.*,
	oi.order_id
FROM
	dbo.products AS p
LEFT JOIN
	dbo.order_items AS oi ON oi.product_id = p.product_id
/*
Khi bạn chạy câu lệnh trên bạn sẽ thấy cột order_id có chứa những giá
trị NULL. Lí do nó phản ảnh đúng lý thuyết của LEFT JOIN (Canh bên trái là products. Phải ko khớp thì là NULL)
==> Những sản phẩm mà có cột order_id = NULL là những sản phẩm ko bán được
==> WHERE lại
*/
SELECT 
	p.*,
	oi.order_id
FROM
	dbo.products AS p
LEFT JOIN
	dbo.order_items AS oi ON oi.product_id = p.product_id
WHERE 
	oi.order_id IS NULL
---==> Đây là những sản phẩm không bán được.
---==> Ngược lại cho những sản phẩm bán được.