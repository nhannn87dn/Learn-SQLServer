---SUbQUERY

SELECT
  c.*, 
  (SELECT COUNT(product_id) 
        FROM products AS P 
        WHERE p.category_id = c.product_id) AS 'number_product'
FROM categories AS c


---Ví dụ, bạn có thể sử dụng subquery để tìm tất cả các khách hàng có đơn hàng
-- với tổng giá trị lớn hơn một ngưỡng nào đó

SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(order_amount) > 1000
)

--- Ví dụ: Lấy thông tin đơn hàng của tất cả khách hàng ở New York
SELECT
    order_id,
    order_date,
    customer_id
FROM
    orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;


-- ANY
expresion operator ANY(subquery)


SELECT
    product_name,price
FROM  products
WHERE
    -- Nếu price >= với bất kì giá trị nào
    -- trong kết quả SELECT thì WHERE thực thi
    price >= ANY (
        SELECT AVG (price) FROM products GROUP BY brand_id
);


--- Ví dụ: Lấy thông tin khách hàng, có đơn hàng mua vào năm 2017.

SELECT customer_id,first_name,last_name, city
FROM customers AS c
WHERE
    EXISTS (
        -- Đi tìm những khách hàng mua hàng năm 2017
        SELECT customer_id
        FROM orders AS o
        WHERE o.customer_id = c.customer_id AND YEAR (order_date) = 2017
    )
ORDER BY first_name, last_name;

--JOIN