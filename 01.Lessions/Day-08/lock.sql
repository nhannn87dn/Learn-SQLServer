-- Tạo bảng 'banking'
CREATE TABLE banking (
    id INT PRIMARY KEY NOT NULL,
    balance DECIMAL(12,2)
);

-- Tạo 10,000 bản ghi với balance ngẫu nhiên
DECLARE @counter INT = 1;

WHILE @counter <= 10000
BEGIN
    INSERT INTO banking (id, balance)
    VALUES (@counter, ROUND(RAND() * 100000, 2));

    SET @counter = @counter + 1;
END;

-- Kiểm tra dữ liệu
SELECT * FROM banking

-- Lần lượt
-- Rút 2931.92
BEGIN TRAN;
UPDATE banking SET balance = 8000.00 WHERE id = 1
-- Transaction chưa commit

-- Mở thêm tab new Query

BEGIN TRAN;

SELECT * FROM banking WHERE id = 1;