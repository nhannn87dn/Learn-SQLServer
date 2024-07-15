-- Tạo view

CREATE VIEW v_getProducts 
as SELECT 
 product_id FROM dbo.products

EXEC sp_helptext v_getProducts

EXEC sp_rename 'products.model_years', 'model_year', 'COLUMN';

DROP VIEW dbo.v_getProducts

select * from dbo.products
select * from dbo.v_getProducts ORDER BY product_id DESC

UPDATE dbo.v_getProducts SET product_name = 'Trek 820 - 2024'
WHERE product_id = 1


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
WHERE p.discount > 0.05 -- Nếu không thõa mãn WHERE thì VIEW sẽ không chạy được
WITH CHECK OPTION;

SELECT * FROM dbo.v_daily_sales
UPDATE dbo.v_daily_sales SET discount = 0.01
WHERE product_id = 20

EXEC sp_helptext v_daily_sales

--########### STORE  ##############
--Sử dụng từ khóa CREATE PROCEDURE
CREATE PROCEDURE usp_ProductList -- đặt tên với prefix usp_
AS
BEGIN
    BEGIN TRY

        SELECT 
		 p.product_id,
		 p.product_name,
		 c.category_name
		FROM dbo.products AS p
		LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id
		
		
	
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

EXEC usp_ProductList


alter PROCEDURE usp_FindProductsByModelYear(@model_year INT)
AS
BEGIN
    BEGIN TRY
        SELECT
            product_name,
            price,
			model_year
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
EXEC usp_FindProductsByModelYear 2024;

CREATE PROCEDURE usp_TotalOrderByRangeDate (
    @FromDate DATETIME, --tham số đầu vào
    @ToDate DATETIME, --tham số đầu vào
    @Total INT OUTPUT --Tham số đầu ra OUTPUT
)
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE CAST(order_date AS DATE)  BETWEEN @FromDate AND @ToDate
END;

select * FROM DBO.orders

DECLARE @TotalOrders INT;

EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-15', @TotalOrders OUTPUT;

SELECT @TotalOrders as TotalOrders;


CREATE PROCEDURE ups_CheckOrderStatus
    @OrderId INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM orders WHERE order_id = @OrderId)
        RETURN 1 -- Order exists
    ELSE
        RETURN 0 -- Order does not exist
END;


DECLARE @Status INT
EXEC @Status = ups_CheckOrderStatus 1343434343
SELECT @Status as Status

EXEC sp_helptext N'dbo.ups_CheckOrderStatus'; 

-- Xem danh sach table cua database hien tai
SELECT * FROM sys.tables

SELECT * FROM sys.views

SELECT * FROM sys.procedures

