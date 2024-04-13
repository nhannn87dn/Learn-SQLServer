-- Cach khai bao bien
DECLARE @tenbien nvarchar(50); 
-- định nghĩa biến, nhưng chưa gán giá trị
-- Giá giá trị cho biến
SET @tenbien = N'Nhân';

--Để debug, in ra giá trị của biến
PRINT(@tenbien)
--Trả về giá trị của biến
SELECT @tenbien;
----------------------
DECLARE @product_count INT;
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        dbo.products 
);
SELECT @product_count;

--Đưa biến vào trong các câu lệnh truy vấn
--Ex1: Lấy ds sản phẩm có model_year = 2018
DECLARE @ModelYear SMALLINT = 2017; 
--vừa khai báo biến, vừa gán giá trị cho biến
SELECT
 *
FROM dbo.products
WHERE model_year = @ModelYear;

-- Khai báo nhiều biến cùng lúc
DECLARE 
	@LastName NVARCHAR(30) = 'Tom', 
	@FirstName NVARCHAR(20) = 'Han', 
	@StateProvince NCHAR(2) = 'UK';

PRINT(CONCAT(@LastName, '-', @FirstName,'-', @StateProvince))

-- gán giá trị cho biến khi truy vấn
DECLARE
	@lname NVARCHAR(30), 
	@fname NVARCHAR(20);
SELECT
	@fname = first_name,
	@lname = last_name
FROM dbo.customers WHERE customer_id = 1;
SELECT @fname AS fname, @lname AS lname;
--Với điều kiện là sELECT phải trả về 1 records

--================Synonyms===========
CREATE TABLE t_hrs_thong_tin_nhan_vien (
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(50) NOT NULL
)
INSERT t_hrs_thong_tin_nhan_vien
(Name)
VALUES
('Apple'),('Samsung'),('Xiaomi')
SELECT * FROM t_hrs_thong_tin_nhan_vien
--Cách khai báo
CREATE SYNONYM ttnv FOR dbo.t_hrs_thong_tin_nhan_vien;
--Tạo tên gắn gọn 'ttnv' ==> cho table t_hrs_thong_tin_nhan_vien
SELECT * FROM ttnv

--=========== Các câu lệnh trong T-SQL =============
--1. BEGIN END =  Khối lệnh
BEGIN --{ ==> Mở khối
	SELECT * FROM dbo.brands; --=> câu lệnh bên trong khối
END --} ==> đóng khối

--2.  IF...ELSE
DECLARE @age SMALLINT = 16;
IF @age > 18
BEGIN
	PRINT('Duoc lai xe');
END
ELSE
BEGIN
	PRINT('khong duoc lai xe');
END

--WHILE loop
DECLARE @counter INT = 1;

WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

---BREAK

DECLARE @c INT = 0;
WHILE @c <= 5
BEGIN
    SET @c = @c + 1;
    IF @c = 4
        BREAK; -- Bỏ qua những lệnh phía sau nó, thoát khỏi vòng lặp
    PRINT @c;
END

-- CONTINUE
DECLARE @d INT = 0;
WHILE @d < 5
BEGIN
    SET @d = @d + 1;
    IF @d = 3
        CONTINUE; -- bỏ qua câu lệnh sau nó, tiếp tục vòng lặp
    PRINT @d;
END

-- GOTO
DECLARE @i int = 1;
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
PRINT 'Done';
--=> GOTO nhảy tới vị trí label đã chỉ định 
--và thực thi các câu lệnh tiếp theo

-- WAITFOR
-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ 10 giây
WAITFOR DELAY '00:00:10'; --> chờ sau 10s mới thực hiện câu lệnh tiếp theo
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ 10 giây';

-- WAITFOR TIME
-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';
-- Chờ 10 giây
WAITFOR TIME '19:22:00'; --> hẹn đến đúng time đó thì thực thi tiếp câu lệnh phía sau
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ 10 giây';

--========== Functions ============
-- 1. Scalar Valued Function -- hàm trả về giá trị đơn
SELECT
	customer_id,
	dbo.udsvf_GetFullName(first_name, last_name) as full_name
FROM dbo.customers;
--Thay bằng hàm
ALTER FUNCTION udsvf_GetFullName
(	
	--Tham số đầu vào
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
)
RETURNS nvarchar(105) --Output
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' - ' + @LastName
    RETURN @FullName
END

--thay đổi cấu trúc function

-- TABLE VALUED FUNCTION --> output là một table

CREATE FUNCTION dbo.udtvf_PromotionProducts()
RETURNS TABLE -- return về một Table
AS
RETURN
(
    SELECT *
    FROM dbo.products
    WHERE discount > 0
)
-- sử dụng
SELECT * FROM dbo.udtvf_PromotionProducts()
--> udtvf_PromotionProducts được dùng như một table

-- Lấy cho tôi thông chi tiết đơn hàng có id = 1
CREATE FUNCTION udtvf_getOrderById(@cusomer_id INT)
RETURNS TABLE
AS
RETURN
(
	SELECT
		o.*,
		c.first_name,
		c.last_name
	FROM dbo.orders AS o
	INNER JOIN dbo.customers AS c 
		ON c.customer_id = o.customer_id
	WHERE o.customer_id = @cusomer_id
)
-- cách dùng
DECLARE @CustomerID INT = 1;
SELECT * FROM dbo.udtvf_getOrderById(@CustomerID)

--========== HÀM THỜI GIAN -----------
SELECT GETDATE() -- ngày hiện tại
SELECT CURRENT_TIMESTAMP

SELECT DAY(GETDATE()) --> ngày của ngày hiện tại
SELECT MONTH(GETDATE()) --> tháng của ngày hiện tại
SELECT YEAR(GETDATE()) --> năm của ngày hiện tại
--Biết 1 người sinh ngày 22-12-1988 --> đến nay bao nhiêu 
-- DATEDIFF( date_part , start_date , end_date)
DECLARE @StartDate DATE = CAST('1988-12-22' AS DATETIME) --> lưu ý YYYY-mm-dd
DECLARE @EndDate DATE = GETDATE()
SELECT DATEDIFF(year, @StartDate, @EndDate) AS age --> số tuổi

--============ STRING ==========
-- CONCAT nối chuỗi
-- LOWER --> convert chữ thường
-- UPPER --> conver HOA
-- REPLACE --> để thay thế chuỗi
-- TRIM --> loại bỏ kí tự trống trước và cuối chuỗi

--========= MATH ===
-- RAND --> tạo giá ngẩu nhiên
-- ROUND --> làm tròn

-- ========= SYSTEM FUNCTION
-- CAST --> ép kiểu dữ liệu
-- Ví dụ: Chuỗi thành kiểu ngày
SELECT CAST('1988-12-22' AS DATE)
-- Tím đơn hàng đặt hàng vào ngày 2016-03-16
SELECT * FROM dbo.orders WHERE order_date = CAST('2016-03-16' AS DATE)
--CONVERT --> chuyển đổi kiểu dữ liệu
SELECT CONVERT(INT, 9.95) result; -- DECIMAL --> INT
SELECT CONVERT(DATETIME, '2019-03-14') result; --VARCHAR --> DATETIME


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
WHERE 
    YEAR(order_date) = 2018

	SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;
--Kết quả: Hi

--============ SESSION 15 Error Handing =================

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
    PRINT('Raise the caught error again');
    THROW;
END CATCH
