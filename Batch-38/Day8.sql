CREATE TABLE [dbo].[tbl_Color](
    [Color ID] [int] IDENTITY(1,1) NOT NULL,
    [Color Name] [varchar](3) NULL
) ON [PRIMARY]
GO

INSERT INTO [dbo].[tbl_Color]
           ([Color Name])
     VALUES
           ('Red'),
           ('Blue'), -- Vượt quá độ dài đã khai báo
           ('Green') --
GO

SELECT
    O.*,
    (SELECT * FROM customers AS C WHERE O.customer_id = C.customer_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS customer,
    (SELECT * FROM staffs AS S WHERE O.staff_id = S.staff_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS staffs
FROM orders AS O

CREATE TABLE People (
      ID INT PRIMARY KEY,
      Info NVARCHAR(MAX)
  )

SELECT JSON_VALUE('{"name": "John", "age": 30}', '$.name') AS name

SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address


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
  INSERT INTO People (ID,Info) VALUES (1,@info)

SELECT * FROM People

SELECT 
  JSON_VALUE(Info, '$.address.StreetAddress') AS Street
FROM People
WHERE ISJSON(Info) > 0

UPDATE People
SET Info = JSON_MODIFY(Info, '$.age', 36)
WHERE ID = 1 AND ISJSON(Info) > 0


SELECT 
  JSON_VALUE(Info, '$.age') AS Age
FROM People
WHERE ISJSON(Info) > 0

SELECT * from dbo.customers

CREATE TABLE dbo.customer_index (
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

INSERT INTO dbo.customer_index
SELECT [customer_id], [first_name], [last_name], [phone], [email],
       CONVERT(date, [birthday], 103), [street], [city], [state], [zip_code]
FROM dbo.customers ORDER BY [birthday],[first_name];


DELETE FROM dbo.customer_index

SELECT * FROM dbo.customer_index

--Check xem có index không
EXEC sp_helpindex 'customer_index';

--Để xem thời gian thực hiện truy vấn
 SET STATISTICS TIME ON;
 --Để xem tài nguyên thực hiện truy vấn
 SET STATISTICS IO ON;
 -- Truy vấn SQL của bạn ở đây

SELECT order_id FROM dbo.orders WHERE order_id = 5

--Tắt đi sau khi truy vấn thực hiện
 SET STATISTICS TIME OFF;
 SET STATISTICS IO OFF;

 --0.0298702
 --rows 1445
SELECT customer_id FROM dbo.customer_index WHERE customer_id = 5

--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_id
ON dbo.customer_index (customer_id ASC);
--0.0017465
--1445

SELECT customer_id, phone FROM dbo.customer_index WHERE phone = '0968411372'

CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phone ON customer_index (phone)

SELECT customer_id, phone, first_name FROM dbo.customer_index WHERE phone = '0968411372'


CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phoneinclu 
ON customer_index (phone)
INCLUDE(first_name,last_name);
