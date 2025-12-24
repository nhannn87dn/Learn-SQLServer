IF OBJECT_ID('dbo.CustomersTest', 'U') IS NOT NULL
    DROP TABLE dbo.CustomersTest;


-- Tạo bảng KHÔNG có PRIMARY KEY và KHÔNG có INDEX
CREATE TABLE dbo.CustomersIndex (
    Id INT IDENTITY(1,1),  -- Không là PRIMARY KEY
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    City NVARCHAR(50),
    CreatedAt DATETIME
);

-- Chèn 1 triệu dòng dữ liệu giả
SET NOCOUNT ON;

INSERT INTO dbo.CustomersIndex (FirstName, LastName, Email, City, CreatedAt)
SELECT TOP (1000000)
    'First' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    'Last' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    'user' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR) + '@example.com',
    CASE ABS(CHECKSUM(NEWID())) % 5
        WHEN 0 THEN 'Hanoi'
        WHEN 1 THEN 'Saigon'
        WHEN 2 THEN 'Danang'
        WHEN 3 THEN 'Hue'
        ELSE 'Cantho'
    END,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1000), GETDATE())
FROM master.dbo.spt_values t1
CROSS JOIN master.dbo.spt_values t2;


SELECT * FROM dbo.CustomersIndex WHERE City = 'Hanoi';

SELECT * FROM dbo.CustomersIndex WHERE Email = 'user500000@example.com';

SELECT * FROM dbo.CustomersIndex WHERE City = 'Saigon' AND CreatedAt > DATEADD(DAY, -100, GETDATE());


-- danh index
-- Thêm PRIMARY KEY sau
ALTER TABLE dbo.CustomersIndex
ADD CONSTRAINT PK_Customers_Id PRIMARY KEY CLUSTERED (Id);

-- Tạo index để so sánh hiệu năng
CREATE NONCLUSTERED INDEX IX_Customers_City ON dbo.CustomersIndex(City);
CREATE UNIQUE NONCLUSTERED INDEX IX_Customers_Email ON dbo.CustomersIndex(Email);
CREATE NONCLUSTERED INDEX IX_Customers_City_CreatedAt ON dbo.CustomersIndex(City, CreatedAt);
