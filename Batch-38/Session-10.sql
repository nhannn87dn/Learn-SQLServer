CREATE VIEW dbo.v_daily_sales
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

SELECT * FROM dbo.products WHERE product_id = 8
SELECT * FROM dbo.v_daily_sales

UPDATE dbo.v_daily_sales SET discount=0.04 WHERE product_id = 8

EXEC sp_helptext [v_daily_sales];

--PR
--Sử dụng từ khóa CREATE PROCEDURE
ALTER PROCEDURE usp_ProductList
AS
BEGIN
    BEGIN TRY
        SELECT 
            product_name, 
            price
        FROM 
            dbo.products
        ORDER BY 
            product_name;
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

EXECUTE usp_ProductList

--PROC có tham số đầu vào như Function
ALTER PROCEDURE usp_FindProductsByModelYear(@model_year INT)
AS
BEGIN
    BEGIN TRY
        SELECT
            product_name,
			model_year,
            price
        FROM 
            dbo.products
        WHERE
            model_year >= @model_year
        ORDER BY
            price;
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
--Sử dụng Store khi có tham số
EXECUTE usp_FindProductsByModelYear 2019;


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

EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-12-30', @TotalOrders OUTPUT;

SELECT @TotalOrders as TotalOrders;

SELECT * FROM orders


CREATE PROCEDURE usp_CheckOrderStatus(@OrderId INT)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM dbo.orders WHERE order_id = @OrderId)
        RETURN 1 -- Order exists
    ELSE
        RETURN 0 -- Order does not exist
END;

DECLARE @Status INT
EXEC @Status = usp_CheckOrderStatus 1
SELECT @Status as Status

