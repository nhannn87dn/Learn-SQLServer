
ALTER VIEW udv_getProductsInfo
WITH SCHEMABINDING
AS
(SELECT 
	p.product_id,
	p.product_name,
	p.price,
	p.model_year,
	p.description,
	c.category_name,
	b.brand_name
FROM dbo.products AS p
LEFT JOIN dbo.brands AS b ON b.brand_id = p.brand_id
LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id)


EXEC sp_rename 'products.model_year', 'model_years', 'COLUMN';


-- Dùng view như là một table bình thường
-- các bạn có thể đánh chỉ mục index đổi tối ưu tốc độ truy vấn
SELECT
*
FROM dbo.udv_getProductsInfo
WHERE model_year > 2025
ORDER BY price ASC

UPDATE dbo.udv_getProductsInfo
SET price = 410 WHERE product_id = 107

SELECT * FROM dbo.products WHERE product_id = 107

-- Mục đích cần đến VIEW để bảo mật dữ liệu
ALTER VIEW udv_getCustomerInfo
AS
(SELECT 
customer_id,
first_name,
last_name,
birthday
FROM dbo.customers)

SELECT * FROM dbo.udv_getCustomerInfo

SELECT * FROM sys.views


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

--v_daily_sales = table
-- có thể update dữ liệu của cột
UPDATE dbo.v_daily_sales SET discount = 0.01 WHERE product_id = 4

-- xem cấu trúc của view
EXEC sp_helptext 'udv_getCustomerInfo';

-- Store Procedures 
ALTER PROC udp_getProductInfo -- tên proc
AS
BEGIN -- {
	-- câu lênh 1
	-- câu lệnh 2
	-- câu lệnh n
	-- có thể vừa insert, update, delete
	SELECT * FROM brands
	SELECT 
		p.product_id,
		p.product_name,
		p.price,
		p.model_year,
		p.description,
		c.category_name,
		b.brand_name
	FROM dbo.products AS p
	LEFT JOIN dbo.brands AS b ON b.brand_id = p.brand_id
	LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id 

END -- }
-- kế hoạch thực thi

EXEC udp_getProductInfo -- thực thi proc = gọi hàm

-- Tạo Store có tham số đầu vào
-- Giống hàm có tham số

SELECT *
FROM dbo.products WHERE model_year = 2025

-- =Hàm có tham số, nhưng ko return
CREATE PROC udp_getProductByModelYear(
	@ModelYear SMALLINT
)
AS
BEGIN
	SELECT *
	FROM dbo.products WHERE model_year = @ModelYear
END
-- gọi proc = gọi hàm
-- EXEC tên_proc [tham số 1 , tham số 2, ...]
EXEC udp_getProductByModelYear 2018;


SELECT * 
FROM dbo.products WHERE model_year = 2025

-- Tạo Store có tham số OUTPUT
--Ví dụ: Tổng số đơn hàng bán ra từ ngày đến ngày.

CREATE PROCEDURE usp_TotalOrderByRangeDate (
    @FromDate DATETIME, --tham số đầu vào
    @ToDate DATETIME, --tham số đầu vào
    @Total INT OUTPUT --Tham số đầu ra OUTPUT
)
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE CAST(order_date AS DATE)  BETWEEN @FromDate AND @ToDate
END;

SELECT * FROM orders

DECLARE @TotalOrders INT; --đối với proc có oput thì cần định nghĩa biến phụ
EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-31', @TotalOrders OUTPUT;
SELECT @TotalOrders as TotalOrders;

--  Stored procedure Có RETURN
-- Kiểm tra xem đơn hàng có ID này tồn tại không
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
EXEC @Status = ups_CheckOrderStatus 1
SELECT @Status as Status