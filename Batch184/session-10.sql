ALTER VIEW dbo.v_getinfo_products
AS 
(
	SELECT
		 p.*,
		 c.category_name
	FROM
		dbo.products AS p
	LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id
	WHERE p.discount > 0.05	
) WITH CHECK OPTION

UPDATE dbo.v_getinfo_products
SET discount = 0.01
WHERE product_id = 2

-- Cau lenh SELEC --> duoc dat mot cai ten == dbo.v_getinfo_products
--Note: Khong su dung ORDER BY ben trong VIEW

SELECT 
* 
FROM dbo.v_getinfo_products
--WHERE brand_id = 5
ORDER BY
	product_id DESC

--Vi sao can VIEW
--1. De bao mat
--Ong Admin: xem duoc toan bo fields cua table Customers
--Ong Dev: ko duoc xem email cua table Customers. 
--Ong Dev: ko co quyen SELECT table Customer
ALTER VIEW dbo.v_getinfo_customers
WITH SCHEMABINDING
AS (
	SELECT
		customer_id,first_name, last_name, phone, street, state, zip_code
	FROM dbo.customers
)
--rename phone --> mobile
EXEC sp_rename 'customers.phone', 'mobile', 'COLUMN';
--ong Admin, cung khoa quyen cua ong Dev duoc Edit View

SELECT * FROM dbo.v_getinfo_customers
--Thong qua VIEW, ong Dev co the INSERT, UPDATE, DELETE customer
UPDATE dbo.v_getinfo_customers
SET birthday = '2016-04-01' WHERE customer_id = 1445
SELECT * FROM dbo.customers WHERE customer_id = 1445

--Xem danh sach VIEW da tao trong database hien tai
SELECT * FROM sys.views

--Xem cau truc cua VIEW
EXEC sp_helptext v_getinfo_customers;
--HOI DAP ?

--================== STORED PROCEDURES ====================
--Sử dụng từ khóa CREATE PROCEDURE
ALTER PROCEDURE dbo.usp_ProductList (
	@model_year SMALLINT, -- require
	@discount DECIMAL(4,2) = 0 -- option, default = 0, --- 00.00
)
AS
BEGIN
    BEGIN TRY
        SELECT
		 p.*,
		 c.category_name
		FROM
			dbo.products AS p
		LEFT JOIN dbo.categories AS c ON c.category_id = p.category_id
		WHERE discount > @discount AND model_year = @model_year
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

--Cach goi mo Store
EXEC dbo.usp_ProductList
--Truyen tham so cho Store theo thu tu
EXEC dbo.usp_ProductList 10
--Truyen nhieu tham so cho Store theo thu tu
-- Moi doi so cach nhau dau phay
EXEC dbo.usp_ProductList 2018, 10 --> lay dssp co model_year = 2018, discount> 10
--HOAC goi tuong minh hon voi BIEN
DECLARE @model_year SMALLINT = 2018;
DECLARE @discount DECIMAL(4,1) = 10;
EXEC dbo.usp_ProductList @model_year, @discount


---KET LUAN: Store <> View ?
--1. View chi dung duoc 1 cau lenh SELECT, Store thi tap hop ALL cac cau lenh
--2. View KO CACHE, con Store thi CO CACHE

-- Khi nao dung STORE ?
--> BAT KI TH nao ban cung co the dung STORE
--> Vi no Toi uu hieu suat, giam tai cho Server
--> Dac biet la cac cau lenh SELECT

--- STRORE voi OUTPUT

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
-- su dung bien output
DECLARE @TotalOrders INT;
EXEC usp_TotalOrderByRangeDate '2016-01-01', '2016-01-31', @TotalOrders OUTPUT;
SELECT @TotalOrders as TotalOrders;

-- STORE voi RETURN
-- Return chi tra ve 1 gia tri DON duy nhat.
CREATE PROCEDURE usp_CheckOrderStatus
    @OrderId INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM orders WHERE order_id = @OrderId)
        RETURN 1 -- Order exists
    ELSE
        RETURN 0 -- Order does not exist
END;
-- su dung
DECLARE @Status INT
--Tao bien status, gan gia tri = ket qua cua STORE
EXEC @Status = usp_CheckOrderStatus 2
-- Lay ket qua
SELECT @Status as Status

-- Xem cau truc tao STORE
EXEC sp_helptext N'dbo.usp_CheckOrderStatus';  

-- QA ?

SELECT * FROM dbo.products

--DYNAMIC SQL with STORE

ALTER PROC usp_LayDanhSach_Filters (
	@model_year SMALLINT = NULL,
	@category_id INT = NULL
)
AS
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = N'SELECT * FROM dbo.products WHERE 1 = 1 ';
	--Them dieu kien model_year khi @model_year IS NOT NULL
	IF @model_year IS NOT NULL
	BEGIN
		SET @Sql = CONCAT(@Sql, N' AND model_year = @model_year')
	END
	--Them dieu kien category_id khi @category_id IS NOT NULL
	IF @category_id IS NOT NULL
	BEGIN
		SET @Sql = CONCAT(@Sql, N' AND category_id = @category_id')
	END
	PRINT @Sql;
	EXEC sp_executesql @Sql, 
						N'
						@model_year SMALLINT, 
						@category_id INT
						', 
						@model_year, 
						@category_id;
END

-- Filter model_year = 2018, category_id = 5
EXEC usp_LayDanhSach_Filters 2018, 5


---Cach viet khac
CREATE PROC usp_LayDanhSach_Filters_v2 (
	@model_year SMALLINT = NULL,
	@category_id INT = NULL
)
AS
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = N'SELECT * FROM dbo.products WHERE ';
	DECLARE @Where NVARCHAR(MAX) = N'';
	--Them dieu kien model_year khi @model_year IS NOT NULL
	IF @model_year IS NOT NULL
	BEGIN
		SET @Where = CONCAT(@Where, N' model_year = @model_year')
	END
	--Them dieu kien category_id khi @category_id IS NOT NULL
	IF @category_id IS NOT NULL
	BEGIN
		IF LEN(@Where) > 0
		BEGIN
			SET @Where = CONCAT(@Where, N' AND')
		END
		SET @Where = CONCAT(@Where, N' category_id = @category_id')
	END
	SET @Sql = CONCAT(@Sql, @Where);
	PRINT @Sql;
	EXEC sp_executesql @Sql, N'@model_year SMALLINT, @category_id INT', @model_year, @category_id;
END
