-- 1.Khai báo biến - DECLARE
--Cú pháp
-- DECLARE @<Tên biến> <Data Type> [= <value>]
-- Data Type chấp nhận = Data Type SQL Server
DECLARE @x INT = 2; -- khai báo biến và gán một giá trị cụ thể
DECLARE @y INT; -- chỉ mới khai biến, chưa gán giá trị
DECLARE @MySchool NVARCHAR(50) = N'Softech' -- string
DECLARE @IsAdmin BIT = 1;
DECLARE @BirthDay DATE = CAST('2024-01-01' AS DATE);

-- 2. Từ khóa SET
-- Dùng để gán giá trị cho biến
DECLARE @z INT; -- z chưa có giá trị
SET @z = 5; --gán giá trị cho biến

--3. Các lệnh để OUTPUT giá trị của biến
PRINT @z; -- output ra tại cửa sổ Messages
SELECT @z AS z; -- output ra tại cửa sổ Results

--4. Sử dụng BIẾN trong các câu lệnh truy vấn
SELECT * FROM products WHERE model_year = 2020;
--Sử dụng biến trong mệnh đề WHERE
DECLARE @ModelYear SMALLINT = 2020;
SELECT * FROM products WHERE model_year = @ModelYear;
-- Sử dụng biến = Kết quả của một câu lệnh truy vấn
DECLARE @product_count INT;
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        dbo.products 
);
SELECT @product_count AS totalProduct
--hoặc
DECLARE @FullName NVARCHAR(200);
SELECT  
	-- gán giá trị cho biến trong khi SELECT 
	@FullName = CONCAT(first_name, ' ', last_name) 
FROM customers 
WHERE customer_id =1; --> 1 record
SELECT @FullName AS FullName;

--{ --> BEGIN

--} --> END
-- 5.Khối lệnh trong SQL
BEGIN -- bắt đầu khối
	DECLARE @Full NVARCHAR(200);
	SELECT  
		-- gán giá trị cho biến trong khi SELECT 
		@Full = CONCAT(first_name, ' ', last_name) 
	FROM customers 
	WHERE customer_id =1; --> 1 record
	SELECT @Full AS FullName;
END -- kết thúc khối

--6. IF...ELSE
/**
if (condition) {
	//khoi lenh
}
else {
	...
}
*/
DECLARE @n SMALLINT = -1;
IF (@n > 0)
BEGIN
	PRINT N'n là Số dương'
END
ELSE
BEGIN
	PRINT N'n là số âm'
END

--7. Vòng lặp WHILE

/*
while (condition){
	...logic
}

*/

DECLARE @counter INT = 1;

WHILE (@counter <= 5)
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

DECLARE @c INT = 0;

WHILE (@c <= 5)
BEGIN
    SET @c = @c + 1;
    IF (@c = 4)
		BREAK; -- Bỏ qua những lệnh phía sau nó
    PRINT @c;
END


DECLARE @i int = 1
WHILE @i <= 10 
BEGIN
    IF @i = 5 
	BEGIN
        GOTO label
    END
    PRINT @i
    SET @i = @i + 1
END

label:
PRINT 'Done'



-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ 10 giây
WAITFOR DELAY '00:00:10';
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ 10 giây';


-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ đến thời điểm 23:59:00
WAITFOR TIME '19:08:00';
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ đến 19:08:00';\


---9. Function SQL server
-- Để bạn hiểu khi nào thì cần sử dụng function
SELECT first_name + ' ' + last_name AS full_name FROM customers;
SELECT first_name + ' ' + last_name AS full_name FROM staffs;

-- đỊNH NGHĨA 1 function
ALTER FUNCTION dbo.udsf_getFullName(@FirstName NVARCHAR(255), @LastName NVARCHAR(255))
RETURNS NVARCHAR(600)
AS
BEGIN
	RETURN @FirstName + ' ' + @LastName;
END

-- Sử dụng hàm
SELECT dbo.udsf_getFullName(first_name, last_name) AS full_name FROM staffs;

-- Xóa function
DROP FUNCTION dbo.udsf_getFullName

--TABLE Functions
DECLARE @Model_Year SMALLINT = 2022;


CREATE FUNCTION udtf_getProductsByModelYear(@Model_Year SMALLINT)
RETURNS TABLE -- return về một Table
AS
RETURN
(
    SELECT * FROM products WHERE model_year = @Model_Year
)

--Sử hàm đó như là một bảng bình thường
SELECT * FROM dbo.udtf_getProductsByModelYear(2020)
SELECT * FROM dbo.udtf_getProductsByModelYear(2022)

SELECT * FROM orders


SELECT
	order_id,
	customer_id,

    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status
FROM    
    dbo.orders

SELECT 
	order_id,
	customer_id,
	--COALESCE(shipping_city, 'No City')
	NULLIF('No City', shipping_city)
FROm orders



BEGIN
    BEGIN TRY
        SELECT 1/0 -- Chia một số cho 0
    END TRY
    BEGIN CATCH
        --Bắt lỗi, và hiển ra thành một table
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
END;



-- Tạo table t1
CREATE TABLE t1(
    id int primary key
);
GO
--
BEGIN TRY
    INSERT INTO t1(id) VALUES(1);
    --  cause error
    INSERT INTO t1(id) VALUES(1);
END TRY
BEGIN CATCH
    --PRINT('Raise the caught error again');
	--THROW;
    --THROW 50000, 'Raise the caught error again' ,1

	RAISERROR('This is a custom error', 16, 1)

END CATCH


SELECT 1/0
SELECT @@ERROR