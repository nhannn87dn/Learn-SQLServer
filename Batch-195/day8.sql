SELECT * FROM dbo.product_test

--Cách khởi tạo một transaction (1 phiên giao dịch)
--Bước 1. Bắt đầu transaction
BEGIN TRANSACTION --(BEGIN TRAN)
--Bước 2: 
	--Các lệnh truy vấn
	UPDATE dbo.product_test SET Price = 100 WHERE ProductID = 1
	UPDATE dbo.product_test SET Price = 100 WHERE ProductID = 2

--Bước 3: Kết thúc transaction
--Kết thúc có tình huống
--3.1 sử dụng COMMIT --> Để xác nhận thay đổi dữ liệu
--COMMIT
--3.1 Sử dụng ROLLBACK
ROLLBACK



--Tạo table bank
CREATE TABLE bank
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20),
    balance DECIMAL(10,2)
)
--Ghi log giao dich
CREATE TABLE bank_log
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    note NVARCHAR(500)
)

--chèn dữ liệu ban đầu cho a và b
INSERT bank
    (name,balance)
VALUES
    ('a', 250),
    ('b', 0)

SELECT * FROM bank
SELECT * FROM bank_log


--Bước 1
BEGIN TRANSACTION;
--Bước 2
BEGIN TRY
    -- b1. Trừ tiền người a: 50
    UPDATE bank SET balance = balance - 50 WHERE name = 'a';

    -- b2. Ghi log lịch sử transaction
    INSERT INTO bank_log (note)
    VALUES ('Chuyen tien tu a sang b, 50USD');

    -- b3. Cộng tiền người b: 50
    UPDATE bank SET balance = balance + 50 WHERE name = 'b';

    -- b4. Ghi log lịch sử transaction
    INSERT INTO bank_log (id, note)
    VALUES (4,'Nhan tien tu nguoi a, 50USD');

    -- Nếu không có lỗi, xác nhận transaction
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Xử lý lỗi
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

    -- Nếu có lỗi, hủy bỏ transaction
    ROLLBACK TRANSACTION;
END CATCH


BEGIN TRAN
UPDATE bank SET balance = balance - 50 WHERE name = 'a';
COMMIT


--after trigger
-- Xảy ra sau sự kiện update, delete, insert
SELECT * FROm dbo.product_test

INSERT dbo.product_test (ProductID, ProductName, Price) VALUES (9, 'abc', 100)

UPDATE product_test SET Price = 100 WHERE ProductID = 1


CREATE OR ALTER TRIGGER tg_test
ON product_test
AFTER  UPDATE
AS
BEGIN
    --Làm gì đó sau khi bạn thực hiện update table product_test
	PRINT N'Bạn đã update table product test'
END;

--Khi nào thì dùng ? Khi bạn muốn làm gì đó khi người ta update, insert, delete các record
-- thì dùng
--Ví dụ: 
SELECT * FROm orders



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


UPDATE orders SET order_note = 'abc' WHERE order_id IN (76)
SELECT * FROM orders WHERE order_id IN (1, 76)



CREATE TRIGGER trg_poduct_test_PreventInsert
ON product_test
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END



DISABLE TRIGGER trg_poduct_test_PreventInsert ON product_test;
ENABLE  TRIGGER trg_poduct_test_PreventInsert ON product_test;

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
ALTER table basket_a
ALTER column fruit_a VARCHAR(60)

DROP table basket_a