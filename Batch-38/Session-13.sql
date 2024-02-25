--Khai báo biến, chư9999999a gán giá trị
DECLARE @model_year SMALLINT;
--DECLARE @model_year SMALLINT = 2016;
--gán giá trị cho biến
SET @model_year = 2018;
--truy cập đến giá trị của biến
--SELECT @model_year
-- debug giá trị của biến
--PRINT @model_year

--ví dụ: lấy ra sản phẩm có model_year = 2016
SELECT * FROM dbo.products WHERE model_year = @model_year

--biến = kết quả của một câu lệnh truy vấn
DECLARE @product_count INT;
SET @product_count = (SELECT COUNT(product_id) FROM tp);
SELECT @product_count

--rút gọn tên table với SYNONYM
CREATE SYNONYM tp
FOR dbo.products;

--Khối lệnh
BEGIN
SELECT * FROM tp
SELECT * FROM categories
END

BEGIN
    SELECT
        product_id,
        product_name,
		price
    FROM
        dbo.products
    WHERE
        price > 20000;

    IF @@ROWCOUNT = 0
        -- In giá trị ra cửa sổ message
        PRINT 'No product with price greater than 20000 found';
END

if(a > 3) {
	console.log('yes')
}
else{
	console.log('no')
}

DECLARE @a INT = 5;

IF @a > 3
BEGIN
	PRINT 'yes'
END
ELSE
BEGIN
	PRINT 'no'
END


BEGIN
    DECLARE @sales INT;

    SELECT 
        @sales = SUM(price * quantity)
    FROM
        dbo.order_items AS i
        INNER JOIN dbo.orders o ON o.order_id = i.order_id
    WHERE
        YEAR(order_date) = 2018;

    SELECT @sales;

    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
    END
    ELSE
    BEGIN
        PRINT 'Sales amount in 2018 did not reach 1,000,000';
    END
END


BEGIN
    DECLARE @x INT = 10,
            @y INT = 20;

    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 and x < y';
        ELSE
            PRINT 'x > 0 and x >= y';
    END			
END

--WHILE

DECLARE @counter INT = 1;

WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

DECLARE @c INT = 0;

WHILE @c <= 5
BEGIN
    SET @c = @c + 1; 
    IF @c = 4
        --BREAK; -- Bỏ qua những lệnh phía sau nó, thoát khỏi vòng lặp
		CONTINUE; --Tiếp tục vòng lặp
    PRINT @c;
END

--GOTO
DECLARE @i int = 1
WHILE @i <= 10 
BEGIN
    IF @i = 5 
	BEGIN
        GOTO label --nó thoát khỏi vòng lặp, nhảy đến vị trí label
    END
    PRINT @i
    SET @i = @i + 1
END --het vong lap while
label:
PRINT 'Done'

PRINT 'Start';
WAITFOR DELAY '00:00:30'; --Dừng 30s rồi chạy lệnh Sau nó
PRINT 'End';

/*
function getFullName(first_name : string, last_name: : string): string
{
	return first_name + last_name
}
getFullName(first_name,last_name)
*/
CREATE FUNCTION udsf_GetFullName
(
    @firstName nvarchar(50),
    @lastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @firstName + ' ' + @lastName
    RETURN @FullName
END

DROP FUNCTION dbo.udsf_GetFullName

SELECT 
	customer_id, 
	--first_name + ' ' + last_name AS fullname 
	dbo.udsf_GetFullName(first_name,last_name) as fullname
FROM dbo.customers

SELECT * FROM order_items


CREATE FUNCTION udsf_GetAmountProduct(@Price money, @Discount decimal(18, 2), @Quantity decimal(18, 2))
RETURNS decimal(18, 2)
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END

SELECT order_id, product_id, dbo.udsf_GetAmountProduct(price, discount, quantity) AS total_amount
FROM dbo.order_items

SELECT
 order_id,
 SUM(dbo.udsf_GetAmountProduct(price, discount, quantity)) as Total
FROM 
	order_items
GROUP BY 
	order_id
ORDER BY 
	order_id
CREATE FUNCTION udtf_ProductInfo()
RETURNS TABLE 
AS
RETURN
(
SELECT
	p.*,
	c.category_name
FROM dbo.products AS p
LEFT JOIN
	dbo.categories AS c ON c.category_id = p.category_id 
)

SELECT * FROM dbo.udtf_ProductInfo()

--CASE
SELECT 
	order_id, 
	CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status  
FROM 
	orders

SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;

SELECT * FROM 
    dbo.stores
UPDATE dbo.stores SET phone = NULL WHERE store_id = 3

SELECT 
    store_id, 
    store_name, 
    COALESCE(phone,'') AS phone, 
    email
FROM 
    dbo.stores
ORDER BY 
    store_id; 
