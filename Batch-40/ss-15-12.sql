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

--Bắt đầu một transaction
BEGIN TRANSACTION -- BEGIN TRAN
--b1
UPDATE bank SET balance = balance + 50 WHERE name = 'a'

SAVE TRANSACTION Savepoint1

--b2 them moi khach hang
INSERT bank (id, name, balance) VALUES(3, 'c', 50)

ROLLBACK TRANSACTION Savepoint1

INSERT bank (name, balance) VALUES('d', 100)

COMMIT TRANSACTION;


--COMMIT;
ROLLBACK TRANSACTION; -- hủy tất tất cả những lệnh trước đó


SELECT @@TRANCOUNT AS TranCountBefore;

BEGIN TRANSACTION;

BEGIN TRY
	SELECT @@TRANCOUNT AS TranCountAfterBegin;
    -- b1. Trừ tiền người a: 50
    UPDATE bank SET balance = balance - 50 WHERE name = 'a';

    -- b2. Ghi log lịch sử transaction
    INSERT INTO bank_log (note)
    VALUES ('Chuyen tien tu a sang 5, 50USD');

    -- b3. Cộng tiền người b: 50
    UPDATE bank SET balance = balance + 50 WHERE name = 'b';

    -- b4. Ghi log lịch sử transaction <=== LỖI Ở DÒNG NÀY
    INSERT INTO bank_log ( note)
    VALUES ('Nhan tien tu nguoi a, 50USD');

    -- Nếu không có lỗi, xác nhận transaction
    COMMIT TRANSACTION;
	SELECT @@TRANCOUNT AS TranCountAfterCommit;
END TRY
BEGIN CATCH
    -- Xử lý lỗi
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

    -- Nếu có lỗi, hủy bỏ transaction
    ROLLBACK TRANSACTION;
END CATCH

SELECt * FROM bank

Đặt hàng online có thanh toán trực tuyến


SET trạng thái đơn hàng đã thanh toán
SET số lượng tồn kh0 giảm = chính số lượng đơn đã mua

--TRIGER

--AFTER Trigger
-- Khi update số dư của một tài khoản thì tự động ghi log
CREATE TRIGGER trg_AutoWriteLogWhenUpdateBank
ON bank
AFTER UPDATE
AS
BEGIN
	--các lệnh thực thi sau khi có một câu lệnh UPDATE xảy
	--ra trên table bank
	BEGIN TRY
		INSERT bank_log
			(note)
		VALUES
			(CONCAT('Co Thay doi so du', GETDATE()))
	END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END

SELECT * FROM bank
UPDATE bank SET balance = balance + 50 WHERE name = 'a'
SELECT * FROM bank_log

DELETE bank WHERE name = 'd'

--trigger dùng để giám sát hoạt động INSERT, UPDATE, DELETE
--cho một table.


ALTER TRIGGER trg_NoDeleteNameA
ON bank
AFTER DELETE
AS
BEGIN
	--các lệnh thực thi sau khi có một câu lệnh UPDATE xảy
	--ra trên table bank
	BEGIN TRY
		IF EXISTS (SELECT * FROM deleted WHERE name = 'd')
		BEGIN
			PRINT 'Cannot delete d.'
			ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
		END
	END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END

-- INSTEAD OF Trigger thực hiện trigger trước khi sự kiện xảy ra
CREATE OR ALTER TRIGGER trg_log_PreventInsert
ON bank_log
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the bank_log table.'
END

INSERT bank_log (note) VALUES (',smds,mds,d')
SELECT * FROM bank_log


CREATE TRIGGER trg_bank_Prevent_DropTable
ON DATABASE
FOR DROP TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: bank.'
        ROLLBACK -- khôi phục lại
    END
END;

DROP TABLE IF EXISTS bank



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
ALTER TRIGGER trg_customers_LogAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy thông tin sự kiện
    DECLARE @eventData XML = EVENTDATA();

    -- Trích xuất tên bảng và schema từ sự kiện
    DECLARE @schema NVARCHAR(255), @table NVARCHAR(255);
    SET @schema = @eventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(255)');
    SET @table = @eventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)');

    -- Nếu bảng bị tác động là 'customers' trong schema 'dbo'
    IF @schema = 'dbo' AND @table = 'customers'
    BEGIN
        -- Ghi log
        INSERT INTO dbo.logs ([Date], [User], [Host], [Action], [Table])
        VALUES (GETDATE(), SUSER_SNAME(), HOST_NAME(), 'ALTER TABLE', 'customers');
    END
END;


ALTER TABLE customers
ALTER column phone NVARCHAR(15) NOT NULL

ALTER TABLE dbo.customers ADD new_column INT;



ALTER TRIGGER trg_prevent_table_modifications
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
        RAISERROR ('Không được phép xóa hoặc sửa đổi bảng TenBangCanBaoVe.', 16, 1)
        ROLLBACK
    END
END

DROP table basket_a