
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
    END CATCH
END;

SELECT * FROM order_items WHERE order_id = 2 AND item_id = 3
SELECT * FROM orders WHERE order_id = 2
SELECT * FROM dbo.products WHERE product_id = 5

INSERT INTO order_items
(order_id, item_id, product_id, quantity,price, discount)
VALUES
(2, 3, 5, 1, 1320.99, 0.1)

--Kiểm tra tồn kho của product_id = 5
SELECT * FROM stocks WHERE product_id = 5 AND store_id = 2
-- stock 1


CREATE TRIGGER trg_Orders_Prevent_UpdateDelete
ON orders
AFTER UPDATE, DELETE -- Ngăn cách nhau bởi dấy phẩu khi có nhiều action
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot update order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh UPDATE trước đó vào orders
    END

    IF EXISTS (SELECT * FROM deleted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
    END
END;

SELECT * FROm dbo.orders
UPDATE dbo.orders SET order_note = 'abc' WHERE order_id = 1

DELETE dbo.orders  WHERE order_id = 1


CREATE TRIGGER trg_customers_PreventInsert
ON customers
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END

SElECT * FROM customers

INSERT INTO [dbo].[customers]
           ([first_name]
           ,[last_name]
           ,[phone]
           ,[email]
           ,[street]
           ,[city]
           ,[state]
           ,[zip_code]
           ,[birthday])
     VALUES 
           ('John'       -- first_name
           ,'Doe'        -- last_name
           ,'123-456-7890' -- phone
           ,'john.doe@example.com' -- email
           ,'123 Main St' -- street
           ,'Anytown'    -- city
           ,'CA'         -- state
           ,'12345'      -- zip_code
           ,'1980-01-01'); -- birthday

CREATE TRIGGER trg_bank_log_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank_log]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Bank Log.'
        ROLLBACK
    END
END;

DROP TABLE bank_log


-- Tạo table logs trước
CREATE TABLE dbo.logs (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    [Date] DATETIME,
    [User] NVARCHAR(100),
    [Host] NVARCHAR(100),
    [Action] NVARCHAR(100),
    [Table] NVARCHAR(100)
);

-- Thêm trigger
CREATE TRIGGER trg_bank_LogAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
    BEGIN
        INSERT INTO dbo.logs ([Date], [User], [Host], [Action], [Table])
        SELECT GETDATE(), USER_NAME(), HOST_NAME(), 'ALTER TABLE', 'bank'
    END
END

SELECT * FROM dbo.bank

ALTER TABLE dbo.bank
ALTER column name NVARCHAR(30)

SELECT * FROM dbo.logs