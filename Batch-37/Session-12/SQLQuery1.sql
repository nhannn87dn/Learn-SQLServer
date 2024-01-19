--
select * from bank
select * from bank_log
--
INSERT bank (name, balance)
VALUES ('c', 150);

INSERT bank_log (note) VALUE (N'Tao tai khoan cho ong C so du 150')


CREATE TRIGGER dbo.trg_bank_log
ON bank
AFTER INSERT --{[INSERT],[UPDATE],[DELETE]}
AS
BEGIN
	DECLARE i = 
	INSERT bank_log (note) 
	VALUE (
	)
	(SELECT * FROM inserted)
END
select * FROM orders WHERE order_id = 4
select * FROM order_items WHERE order_id = 4

select * from stocks WHERE product_id = 3 AND store_id = 1
--
INSERT order_items (
order_id,item_id, product_id, quantity, price, discount
)VALUES (
4, 2, 3, 1, 200, 0
)


CREATE TRIGGER trg_OrderItems_Update_ProductStock
ON order_items
AFTER INSERT
AS
BEGIN
    UPDATE stocks
        SET quantity = s.quantity - i.quantity
    FROM
       stocks as s
    INNER JOIN inserted AS i ON s.product_id = i.product_id
	INNER JOIN orders AS o ON o.order_id = i.order_id AND o.store_id = s.store_id;
END;


CREATE OR ALTER TRIGGER trg_Orders_Prevent_UpdateDelete
ON orders
AFTER UPDATE, DELETE -- Ngăn cách nhau bởi dấy phẩu khi có nhiều action
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
    END

    IF EXISTS (SELECT * FROM updated WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot update order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh UPDATE trước đó vào orders
    END

    
END;

UPDATE orders SET customer_id = 1 WHERE order_id = 2
DELETE orders WHERE order_id = 2
select * from order_items WHERE order_id = 1


CREATE OR ALTER TRIGGER trg_OrderItems_Prevent_InsertUpdateDelete
ON order_items
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM
        inserted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
        WHERE [order_status] = 4
    )
    BEGIN
        PRINT 'Cannot insert or update order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END

    IF EXISTS (
        SELECT * FROM
        deleted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
    )
    BEGIN
        PRINT 'Cannot delete order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END
END

UPDATE order_items SET quantity = 1 WHERE order_id = 9

select * from order_items  AS i
LEFT JOIN orders AS o ON o.order_id = i.order_id
WHERE o.order_id = 9.

-- giam sat sat don hang
-- giam sat san pham
/*
Ai đã sửa đơn hàng ?
Ai đã thay đổi giá sản phẩm ?
*/

SELECT * FROM sys.objects
SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]')

SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR';

--VIEW

CREATE OR ALTER VIEW v_productCategory
AS 
SELECT 
	p.*, c.category_name 
FROM 
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id
WHERE p.model_year  = 2016

SELECT * FROM v_productCategory WHERE brand_id = 9
ORDER BY product_id ASC

DROP VIEW IF EXISTS dbo.v_daily_sales

ALTER VIEW dbo.v_daily_sales --đặt tên với prefix v_
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
	p.discount,
    i.quantity * i.price AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id
WHERE p.discount > 0.05
WITH CHECK OPTION;
--- ==> Kết quả nó tạo ra một table ảo, chứa kết quả của câu lệnh truy vấn SELECT

-- Xem danh sách các view đã tạo
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
select * from products WHERE discount > 2
select * from dbo.v_daily_sales

UPDATE dbo.v_daily_sales SET discount = 0.05 WHERE discount = 0.07;

EXEC sp_rename 'products.model', 'model_year', 'COLUMN';

INSERT dbo.v_daily_sales (y, m,d, product_id, product_name, discount, sales)
VALUES (
2016, 1,1, 1, 'jksjdksjd', 0.0001, 345
)

CREATE PROCEDURE usp_products
AS
BEGIN
	SELECT 
			product_name, 
			price
		FROM 
			dbo.products
		ORDER BY 
			product_name;
	cau a
	cau b
	cau c
END

EXECUTE usp_products

CREATE PROCEDURE usp_sales
@FromDate DATETIME,
@ToDate DATETIME,
@Total INT OUTPUT
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE order_date BETWEEN CAST(@FromDate, DATE) AND @ToDate
END;

DECLARE @Total INT
EXEC usp_sales '2021-01-01', '2021-01-31', @Total OUTPUT
SELECT @Total

select * from orders

CREATE PROCEDURE usp_deleteProduct(@productId INT)
AS 
BEGIN
	DELETE dbo.products WHERE product_id = @productId
END

EXECUTE usp_deleteProduct 1; --xóa sp id = 1
EXECUTE usp_deleteProduct 2; --xóa sp id = 2


CREATE PROCEDURE uspFindProductByModel (
    @model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT 
        product_name,
        price
    FROM
        dbo.products
    WHERE
        model_year = @model_year;

    SELECT @product_count = @@ROWCOUNT;
END;


DECLARE @count INT;

EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;

SELECT @count AS 'Number of products found';

SELECT *
FROM sys.tables


SELECT *
FROM sys.views

SELECT *
FROM sys.procedures