--Khai báo biến
DECLARE @my_name NVARCHAR(20) = 'Nhân'
--product_name NVARCHAR(255)
DECLARE @brand_id INT = 9
SELECT * FROM dbo.products
WHERE brand_id = @brand_id

DECLARE @last_name NVARCHAR(255) = 'Burks'
SELECT * FROM dbo.customers
WHERE last_name = @last_name

DECLARE @product_count INT;
-- Định biến mà chưa gán giá trị
-- Sử dụng từ khóa SET để gán giá trị
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        dbo.products 
);
SELECT @product_count
PRINT @product_count

-- Synonyms ?
SELECT * FROM dbo.sales_summary
CREATE SYNONYM ss
FOR dbo.sales_summary;
SELECT * FROM dbo.ss

-- Các câu lệnh trong T-SQL
-- Khối lệnh ?
BEGIN
	SELECT * FROM dbo.ss
END

-- if else

--if(number > 0){
--	console.log('so duong)
--}
DECLARE @number INT = -1
IF @number > 0
BEGIN
	PRINT('So duong')
END
ELSE
BEGIN
	PRINT('So am')
END

-- While
--var counter = 1
--while (counter < =5) {
--  console.log(counter)
-- counter++
--}

DECLARE @counter INT = 1;
WHILE @counter <= 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE; --Tiếp tục vòng lặp, bỏ qua câu lệnh sau nó
    PRINT @counter;
END

-- GOTO
DECLARE @i int = 1
WHILE @i <= 10 
BEGIN
    IF @i = 5 
	BEGIN
        GOTO label
    END
	---
    PRINT @i
    SET @i = @i + 1
END
-- bên ngoài vòng lặp while
label:
PRINT 'Done'

-- WAIT FOR

-- Câu lệnh thứ nhất
SELECT GETDATE() AS 'Thời gian hiện tại';

-- Chờ 10 giây
WAITFOR DELAY '00:00:10';

-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ 10 giây';

-- FUNCTIONS
-- String Function
-- CONCAT
SELECT CONCAT(first_name, ' ', last_name) FROM dbo.customers

-- Tạo một function
CREATE FUNCTION tinh_tong(@a INT, @b INT) 
RETURNS INT AS
BEGIN
	RETURN (@a + @B)
END

SELECT dbo.tinh_tong(2,5)

-- Tạo hàm đẻ lấy tổng số sản phẩm đang có
ALTER FUNCTION dbo.udsf_getTotal()
RETURNS INT AS
BEGIN
	DECLARE @totals INT;
	SET @totals = (SELECT COUNT(product_id) FROM dbo.products)
	RETURN @totals
END

SELECT dbo.udsf_getTotalProducts()

DROP FUNCTION dbo.udsf_getTotalProducts

-- TABLE-VALUE FUNCTION
CREATE FUNCTION udsf_getProductInfo()
RETURNS TABLE
AS
RETURN
(
SELECT
	p.*,
	c.category_name
FROM dbo.products AS p
LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id
)

SELECT product_name FROM dbo.udsf_getProductInfo()
WHERE price > 2000

-- Lấy thông tin của khách hàng có customer_id = 5
-- Lấy thông tin của khách hàng có customer_id = 10
-- Lấy thông tin của khách hàng có customer_id = 15
CREATE FUNCTION udtf_getCustomerInfo(@customer_id INT)
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM dbo.customers WHERE customer_id = @customer_id
)

SELECT * FROM dbo.udtf_getCustomerInfo(1)

---
SELECT 
	order_id,
	CASE order_status
		WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
	END AS order_status
FROM dbo.orders

SELECT 
 order_id,
 COALESCE(shipping_city, 'No city')
FROM dbo.orders

--SESSIION 15
--try{
--}
--catch (){
--}
BEGIN TRY


END TRY



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