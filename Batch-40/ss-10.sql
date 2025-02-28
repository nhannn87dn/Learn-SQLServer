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

-- Xõa dữ liệu nếu có
DELETE FROM dbo.customers_index
-- Đổ dữ liệu từ table customers, sắp xếp theo birthday
INSERT INTO dbo.customers_index
SELECT [customer_id], [first_name], [last_name], [phone], [email],
       CONVERT(date, [birthday], 103), [street], [city], [state], [zip_code]
FROM dbo.customers ORDER BY [birthday],[first_name];

SELECT * FROM dbo.customers_index
--Check xem có index không
EXEC sp_helpindex 'customers_index';

--Câu chuyện thời gian thực thi 1 truy vấn nhanh chậm ?
SELECT customer_id FROM dbo.customers_index WHERE customer_id = 5


--BEFORE CLUSTERED INDEX
--read 1445
-- cost 0.0315382 (100%)

--AFTER CLUSTERED INDEX
--read:  1
-- cost: 0.0032831 (100%)

--Tạo clustered index
CREATE CLUSTERED INDEX CIX_customers_index_customer_id -- tên đặt cho index
ON 
customers_index -- table cần đánh clustered index
(customer_id ASC) -- danh sách các cột đánh clustered index
-- thông thường đánh trên khóa CHÍNH PRIMARY KEY

--BEFORE: read 1445, cost 0.0256122 
SELECT customer_id, phone FROM dbo.customers_index WHERE phone = '0968411372'

CREATE UNIQUE NONCLUSTERED INDEX UNCIX_customers_index_phone 
ON customers_index (phone, first_name)
--BEFORE: read 1, cost 0.0032831 (100%)


SELECT customer_id, phone, first_name FROM dbo.customers_index WHERE phone = '0968411372'


CREATE TABLE dbo.brandsV2 (
	[brand_id] [int] IDENTITY(1,1) NOT NULL,
	[brand_name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](500) NULL,
	-- CONSTRAINTs
	CONSTRAINT [pk_categories_brands] PRIMARY KEY([brand_id]),
	CONSTRAINT [uq_brands] UNIQUE([brand_name])
);