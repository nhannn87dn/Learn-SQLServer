--VIEW
CREATE VIEW dbo.view_customers
AS
SELECT 
	customer_id, first_name, last_name, email,birthday, street, city, zip_code
	, new_column
	--phone là private
FROM customers

--View được xem là 1 table ảo
SELECT * FROM dbo.view_customer
--Các dev SQL người ta chỉ được phép truy vấn trên view_cusomer
--Các dev SQL không được phéo truy cập customers

--View cho phép bạn update, insert, delete, ...
--và nó sẽ tham chiếu tới table thật
UPDATE dbo.view_customer
SET zip_code = 72141 WHERE customer_id = 1

SELECT * FROm customers

CREATE VIEW dbo.v_productCategorie
WITH SCHEMABINDING
AS
SELECT 
	p.product_id,
	p.product_name,
	p.brand_id,
	p.model_year,
	p.category_id,
	p.description,
	c.category_name,
	c.description AS category_description
FROM products AS p
LEFT JOIN categories AS c 
ON c.category_id = p.category_id

SELECT * FROM dbo.v_productCategorie 
ORDER BY product_id DESC

SELECT * FROM sys.views


ALTER VIEW dbo.v_daily_sales
WITH ENCRYPTION -- ràng buộc cấu trúc với các table tham chiếu
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

SELECT * FROM v_daily_sales

ALTER TABLE products
ALTER column discount DECIMAL(6,2) NOT NULL


EXEC sp_helptext 'view_customers';


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
 
SELECT * FROM v_daily_sales
UPDATE v_daily_sales SET discount = 0.01 WHERE product_id = 20

CREATE PROCEDURE usp_ProductList
-- đặt tên với prefix usp_
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

EXEC usp_ProductList


-- Với input - tham số đầu vào
ALTER PROCEDURE usp_FindProductsByModelYear(@model_year INT)
AS
BEGIN


SELECT
            product_name,
			model_year,
            price
        FROM
            dbo.products
        WHERE
            model_year > @model_year
        ORDER BY
            price
END;

--
EXEC usp_FindProductsByModelYear 2028


CREATE PROCEDURE GetOrderByID
    @OrderID INT
AS
BEGIN
    -- Kiểm tra nếu đơn hàng tồn tại
    IF EXISTS (SELECT 1 FROM orders WHERE order_id = @OrderID)
    BEGIN
        -- Lấy thông tin đơn hàng
        SELECT 
            order_id AS OrderID,
            customer_id AS CustomerID,
            order_date AS OrderDate,
            order_status AS OrderStatus,
            order_amount AS TotalAmount
        FROM orders
        WHERE order_id = @OrderID;
    END
    ELSE
    BEGIN
        -- Trả về thông báo lỗi
        SELECT 
            'Error' AS Status,
            'Order not found' AS Message;
    END
END

EXEC GetOrderByID 243656


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

EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-31', @TotalOrders OUTPUT;

SELECT @TotalOrders as TotalOrders;

SELECT * FROM orders


CREATE PROCEDURE ups_CheckOrderExistsByID
(@OrderId INT)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM orders WHERE order_id = @OrderId)
        RETURN 1 -- Order exists
    ELSE
        RETURN 0 -- Order does not exist
END

DECLARE @Status INT
EXEC @Status = ups_CheckOrderExistsByID 1
SELECT @Status as Status