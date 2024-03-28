--SELECT
SELECT *
FROM orders
WHERE order_date BETWEEN '2016-01-01' AND '2016-03-01';




--GROUP BY

SELECT discount
FROM products
ORDER BY discount ASC

SELECT discount
FROM products
GROUP BY discount
ORDER BY discount ASC


SELECT 
  discount, 
  COUNT(product_id) AS Total 
GROUP BY discount
ORDER BY discount ASC


SELECT 
  customer_id, 
  SUM(order_amount) AS Total
FROM orders
GROUP BY customer_id
ORDER BY customer_id ASC


SELECT 
  c.first_name || ' ' || c.last_name AS full_name, 
  SUM(o.order_amount) AS total
FROM orders AS o
INNER JOIN customers AS c USING (customer_id)
GROUP BY full_name
ORDER BY total ASC



SELECT 
  c.first_name || ' ' || c.last_name AS full_name, 
  SUM(o.order_amount) AS total
FROM orders AS o
INNER JOIN customers AS c USING (customer_id)
GROUP BY full_name
HAVING SUM(o.order_amount) > 30000
ORDER BY total ASC


