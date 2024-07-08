--Mô phỏng chuyển tiền ngân hàng từ người a, sang người b
SET IMPLICIT_TRANSACTIONS OFF;

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

--
SELECT * FROM dbo.bank

--Chuyển 50$ từ người a sang b

-- kHỞI TẠO TRANSACTION
BEGIN TRAN -- Hoặc BEGIN TRANSACTION
--1. trừ tiên của người a
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'a'
--2.Ghi log lịch sử giao dịch
INSERT dbo.bank_log
(id, note)
VALUES 
(5, N'Chuyen tien tu a sang b, 50USD')
--3.Cộng tiền cho ông b
UPDATE dbo.bank SET balance = balance + 50 WHERE name = 'b'
--4.Ghi log lịch sử giao dịch
INSERT dbo.bank_log
(note)
VALUES 
(N'Nguoi b nhan tu nguoi a, 50USD')
--Kết thúc transaction = COMMIT
COMMIT;

SELECT * FROM bank