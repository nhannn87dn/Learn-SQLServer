--1. Khai bao biến

DECLARE @x INT = 5;
-- DECLARE: từ khóa khai báo biến
-- @x là tên biến. Luôn bắt đầu bằng @
-- INT là kiểu dữ liệu của biến
-- = là toán tử gán
-- 5 : là giá trị gán cho biến x
DECLARE @My_Name NVARCHAR(50) = N'Ngọc Nhân';
DECLARE @IsTeacher BIT = 1; --True
SELECT @IsTeacher AS name
PRINT @IsTeacher


--2. Có thể khai báo một biến rỗng
DECLARE @y INT; --> Không gán giá trị cho biến
--
SET @y = 2; --> gán giá trị biến với từ khóa SET

--3. Lệnh OUTPUT giá trị của biến ( in ra)
PRINT @y;

--4. Có thể gán giá trị cho biến bằng kết quả một câu lệnh truy vấn
--Ví dụ:
DECLARE @TotalProducts INT;
SET @TotalProducts = (SELECT COUNT(*) FROM products)
--Với điều kiện truy vấn trả về giá trị đơn
SELECT @TotalProducts

--5. Vì sao lại cần sử dụng biến ?
--> Dynamic Query: Truy vấn động

DECLARE @StartDate Date = '2016-02-01';
DECLARE @EndDate Date = '2016-02-28';

SELECT * 
FROM orders
WHERE order_date BETWEEN CAST(@StartDate AS date) AND CAST(@EndDate AS date)

--> Lập trình logic )Bài học sau


--6. Khối lệnh
--{ == BEGIN
--} == END


--7. IF ELSE
/*
Cho biến n = 5
- Nếu n > 0: thì in ra n là số Dương
- Còn lại là số âm.
if(n>0){
	console.log('Dương')
}else {
	console.log('Âm')
}
*/
DECLARE @n INT = -5;
IF (@n > 0)
	BEGIN
		PRINT N'Dương'
	END
ELSE
	BEGIN
		PRINT N'Âm'
	END

--8. Vòng lặp WHILE

DECLARE @counter INT = 1;

WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

DECLARE @b INT = 0;

WHILE @b <= 5
BEGIN
    SET @b = @b + 1;
    IF @b = 4
        BREAK; -- Bỏ qua những lệnh phía sau nó, thoát vòng lặp
    PRINT @b;
END


DECLARE @i int = 1
WHILE @i <= 10 BEGIN
    IF @i = 5 
		BEGIN
			GOTO label -- Nhảy đến vị trí chỉ định và chạy tiếp dòng lệnh
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
WAITFOR TIME '18:49:00';
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ đến 18:49:00';


--hàm
ALTER FUNCTION udsf_getFullname(
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50)
)
RETURNS NVARCHAR(100)
AS
BEGIN
	--Logic xử lý
	DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' - ' + @LastName
	--Return về giá trị đơn
    RETURN @FullName
END


SELECT dbo.udsf_getFullname(first_name, last_name) AS full_name FROM customers
SELECT dbo.udsf_getFullname(first_name, last_name) AS full_name FROM staffs

CREATE OR ALTER FUNCTION udtf_GetProducts(
	@ModelYear SMALLINT
)
RETURNS TABLE
AS
RETURN
(
SELECT 
 p.*,
 b.brand_name,
 c.category_name
FROM products AS p
LEFT JOIN brands AS b ON b.brand_id = p.brand_id
LEFT JOIN categories AS c ON c.category_id = p.category_id
WHERE p.model_year = @ModelYear
)

SELECT * FROM dbo.udtf_GetProducts(2022)


SELECT * FROM orders


SELECT  
	order_id,
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status
FROM    
    dbo.orders



SELECT 1/0 -- Chia một số cho 0

/**
try{
	1/0
}
catch {
 consle.log(error)
}

*/

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


--> Chủ động ném lỗi
DECLARE @z INT = 0;
IF @z = 0
	BEGIN
		THROW 50000, 'Nhập vào số lớn không', 1
	END


SELECT * FROM users

BEGIN
	BEGIN TRY
		--Ví dụ dữ liệu lấy được từ form login bên frontend gửi lên
		DECLARE @email varchar(160) =  'admin@example.com';
		DECLARE @password varchar(160) =  '1234';
		--Truy vấn
		IF EXISTS (SELECT * FROM dbo.users WHERE email = @email)
			BEGIN
				IF EXISTS (SELECT * FROM dbo.users WHERE email = @email AND password = @password)
					BEGIN
						print N'Login thành công'
					END
				ELSE
					BEGIN
						THROW 50000, N'Thông tin không hợp lệ', 1
					END

			END
		ELSE
			BEGIN
				THROW 50000, N'Thông tin không hợp lệ', 1
			END

	END TRY
	BEGIN CATCH
		THROW 50000, N'Thông tin không hợp lệ', 1
	END CATCH
END