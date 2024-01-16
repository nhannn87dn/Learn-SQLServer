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

--chèn dữ liệu ban đầu cho a và b
INSERT bank
    (name,balance)
VALUES
    ('a', 250),
    ('b', 0)

/*
Để thực hiện chuyển 50USD từ a --> b cần các bước:
1. Trừ tiền người a: 50
2. Ghi log lịch sử giao dịch
3. Cộng tiền người b: 50
4. Ghi log lịch sử giao dịch

==> 4 bước trên được coi là 1 GIAO DỊCH trong ngân hàng
==> Chỉ cần 1 trong 4 lệnh trên lỗi thì GIAO DỊCH được coi là không thành công.
==> Trạng thái sẽ được khôi phục lại như khi chưa thực hiện GIAO DỊCH
*/

--Kiểm tra số dư của a và b trước khi thực hiện
SELECT *
FROM bank

BEGIN TRANSACTION;
--b1. Trừ tiền người a: 50
UPDATE bank SET balance = balance - 50 WHERE name = 'a';
--b2. Ghi log lịch sử giao dịch
INSERT bank_log
    (note)
VALUES
    ('Chuyen tien tu a sang 5, 50USD')
--b3. Cộng tiền người b: 50
UPDATE bank SET balance = balance + 50 WHERE name = 'b';
--b4. Ghi log lịch sử giao dịch
INSERT bank_log
    (id, note)
VALUES
    (2, 'Nhan tien tu nguoi a, 50USD')
COMMIT TRANSACTION;

/*
Trong Giao dịch trên:
- Câu lệnh bước 4 bị lỗi vì id đã định danh tự tăng
- GIAO DỊCH khi đó được khôi phục lại như trạng thái ban đầu
*/

--Kiểm tra số dư của a và b SAU khi thực hiện
SELECT *
FROM bank