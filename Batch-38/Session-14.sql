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
VALUES (400, 0);
-- Thêm vào invoice_items
 INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (2, 'Laptop', 90, 0.05),
       (2, 'Moble', 30, 0.02);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
--COMMIT TRANSACTION; -- or COMMIT
ROLLBACK;

SELECT * FROM dbo.invoices
SELECT * FROM dbo.invoice_items

SELECT * from dbo.stores

BEGIN TRANSACTION
	DECLARE @c INT = (SELECT COUNT(*) FROM dbo.stores WHERE phone = 'N/A')
	
	PRINT @c

	IF @c > 0
	BEGIN
		UPDATE dbo.stores SET phone = 'N/A' WHERE phone IS NULL;
		ROLLBACK TRANSACTION;
		PRINT 'yes'
	END
	ELSE
	BEGIN
		PRINT 'no'
	END
COMMIT TRANSACTION;