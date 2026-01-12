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



  SELECT JSON_MODIFY(@info, '$.age', '30') AS age

  UPDATE People
	SET Info = JSON_MODIFY(Info, '$.age', 36)
	WHERE ID = 1


  INSERT INTO People (ID, Info) VALUES (1, @info)

  SELECT * FROM People


SELECT
  JSON_VALUE(Info, '$.age') AS age
FROM People
WHERE ISJSON(Info) > 0


SELECT JSON_MODIFY('{"name": "John", "age": 30}', '$.name', 'Jane') AS name



SELECT JSON_VALUE('{"name": "John", "age": 30}', '$.name') AS name


SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address


SELECT * FROM customers


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

SELECT * FROM customers_index


SELECT customer_id FROM dbo.customers_index WHERE customer_id = 5
--BEFORE
-- CPU: 0.001668			---  0.0001581
-- Rows: 1445				--- 1
-- Cost: 0.0315382 (100%)   --- 0.0032831 (100%)
-- Action: table scan		--- Clustered index

--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_id
ON customers_index (customer_id ASC);


SELECT customer_id, phone FROM dbo.customers_index WHERE phone = '0968411372'

CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phone 
ON customers_index (phone)
INCLUDE (first_name, last_name)


SELECT customer_id, phone, first_name, last_name FROM dbo.customers_index WHERE phone = '0968411372'


SELECT 
*
FROM products
WHERE
	category_id = 1,
	brand_id = 1,
	recomend=1, --1 la new
	product_name LIKE '%s21%'
