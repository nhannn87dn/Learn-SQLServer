CREATE VIEW v_view_products
AS 
SELECT
	product_id,
	product_name,
	model_year,
	discount,
	description
FROM
	products

--> v_products --> được gọi 1 table ảo

--Nếu là 1 table thì có thể làm gì ?
--SELECT
SELECT * FROM v_products
-- UPDATE
UPDATE v_products SET discount = 0.2 WHERE product_id = 1
-- INSERT , DELETE

CREATE VIEW v_AllProducts
WITH SCHEMABINDING
AS (
SELECT 
 p.product_id,
p.product_name,
p.model_year,
p.discount,
p.description,
 c.category_name,
 b.brand_name
FROM products AS p
LEFT JOIN categories AS c ON c.category_id = p.category_id
LEFT JOIN brands AS b ON b.brand_id = p.brand_id)


SELECT * FROM v_AllProducts

DROP VIEW IF EXISTS v_products

--Tác dụng view là ? Bảo mật thông tin nhạy cảm có ở trong table gốc


SELECT * FROM sys.views



ALTER VIEW dbo.v_daily_sales
WITH SCHEMABINDING, ENCRYPTION -- ràng buộc cấu trúc với các table tham chiếu
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;


SELECT * FROM dbo.v_daily_sales;

EXEC sp_helptext [v_daily_sales];


EXEC sp_helptext [v_view_products];

EXEC sp_rename 'products.discount', 'discounts', 'COLUMN';



CREATE VIEW dbo.v_daily_sales_check
AS
SELECT
    p.product_id,
    p.product_name,
    p.discount,
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id
WHERE p.discount > 0.05 -- Nếu không thõa mãn WHERE thì VIEW sẽ không chạy được
WITH CHECK OPTION;

SELECT * FROM v_daily_sales_check

UPDATE v_daily_sales_check SET discount = 0.01 WHERE product_id = 20;

UPDATE products SET discount = 0.01 WHERE product_id = 20;





--1 kế hoạch thực thi


CREATE PROCEDURE usp_dailysale -- đặt tên với prefix usp_
AS
BEGIN
    BEGIN TRY
        SELECT
			p.product_id,
			p.product_name, p.discount,
			year(order_date) AS y,
			month(order_date) AS m,
			day(order_date) AS d,
			(i.quantity * i.price) AS sales
		FROM
			dbo.orders AS o
		INNER JOIN dbo.order_items AS i
			ON o.order_id = i.order_id
		INNER JOIN dbo.products AS p
			ON p.product_id = i.product_id;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        --Ném lỗi
        THROW;
    END CATCH;
END;

EXEC dbo.usp_dailysale

CREATE PROC udsp_getOrderByDates(
 @StartDate Date,
 @EndDate Date
)
AS
BEGIN
	SELECT * FROM orders
	WHERE order_date BETWEEN @StartDate AND @EndDate
END


EXEC dbo.udsp_getOrderByDates '2016-02-01', '2016-02-28' 



CREATE PROCEDURE usp_TotalOrderByRangeDate (
    @FromDate DATETIME, --tham số đầu vào
    @ToDate DATETIME, --tham số đầu vào
    @Total INT OUTPUT --Tham số đầu ra OUTPUT
)
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE CAST(order_date AS DATE)  BETWEEN @FromDate AND @ToDate
END;


DECLARE @TotalOrders INT;

EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-30', @TotalOrders OUTPUT;

SELECT @TotalOrders as TotalOrders;