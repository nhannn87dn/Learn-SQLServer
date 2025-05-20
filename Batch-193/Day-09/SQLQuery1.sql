-- VIEW
CREATE OR ALTER VIEW dbo.v_getProductsList --> nó như 1 table ảo, 1024 columns
WITH SCHEMABINDING -- thêm tùy chọn vào
AS
(
SELECT 
	p.product_id,
	p.product_name,
	p.model_year,
	p.description AS p_descsription,
	c.category_name,
	b.brand_name
FROM		products	AS p
LEFT JOIN	brands		AS b ON b.brand_id = p.brand_id
LEFT JOIN	categories	AS c ON c.category_id = p.category_id
)
-- Vì nó là một table ảo nên các bạn có thể truy vấn như table bình thường
SELECT * FROm dbo.v_getProductsList
--1. Bạn có thể INSERT, Update, delete
UPDATE dbo.v_getProductsList SET price = 400 WHERE product_id = 1
SELECT * FROM products
--2. Tại vì sao lại cần đến View ?
-- Giả sử table thật bị khóa bởi trigger, chặn ko cho thay đổi dữ liệu trực tiếp
-- View --> trung gian --> để thay đổi dữ liệu
-- Che dấu dữ liệu không mong muốn thấy ở table thật. Ví dụ cột giá vốn

CREATE OR ALTER VIEW dbo.v_getCustomers --> nó như 1 table ảo, 1024 columns
WITH SCHEMABINDING, ENCRYPTION  -- thêm tùy chọn vào
AS
(
SELECT 
	customer_id,
	first_name,
	last_name,
	phone
FROM dbo.customers
)
-- đổi tên cột --> WITH SCHEMABINDING sẽ phát hiện và chặn lại
EXEC sp_rename 'customers.phone', 'mobile', 'COLUMN';

SELECT * FROM customers

--Xem cấu trúc của view
EXEC sp_helptext v_getCustomers;


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
UPDATE dbo.v_daily_sales SET discount = 0.1 WHERE product_id = 20;


-- Store
CREATE OR ALTER PROC usp_daily_sales
AS
BEGIN
	SELECT
		p.product_id, p.product_name,
		p.discount,
		year(order_date) AS y,
		month(order_date) AS m,
		day(order_date) AS d,
		(i.quantity * i.price) AS sales
	FROM dbo.orders AS o
	INNER JOIN dbo.order_items AS i ON o.order_id = i.order_id
	INNER JOIN dbo.products AS p ON p.product_id = i.product_id
END
-- gọi store
EXEC dbo.usp_daily_sales

-- Tại vì sao lại cần Proc
--1. Để cache kế hoạch thực thi --> giúp câu lệnh truy vấn lần thứ 2 trở được nhanh hơn
--2. Giúp bạn đóng gói một tập hợp các câu lệnh thành một khối để thực thi khi lặp đi lặp lại về mặt logic

-- Liệt kê tất cả đơn hàng trong tháng 2-2016
SELECT * FROM orders WHERE order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-01-30' AS DATE)


-- tạo Proc có tham số đầu vào
CREATE OR ALTER PROC usp_getOrdersByRangeDate(@StartDate DATE, @EndDate DATE)
AS
BEGIN
	SELECT * FROM orders 
		WHERE order_date BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
END

DECLARE @StartDate DATE = '2016-01-01',
		@EndDate DATE = '2016-01-30';
-- Sau tên proc, danh sách các đối số, cách nhau bởi dấy phẩy
EXEC usp_getOrdersByRangeDate @StartDate, @EndDate

SELECT * FROM users

CREATE OR ALTER PROC usp_login(@email VARCHAR(255), @password VARCHAR(255))
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM users WHERE email = @email)
			BEGIN
				DECLARE @userId  VARCHAR(255);
				DECLARE @oldPassword  VARCHAR(255);
				SELECT @userId = id, @oldPassword= password FROM users WHERE email = @email;
				-- lỗi insert
				
				--check mk khop kko
				IF(@password != @oldPassword)
					BEGIN
						SELECT 'Invalid passoword or email' AS Message
					END
				ELSE
					BEGIn
						SELECT @userId AS userId, @email AS email
					END
			END
		ElSE
			BEGIN
				SELECT 'Invalid passoword or email' AS Message
			END
	END TRY
	BEGIN CATCH
		 -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        --Ném lỗi
        THROW;
	END CATCH
END


DECLARE @email VARCHAR(255) = 'nhannn@softech.vn',
		@password VARCHAR(255) = '123456';

EXEC usp_login @email, @password

CREATE PROCEDURE usp_TotalOrderByRangeDate (
    @FromDate DATETIME, --tham số đầu vào
    @ToDate DATETIME, --tham số đầu vào
    @Total INT OUTPUT --Tham số đầu ra OUTPUT
	-- có thể out ra nhiều biến
)
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE CAST(order_date AS DATE)  BETWEEN @FromDate AND @ToDate
END;

DECLARE @TotalOrders INT;

EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-30', @TotalOrders OUTPUT;

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
EXEC @Status = abc.ups_CheckOrderStatus 1
SELECT @Status as Status