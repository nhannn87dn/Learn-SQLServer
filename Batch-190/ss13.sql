--Homeword D
--1.
SELECT 
p.product_id,
p.product_name,
p.price,
c.category_name
FROM dbo.products AS p
LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id 
--4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
SELECT * FROM dbo.products AS p
LEFT JOIN dbo.stocks AS s ON s.product_id = p.product_id
WHERE s.quantity <= 5
--10. Hiển thị tất cả các sản phẩm được bán trong khoảng từ ngày, đến ngày
SELECT
oi.product_id,
p.product_name,
o.order_date,
oi.price, 
oi.quantity
FROM dbo.order_items AS oi
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
INNER JOIN dbo.products AS p ON p.product_id = oi.product_id
WHERE order_date >= CAST('2016-01-01' AS DATE) 
		AND order_date <= CAST('2016-01-05' AS DATE)

-- SESSION 13
-- Khai báo Biến
DECLARE @MyName NVARCHAR(50) -- Khai báo biến với kiểu dữ liệu
--Chưa cần gán giá trị
DECLARE @MyAge TINYINT = 36;-- Khái báo biến  = giá trị cụ thể
-- Gán giá trị cho biến
SET @MyName = 'Nhan';
--Làm sao để in biến ra
PRINT @MyName;
-- Sử dụng biến
SELECT @MyName as my_name
--Sử dụng biến trong câu lệnh truy vấn
DECLARE @ModelYear SMALLINT = 2026;
SELECT * FROM dbo.products WHERE model_year = @ModelYear
-- Có thể gán giá trị cho biến = một kết quả của câu lệnh truy vấn
DECLARE @ProductCount SMALLINT =
(SELECT COUNT(product_id) FROM dbo.products);
SELECT @ProductCount AS count;
-- Khái báo nhiều biến cùng lúc
DECLARE @name NVARCHAR(50),
		@age INT;

CREATE TABLE SUNSHINE_Customer_Customer_Customer (
	id INT,
	name NVARCHAR(50)
)
INSERT SUNSHINE_Customer_Customer_Customer
(id, name)
VALUES 
(1, 'Nhan'),
(2, 'Jonh')
SELECT * FROM sccc;

CREATE SYNONYM sccc
FOR dbo.SUNSHINE_Customer_Customer_Customer;

-- KHỐI LỆNH
--if(a > n){
--	--khoi lenh js
--}
BEGIN
	SELECT * FROM dbo.products
END

-- Nếu mà level khách hàng = VIP thì discount 5%
--discount = 0;
--if(level === 'vip'){
--	discount = 5;
--}

DECLARE @level NVARCHAR(20) = 'vip';
DECLARE @OrderAmout INT = 5000;
DECLARE @discount TINYINT;
-- Nếu là vip và tổng giá trị đơn  hàng > 5000 thì giảm 5%
IF @level = 'vip' AND @OrderAmout >= 5000  -- so sánh
	BEGIN
		SET @discount = 5;
	END
ELSE
	BEGIN
		SET @discount = 0;
	END
SELECT @discount as discount;
--if else


DECLARE @Number INT;
SET @Number = 50;

IF @Number > 100
    PRINT 'The number is large.';
ELSE
BEGIN
    IF @Number < 10
        PRINT 'The number is small.';
    ELSE
        PRINT 'The number is medium.';
END;
GO


DECLARE @counter INT = 0;

WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE; --Tiếp tục vòng lặp, bỏ qua câu lệnh sau nó
    PRINT @counter;
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
WAITFOR TIME '19:59:00';
-- Câu lệnh thứ hai
SELECT GETDATE() AS 'Thời gian sau khi chờ đến 19:59:00';


-- Viết một hàm trả tổng số sản phẩm đang có
SELECT 
customer_id,
dbo.udsf_getFullName(first_name, last_name) AS full_name
FROM customers

CREATE FUNCTION udsf_getFullName(
	@FirstName NVARCHAR(20),
	@LastName NVARCHAR(20)
)
RETURNS NVARCHAR(41)
AS
BEGIN
	DECLARE @FullName NVARCHAR(41);
    SET @FullName = @FirstName + ' ' + @LastName;
    RETURN @FullName;
END

SELECT 
order_id,
product_id,
dbo.udsf_getTotalAmout(quantity,price, discount) AS amount
FROm order_items

ALTER FUNCTION udsf_getTotalAmout(
	@quantity SMALLINT,
	@price DECIMAL(18,2),
	@discount DECIMAL(4,2)
)
RETURNS DECIMAL(18,2) 
AS
BEGIN
	DECLARE @TotalAmout DECIMAL(18,2) = (@quantity * @price * (1 - @discount));
	RETURN @TotalAmout;-- trả về 1 giá trị đơn = scalar 
END
-- table valued function
-- Ví bạn cần lấy danh sách sp bán ra từ ngày x - ngày y
CREATE FUNCTION udtf_getProductsByArangeDate(
	@BeginDate DATE,
	@EndDate DATE
)
RETURNS TABLE
AS
RETURN
(SELECT
oi.product_id,
p.product_name,
o.order_date,
oi.price, 
oi.quantity
FROM dbo.order_items AS oi
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
INNER JOIN dbo.products AS p ON p.product_id = oi.product_id
WHERE order_date >= CAST(@BeginDate AS DATE) 
		AND order_date <= CAST(@EndDate AS DATE))
-- trả về 1 tablet --> nên sử dụng hàm như một table bình thường
SELECT * FROM dbo.udtf_getProductsByArangeDate(
	'2016-01-01',
	'2016-01-06'
)
WHERE quantity >= 2 --- có thể where được
ORDER BY product_id ASC -- có thể orderby bình thường

SELECT
order_id,
	CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status,
order_date
FROM orders
--4 Completed --> hoàn thành
--3 Rejected --> hủy
--2 Processing -- đang xử lý
--1 Pending -- chưa xác nhận

SELECT 
    order_id,
	COALESCE(shipping_city,'') AS shipping_city
FROM 
    dbo.orders

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
