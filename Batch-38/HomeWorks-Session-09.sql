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

