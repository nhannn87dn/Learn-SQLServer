--Cách khai báo biến

DECLARE @pid INT; -- định nghĩa biến và kiểu dữ liệu của biến
SET @pid = 5; --gán giá trị cho biến

--Tìm sản phẩm có product_id = 5
SELECT * FROM dbo.products WHERE product_id = @pid;

DECLARE @prid INT = 10;-- vừa định nghĩa biến, vừa gán giá trị cho biến
SELECT * FROM dbo.products WHERE product_id = @prid;

--@ProductId --> Pascal case
--@product_id --> snake cacke
--@productId --> camel cacke
DECLARE @DECLARE INT = 3;
SELECT @DECLARE

DECLARE @ProductCount INT = (SELECT 
    COUNT(*) 
FROM 
   dbo.products)

--SELECT @ProductCount -- in ra ở tab results
PRINT @ProductCount --in ra tab message

--Synonyms
SELECT * FROM [dbo].[customers]

CREATE SYNONYM ctm
FOR dbo.customers;

SELECT * FROM ctm

-- T-SQL
BEGIN
    SELECT * FROM ctm
	SELECT * FROM ctm WHERE customer_id = 2
END


IF Boolean_expression
BEGIN
    -- Statement block executes when the Boolean expression is TRUE
END
ELSE
BEGIN
    -- Statement block executes when the Boolean expression is FALSE
END

--Ví dụ:
BEGIN
	DECLARE @modelYear INT = 2024;
	DECLARE @isFound INT;
	--Tìm sản phẩm có model_year = 2024
	SELECT @isFound = COUNT(*) FROM products WHERE model_year = @modelYear;
	SELECT @isFound

	IF @isFound > 0
	BEGIN
		PRINT 'Co tim thay'
	END
	ELSE
	BEGIN
		PRINT 'Khong tim thay'
	END
END

--Vd2
DECLARE @level NVARCHAR(3) = 'VIP';

IF @level = 'VIP'
BEGIN
	PRINT 'Giam gia 10%'
END
ELSE
BEGIN
	PRINT 'Khong giam gia'
END

IF @level = 'GOLD'
BEGIN
	PRINT 'Giam gia 7%'
END

IF @level = 'SLIVER'
BEGIN
	PRINT 'Giam gia 2%'
END


DECLARE @age INT = 25

IF @age > 18
    PRINT 'Người trưởng thành'
ELSE
    PRINT 'Người chưa trưởng thành'

DECLARE @name NVARCHAR(50) = 'John'

IF @name = 'John'
BEGIN
    PRINT N'Họ tên là John'
	PRINT N'Họ tên là John'
END
ELSE
    PRINT N'Họ tên không phải John'



DECLARE @counter INT = 0;

WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE; --bỏ qua câu lệnh sau nó và Tiếp tục vòng lặp
    PRINT @counter;
END


DECLARE @i int = 1

WHILE @i <= 10 
BEGIN
    IF @i = 5 
	BEGIN
        GOTO label --> Nhảy ra đến địa điểm định sẳn, và tiếp tục thực hiện các lệnh tiếp theo
    END
    PRINT @i
    SET @i = @i + 1
END

label:
PRINT 'Done'


PRINT 'Start';
WAITFOR DELAY '00:00:05'; --Dừng 5s rồi chạy lệnh Sau nó
PRINT 'End';

-- Scalar Function
select first_name + ' ' + last_name as fullName FROM customers

-- định nghĩa hàm
CREATE FUNCTION [dbo].[getFullName] (
	@FirstName nvarchar(50), 
	@LastName nvarchar(50)
)
RETURNS nvarchar(100)
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END

select dbo.getFullName(first_name, last_name) as FullName FROM customers

select * from order_items

-- Sửa cấu trúc hàm
ALTER FUNCTION udsf_GetAmountProduct(
	@Price decimal(10, 2), 
	@Discount decimal(18, 2), 
	@Quantity decimal(18, 2)
)
RETURNS decimal(18, 2)
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END

SELECT *, dbo.udsf_GetAmountProduct(price, discount, quantity) AS total_amount
FROM dbo.order_items

--Xóa hàm
DROP FUNCTION udsf_GetAmountProduct;

-- lấy ra danh sách phẩm + tên của danh mục
CREATE FUNCTION udtf_GetProductsList()
RETURNS Table
AS
RETURN (
SELECT 
	p.*,
	c.category_name
FROM
	dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id
)

SELECT * FROM udtf_GetProductsList() WHERE product_id = 5

SELECT order_id, 
	CASE order_status 
		WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
	END AS order_status_text
FROM orders

SELECT order_id, 
	CASE  
		WHEN order_status = 1 THEN 'Pending'
        WHEN order_status = 2 THEN 'Processing'
        WHEN order_status = 3 THEN 'Rejected'
        WHEN order_status = 4 THEN 'Completed'
	END AS order_status_text
FROM orders

SELECT    
    o.order_id, 
    SUM(quantity * price) order_value,
    CASE
        WHEN SUM(quantity * price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * price) > 500 AND 
            SUM(quantity * price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * price) > 1000 AND 
            SUM(quantity * price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * price) > 5000 AND 
            SUM(quantity * price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    dbo.orders o
INNER JOIN dbo.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id;

SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;
--Kết quả: Hi
select * from stores WHERE phone IS NULL
UPDATE stores SET phone = NULL WHERE store_id = 3

select 
	store_id,
	store_name,
	COALESCE(phone, 'N/A')
from stores


SELECT NULLIF(10, 10) result; --=> NULL

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

RAISERROR('This is a custom error', 16, 1)

THROW 50000, 'This is a custom error', 1


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
    THROW 50000, 'Raise the caught error again', 1
END CATCH


SELECT 1/0
SELECT @@ERROR
SELECT ERROR_NUMBER() AS numbrt
SELECT  ERROR_SEVERITY() as ser
SELECT  ERROR_LINE() AS line
SELECT  ERROR_MESSAGE() as msg