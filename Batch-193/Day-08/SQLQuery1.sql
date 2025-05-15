--SESION 14
--TRANSATION ?
/*
Ví dụ: chuyển tiền từ người A sang B trong giao dịch Banking

1. Trừ tiền người a
2. Ghi log lịch sử giao dịch trừ tiền của a
3. Cộng tiền cho b
4. Ghi log lịch sử giao dịch cộng tiền cho b

===========kết quả=======
1. Nếu thành công --> 4 bước trên phải thành công
2. Thất bại --> 1 trong 4 bước trên ko thực hiện được.

*/


--Mô phỏng chuyển tiền ngân hàng từ người a, sang người b

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


---Để tạo ra một transaction
BEGIN TRANSACTION -- BEGIN TRAN ==> điểm bắt đầu
	--Tất cả các câu lệnh truy vấn INSERT, UPDATE, DELETE, SELECT
	INSERT bank
		(name,balance)
	VALUES
		('b', 0);
---Kết thúc với 1 trong 2 cách
--ví dụ cách 1:
COMMIT TRANSACTION --> xác nhận hoàn tất giao dịch
--ví dụ cách 2:
--ROLLBACK TRANSACTION --> Thì nó hủy bỏ giao dịch và hồi lại các lệnh truy vấn
BẺGFI
SELECT * FROM bank_log


SELECT * FROM bank

-- Mô phỏng giao dịch chuyển tiền banking a-> b
BEGIN TRANSACTION;
BEGIN TRY
	-- Cố găng thực hiện giao dịch
	--1. Trừ tiền người a 50USD
	UPDATE bank SET balance = balance - 50 WHERE name = 'a';
	--2. Ghi log lịch giao dịch trừ tiền của a
	INSERT bank_log (note) VALUES (N'Chuyển từ a sang b 50 USD');
	--3. Cộng tiền cho b
	UPDATE bank SET balance = balance + 50 WHERE name = 'b';
	--4. Ghi log lịch giao dịch trừ tiền của a
	--INSERT bank_log (note) VALUES (N'B nhận tiền từ a - 50 USD');
	INSERT bank_log (id, note) VALUES (10, N'B nhận tiền từ a - 50 USD');
	--Nếu 4 queries trên thành công thì commit để hoàn tất giao dịch
	COMMIT TRANSACTION;
END TRY
--Nếu giao dịch lỗi thì lỗi được catch
BEGIN CATCH
	-- Xử lý lỗi
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

    -- Nếu có lỗi, hủy bỏ transaction
    ROLLBACK TRANSACTION
END CATCH


-- Giao dịch bán hàng, có thanh toán online
-- A. giao thành công
-- 1. chọn sản phẩm --> tạo đơn hàng
-- 2. Thanh toán
-- 3. Cập nhật đơn hàng --> đã thanh toán thành công
-- 4. Trừ số lượng tồn kho của các sp mà đơn hàng đã mua