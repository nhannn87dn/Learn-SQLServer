BEGIN TRAN

USE Batch193_Data
GO
UPDATE bank SET balance = balance + 50
WHERE name = 'a'
GO
-- chua commit
COMMIT

--SESSION 12 - TRIGGERS
-- After Trigger -- Xảy ra sau khi sự kiện insert, update, delete

CREATE OR ALTER TRIGGER dbo.trg_insertBankLog
ON bank -- gắn cho table bank
AFTER  UPDATE -- Khi bạn update table bank, thì trigger được kích hoạt và chạy
AS
BEGIN
    INSERT bank_log (note) VALUES (CONCAT('bank log', GETDATE()));
END;

--
SELECT * FROM bank_log
SELECT * FROM bank
UPDATE bank SET balance = balance + 50 WHERE name ='a'

--Kết luận: Khi mà bạn thực hiện một sự kiện và đồng bạn muốn thực hiện
-- luôn những tác vụ liên quan --> sử dụng trigger để chạy ngầm

-- Ví dụ trong quy trình bán hàng
SELECT * FROM orders
-- Khi mà thanh toán thành công --> tự động kích hoạt trigger --> giảm số lượng tồn kho


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

UPDATE orders SET order_note = 'babababa' WHERE order_id = 1


CREATE TRIGGER trg_bank_log_PreventInsert
ON bank_log
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the bank_log table.'
END

INSERT bank_log (note) VALUES (CONCAT('bank log 11111', GETDATE()));


CREATE TRIGGER trg_prevent_table_modifications
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA()
    DECLARE @ObjectName NVARCHAR(MAX)

    -- Lấy tên bảng từ EVENTDATA
    SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(MAX)')

    -- Kiểm tra nếu tên bảng là bảng cụ thể cần bảo vệ
    IF @ObjectName = 'basket_a'
    BEGIN
        RAISERROR ('Không được phép xóa hoặc sửa đổi bảng basket_a.', 16, 1)
        ROLLBACK
    END
END
-- Thực hiện lệnh thì báo lỗi
DROP table basket_a

ALTER TABLE basket_a
ALTER COLUMN fruit_a VARCHAR(60) NOT NULL


CREATE TRIGGER trg_debug_inserted_deleted
ON bank
AFTER UPDATE
AS
BEGIN
    -- Hiển thị giá trị mới (INSERTED)
    SELECT * FROM INSERTED;

    -- Hiển thị giá trị cũ (DELETED)
    SELECT * FROM DELETED;

    -- Log ví dụ
    INSERT INTO bank_log (note)
    SELECT 
        CONCAT('Debug - New Balance: ', INSERTED.balance, ', Old Balance: ', DELETED.balance)
    FROM INSERTED
    INNER JOIN DELETED
    ON INSERTED.id = DELETED.id;
END;

SELECT * FROM bank_log
SELECT *FROM bank
UPDATE bank SET balance = balance + 50 WHERE name ='a'

bank_log = [
	{id: 1, note: "nanskjs"}
	{id: 2, note: "nanskjs", abc: "dsd"}
];

SELECT * FROM bank_log
ALTER TABLE bank_log
ADD abc VARCHAR(10) NULL DEFAULT NULL