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

/* JSON Format
user_profile = '{
	"id": 1,
	"name": "Nhan",
	relations: {
		parents: 
		anh c
	}
}'
-- Khi nào thì dùng JSON ?
+ Khi cần lưu trữ nhiều thông tin mà không cần truy vấn WHERE
*/

SELECT
    O.*,
    (SELECT * FROM customers AS C WHERE O.customer_id = C.customer_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS customer,
    (SELECT * FROM staffs AS S WHERE O.staff_id = S.staff_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS staffs
FROM orders AS O

DECLARE @MyJSON VARCHAR(255) = '{"name": "John", "age": 30}';

SELECT JSON_VALUE(@MyJSON, '$.name') AS name

SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address

SELECT JSON_MODIFY('{"name": "John", "age": 30}', '$.name', 'Jane') AS name

SELECT ISJSON('{"name": "John", "age": 30}') AS is_json

SELECT * FROM OPENJSON('{"name": "John", "age": 30}')

/*
user_info = {
	id: 1,
	first_name: "abc"
	age: 1234,

}

*/

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
  INSERT INTO People (ID, Info) VALUES (1, @info)

  SELECT * FROM People


  SELECT
  JSON_VALUE(Info, '$.address.StreetAddress') AS Street,
  JSON_VALUE(Info, '$.age') AS Age
FROM People
WHERE ISJSON(Info) > 0


UPDATE People
SET Info = JSON_MODIFY(Info, '$.age', 36)
WHERE ID = 1


-- Tạo cấu trúc bảng customer_index
CREATE TABLE dbo.customers_index (
	[customer_id] [int]  NOT NULL PRIMARY KEY,
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
-- Xõa dữ liệu nếu có
DELETE FROM dbo.customers_index
-- Đổ dữ liệu từ table customers, sắp xếp theo birthday
INSERT INTO dbo.customers_index
SELECT [customer_id], [first_name], [last_name], [phone], [email],
       CONVERT(date, [birthday], 103), [street], [city], [state], [zip_code]
FROM dbo.customers ORDER BY [birthday],[first_name];
--Check xem có index không
EXEC sp_helpindex 'customers_index';
-- Xem dữ liệu hiện tại
SELECT * FROM dbo.customers_index


SELECT customer_id FROM dbo.customers_index WHERE customer_id = 5
--	read 1445  --- 1
--  table scan -- index seed
--	cost: 0.0315382 -- 0.0032831

---Clustered index
--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_id
ON customers_index (customer_id ASC);


SELECT customer_id, phone FROM dbo.customers_index WHERE phone = '0968411372'

CREATE UNIQUE NONCLUSTERED INDEX UIX_customer_index_phone 
	ON customers_index (phone)
	INCLUDE(first_name)


SELECT customer_id, phone, first_name, email FROM dbo.customers_index WHERE phone = '0968411372'

