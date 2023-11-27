
--Bo sung cac truong

ALTER TABLE dbo.products
ADD discount SMALLINT NOT NULL DEFAULT 0,
	description NVARCHAR (max);
GO

UPDATE [dbo].products SET description = 'Description for ' +  product_name

UPDATE [dbo].products
SET discount = ABS(CHECKSUM(NEWID())) % 30 + 0

ALTER TABLE dbo.orders
ADD order_note NVARCHAR(500),
    shipping_address NVARCHAR(500),
    shipping_city NVARCHAR(50),
    payment_type TINYINT NOT NULL DEFAULT 4;

UPDATE [dbo].orders
SET payment_type = ABS(CHECKSUM(NEWID())) % 4 + 1

UPDATE dbo.orders
SET shipping_address = c.street,
    shipping_city = c.city
FROM dbo.orders o
INNER JOIN dbo.customers c ON o.customer_id = c.customer_id;


UPDATE dbo.products
SET product_name = CONCAT(product_name, product_id), model_year = (model_year + (ABS(CHECKSUM(NEWID())) % 9 + 1))
WHERE product_name IN (
    SELECT product_name
    FROM dbo.products
    GROUP BY product_name
    HAVING COUNT(product_id) > 1
);


UPDATE dbo.products
SET product_name = REPLACE(product_name, '/', '')
WHERE product_name LIKE '%/%';