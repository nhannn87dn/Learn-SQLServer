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


--Bat dau 1 transaction
-- A chuyen cho B 50$
BEGIN TRANSACTION;
	--step1: Tru tien ong A
	UPDATE bank SET balance = (balance - 10) WHERE id = 1;
	--step2: ghi log lich su chuyen tien
	INSERT INTO bank_log (note) VALUES (N'chuyen cho b 10$')
	SAVE TRANSACTION step2
	--step3: cong tien cho ong B
	UPDATE bank SET balances = (balance + 10) WHERE id = 2;
	ROLLBACK TRANSACTION step2
	--step4: ghi log lich su chuyen tien
	INSERT INTO bank_log (note) VALUES (N'nhan tien tu ong a 10$')
--Đóng transaction với 1 trong 2 lệnh
COMMIT TRANSACTION;
--ROLLBACK;


BEGIN TRANSACTION;

BEGIN TRY
    -- b1. Trừ tiền người a: 50
    UPDATE bank SET balance = balance - 50 WHERE name = 'a';

    -- b2. Ghi log lịch sử transaction
    INSERT INTO bank_log (note)
    VALUES ('Chuyen tien tu a sang 5, 50USD');
	
	SAVE TRANSACTION step2

    -- b3. Cộng tiền người b: 50
    UPDATE bank SET balances = balance + 50 WHERE name = 'b';

	ROLLBACK TRANSACTION step2

    -- b4. Ghi log lịch sử transaction
    INSERT INTO bank_log (id, note)
    VALUES (2, 'Nhan tien tu nguoi a, 50USD');

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