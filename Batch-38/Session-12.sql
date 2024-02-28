
CREATE TRIGGER trg_OrderItems_Update_ProductStock
ON order_items
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        UPDATE stocks
            SET quantity = s.quantity - i.quantity
        FROM
        stocks as s
        INNER JOIN inserted AS i ON s.product_id = i.product_id
        INNER JOIN orders AS o ON o.order_id = i.order_id AND o.store_id = s.store_id;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
		THROW;
    END CATCH
END;
SELECT price, discount FROM dbo.products WHERE product_id = 1

SELECT * FROM order_items
SELECT * FROM orders WHERE order_id = 1615

INSERT 
	order_items
(order_id, item_id, product_id,quantity,price,discount)
VALUES
(1615,4,1,1,379.99,3.00)
--xem tồn kho trước
--storeIid=3
--quanlity=14
SELECT * FROM stocks WHERE product_id = 1

SELECT * FROM staffs


CREATE TRIGGER trg_brands_PreventInsert
ON brands
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END

INSERT brands
(brand_name)
VALUES
('BMW')

SELECT * FROM brands

CREATE TRIGGER trg_customers_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Customers.'
        ROLLBACK
    END
END;