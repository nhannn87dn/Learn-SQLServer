---
--- Phần C: Truy vấn cơ bản
---
---31.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó
SELECT
	discount,
	COUNT(product_id) as count_product
FROM
	dbo.products
GROUP BY
	discount

-- 32.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó, sắp xếp theo số lượng giảm giá (discount) giảm dần
SELECT
	discount,
	COUNT(product_id) as count_product
FROM
	dbo.products
GROUP BY
	discount
ORDER BY
	COUNT(product_id) DESC

---33.Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau và số lượng sản phẩm có mức giảm giá (discount) đó, 
---sắp xếp theo số lượng giảm giá (discount) tăng dần, chỉ hiển thị các mức giảm giá (discount) có số lượng sản phẩm >= 5

SELECT
	discount,
	COUNT(product_id) as count_product
FROM
	dbo.products
GROUP BY
	discount
HAVING
	discount >= 5
ORDER BY
	COUNT(product_id) ASC

---34.Hiển thị xem có bao nhiêu mức tuổi khác nhau của khách hàng và số lượng khách hàng có mức tuổi đó, sắp xếp theo số lượng khách hàng tăng dần.
SELECT 
	DATEDIFF(year, birthday, GETDATE()) as age,
	count(customer_id) as count_customer
FROM
	dbo.customers
GROUP BY
	DATEDIFF(year, birthday, GETDATE())
ORDER BY
	count(customer_id) ASC


--- 36.Hiển thị số lượng đơn hàng theo từng ngày khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
SELECT
	order_date,
	COUNT(order_id) as count_order
FROM
	dbo.orders
GROUP BY
	order_date
ORDER BY
	COUNT(order_id) DESC