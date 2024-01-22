
--Tự động cập nhật số lượng tồn kho, khi có đơn hàng mới
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


--Ví dụ 2: Tạo một trigger AFTER để ngăn chặn việc cập nhật / xóa đơn hàng 
--khi đơn hàng (orders) có trạng thái order_status = 4 (COMPLETED)


CREATE TRIGGER trg_Orders_Prevent_UpdateDelete
ON orders
AFTER UPDATE, DELETE 
AS
BEGIN
    IF EXISTS (SELECT *
    FROM inserted
    WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot update order having status = 4 (COMPLETED).'
        ROLLBACK
    -- Hủy lệnh UPDATE trước đó vào orders
    END

    IF EXISTS (SELECT *
    FROM deleted
    WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK
    -- Hủy lệnh DELETE trước đó vào orders
    END
END;


---Ví dụ 3: Tạo một trigger AFTER để ngăn chặn việc cập nhật / thêm mới / xóa chi tiết đơn hàng (orders) có trạng thái order_status = 4 (COMPLETED)

CREATE OR ALTER TRIGGER trg_OrderItems_Prevent_InsertUpdateDelete
ON order_items
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT *
    FROM
        inserted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
    WHERE [order_status] = 4
    )
    BEGIN
        PRINT 'Cannot insert or update order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END

    IF EXISTS (
        SELECT *
    FROM
        deleted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
    )
    BEGIN
        PRINT 'Cannot delete order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END
END;


--Ví dụ: Tạo một trigger để ngăn chặn việc xóa bảng customers

CREATE TRIGGER trg_customers_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Customers.'
        ROLLBACK
    END
END;

---Ví dụ 2: Tạo một trigger để ghi nhật ký sửa đổi cấu trúc bảng customers

-- Tạo table logs trước
CREATE TABLE dbo.logs
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    [Date] DATETIME,
    [User] NVARCHAR(100),
    [Host] NVARCHAR(100),
    [Action] NVARCHAR(100),
    [Table] NVARCHAR(100)
);

-- Thêm trigger
CREATE TRIGGER trg_customers_LogAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    IF EXISTS (SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        INSERT INTO dbo.logs
            ([Date], [User], [Host], [Action], [Table])
        SELECT GETDATE(), USER_NAME(), HOST_NAME(), 'ALTER TABLE', 'customers'
    END
END