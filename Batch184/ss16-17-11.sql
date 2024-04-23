CREATE TABLE [dbo].[tbl_Color](
    [Color ID] [int] IDENTITY(1,1) NOT NULL,
    [Color Name] [varchar](3) NULL
) ON [PRIMARY]

INSERT INTO [dbo].[tbl_Color]
           ([Color Name])
     VALUES
           ('Red'),
           ('Blue'), -- Vượt quá độ dài đã khai báo
           ('Green') --

SELECT
    O.*,
    (SELECT * FROM customers AS C WHERE O.customer_id = C.customer_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS customer,
    (SELECT * FROM staffs AS S WHERE O.staff_id = S.staff_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS staffs
FROM orders AS O

SELECT JSON_VALUE('{"name": "John", "age": 30}', '$.name') AS name

SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address

SELECT JSON_MODIFY('{"name": "John", "age": 30}', '$.name', 'Jane') AS name

SELECT * FROM OPENJSON('{"name": "John", "age": 30}')

CREATE TABLE People (
      ID INT PRIMARY KEY,
      Info NVARCHAR(MAX)
  )

  DECLARE @info NVARCHAR(MAX)
  SET @info = N'{
    "firstName": "Nguyễn",
    "lastName": "Thảo",
    "age": 25,
    "address": {
      "StreetAddress": "290/58 Nơ Trang Long",
      "City": "Việt Nam",
      "State": "VN",
      "postalCode": "76000"
    },
    "PhoneNumber": [
      {"type": "home","number": "212 555-1234"},
      {"type": "fax","number": "646 555-4567"}
    ]
  }'
  INSERT INTO People (ID,Info) VALUES (1, @info)

  SELECT * FROM People


  SELECT 
  JSON_VALUE(Info, '$.address.StreetAddress') AS Street,
  JSON_QUERY(Info, '$.skills') AS Skills
FROM People
WHERE ISJSON(Info) > 0


UPDATE People
SET Info = JSON_MODIFY(Info, '$.age', 36)
WHERE ID = 1


-- Tạo cấu trúc bảng customer_index
CREATE TABLE dbo.customers_index (
	[customer_id] [int]  NOT NULL,
	[first_name] [nvarchar](255) NOT NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[birthday] [date] NULL,
	[street] [nvarchar](255) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[state] [nvarchar](50) NOT NULL,
	[zip_code] [varchar](5) NULL,
);

INSERT INTO dbo.customers_index
SELECT [customer_id], [first_name], [last_name], [phone], [email],
       CONVERT(date, [birthday], 103), [street], [city], [state], [zip_code]
FROM dbo.customers ORDER BY [birthday],[first_name];

DELETE FROM dbo.customers_index



 --Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME ON;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO ON;
 -- Truy vấn SQL của bạn ở đây
	SELECT * FROM dbo.order_items

 --Tắt đi sau khi truy vấn thực hiện
 SET STATISTICS TIME OFF;
 SET STATISTICS IO OFF;

 --Heap Structures
 SELECT * FROM customers_index
 --Check xem 1 table da duoc index chua
 EXEC sp_helpindex 'customers_index';

 --Lay customer co id = 5
 --BEFORE: 0.0315382 (100%), Row 1445
SELECT customer_id FROM dbo.customers_index WHERE customer_id = 5
--AFTER: 0.0032831 (100%), Row
--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_customer_id
ON customers_index (customer_id ASC);

--Luu y: trong 1 table, chi co duy nhat 1 index clustered
--Li do: clustered index thuong dc danh tren PRIMARY KEY

CREATE CLUSTERED INDEX CIX_customers_index_phone
ON customers_index (phone); --> Bao loi

-- Vi du 2: tim theo phone
SELECT customer_id, phone FROM dbo.customers_index WHERE phone = '0968411372'

CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phone ON customers_index (phone)
	INCLUDE (first_name)

-- vi du 3: 
SELECT customer_id, phone, first_name FROM dbo.customers_index WHERE phone = '0968411372'

SELECT 
	b.brand_name
FROM dbo.products AS p
LEFT JOIN dbo.order_items AS oi ON oi.product_id = p.product_id
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id AND o.order_status <> 4
INNER JOIN dbo.brands AS b ON b.brand_id = p.brand_id
WHERE o.order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-05-30' AS DATE)
GROUP BY
	b.brand_name

CREATE NONCLUSTERED INDEX UIX_order_order_date ON orders (order_date)
	INCLUDE (first_name)

--> sp da ban dc tu ngay den ngay
EXCEPT
SELECT * FROM dbo.products;


SELECT
    product_id
FROM
    dbo.products
EXCEPT

SELECT
	--oi.product_id
	b.brand_name
FROM
    dbo.order_items AS oi
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
INNER JOIN dbo.products AS p ON p.product_id = oi.product_id
INNER JOIN dbo.brands AS b ON b.brand_id = p.brand_id
WHERE o.order_status <> 4 AND o.order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-05-30' AS DATE)
GROUP BY
	b.brand_name

SELECT oi.order_id, o.order_status
FROM order_items AS oi 
INNER JOIN dbo.orders AS o ON o.order_id = oi.order_id
WHERE oi.product_id = 3

Heller
Surly
Electra
Trek
Pure Cycles

SELECT
	b.brand_name
FROM
	dbo.brands b
JOIN dbo.products p ON b.brand_id = p.brand_id
JOIN dbo.order_items oi ON p.product_id = oi.product_id
JOIN dbo.orders o ON oi.order_id = o.order_id
WHERE
	o.order_status != 4
	AND
	o.order_date BETWEEN CAST('2016-01-01' AS DATE) AND CAST('2016-05-30' AS DATE)
GROUP BY
	b.brand_name