--cau 8:
SELECT 
c.*,
(SELECT COUNT(product_id) FROM dbo.products p WHERE p.category_id = c.category_id) AS total
FROM categories AS c

SELECT * FROM orders
SELECT * FROM order_items
-- cau 10
SELECT * FROM dbo.products WHERE product_id IN (
SELECT 
	oi.product_id
FROM dbo.order_items AS oi
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
WHERE o.order_status = 4 AND o.order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-01-30' AS DATE)
)

---SESSIOn 13
--1. Khai bao bien
--Cu phap: DECLARE @<ten_bien> <Data_type> [= Value];
--Vi du:

DECLARE @MyName NVARCHAR(50) = N'Nhân'; -- định nghĩa biến đồng thời gán giá trị cho biến
DECLARE @MyAge SMALLINT; -- Định nghĩa biến nhưng chưa gán giá trị
--gán giá trị mới cho biến
SET @MyAge = 38;

--Ouput giá trị của biến
SELECT @MyName, @MyAge
--hoặc để xem , debug giống như console.log bên javascript
PRINT @MyName
--Cho phép khai báo nhiều biến cùng lúc với từ khóa DECLARE
DECLARE @ModelYear	SMALLINT	=	2018,
		@BrandId	INT			=	2; --Kết thúc bằng dấu ;

--Sử dụng biến: 
-- Sử dụng trong biểu thức tính toán
DECLARE @x	SMALLINT	=	6,
		@y	SMALLINT	=	2;
SELECT @x + @y;
-- Sử dụng trong câu lệnh truy vấn
DECLARE @ModelYearV2	SMALLINT	=	2018;
SELECT * FROM dbo.products WHERE model_year = @ModelYearV2
--> Nếu sử dụng biến thì có thể Dynamic query

--> Có thể gán giá trị cho biến = một kết quả truy vấn --> trả lại scalar-value (giá trị đơn)
DECLARE @TotalProduct SMALLINT;
SET @TotalProduct = (
SELECT 
        COUNT(*) 
    FROM 
        dbo.products 
)
SELECT @TotalProduct

-- KHối lệnh
BEGIN --{
	SELECT * FROM categories
END --}
--IF ELSE
/*
const z = 4
if(z >0){
	console.log(z la so duong)
}
*/
DECLARE @z SMALLINT = 4;
IF (@z > 0)
BEGIN
	PRINT N'Z la so duong'
END

/*
const z = 4
if(z >0){
	console.log(z la so duong)
}
else{
console.log(z la so am)
}
*/

DECLARE @i INT = -1;
IF (@i > 0)
	BEGIN
		PRINT N'i la so duong'
	END
ELSE
	BEGIN
		PRINT N'i la so am'
	END

CREATE TABLE users (
 id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 email VARCHAR(255) NOT NULL,
 password VARCHAR(255) NOT NULL,
)

INSERT users
(email, password)
VALUES
('nhannn@softech.vn', '123456')

DECLARE  @Email VARCHAR(255)  = 'nhannn@softech.vn',
		@Password VARCHAR(255)  ='12345678';

--- IF EXISTS --> trả về TRUE nếu query có kết quả
IF EXISTS (SELECT * FROM users WHERE email = @Email AND password = @Password)
	BEGIN
		PRINT 'Login is successfully !'
	END	
ELSE
	BEGIN
		PRINT 'Email or passowrd invalid'
	END

--WHILE
DECLARE @counter INT = 1;

WHILE (@counter <= 5)
	BEGIN
		PRINT @counter; -- in ra giá trị hiện tại 
		SET @counter = @counter + 1; -- tăng lên 1 đơn vị
	END

DECLARE @b INT = 0;
WHILE @b <= 5
	BEGIN
		SET @b = @b + 1;
		IF @b = 4
			BREAK; -- Bỏ qua những lệnh phía sau nó, thoát khỏi vòng lặp
		PRINT @b;
	END

DECLARE @c INT = 0;
WHILE @c < 5
BEGIN
    SET @c = @c + 1;
    IF @c = 3
        CONTINUE; --Tiếp tục vòng lặp, bỏ qua câu lệnh sau nó
    PRINT @c;
END

--> Sử dụng vòng lặp ĐIỀU QUAN TRỌNG --> THIẾT LẬP THỜI ĐIỂM KẾT THÚC VÒNG LẶP
--> nẾU KO thì nó lặp vô hạn --> TREO Máy

DECLARE @j int = 1
WHILE @j <= 10 
	BEGIN
		IF @j = 5 
			BEGIN
				GOTO label
			END
		PRINT @j
		SET @j = @j + 1
	END
label:
PRINT 'Done'


-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ 10 giây
WAITFOR DELAY '00:00:10'; --> đếm ngược
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ 10 giây';

-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ đến thời điểm 19:46:00
WAITFOR TIME '19:46:00'; --hẹn giờ
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ đến 19:46:00';


--FUNCTION
SELECT 
	customer_id,
	first_name + ' ' + last_name AS full_name, --logic tao fullname
	phone,
	email
FROM dbo.customers


SELECT 
	staff_id,
	first_name + ' ' + last_name AS full_name, --logic tao fullname
	phone,
	email
FROM dbo.staffs

/**
function udsf_getFullname(first_name, lastname) {
	return first_name + ' ' + last_name
}
udsf_getFullname('nhan', 'nguyen')
*/

CREATE FUNCTION udsf_getFullname(@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
RETURNS nvarchar(101) -- khai báo kiểu dữ liệu của giá trị trả về
AS
BEGIN
	DECLARE @FullName nvarchar(101)
    SET @FullName = @FirstName + ' - ' + @LastName
    RETURN @FullName
END

SELECT 
	staff_id,
	dbo.udsf_getFullname(first_name, last_name) AS full_name, --gọi hàm
	phone,
	email
FROM dbo.staffs

drop FUNCTION udsf_getFullname

/*
Khi nào áp dụng scalar-value function: Khi cần tạo hàm tiện ích
để trả về một giá trị đơn
*/

-- table-value function --> trả lại một bảng dữ liệu
---> Lấy danh sách sp bán được theo khoảng ngày

CREATE FUNCTION udtf_getSoldProductsByRangeOrderDate(
	@StartDate DATE,
	@EndDate DATE
)
RETURNS TABLE -- return về một Table
AS
RETURN
(
    SELECT * FROM dbo.products WHERE product_id IN (
SELECT 
	oi.product_id
FROM dbo.order_items AS oi
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
WHERE o.order_status = 4 AND o.order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
)
)
--- sử dụng hàm
DECLARE @StartDate DATE = '2018-01-01',
		@EndDate DATE= '2018-01-30';
SELECT * FROM dbo.udtf_getSoldProductsByRangeOrderDate(@StartDate, @EndDate)

-- Error Handing


BEGIN
    BEGIN TRY
        SELECT 4/2 -- Chia một số cho 0
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
    PRINT('Raise the caught error again');
    THROW;
END CATCH


SELECT * FROM order_items