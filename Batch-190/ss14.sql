-- Hóa đơn
CREATE TABLE invoices (
  id int IDENTITY(1,1) PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);
-- Chi tiết các mục ghi vào hóa đơn
CREATE TABLE invoice_items (
  id int IDENTITY(1,1),
  invoice_id int NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(18, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id),
  FOREIGN KEY (invoice_id) REFERENCES invoices (id)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);


-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
	INSERT INTO dbo.invoices (customer_id, total)
	VALUES (100, 0);
	-- Thêm vào invoice_items
	 INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
	VALUES (1, 'Keyboard', 70, 0.08),
		   (1, 'Mouse', 50, 0.08);
	-- Thay đổi dữ liệu cho record đã chèn vào invoices
	UPDATE dbo.invoices
	SET total = (SELECT
	  SUM(amount * (1 + tax))
	FROM invoice_items
	WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT

--Check dữ liệu của 2 table trước khi thực hiện
select * from invoices
select * from invoice_items

SET XACT_ABORT ON

-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
INSERT INTO dbo.invoices (customer_id, total)
VALUES (100, 0);
--Trường ID đã khai báo IDENTITY nên bạn không thể khai báo chi tiết giá trị của id khi thêm mới
--Câu lệnh này sẽ gây lỗi IDENTITY_INSERT is set to OFF
 INSERT INTO dbo.invoice_items (id, invoice_id, item_name, amount, tax)
VALUES (3, 1, 'Keyboard v2 ', 70, 0.08),
       (4, 1, 'Mouse v2 ', 50, 0.08);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT


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

INSERT bank
    (name,balance)
VALUES
    ('a', 250),
    ('b', 0)
SELECT * FROM bank

-- Chuyển từ từ a 50$ -> b
BEGIN TRANSACTION
BEGIN TRY
	--b1: trừ tiền của a
	UPDATE bank SET balance = (balance - 50) WHERE name = 'a';
	--b2: ghi log
	INSERT bank_log (note) VALUES (N'Chuyen tien 50$ tu a sang b')
	--b3: Cộng tiền cho b
	UPDATE bank SET balance = (balance + 50) WHERE name = 'b';
	--b4: ghi log
	INSERT INTO bank_log 
		(id, note)
    VALUES 
		(2, 'Nhan tien tu nguoi a, 50USD');

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

SELECT * FROM bank



--- TRIGGER
-- khi ma bạn update table bank thì trigger được thực thi tự động
ALTER TRIGGER trg_update_bank
ON bank
AFTER UPDATE 
AS
BEGIN
    -- Tạo định dạng log cho các thay đổi
    --INSERT INTO bank_log (note) values (CONCAT('Thay doi bank xxx', GETDATE()))
	-- Tạo định dạng log cho các thay đổi
    INSERT INTO bank_log (note)
    SELECT
        CONCAT(
            'Row updated: ID=', INSERTED.id,
            ', Old Balance=', DELETED.balance,
            ', New Balance=', INSERTED.balance,
            ', Name=', INSERTED.name
        )
    FROM INSERTED
    INNER JOIN DELETED
    ON INSERTED.id = DELETED.id;

END

SELECT * FROM bank
SELECT * FROM bank_log

BEGIN TRAN;
UPDATE bank SET balance = (balance + 50) WHERE name ='b'
ROLLBACK;

CREATE TRIGGER trg_bank_log_PreventInsert
ON bank_log
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END

INSERT bank_log (note) VALUES ('bababa')

-- DDL Trigger tác động trên cấp độ database

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

DROP table bank_log -- 274100017

SELECT * FROM  sys.tables
SELECT OBJECT_ID(N'[dbo].[bank_log]')


-- Tạo table logs trước
CREATE TABLE dbo.logs (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    [Date] DATETIME,
    [User] NVARCHAR(100),
    [Host] NVARCHAR(100),
    [Action] NVARCHAR(100),
    [Table] NVARCHAR(100)
);

CREATE TRIGGER trg_bank_LogAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bank]') AND type in (N'U'))
    BEGIN
        INSERT INTO dbo.logs ([Date], [User], [Host], [Action], [Table])
        SELECT GETDATE(), USER_NAME(), HOST_NAME(), 'ALTER TABLE', 'bank'
		ROLLBACK;
	END
END

ALTER TABLE bank
ALTER column name NVARCHAR(50)

SELECT * FROM logs



DISABLE TRIGGER trg_bank_LogAlterTable ON DATABASE;