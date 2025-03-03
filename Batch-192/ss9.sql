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