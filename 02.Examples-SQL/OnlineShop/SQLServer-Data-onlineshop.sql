USE [OnlineShop]
GO
/****** Object:  UserDefinedFunction [dbo].[f_ConvertToSafeText]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[f_ConvertToSafeText](@Text NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS
BEGIN    
    IF (@Text IS NULL OR @Text = '')  RETURN ''
   
    DECLARE @RT NVARCHAR(MAX)
    DECLARE @SIGN_CHARS NCHAR(256)
    DECLARE @UNSIGN_CHARS NCHAR (256)
 
    SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
 
    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
   
    SET @COUNTER = 1
    WHILE (@COUNTER <= LEN(@Text))
    BEGIN  
        SET @COUNTER1 = 1
        WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@Text,@COUNTER ,1))
            BEGIN          
                IF @COUNTER = 1
                    SET @Text = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@Text, @COUNTER+1,LEN(@Text)-1)      
                ELSE
                    SET @Text = SUBSTRING(@Text, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@Text, @COUNTER+1,LEN(@Text)- @COUNTER)
                BREAK
            END
            SET @COUNTER1 = @COUNTER1 +1
        END
        SET @COUNTER = @COUNTER +1
    END
	-- SET @Text = replace(@Text,' ','-')
	SET @Text = replace(@Text,'--','-')
	SET @Text = replace(@Text,'--','-')
	SET @Text = replace(@Text,'--','-')
	SET @Text = replace(@Text,'--','-')
    RETURN @Text
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Employee_GetFullName]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Employee_GetFullName]
(
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetAge]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetAge](@Birthday DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @CurrentYear INT
    SET @CurrentYear = YEAR(GETDATE())

    DECLARE @YearOfBirthday INT
    SET @YearOfBirthday = YEAR(@Birthday)

    RETURN @CurrentYear - @YearOfBirthday
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Order_GetTotalPrice]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Order_GetTotalPrice](@OrderId INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY = 0

    SELECT 
        @Total = SUM(dbo.udf_Product_GetTotalPrice(OD.Price, OD.Discount, OD.Quantity))
     FROM OrderDetails AS OD
    WHERE 
        OD.OrderId = @OrderId

    RETURN @Total
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Product_GetTotalPrice]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Product_GetTotalPrice](@Price money, @Discount decimal(18, 2), @Quantity decimal(18, 2))
RETURNS money
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END
GO
/****** Object:  Table [dbo].[Products]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Price] [money] NOT NULL,
	[Discount] [int] NOT NULL,
	[Stock] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[SupplierId] [int] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ProductWithCategory]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_ProductWithCategory]
AS
SELECT 
    P.*, C.Name AS 'CategoryName', C.[Description] AS 'CategoryDescription'
FROM 
    Products AS P 
    INNER JOIN Categories AS C ON P.CategoryId = C.Id   
GO
/****** Object:  View [dbo].[v_ProductsHavingStock]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_ProductsHavingStock]
AS
SELECT 
  Id, Stock, Price, [Description]
FROM
    dbo.Products
WHERE Stock = 0
WITH CHECK OPTION
GO
/****** Object:  View [dbo].[v_Products]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_Products]
AS
SELECT 
    P.Id,
    P.[Name],
    P.Price,
    P.Discount,
    P.Stock,
    P.[Description]
FROM
    dbo.Products AS P
WHERE Stock > 0


GO
/****** Object:  View [dbo].[v_ProductsHavingEmptyStock]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_ProductsHavingEmptyStock]
AS
SELECT 
  Id, Name, Stock, Price, Discount, [Description]
FROM
    dbo.Products
WHERE Stock = 0
WITH CHECK OPTION
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Price] [money] NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_OrderDetails]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_OrderDetails]
AS
SELECT 
    OD.*,
    ((OD.Price * (100 - OD.Discount) / 100) * OD.Quantity) AS 'Sum'
FROM OrderDetails AS OD
GO
/****** Object:  View [dbo].[v_Products_NotSold]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Products_NotSold]
AS
SELECT * FROM Products AS P
WHERE NOT EXISTS (
    SELECT P.Id FROM OrderDetails AS OD WHERE P.Id = OD.ProductId
)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Products_GetByMinPrice]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Products_GetByMinPrice](@Price money)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Products
    WHERE Price >= @Price
)
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[Birthday] [date] NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[Birthday] [date] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderLogs]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ShippedDate] [datetime] NULL,
	[Status] [varchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ShippingAddress] [nvarchar](500) NULL,
	[ShippingCity] [nvarchar](50) NULL,
	[PaymentType] [varchar](20) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persons]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persons](
	[ID] [int] NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_04f7be88261f9d1e55675c0ee75] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[RefreshToken] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_329bb2946729a51bd2b19a5159f] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users_Roles]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_Roles](
	[userId] [int] NOT NULL,
	[roleId] [int] NOT NULL,
 CONSTRAINT [PK_4f5bba712b619534557413dad7a] PRIMARY KEY CLUSTERED 
(
	[userId] ASC,
	[roleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (1, N'Update Categories 1', N'Complete')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (2, N'HDD 121212', N'Categories-patch2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (3, N'Name 10223', N'Category 1 description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (14, N'Category322', N'')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (6983, N'11111111111111111111111111111111111111111111111111', N'Desc Huan thu xi 2x')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (6987, N'Gia dụng', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (7982, N'156', N'D123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (7983, N'Nhathoang`', N'123124')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (7984, N'Name 123456789', N'Desc 123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (7986, N'Name 123456711189', N'Desc 123411156789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (7988, N'123', N'123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8020, N'Categori0101', N'Desc 222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8021, N'Categori01012', N'Desc 222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8044, N'New Name 21', N'New Desc 21')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8047, N'May lanh 0704', N'May lanh 0704 is description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8048, N'null', N'May lanh 0704-is description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8049, N'Name 1', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8050, N'Name 2', N'Desc 2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8051, N'Name 3', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8052, N'Name 4', N'Desc 4')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8053, N'Name 5', N'Desc 5')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8055, N'Name 78', N'Desc 4')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8056, N'Name 77', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8057, N'Name 75', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8060, N'CNCM 2', N'Desc 2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8061, N'CNCM 1', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8062, N'CNCM 5', N'Desc 5')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8063, N'CNCM 11', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8064, N'CATE 1111', N'DES 2222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8065, N'new catagories name', N'description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8066, N'category 100', N'Mo ta ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8067, N'category 101', N'Mo ta ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8068, N'category 102', N'Mo ta ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8069, N'category 103', N'Mo ta ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8070, N'Tester 122', N'Category  131')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8071, N'Procus123', N'123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8073, N'Tester 22', N'Category  31')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8074, N'Category 122', N'Category 173 description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8075, N'Category 22', N'Category 73 description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8078, N'Category 21', N'Category 33 description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8079, N'Your expertise', N'cay da284')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8081, N'Naabbb 1', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8082, N'accessible 44', N'Desc 4')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8083, N'accessible 33', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8084, N'accessible 22', N'Desc 2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8085, N'accessible 12', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8086, N'accessible 55', N'Desc 5')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8087, N'Naabbb 2', N'Desc 2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8088, N'Naabbb 3', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8089, N'Naabbb 4', N'Desc 4')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8093, N'Naúibdb 3', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8114, N'Category Name 333', N'Category Desc 333')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8119, N'New Print', N'New')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8120, N'Wunsch - Bode', N'Future')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8121, N'${__RandomString()}', N'${__RandomString()}')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8122, N'???', N'??????????')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8123, N'????', N'???????????')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8124, N'edfgf', N'ggebdfcegc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8125, N'bebed', N'debaefcgdc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8126, N'gccaf', N'babcbggdfc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8127, N'faefd', N'eeaacgfcag')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8128, N'agede', N'ddbcafeafg')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8129, N'cbbbg', N'bdgcbggaef')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8130, N'badae', N'gebccaaddb')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8131, N'fcdgf', N'fcgfcgfdag')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8132, N'adgae', N'eagbgbdebe')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8133, N'bgddb', N'bdcaeedcdf')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8134, N'gfggg', N'dfeeagabdg')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8135, N'fgfcb', N'adbdbfdaab')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8136, N'eeace', N'gfdfebdecc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8137, N'cdgfa', N'fdefgeceag')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8138, N'aefcd', N'ececebfbfb')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8140, N'ebefb', N'gagdafafef')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8141, N'ebadd', N'cedgafgaac')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8142, N'dcdff', N'ecebcbdcbd')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8143, N'dgddc', N'fbccgeffbe')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8144, N'TamVTT1', N'fgbggabcfc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8145, N'fcgbf', N'ebfcefgeeg')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8146, N'bdgcg', N'abacgdgdec')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8147, N'dgdba', N'fadbfedgaa')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8148, N'bccad', N'cfcadffbdd')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8149, N'dbbfa', N'edgcegegae')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8150, N'fbcdc', N'ddfcbbabgf')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8151, N'gcfca', N'adbaccgcbg')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8152, N'fadgg', N'eadgdbgddc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8153, N'eeaaa', N'acgggecdda')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8154, N'aebca', N'gabdbgfeea')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8155, N'gedfc', N'cabaadbeda')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8156, N'effge', N'eeebabfeeb')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8157, N'gffbd', N'bdgffcdddf')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8158, N'efcgc', N'bbcfcabbbb')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8159, N'fbcae', N'fbecegecdf')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8160, N'dddfa', N'gffaccebec')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8161, N'adgfe', N'gafgfegbfc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8231, N'Category Name 3334', N'Category Desc 3334')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8232, N'New Name 2123', N'New Desc 2123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8236, N'Category Name 12345', N'Category Desc 12345')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8238, N'Category Name 12345678', N'Category Desc 12345678')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8240, N'Category Name 3331', N'Category Desc 3331')
GO
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8241, N'Category Name 34567', N'${desc}')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8242, N'Category Name 123123', N'Category Desc 123123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8243, N'Category Name 12312312', N'Category Desc 12312312')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8244, N'Category Name 123456789', N'Category Desc 123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8245, N'Category Name 33333', N'Category Desc 33333')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8246, N'Category Name 4567', N'${desc}')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8247, N'Category Name 345678', N'${desc}')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8248, N'Category Name 3456', N'Category Desc 3456')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8249, N'Category Name 12344', N'Category Desc 12344')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8250, N'Category Name 3456789', N'Category Desc 3456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8251, N'Category Name 345678912', N'Category Desc 3456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8253, N'Category Name 4443', N'Category Desc 4443')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8254, N'Category Name 1212', N'Category Desc 1212')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8255, N'Category Name 123456', N'Category Desc 123456')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8256, N'Category Name 3333', N'Category Desc 3333')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8257, N'Category Name 333333', N'Category Desc 333333')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8258, N'Category Name 3333335', N'Category Desc 3333335')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8259, N'Category Name 2023', N'Category Desc 2023')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8260, N'Category Name 2024', N'Category Desc 2024')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8261, N'Category Name 2022', N'Category Desc 2022')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8262, N'Category Name 1001', N'Category Desc 1001')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8266, N'Category Name 1003', N'Category Desc 1003')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8268, N'giadung', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8269, N'giadung123', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8270, N'giadung12', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8272, N'nhabep1', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8273, N'nhabep2', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8274, N'nhabep3', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8275, N'nhabep4', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8276, N'nhabep5', N'do dung nha bep')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8278, N'Name 222', N'Desc 222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8279, N'hihi123', N'abczx')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8281, N'hỏntyr', N'abczx')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8282, N'hoangnhat', N'hoang123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8285, N'Name 223', N'Desc 222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8287, N'NAME 123', N'new 123')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8288, N'Name 1234', N'New 1234')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8290, N'new catagories name 123', N'description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8305, N'Category Name 2233', N'Category Desc 2233')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8306, N'Category Name 2222', N'Category Desc 2222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8307, N'Category Name 222', N'Category Desc 222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8308, N'Category Name 1234', N'Category Desc 1234')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8309, N'Category Name 54321', N'Category Desc 54321')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8311, N'Name 1234567', N'Name 1234567')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8314, N'Name 9876', N'Name 9876')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8315, N'Name 98765', N'Name 98765')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8316, N'Name 987654', N'Name 987654')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8323, N'Name 2023', N'Name 2023')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8325, N'Category Name 3322', N'Category Desc 3322')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8326, N'Category Name 33224', N'Category Desc 33224')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8327, N'Name 12344', N'Desc 12345')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8328, N'Kiểm tra chất lượng sản phẩm', N'')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8329, N'Name 2345', N'Name 2345')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8331, N' học tập và phát triển bản thân một cách', N'Name 12345')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8332, N'học tập và phát triển bản thân 2023', N'Name 22222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8333, N'học tập và phát triển bản thân', N'Name 22222')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8334, N'11111111', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8335, N'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8338, N'TEXT 2', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8339, N'TEXT 3', N'DEASC')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8340, N'CPU', N'Chip xử lý')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8341, N'Headphone', N'Tai nghe')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8342, N'Danh mục tên 123', N'Mô tả ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8343, N'Tên danh mục 00912', N'Desc ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8347, N'Categories - 0905157803', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8357, N'MT280220', N'VTMT')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8377, N'Nước tẩy trang 0375689742', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8378, N'Sữa rửa mặt 0375689742', N'Sữa rửa mặt dành cho da dầu')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8379, N'Lotion 0375689742', N'Nước hoa hồng')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8380, N'Serum 0375689742', N'Huyết thanh dưỡng da chuyên sâu')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8381, N'Kem dưỡng da dạng gel 0375689742', N'Dưỡng ẩm cho da dầu')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8382, N'Kem dưỡng da dạng Cream 0375689742', N'Dưỡng ẩm cho da thường và da khô')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8383, N'VTMT2802-1', N'HaiChau')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8384, N'VTMT2802-2', N'HaiChau')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8385, N'VTMT2802-3', N'HaiChau')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8386, N'VTMT2802-4', N'HaiChau')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8387, N'VTMT2802-5', N'HaiChau')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8388, N'Danh muc 123', N'Sap2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8389, N'May giat_Hung', N'May giat vip')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8390, N'Headphone_Hung', N'Tai nghe')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8391, N'Nước rửa chén_Hung', N'3 lit')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8392, N'Camera_Hung', N'Chạy bẳng cơm')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8393, N'Iphone_Hung', N'Iphone 15 promax')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8394, N'Laptop_Hung', N'Macbook air')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8395, N'Điện thoại 0805', N'Màu đen 0805')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8396, N'Laptop 0805', N'Màu trắng 0805')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8397, N'Loa 0805', N'Màu đỏ 0805')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8398, N'Tivi 0805', N'Màu xanh 0805')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8399, N'Tai nghe 0805', N'Màu hồng 0805')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8403, N'Micro', N'Microphone')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8404, N'Epson', N'Máy chiếu Epson')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8405, N'Samsung', N'Điện thoại Samsung')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8408, N'LG', N'Tivi LG 17 inch')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8409, N'Apple watch', N'Đồng hồ thông minh')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8410, N'Xiaomi', N'Điện thoại Xiaomi')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8411, N'Camera', N'Camera IP 360 Độ')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8412, N'Tablet', N'Máy tính bảng iPad 9')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8413, N'CPU_KII', N'Chip xử lý')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8414, N'Headphone_KII', N'Tai nghe')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8415, N'ram 16GB_KII', N'Bo nho tam')
GO
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8416, N'VGA_KII', N'Card do hoa')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8417, N'Cooler Master_KII', N'Tan nhiet')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8418, N'SSD 512gb_KII', N'Bo nho')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8419, N'NAME - TUNG - 009', N'DESC - TUNG - 009')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (8466, N'Kii property', N'anything in here')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9490, N'SELECNIUM - Category 1', N'123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9491, N'SELECNIUM - Category 2', N'123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9492, N'SELECNIUM - Category 3', N'123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9493, N'SELECNIUM - Category 4', N'123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9494, N'SELECNIUM - Category 5', N'123456789')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9495, N'TEST 1000 -1000', N'DESC')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (9496, N'TEST 10001000', N'DESC')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10501, N'Điện thoại', N'Mô tả ...')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10508, N'pen', N'nnnn')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10509, N'pencil', N'eeeee')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10512, N'Búa', N'Đập cu Vương')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10513, N'Kéo', N'Cắt tóc')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10514, N'Lá', N'Thực vật')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10515, N'Gà', N'Động vật')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10516, N'Bò', N'Tái Chanh')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10517, N'Bao', N'Đựng đồ')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10527, N'shdjsh', N'bdhdqhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10528, N'000hsjg', N'bdhdahdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10529, N'cjgdjkdgs', N'bdhzdhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10530, N'777sgksa', N'bdhdvhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10531, N'yyu789', N'bd5hdhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10532, N'hsjhkgsajh990', N'b31dhdhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10533, N'shcjkg', N'be43dhdhdj')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10547, N'iiajptziyrkpjbbflznykzolwkujjbneeqkfrjmqhsufsqzyov', N'category')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10549, N'abc', N'viwvigsxvdflatsdyfblaaezjnnintfjedradozqdevzuzptfuxhsrpdysqftqjxdxfudooyflfwrrxpbplsyrdyyfpgmyfzdgahjvjhdpjgdhkcvgygjpwaabqotjciqacnkhymttbpijquygshnjmswjhekapjjuzlxneyvbcpcaoujhjrvpolnmidfexetgxqivauuuacpvptsslskxrbxzjacedxudsbzecysmcugasetovsnkrnyhrgyqhbqyzbthqxtxdqecoyxazpgqkpeclancvnffxugfaywfanojtnfziborbsfvrfgkafrsbsmfmzrgjdkhdkwtxivkekstqccksomkjhxunlujxjcwirjkzlflejwiynekuhilflhqodnvxkmdvmbahtgqrngyxxiuxkiltllpeqdbocruynfmylducssjqyrtmrcsbrrypybjxvlmasesnzwqbnepwrdyfeajaxgipffveerrlrdhff')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10550, N'Cách hiểu này khiến cho cách phân đoạn thiếu tính ', N'abcfjd ehgbejdbcjsba')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10551, N' khiến*&^%$#@!@/.,'';[]cách phân đoạn=thiếu123/@', N'abcdesdfdca')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10552, N'khiến*&^%$#@!@/.,'';', NULL)
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10553, N'[', N'dafasdgdhfhd')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10554, N'.', N'1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10555, N'khiến*&^%$#!@/.,'';', N'hân chia ra thành các đoạn, sự phân chia có thể không thống nhất giữa những người đọc: có người chia theo ý lớn, có người chia theo ý nhỏ. Ý lớn là đoạn bài có hai hoặc ba ý nhỏ được khai triển từ ý lớn, bao gồm hai hoặc ba đoạn văn ngắn, mỗi đoạn ngắn đó là một ý nhỏ, các đoạn này hợp ý với nhau thành một ý lớn; ý nhỏ là ý được khai triển từ ý lớn, về mặt nội dung chỉ triển khai theo một phương diện, một hướng cụ thể, mỗi ý nhỏ là một đoạn.')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10556, N'khiến*&^%$#!@/.,', N'ab13214`61548288747380 @#$%^%*^(&)()(@$!#:":{}{>?<LKNNNNJKVAs ')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10557, N'khiến*&^%$#!@/.,;', N'DBDSHBFSRHF')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10588, N'Name 8585858585', N'Desc 8585858585')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10590, N'Category 1 name', N'Category description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10602, N'Name 100', N'Desc 1')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10603, N'Name 300', N'Desc 3')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10604, N'Name 400', N'Desc 4')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10605, N'Name 200', N'Desc 2')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10606, N'Name 500', N'Desc 5')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10609, N'Name 700', N'Desc 7')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10610, N'new catagories name 121212', N'description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10611, N'new catagories name 1122', N'description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10612, N'new catagories name 333', N'description')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10624, N'Category API', N'Post')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10625, N'Categoty Name - 00001', N'Desc 00001')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10626, N'Categoty Name CTGR 01', N'Desc 00001')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10628, N'Category Name 333433', N'Category Desc 333444')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10629, N'Category Name 33343344', N'Category Desc 33344455')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10630, N'Category Name 387', N'Category Desc 221')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10631, N'Category Name 388', N'Category Desc 221')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10632, N'thuythuyhihi', N'hiuhiu')
INSERT [dbo].[Categories] ([Id], [Name], [Description]) VALUES (10635, N'New Name 2221', N'New Desc 2221')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (0, N'Johnhhdhh', N'Doe', N'090512345674346', N'johnsdsg@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (1, N'John121212', N'Doe', N'0901115123456', N'john112122@gmail.com', N'Danang', CAST(N'2000-12-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2, N'Tom', N'Hank', N'0909111555', N'tomhank@gmail.com', N'Quận Hải Châu, Đà Nẵng', CAST(N'1950-06-06' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3, N'John', N'Doe', N'0905123451', N'john1@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (1111, N'B', N'B', N'B12', N'C12', N'B12', CAST(N'2005-01-04' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2004, N'Betters', N'Mai', N'0395932346', N'MAito@gmail.com', N'13phandinhphung', CAST(N'2005-07-11' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2005, N'Beters', N'Mi', N'039532346', N'Mto@gmail.com', N'13pandinhphung', CAST(N'2005-09-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2006, N'Buses', N'Misa', N'0395322346', N'MISAo@gmail.com', N'13dinhphung', CAST(N'2005-09-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2007, N'Buseness', N'Missa', N'0845322346', N'MissAo@gmail.com', N'13nguyenhphung', CAST(N'2005-09-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2008, N'Beness', N'Maysa', N'0345322346', N'MaysAo@gmail.com', N'11yenhphung', CAST(N'2020-09-11' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2009, N'Nguyen', N'Better', N'0395995725', N'ThanhHien@gmail.com', N'111Nguyentatthanh', CAST(N'2005-09-10' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2010, N'Tran', N'Betters', N'0395995756', N'ThanhTraen@gmail.com', N'13Nguyentatthanh', CAST(N'2005-09-10' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2013, N'John', N'Doe', N'0905123456', N'john@gmail.com', N'Danang', CAST(N'2000-12-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2014, N'Jonh', N'Doee', N'091051234567', N'john@emaail.com', N'38 Yen Ban, Da Nan', CAST(N'1990-02-11' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2022, N'hoangzz', N'nhatz', N'0909091', N'nh111ath@gmail.com', N'38 yen bai', CAST(N'2000-09-09' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2026, N'XH', N'XH', N'X1', N'XH1 ', N'XH3', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2028, N'John', N'Doe', N'0905126456', N'john888@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2037, N'MinhTam', N'Vo', N'123456784', N'minhtam2802@gmail.com', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2038, N'MinhTam', N'Vo', N'123456783', N'minhtam280@gmail.com', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2039, N'MinhTam', N'Vo', N'123456782', N'minhtam28@gmail.com', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2040, N'MinhTam', N'Vo', N'123456781', N'minhtam2@gmail.com', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2041, N'MinhTam', N'Vo', N'123456780', N'minhtam@gmail.com', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2042, N'Trần', N'Thị A', N'0375689122', N'a@tranngan.com', N'Việt Nam', CAST(N'1993-07-20' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2043, N'Trần', N'Thị B', N'0375689123', N'b@tranngan.com', N'Việt Nam', CAST(N'1993-07-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2044, N'Trần', N'Thị C', N'0375689124', N'c@tranngan.com', N'Việt Nam', CAST(N'1993-07-22' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2045, N'Trần', N'Thị D', N'0375689125', N'd@tranngan.com', N'Việt Nam', CAST(N'1993-07-23' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2046, N'Trần', N'Thị E', N'0375689126', N'e@tranngan.com', N'Việt Nam', CAST(N'1993-07-24' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2047, N'Phạm 0805', N'A 0805', N'0805-23456', N'phamA0805@gmail.com', N'0805 Lê Độ', CAST(N'2000-08-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2048, N'lê 0805', N'B 0805', N'0805-23457', N'leB0805@gmail.com', N'0805 Lê Hồng Phong', CAST(N'2001-08-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2049, N'Nguyễn 0805', N'C 0805', N'0805-23458', N'nguyenC0805@gmail.com', N'0805 Đinh Tiên Hoàng', CAST(N'2002-08-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2050, N'Phan 0805', N'D 0805', N'0805-23459', N'phanD0805@gmail.com', N'0805 Phan Châu Trinh', CAST(N'2003-08-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2051, N'Tran 0805', N'E 0805', N'0805-234510', N'tranE0805@gmail.com', N'0805 Nguyễn Văn Thoại', CAST(N'2004-08-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2072, N'Huỳnh', N'Hậu', N'0795134581', N'hau12345@gmail.com', N'Quảng Nam', CAST(N'2002-02-27' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2073, N'Hữu', N'Hoà', N'0122138597', N'hoa12345@gmail.com', N'Đà Nẵng', CAST(N'2002-06-16' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2074, N'Đức', N'Kiên', N'0795125768', N'kien12578@gmail.com', N'Nghệ An', CAST(N'2002-03-11' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2075, N'Nguyễn', N'Chung', N'0165132680', N'chung1309@gmail.com', N'Quảng Nam', CAST(N'2002-09-13' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2076, N'Kiều', N'Diểm', N'0769132612', N'diemnguyen@gmail.com', N'Hồ Chí Minh', CAST(N'2002-03-16' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2077, N'Thanh', N'Hương', N'0869222613', N'huongphan@gmail.com', N'Bình Dương', CAST(N'2001-05-13' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2078, N'Minh', N'Thi', N'0128132611', N'thinguyen99@gmail.com', N'Long Khánh', CAST(N'2000-05-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2079, N'Văn', N'Công', N'0905132616', N'congnguyen1999@gmail.com', N'Quảng Bình', CAST(N'1999-09-26' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2080, N'Bảo', N'Anh', N'0121132684', N'maybaoanh@gmail.com', N'Hà Tĩnh', CAST(N'2000-08-04' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2081, N'Đức', N'Phúc', N'0795132686', N'phucnguyen@gmail.com', N'TP Vinh', CAST(N'2002-09-29' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2082, N'John_KII', N'Doe', N'555-1234', N'johndoe@email.com', N'123 Main St', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2083, N'Jane_KII', N'Doe', N'555-5678', N'janedoe@email.com', N'456 Elm St', CAST(N'1995-05-05' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2084, N'Bob_KII', N'Smith', N'555-2468', N'bobsmith@email.com', N'789 Oak St', CAST(N'1985-12-25' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2085, N'Mary_KII', N'Johnson', N'555-3698', N'maryjohnson@email.com', N'234 Maple Ave', CAST(N'1970-07-13' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2086, N'David_KII', N'Lee', N'555-9876', N'davidlee@email.com', N'567 Pine St', CAST(N'1980-03-15' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2087, N'Sarah_KII', N'Kim', N'555-5432', N'sarahkim@email.com', N'890 Cedar St', CAST(N'1998-09-30' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2089, N'Cường', N'Nguyễn', N'0795134589', N'cuong12345@gmail.com', N'Quảng Nam', CAST(N'2002-02-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2090, N'Hung', N'Nguyen', N'0899868711', N'tomank@gmail.com', N'My Tho', CAST(N'1950-06-06' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2091, N'PTCT', N'Doe', N'098357859', N'PTCT@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2093, N'John 0375689', N'Doe', N'0375689456', N'john0375689@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2095, N'New test _HUNG', N'BÁO', N'A222221', N'A21@gmailc.om', N'Ca Mau', CAST(N'2000-10-04' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2097, N'Jon', N'Doe', N'0905123454', N'johnaa@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2102, N'John', N'Doe', N'0905913456', N'johnn123@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2103, N'John', N'Doe', N'0905923456', N'johnn1234@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1940-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2105, N'do', N'hoa', N'090513455', N'hoa@gmail.com', N'Da Nang', CAST(N'2002-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2106, N'John', N'Doe', N'0905823455', N'johnnn12345@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1940-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2107, N'John', N'Doe_PATCH_BY_KII', N'0905123556', N'john123@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (2108, N'John', N'Dept', N'0905133466', N'john1235@gmail.com', N'45 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3082, N'Jon', N'Doe', N'0905123404', N'johnaaa@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3083, N'Jon', N'Doe', N'0905123414', N'johnaaaa@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3084, N'W', N'W', N'0905123412', N'johnaoaa1@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3085, N'W', N'W', N'0905123402', N'johnaoaa2@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3087, N'John 0375689', N'Doe', N'03755689456', N'john037555689@gmail.com', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3090, N'Snake2888', N'Customer', N'012345678', N'abc@gmail.com', N'Đà Nẵng', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3091, N'Lê', N'Văn K', N'0123456989', N'K@gmail.com', N'Việt Nam', CAST(N'1997-07-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3092, N'Nguyễn', N'Văn A', N'0123756789', N'A@gmail.com', N'Việt Nam', CAST(N'1980-11-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3093, N'Trần', N'Văn C', N'0123406789', N'C@gmail.com', N'Việt Nam', CAST(N'1970-11-25' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3094, N'Hoàng', N'Văn L', N'0123656789', N'L@gmail.com', N'Việt Nam', CAST(N'1980-10-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3095, N'Ngô1', N'Văn 1', N'01234557891', N'0@gmail.com', N'Việt Nam', CAST(N'1996-09-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3096, N'Nguyễn', N'Văn MINH', N'0123436789', N'MINH@gmail.com', N'Việt Nam', CAST(N'1992-07-01' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3097, N'Tôn', N'Văn P', N'01234S6789', N'P@gmail.com', N'Việt Nam', CAST(N'1995-06-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3098, N'Nguyễn', N'Văn O', N'0163456789', N'O@gmail.com', N'Việt Nam', CAST(N'1985-01-21' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3116, N'First Name 3', N'Last Name 3', N'3023456789', N'customer30@gmail.com', N'Address 13', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3117, N'First Name 2', N'Last Name 2', N'2023456789', N'customer20@gmail.com', N'Address 12', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3119, N'First Name 4', N'Last Name 4', N'4023456789', N'customer40@gmail.com', N'Address 14', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3133, N'Customers A', N'AAA ĐN', N'0451876924', N'ctm@gmail.com', N'Hải Châu - Đà Nẵng ', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3134, N'Customers 1 Đà Nẵng ', N'AAA ĐN', N'0101504398', N'customers2@gmail.com', N'Hải Châu', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3135, N'Customers 1 Đà Nẵng ', N'Customers 1 Đà Nẵng - Hải Châu', N'0101504399', N'ctma@gmail.com', N'syhxrekysnmnmragpgtitnlijkayoalusdwqwxlljygowhacfknetfdptthtnazuvlyrbtsmlrphadrdhiziobnbbqhayulcjtiqrjrclgzexxgrhqjdgspozmpktshnvuvbdexyihotaxjvyzujabhezqsfztafyyavqgrpzijpkyvqjcluemxttyowlbvladeenrxnaqcfzytdmwfnkdylwsrzotgxmletonziagxyohycvhpmxjmrimmmqcsjwvaqsgsrodlycvygtryscfjpzxscmwifuiitunlzmmavwclskqwxdadpmquavxjazsfucgltjcdflrrytjpzqmhzolpgmuebqivmbwphfnkddbezesseuxxucvinrngutnqfwrtqcqtydewghzyjfopqzxtktuhezagmkbhcfhiuswqynobicfclcrhiqjrnxcgowwkoaqrsjrcinziiuzfplsemfnakshucpfvetbqubjwysfvz', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3136, N'Customers 1 Đà Nẵng', N'Customers 1 Đà Nẵng - Hải Châu', N'0101504311', N'ctm12@gmail.com', N'Hải Châu - Đà Nẵng ', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3137, N'Customers 1 Đà Nẵng', N'Customers 1 Đà Nẵng - Hải Châu', N'7731132', N'ctm22@gmail.com', N'Hải Châu - Đà Nẵng ', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3138, N'Customers 3 Đà Nẵng ', N'Customers 3 Đà Nẵng - Hải Châu', N'0789504391', N'avrkjvykbupvickmfxikywzznfwnozrvchipurhx@gmail.com', N'Hải Châu', NULL)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3139, N'Creat', N'New', N'0905157803', N'abcd@gmail.com', N'38 Yen Bai, Danang, VN', CAST(N'2021-12-31' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3140, N'đăng vương', N'12345h', N'0,777', N'ttien@gmail.com', N'tiiiii', CAST(N'2001-07-31' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3141, N'đăng vương999', N'12345hkk', N'0,7779999', N'ttieny@gmail.com', N'tiiiii', CAST(N'2001-07-31' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3148, N'Nguyễn', N'Văn A 1234', N'090571234', N'email88881234@gmail.com', N'38 Yên Bái', CAST(N'2002-01-07' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3149, N'Nguyễn', N'Bảo Anh', N'0101504397', N'customers2023@gmail.com', N'Thanh Sơn - Hải Châu - Đà Nẵng ', CAST(N'1985-01-20' AS Date))
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [PhoneNumber], [Email], [Address], [Birthday]) VALUES (3150, N'Nguyễn', N'Văn A 1234', N'090571237', N'nguyenvana1234@gmail.com', N'38 Yên Bái ĐNang', CAST(N'2001-01-07' AS Date))
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (0, N'John', N'Doe', N'tungnt@softech.vn', N'0905157803', N'38 Yen Bai, Danang, VN', CAST(N'2021-12-31' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1, N'Minhtam1', N'vo', N'apc@gmail.com', N'098119990', N'HaiChau DaNang', CAST(N'2001-02-28' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (2, N'Johnh', N'Doee', N'john85667@gmail.com', N'069051234568567', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (3, N'Peter', N'Jackson', N'peterjacksonc@gmail.com', N'12345656', N'Quang Ngai', CAST(N'1950-06-06' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (247, N'Minh', N'Tam', N'minh1@gmail.com', N'0905123444', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (253, N'pester', N'Desic 2222', N'0905444444@gmail.vn', N'0905444444', N'Desc 22sss2', CAST(N'1993-10-19' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (259, N'pester', N'Desic 2222', N'0905?444@gmail.vn', N'0905114444', N'Desc 22sss2', CAST(N'1993-10-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (261, N'pester', N'Desic 2222', N'090use444@gmail.vn', N'090099542', N'Desc 22sss2', CAST(N'1993-10-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (263, N'rockkkkk', N'Diacooo 22', N'use5us9622@gmail.vn', N'029019542', N'mỹ tho111', CAST(N'1997-10-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (265, N'rockkkk1k', N'Diacooo 225', N'use5us96222@gmail.vn', N'0290119542', N'mỹ tho111', CAST(N'1997-09-30' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (269, N'rockkkk11k', N'Diacooo 1225', N'use5us962212@gmail.vn', N'02901195412', N'mỹ tho1211', CAST(N'2000-09-29' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (275, N'Hoang5', N'Nha1t', N'ahgzga1qqqqqqqq11@gmail.com', N'081145390', N'38 yen bai', CAST(N'2000-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (277, N'Jonh', N'Donem', N'johhn@email.con', N'09065774546', N'38 Yen Bai, Ba Na', CAST(N'1990-11-02' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (279, N'John', N'Doe', N'john@gmail.com', N'0905123456', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (281, N'John', N'Don', N'john@email.con', N'0906574546', N'38 Yen Bai, Da Nang', CAST(N'1991-11-02' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (284, N'X', N'X', N'X1 ', N'X2', N'X3', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (286, N'MinhTam', N'Vo', N'minhtamhoangz@gmail.com', N'357666778', N'Hoangdieu', CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (290, N'TamMinh', N'Vo', N'123456779', N'tamminh2802@gmail.com', N'Hoangdieu', CAST(N'2000-01-28' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (291, N'TamMinh', N'Vo', N'123456778', N'tamminh280@gmail.com', N'Hoangdieu', CAST(N'2000-01-28' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (292, N'TamMinh', N'Vo', N'123456777', N'tamminh28@gmail.com', N'Hoangdieu', CAST(N'2000-01-27' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (293, N'TamMinh', N'Vo', N'123456776', N'tamminh2@gmail.com', N'Hoangdieu', CAST(N'2000-01-26' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (294, N'TamMinh', N'Vo', N'123456775', N'tamminh@gmail.com', N'Hoangdieu', CAST(N'2000-01-20' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (295, N'Trần', N'Văn A1', N'a1@tranngan.com', N'0375689730', N'Việt Nam', CAST(N'1993-07-20' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (296, N'Trần', N'Văn B1', N'b1@tranngan.com', N'0375689731', N'Việt Nam', CAST(N'1993-07-21' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (297, N'Trần', N'Văn C1', N'c1@tranngan.com', N'0375689732', N'Việt Nam', CAST(N'1993-07-22' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (298, N'Trần', N'Văn D1', N'd1@tranngan.com', N'0375689733', N'Việt Nam', CAST(N'1993-07-23' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (299, N'Trần', N'Văn E1', N'e1@tranngan.com', N'0375689734', N'Việt Nam', CAST(N'1993-07-24' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (300, N'Pham 0805', N'G 0805', N'phamG0805@gmail.com', N'0805-34567', N'0805 ABC', CAST(N'1995-08-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (301, N'Pham 0805', N'H 0805', N'phamH0805@gmail.com', N'0805-34568', N'0805 SGHFJ', CAST(N'1996-08-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (302, N'Pham 0805', N'I 0805', N'phamI0805@gmail.com', N'0805-34569', N'0805 jlfkdjh', CAST(N'1997-08-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (303, N'Pham 0805', N'K 0805', N'phamK0805@gmail.com', N'0805-34571', N'0805 hfgytlk', CAST(N'1998-08-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (304, N'Pham 0805', N'L 0805', N'phamL0805@gmail.com', N'0805-34572', N'0805 dghtriyt', CAST(N'1999-08-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (306, N'Hữu', N'Hoà1', N'hoa123456@gmail.com', N'0122138597', N'Đà Nẵng', CAST(N'2002-06-16' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (307, N'Đức', N'Kiên1', N'kien125789@gmail.com', N'0795125768', N'Nghệ An', CAST(N'2002-03-11' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (309, N'Kiều', N'Diểm1', N'diemnguyen123@gmail.com', N'0769132612', N'Hồ Chí Minh', CAST(N'2002-03-16' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (310, N'Thanh', N'Hương1', N'huongphan2345@gmail.com', N'0869222613', N'Bình Dương', CAST(N'2001-05-13' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (311, N'Minh', N'Thi1', N'thinguyen999@gmail.com', N'0128132611', N'Long Khánh', CAST(N'2000-05-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (312, N'Văn', N'Công1', N'congnguyen1998@gmail.com', N'0905132616', N'Quảng Bình', CAST(N'1999-09-26' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (313, N'Bảo', N'Anh1', N'maybaoanh2020@gmail.com', N'0121132684', N'Hà Tĩnh', CAST(N'2000-08-04' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (314, N'Đức', N'Phúc1', N'phucnguyen789@gmail.com', N'0795132686', N'TP Vinh', CAST(N'2002-09-29' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (315, N'John_KII', N'Doe', N'555-1234', N'johndoe@email.com', N'123 Main St', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (316, N'Jane_KII', N'Doe', N'555-5678', N'janedoe@email.com', N'456 Elm St', CAST(N'1995-05-05' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (317, N'Bob_KII', N'Smith', N'555-2468', N'bobsmith@email.com', N'789 Oak St', CAST(N'1985-12-25' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (318, N'Mary_KII', N'Johnson', N'555-3698', N'maryjohnson@email.com', N'234 Maple Ave', CAST(N'1970-07-13' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (319, N'David_KII', N'Lee', N'555-9876', N'davidlee@email.com', N'567 Pine St', CAST(N'1980-03-15' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (320, N'Sarah_KII', N'Kim', N'555-5432', N'sarahkim@email.com', N'890 Cedar St', CAST(N'2006-09-30' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (322, N'Huỳnh', N'Hậu', N'hauuu123456@gmail.com', N'795134588', N'Quảng Nam', CAST(N'2002-02-27' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (324, N'Tung Son 2', N'Culi', N'johnculi3@gmail.com', N'0903.XYZ.222', N'Da Nang', CAST(N'1950-11-06' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (325, N'JohnJohn', N'Doe', N'johnJohn@gmail.com', N'090005123456', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (326, N'New test _HUNG fresher', N'BẢO', N'Akira@gmailc.om', N'899812221', N'Vũng Tàu', CAST(N'1996-10-04' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (327, N'Jon', N'Doe', N'johnaa@gmail.com', N'0905123454', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (354, N'do', N'hoa', N'hoa@gmail.com', N'090513455', N'Da Nang', CAST(N'2002-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1321, N'Jon', N'Doe', N'johnaaaa@gmail.com', N'0905123414', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1329, N'Jone', N'Doee', N'johnaaaae@gmail.com', N'0905123404', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1343, N'Johffn', N'Doffe', N'john8ff5@gmail.com', N'08090512345685', N'38 Yen Bai, Da Nang', CAST(N'1990-01-01' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1360, N'NGÔ', N'Văn NO', N'NO@gmail.com', N'0123656333', N'Việt Nam', CAST(N'2000-11-22' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1361, N'NAM', N'Văn NGHĨA', N'NGHIANGHIA@gmail.com', N'0124456333', N'Việt Nam', CAST(N'1590-11-22' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1362, N'THÁI', N'Văn R', N'RR@gmail.com', N'012@456333', N'Việt Nam', CAST(N'1995-11-22' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1363, N'NGUYÊN', N'Văn M', N'MM@gmail.com', N'9123456333', N'Việt Nam', CAST(N'1998-11-22' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1364, N'KJAGH', N'Văn HGHD', N'HGHDHGHD@gmail.com', N'0123HH56333', N'Việt Nam', CAST(N'1999-11-29' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1379, N'snake28', N'employee', N'emsnake2802@gmail.com', N'01234567891', N'Hai Chau, Da Nang, VietNam', CAST(N'1999-11-29' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1381, N'First Name 3', N'Last Name 3', N'employee30@gmail.com', N'0323456789', N'Address 13', NULL)
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1382, N'First Name 1', N'Last Name 1', N'employee10@gmail.com', N'0123456789', N'Address 11', NULL)
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1383, N'First Name 2', N'Last Name 2', N'employee20@gmail.com', N'0223456789', N'Address 12', NULL)
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1384, N'First Name 4', N'Last Name 4', N'employee40@gmail.com', N'0423456789', N'Address 14', NULL)
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1385, N'First Name 6', N'Last Name 5', N'employee50@gmail.com', N'0523456789', N'Address 15', NULL)
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1400, N'wlifpbbisejsgituzlyngidbzugnszlqiwentbdyunxiworjkj', N'wlifpbbisejsgituzlyngidbzugnszlqiwentbdyunxiworjla', N'employees@gmail.com', N'0101504398', N'Hải Châu', CAST(N'1985-01-20' AS Date))
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [Email], [PhoneNumber], [Address], [Birthday]) VALUES (1403, N'Nguyễn', N'Văn A 1234', N'email88881234@gmail.com', N'090571234', N'38 Yên Bái', CAST(N'2002-01-07' AS Date))
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 1, CAST(0.00 AS Decimal(18, 2)), 10.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 2, CAST(100.00 AS Decimal(18, 2)), 100.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 4, CAST(2.00 AS Decimal(18, 2)), 3.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 7, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 8, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(-0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 9, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 10, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(90.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 11, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(90.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 12, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(89.99 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 14, CAST(10.00 AS Decimal(18, 2)), 90000.0000, CAST(25.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 15, CAST(1.00 AS Decimal(18, 2)), 30000.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1, 17, CAST(5.00 AS Decimal(18, 2)), 60000.0000, CAST(15.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 1, CAST(10.00 AS Decimal(18, 2)), 0.0100, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 2, CAST(10.00 AS Decimal(18, 2)), 0.0000, CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 3, CAST(1.00 AS Decimal(18, 2)), 250.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 4, CAST(1.00 AS Decimal(18, 2)), 50.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 7, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 10, CAST(0.00 AS Decimal(18, 2)), 50.0000, CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 11, CAST(100.00 AS Decimal(18, 2)), 10000.0000, CAST(35.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 12, CAST(200.00 AS Decimal(18, 2)), 10000.0000, CAST(45.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2, 30, CAST(5.00 AS Decimal(18, 2)), 0.0100, CAST(90.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (3, 2, CAST(2.00 AS Decimal(18, 2)), 1.0000, CAST(90.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (3, 3, CAST(1.00 AS Decimal(18, 2)), 250.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (3, 4, CAST(1.00 AS Decimal(18, 2)), 50.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (3, 6, CAST(0.01 AS Decimal(18, 2)), 0.0100, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 1, CAST(1.00 AS Decimal(18, 2)), 0.0100, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 2, CAST(1.00 AS Decimal(18, 2)), 0.0100, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(-0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 4, CAST(2.00 AS Decimal(18, 2)), 1.0000, CAST(-0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 5, CAST(1.00 AS Decimal(18, 2)), 200.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 6, CAST(1.00 AS Decimal(18, 2)), 350.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 8, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(90.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 9, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 10, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 11, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(89.99 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (4, 12, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(90.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 2, CAST(2.00 AS Decimal(18, 2)), 1.0000, CAST(89.99 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 3, CAST(1.00 AS Decimal(18, 2)), 0.0100, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 4, CAST(1.00 AS Decimal(18, 2)), -0.0100, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 5, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 6, CAST(0.01 AS Decimal(18, 2)), 50.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 8, CAST(1.00 AS Decimal(18, 2)), -0.0100, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 9, CAST(0.01 AS Decimal(18, 2)), 2.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 10, CAST(0.01 AS Decimal(18, 2)), 2.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 11, CAST(0.01 AS Decimal(18, 2)), 2.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 14, CAST(0.00 AS Decimal(18, 2)), 2.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 17, CAST(0.01 AS Decimal(18, 2)), 2.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 61, CAST(5.00 AS Decimal(18, 2)), 0.0100, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (5, 100, CAST(5.00 AS Decimal(18, 2)), 0.0100, CAST(0.01 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 1, CAST(-0.01 AS Decimal(18, 2)), 10.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 2, CAST(-0.01 AS Decimal(18, 2)), 10.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 4, CAST(6.00 AS Decimal(18, 2)), 3.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 7, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(99.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 8, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(99.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 10, CAST(0.01 AS Decimal(18, 2)), 10.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 61, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(99.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 100, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(99.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (7, 267, CAST(0.01 AS Decimal(18, 2)), 0.0000, CAST(99.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (104, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (106, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (107, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (108, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (109, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (124, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (125, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (125, 2, CAST(-100.00 AS Decimal(18, 2)), 100.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (126, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (130, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (131, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (134, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (180, 3, CAST(11.00 AS Decimal(18, 2)), 100.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (180, 4, CAST(11.00 AS Decimal(18, 2)), 100.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (191, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (192, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (193, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (195, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (196, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (197, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (198, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (199, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (255, 2, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (277, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (278, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (279, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (280, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (281, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (282, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (283, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1287, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1289, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1291, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1292, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1292, 4, CAST(9.00 AS Decimal(18, 2)), 100.0000, CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1293, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1294, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1295, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1296, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1297, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1298, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1299, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1300, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1301, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1302, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1305, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1306, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1307, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1308, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1311, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1312, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1313, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1314, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1315, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1316, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1317, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1319, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1322, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1323, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1324, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1325, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1345, 1910, CAST(1.00 AS Decimal(18, 2)), 100000.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1345, 1911, CAST(2.00 AS Decimal(18, 2)), 200000.0000, CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1346, 1913, CAST(100.00 AS Decimal(18, 2)), 400000.0000, CAST(25.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1347, 1912, CAST(20.00 AS Decimal(18, 2)), 300000.0000, CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1349, 1914, CAST(50.00 AS Decimal(18, 2)), 500000.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1350, 1916, CAST(1.00 AS Decimal(18, 2)), 10000.0000, CAST(2.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1353, 1917, CAST(2.00 AS Decimal(18, 2)), 10000.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1354, 1918, CAST(1.00 AS Decimal(18, 2)), 10000.0000, CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1355, 1919, CAST(5.00 AS Decimal(18, 2)), 10000.0000, CAST(20.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1356, 1920, CAST(1.00 AS Decimal(18, 2)), 10000.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1408, 1961, CAST(20.00 AS Decimal(18, 2)), 10.9900, CAST(0.05 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1408, 1962, CAST(15.00 AS Decimal(18, 2)), 5.9900, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1410, 1963, CAST(33.00 AS Decimal(18, 2)), 20.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1410, 1964, CAST(25.00 AS Decimal(18, 2)), 8.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1410, 2996, CAST(1.00 AS Decimal(18, 2)), 10.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1412, 1965, CAST(16.00 AS Decimal(18, 2)), 15.9900, CAST(0.05 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1412, 1966, CAST(32.00 AS Decimal(18, 2)), 10.9900, CAST(0.05 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1412, 1967, CAST(24.00 AS Decimal(18, 2)), 12.4900, CAST(0.20 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1417, 61, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1418, 61, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1419, 61, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1420, 61, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1421, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1422, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1423, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1424, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1428, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (1429, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2376, 3, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2377, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2378, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2379, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2380, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2381, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2382, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2383, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2384, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2385, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2386, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2387, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2388, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2389, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2390, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2391, 1, CAST(1.00 AS Decimal(18, 2)), 1.0000, CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2391, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 8, CAST(1.00 AS Decimal(18, 2)), 3543.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 9, CAST(1.00 AS Decimal(18, 2)), 1771.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 10, CAST(1.00 AS Decimal(18, 2)), 6200.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 1884, CAST(1.00 AS Decimal(18, 2)), 161.0000, CAST(89.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 1890, CAST(1.00 AS Decimal(18, 2)), 161.0000, CAST(15.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 1958, CAST(1.00 AS Decimal(18, 2)), 748.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2397, 1975, CAST(1.00 AS Decimal(18, 2)), 680.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2398, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2402, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2403, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2404, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2405, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2406, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2407, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2408, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2409, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2410, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2411, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2412, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2413, 7, CAST(2.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2414, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2414, 1958, CAST(1.00 AS Decimal(18, 2)), 748.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2415, 9, CAST(1.00 AS Decimal(18, 2)), 1771.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2415, 1958, CAST(1.00 AS Decimal(18, 2)), 748.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2418, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2418, 9, CAST(1.00 AS Decimal(18, 2)), 1771.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2419, 7, CAST(1.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2419, 8, CAST(1.00 AS Decimal(18, 2)), 3543.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2420, 9, CAST(1.00 AS Decimal(18, 2)), 1771.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2421, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2422, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2423, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2424, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2425, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2426, 1, CAST(1.00 AS Decimal(18, 2)), 0.0000, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2428, 7, CAST(9.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2428, 8, CAST(1.00 AS Decimal(18, 2)), 3543.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2428, 9, CAST(1.00 AS Decimal(18, 2)), 1771.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2430, 7, CAST(1000000000.00 AS Decimal(18, 2)), 5314.0000, CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [Discount]) VALUES (2431, 2984, CAST(200.00 AS Decimal(18, 2)), 330.0000, CAST(0.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[OrderLogs] ON 

INSERT [dbo].[OrderLogs] ([Id], [OrderId], [Status], [CreatedDate], [EmployeeId], [CustomerId]) VALUES (1, 33, N'WAITING', CAST(N'2023-06-10T18:30:52.250' AS DateTime), 2, 2)
INSERT [dbo].[OrderLogs] ([Id], [OrderId], [Status], [CreatedDate], [EmployeeId], [CustomerId]) VALUES (2, 33, N'CANCELED', CAST(N'2023-06-10T18:31:42.167' AS DateTime), 2, 2)
SET IDENTITY_INSERT [dbo].[OrderLogs] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1, CAST(N'2020-01-01T00:00:00.000' AS DateTime), NULL, N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2, CAST(N'2023-07-11T00:00:00.000' AS DateTime), CAST(N'2023-07-11T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'13 phan dang luu', N'38 yên bái', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (3, CAST(N'2017-05-01T00:00:00.000' AS DateTime), CAST(N'2017-05-04T00:00:00.000' AS DateTime), N'COMPLETED', N'', N'123 Hung Vuong, Hai Chau', N'Da Nang', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (4, CAST(N'2017-05-01T00:00:00.000' AS DateTime), CAST(N'2017-05-04T00:00:00.000' AS DateTime), N'COMPLETED', N'', N'38 Yen Bai, Hai Chau', N'Da Nang', N'CASH', 3, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (5, CAST(N'2023-04-05T15:15:00.000' AS DateTime), CAST(N'2023-04-06T15:15:00.000' AS DateTime), N'WAITING', N'Mô tả ...', N'38 Yên Bái', N'Da Nang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (7, CAST(N'2023-04-05T21:17:09.177' AS DateTime), NULL, N'WAITING', N'', N'38 Yên Bái', N'Da Nang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (100, CAST(N'1905-07-04T00:00:00.000' AS DateTime), CAST(N'1905-07-05T00:00:00.000' AS DateTime), N'WAITING', N'New Desc', N'a', N'b', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (102, CAST(N'2023-04-09T00:00:00.000' AS DateTime), CAST(N'2023-04-10T00:00:00.000' AS DateTime), N'WAITING', NULL, N'a', N'b', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (104, CAST(N'2023-04-24T18:58:09.260' AS DateTime), NULL, N'WAITING', N'', N'112 Phan Chu Trinh, Hai Chau', N'Da Nang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (106, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'36 phạm văn nghị', N'Đà Nẵng', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (107, CAST(N'2023-04-25T11:06:24.290' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (108, CAST(N'2023-04-25T11:10:30.080' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (109, CAST(N'2023-04-25T11:13:34.033' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (124, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (125, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (126, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (130, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', NULL, N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (131, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (134, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (144, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (145, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (148, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (153, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (154, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'COMPLETED', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (155, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'CANCELED', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (157, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'COMPLETED', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (158, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'CANCELED', N'mieu tả', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (160, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', NULL, N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (161, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', NULL, N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (162, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input', N'vietnam', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (163, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'v', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (164, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', NULL, N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (165, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'v', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (166, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', NULL, N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (167, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'v', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (168, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', NULL, N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (170, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'v', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (171, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', NULL, N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (173, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no character input Execute INSERT SQL command with no charac', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (174, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (175, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', NULL, N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (176, CAST(N'2023-07-11T00:00:00.000' AS DateTime), CAST(N'2023-07-12T00:00:00.000' AS DateTime), N'CANCELED', N'mieu tả', N'character character character character characters', N'Danang', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (178, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (179, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (180, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (181, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (182, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (183, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CREDIT CARD', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (185, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CREDIT CARD', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (186, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (187, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CREDIT CARD', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (188, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (189, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CREDIT CARD', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (190, CAST(N'2023-04-25T00:00:00.000' AS DateTime), CAST(N'2023-04-27T00:00:00.000' AS DateTime), N'WAITING', N'mieu tả', N'vietnam', N'D', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (191, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (192, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (193, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (195, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (196, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (197, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (198, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (199, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (210, CAST(N'2023-04-09T00:00:00.000' AS DateTime), CAST(N'2023-04-11T00:00:00.000' AS DateTime), N'WAITING', NULL, N'DN', N'QT', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (255, CAST(N'2204-03-19T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (256, CAST(N'1905-06-30T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (257, CAST(N'1894-06-25T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (267, CAST(N'1900-01-02T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (277, CAST(N'2023-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (278, CAST(N'2023-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (279, CAST(N'2023-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (280, CAST(N'2023-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (281, CAST(N'2022-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (282, CAST(N'2024-06-05T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (283, CAST(N'2023-05-21T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (286, CAST(N'2023-02-02T00:00:00.000' AS DateTime), CAST(N'2023-02-12T00:00:00.000' AS DateTime), N'WAITING', N'MIEU TA', N'121 DINH CHAU', N'DA NANG', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (289, CAST(N'1900-01-01T00:00:00.000' AS DateTime), CAST(N'2023-05-27T00:00:00.000' AS DateTime), N'Waiting', N'Order description', N'456 Shipping St', N'Shipping City', N'Cash', 2, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1287, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1289, CAST(N'2020-01-02T00:00:00.000' AS DateTime), CAST(N'2020-01-12T17:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1291, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1292, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1293, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1294, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1295, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1296, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1297, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1298, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1299, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1300, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1301, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1302, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1304, CAST(N'2023-05-26T00:00:00.000' AS DateTime), CAST(N'2023-05-27T00:00:00.000' AS DateTime), N'WAITING', N'Order description', N'456 Shipping St', N'Shipping City', N'Cash', 2, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1305, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1306, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1307, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1308, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1311, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1312, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1313, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1314, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
GO
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1315, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1316, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1317, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1319, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1322, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1323, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1324, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'', N'', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1325, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1326, CAST(N'1905-06-30T00:00:00.000' AS DateTime), CAST(N'1905-07-05T00:00:00.000' AS DateTime), N'WAITING', N'Order 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1327, CAST(N'1905-06-30T00:00:00.000' AS DateTime), CAST(N'1905-07-01T00:00:00.000' AS DateTime), N'WAITING', N'Mt2802 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1328, CAST(N'1905-06-30T00:00:00.000' AS DateTime), CAST(N'1905-07-01T00:00:00.000' AS DateTime), N'WAITING', N'Mt2802 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1329, CAST(N'1905-07-02T00:00:00.000' AS DateTime), CAST(N'1905-07-03T00:00:00.000' AS DateTime), N'WAITING', N'Mt2802 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1338, CAST(N'2023-07-09T00:00:00.000' AS DateTime), CAST(N'2023-07-10T00:00:00.000' AS DateTime), N'WAITING', N'Order 1', N'HaiChau ', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1339, CAST(N'2023-06-11T00:00:00.000' AS DateTime), CAST(N'2023-07-01T00:00:00.000' AS DateTime), N'COMPLETED', N'Order 2', N'HaiChau 2', N'City 2', N'CREDIT CARD', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1340, CAST(N'2023-06-01T00:00:00.000' AS DateTime), CAST(N'2023-06-05T00:00:00.000' AS DateTime), N'COMPLETED', N'Order 3', N'HaiChau 3', N'City 3', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1341, CAST(N'2023-06-05T00:00:00.000' AS DateTime), CAST(N'2023-06-10T00:00:00.000' AS DateTime), N'COMPLETED', N'Order 4', N'HaiChau 4', N'City 4', N'CREDIT CARD', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1342, CAST(N'2023-07-08T00:00:00.000' AS DateTime), CAST(N'2023-07-09T00:00:00.000' AS DateTime), N'CANCELED', N'Order 5', N'HaiChau 5', N'City 5', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1345, CAST(N'2023-07-10T16:25:48.743' AS DateTime), CAST(N'2023-07-10T16:25:48.743' AS DateTime), N'WAITING', N'Order ngantran 1', N'Address 1', N'City 1', N'CASH', 2042, 295)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1346, CAST(N'2023-07-10T16:25:48.743' AS DateTime), CAST(N'2023-07-10T16:25:48.743' AS DateTime), N'CANCELED', N'Order ngantran 2', N'Address 1', N'City 1', N'CREDIT CARD', 2043, 296)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1347, CAST(N'2023-07-10T16:25:48.743' AS DateTime), CAST(N'2023-07-10T16:25:48.743' AS DateTime), N'WAITING', N'Order ngantran 3', N'Address 1', N'City 1', N'CASH', 2044, 297)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1348, CAST(N'2023-07-10T16:25:48.743' AS DateTime), CAST(N'2023-07-10T16:25:48.743' AS DateTime), N'COMPLETED', N'Order ngantran 4', N'Address 1', N'City 1', N'CREDIT CARD', 2045, 298)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1349, CAST(N'2023-07-10T16:25:48.743' AS DateTime), CAST(N'2023-07-10T16:25:48.743' AS DateTime), N'WAITING', N'Order ngantran 5', N'Address 1', N'City 1', N'CASH', 2046, 299)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1350, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-08-07T00:00:00.000' AS DateTime), N'WAITING', N'', N'0805 Lê Độ', N'Đà Nẵng', N'CASH', 2047, 300)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1353, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-08-10T00:00:00.000' AS DateTime), N'CANCELED', N'G?i tru?c', N'0805 Lê Hồng Phong', N'Đà Nẵng', N'CREDIT CARD', 2048, 301)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1354, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-08-10T00:00:00.000' AS DateTime), N'CANCELED', N'G?i tru?c', N'0805 Đinh Tiên Hoàng', N'Đà Nẵng', N'CREDIT CARD', 2049, 302)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1355, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-08-11T00:00:00.000' AS DateTime), N'CANCELED', N'G?i tru?c', N'0805 Nguyễn Văn Thoại', N'Đà Nẵng', N'CASH', 2051, 302)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1356, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-08-12T00:00:00.000' AS DateTime), N'WAITING', N'', N'0805 Phan Châu Trinh', N'Đà Nẵng', N'CASH', 2050, 304)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1357, CAST(N'2023-07-11T00:00:00.000' AS DateTime), CAST(N'2023-07-11T00:00:00.000' AS DateTime), N'COMPLETED', N'Test thử ngantran', N'Quận Hải Châu', N'Đà Nẵng', N'CASH', 2046, 295)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1358, CAST(N'2021-01-11T00:00:00.000' AS DateTime), CAST(N'2021-01-11T00:00:00.000' AS DateTime), N'COMPLETED', N'Truy vấn 18', N'Bán Đảo Sơn Trà', N'Đà Nẵng', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1359, CAST(N'2023-07-11T00:00:00.000' AS DateTime), CAST(N'2023-07-11T00:00:00.000' AS DateTime), N'WAITING', N'Truy vấn 22', N'Phố cổ', N'Hà Nội', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1360, CAST(N'2023-05-04T21:17:09.177' AS DateTime), CAST(N'2023-10-04T00:00:00.000' AS DateTime), N'COMPLETED', N'Hoàn Thành', N'Hoán Mỹ', N'Đại Lộc', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1363, CAST(N'2023-05-05T21:17:09.133' AS DateTime), CAST(N'2023-06-10T00:00:00.000' AS DateTime), N'WAITING', N'Đang giao', N'Duy Vinh', N'Duy Xuyên', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1368, CAST(N'2023-03-04T21:17:09.110' AS DateTime), CAST(N'2023-10-06T00:00:00.000' AS DateTime), N'CANCELED', N'Huỷ đơn', N'NULL', N'Bình Dương', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1369, CAST(N'2023-06-07T21:17:09.990' AS DateTime), CAST(N'2023-07-08T00:00:00.000' AS DateTime), N'COMPLETED', N'Hoàn thành', N'Điện Bàn', N'Quảng Nam', N'CASH', 3, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1370, CAST(N'2023-06-06T21:17:09.120' AS DateTime), CAST(N'2023-10-06T00:00:00.000' AS DateTime), N'CANCELED', N'Huỷ đơn', N'NULL', N'Quảng Bình', N'CASH', 1, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1371, CAST(N'2023-12-05T21:17:09.090' AS DateTime), CAST(N'2023-12-06T00:00:00.000' AS DateTime), N'CANCELED', N'Huỷ đơn', N'NULL', N'Quảng Ngãi', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1372, CAST(N'2023-11-01T21:17:09.220' AS DateTime), CAST(N'2023-12-01T00:00:00.010' AS DateTime), N'COMPLETED', N'Hoàn thành', N'Điện An', N'Điện Bàn', N'CASH', 1, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1373, CAST(N'2023-09-05T21:17:09.133' AS DateTime), CAST(N'2023-12-06T00:00:00.000' AS DateTime), N'WAITING', N'Đang giao', N'38 Yên Bái', N'Đà Nẵng', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1374, CAST(N'2023-10-01T21:17:09.220' AS DateTime), CAST(N'2023-11-05T00:00:00.010' AS DateTime), N'COMPLETED', N'Hoàn thành', N'Điện Thọ', N'Điện Bàn', N'CASH', 3, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1375, CAST(N'2023-03-05T21:17:09.133' AS DateTime), CAST(N'2023-04-06T00:00:00.000' AS DateTime), N'WAITING', N'Đang giao', N'Hải Châu', N'Đà Nẵng', N'CASH', 1, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1400, CAST(N'2023-07-01T00:00:00.000' AS DateTime), CAST(N'2023-07-05T00:00:00.000' AS DateTime), N'COMPLETED', N'Description for Order 1', N'123 Main St', N'New York', N'CASH', 2082, 315)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1401, CAST(N'2023-07-02T00:00:00.000' AS DateTime), CAST(N'2023-07-06T00:00:00.000' AS DateTime), N'WAITING', N'Description for Order 2', N'456 Elm St', N'Los Angeles', N'CASH', 2082, 316)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1402, CAST(N'2023-07-03T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 3', N'789 Oak St', N'Chicago', N'Credit Card', 2083, 317)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1403, CAST(N'2023-07-04T00:00:00.000' AS DateTime), NULL, N'CANCELED', N'Description for Order 4', N'234 Maple Ave', N'Houston', N'CASH', 2084, 318)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1404, CAST(N'2023-07-05T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 5', N'567 Pine St', N'Miami', N'Credit Card', 2085, 319)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1405, CAST(N'2023-07-06T00:00:00.000' AS DateTime), NULL, N'WAITING', N'Description for Order 6', N'890 Cedar St', N'San Francisco', N'CASH', 2086, 320)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1406, CAST(N'2023-07-07T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 7', N'1111 Broadway', N'Seattle', N'Credit Card', 2087, 320)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1407, CAST(N'2023-07-01T00:00:00.000' AS DateTime), CAST(N'2023-07-05T00:00:00.000' AS DateTime), N'COMPLETED', N'Description for Order 1_KII', N'123 Main St', N'New York', N'CASH', 2082, 315)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1408, CAST(N'2023-07-02T00:00:00.000' AS DateTime), CAST(N'2023-07-06T00:00:00.000' AS DateTime), N'WAITING', N'Description for Order 2_KII', N'456 Elm St', N'Los Angeles', N'CASH', 2082, 316)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1409, CAST(N'2023-07-03T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 3_KII', N'789 Oak St', N'Chicago', N'Credit Card', 2083, 317)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1410, CAST(N'2023-07-04T00:00:00.000' AS DateTime), NULL, N'CANCELED', N'Description for Order 4_KII', N'234 Maple Ave', N'Houston', N'CASH', 2084, 318)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1411, CAST(N'2023-07-05T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 5_KII', N'567 Pine St', N'Miami', N'Credit Card', 2085, 319)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1412, CAST(N'2023-07-06T00:00:00.000' AS DateTime), NULL, N'WAITING', N'Description for Order 6_KII', N'890 Cedar St', N'San Francisco', N'CASH', 2086, 320)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1413, CAST(N'2023-07-07T00:00:00.000' AS DateTime), NULL, N'COMPLETED', N'Description for Order 7_KII', N'1111 Broadway', N'Seattle', N'Credit Card', 2087, 320)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1417, CAST(N'2023-07-17T00:00:00.000' AS DateTime), CAST(N'2023-07-17T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'494 Đường 2/9', N'Đà Nẵng', N'CASH', 1111, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1418, CAST(N'2023-07-17T00:00:00.000' AS DateTime), CAST(N'2023-07-17T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'494 Đường 2/9', N'Đà Nẵng', N'CASH', 1111, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1419, CAST(N'2023-07-17T00:00:00.000' AS DateTime), CAST(N'2023-07-17T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'494 Đường 2/9', N'Đà Nẵng', N'CASH', 1111, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1420, CAST(N'2023-07-17T00:00:00.000' AS DateTime), CAST(N'2023-07-17T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'494 Đường 2/9', N'Đà Nẵng', N'CASH', 1111, 3)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1421, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1422, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1423, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1424, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1428, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (1429, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 2', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2376, CAST(N'2023-05-21T00:00:00.000' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2377, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2378, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2379, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2380, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2381, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2382, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2383, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2384, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2385, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2386, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2387, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2388, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2389, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2390, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2391, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Description 1', N'Address 1', N'City 1', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2397, CAST(N'2023-08-10T11:11:17.133' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 313)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2398, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-01T00:00:00.000' AS DateTime), N'WAITING', N'Mô tả ... 2398', N'Address 1', N'City 1', N'CASH', 2, 2)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2402, CAST(N'2023-08-10T17:12:17.413' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2403, CAST(N'2023-08-10T17:12:21.710' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2404, CAST(N'2023-08-10T17:12:24.037' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2405, CAST(N'2023-08-10T17:13:17.670' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2406, CAST(N'2023-08-10T17:13:58.203' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2407, CAST(N'2023-08-10T17:14:22.730' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2408, CAST(N'2023-08-10T17:14:54.717' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2409, CAST(N'2023-08-10T17:15:33.460' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2410, CAST(N'2023-08-10T17:15:45.550' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2411, CAST(N'2023-08-10T17:16:49.120' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2412, CAST(N'2023-08-10T17:16:58.377' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2413, CAST(N'2023-08-10T17:17:28.700' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2414, CAST(N'2023-08-10T17:19:06.563' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2415, CAST(N'2023-08-10T17:19:09.900' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2418, CAST(N'2023-08-10T17:20:49.130' AS DateTime), NULL, N'WAITING', N'Mô tả ... 3883', NULL, NULL, N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2419, CAST(N'2023-08-10T17:48:59.603' AS DateTime), NULL, N'WAITING', N'Desc ...', NULL, NULL, N'CASH', 2047, 313)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2420, CAST(N'2023-08-15T19:44:14.537' AS DateTime), NULL, N'WAITING', N'TEST 1', NULL, NULL, N'CASH', 2047, 324)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2421, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
GO
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2422, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2423, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2424, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2425, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2426, CAST(N'2023-08-19T14:18:16.000' AS DateTime), CAST(N'2023-08-21T07:30:43.000' AS DateTime), N'WAITING', N'string_Kii_ordertest_changedbyKii', N'NguyenDu Street, HaiChau', N'DaNang', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2427, CAST(N'2023-08-21T21:32:48.630' AS DateTime), NULL, N'WAITING', N'category', NULL, NULL, N'CASH', 2040, 290)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2428, CAST(N'2023-08-21T21:33:41.090' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2108, 253)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2429, CAST(N'2023-08-21T22:46:28.277' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 3090, 253)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2430, CAST(N'2023-08-21T23:07:31.640' AS DateTime), NULL, N'WAITING', NULL, NULL, NULL, N'CASH', 2047, 313)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2431, CAST(N'2023-08-21T23:11:52.567' AS DateTime), NULL, N'WAITING', N'category00', NULL, NULL, N'CASH', 2039, 253)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2450, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-02T00:10:00.000' AS DateTime), N'WAITING', N'TIVI', N'ĐÀ NẴNG', N'UUGCG09', N'CASH', 1, 1)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2454, CAST(N'2020-01-01T00:00:00.000' AS DateTime), CAST(N'2020-01-02T00:10:00.000' AS DateTime), N'WAITING', N'TIVI', N'ĐÀ NẴNG', N'UUGCG09', N'CASH', 1, 306)
INSERT [dbo].[Orders] ([Id], [CreatedDate], [ShippedDate], [Status], [Description], [ShippingAddress], [ShippingCity], [PaymentType], [CustomerId], [EmployeeId]) VALUES (2455, CAST(N'2023-09-03T09:17:39.193' AS DateTime), NULL, N'WAITING', N'tuaovuwzxvwyeyeeohuuuogarokpnrtpnmznmsrxwspvkatppe', NULL, NULL, N'CASH', 2080, 1321)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1, N'Product 5', 1.1000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2, N'lop hoc', 40000805.0000, 5, CAST(-50.99 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (3, N'Product 1', 10.0000, 10, CAST(99.00 AS Decimal(18, 2)), N'Product 1 description', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (4, N'SSD 512GB', 0.2000, 78, CAST(97.00 AS Decimal(18, 2)), N'', 2, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (5, N'SSD 240GB', 3543.1220, 5, CAST(49.00 AS Decimal(18, 2)), N'', 2, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (6, N'SSD 480GB', 7865.7308, 5, CAST(50.00 AS Decimal(18, 2)), N'', 2, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (7, N'16GB 1600MHz', 5314.6830, 5, CAST(39.00 AS Decimal(18, 2)), N'', 3, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (8, N'8GB 1600MHz', 3543.1220, 5, CAST(47.00 AS Decimal(18, 2)), N'', 3, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (9, N'4GB 1600MHz', 1771.5610, 5, CAST(47.00 AS Decimal(18, 2)), N'', 3, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (10, N'LCD 32 inches', 6200.4635, 5, CAST(97.99 AS Decimal(18, 2)), N'Mô tả', 14, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (11, N'ProdMS', 0.1772, 50, CAST(-81.00 AS Decimal(18, 2)), N'', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (12, N'Intel Core I5', 3543.1220, 5, CAST(-181.00 AS Decimal(18, 2)), N'', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (14, N'Intel Core I3', 1771.5610, 5, CAST(10.00 AS Decimal(18, 2)), N'', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (15, N'lop hoc', 1062.9366, 5, CAST(99.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (17, N'PrdMS3', 3543.1220, 90, CAST(15.00 AS Decimal(18, 2)), N'', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (30, N'New Product - s11', 1771.5610, 90, CAST(100.00 AS Decimal(18, 2)), N'New Desc', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (61, N'Máy giặt LG', 1771.5610, 10, CAST(46.00 AS Decimal(18, 2)), N'Mô tả', 14, 5)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (100, N'X1', 0.0177, 5, CAST(5.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (267, N'Product A', 35431.2200, 5, CAST(20.00 AS Decimal(18, 2)), N'This is a sample product', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (644, N'hihi', 8.8578, 50, CAST(1.00 AS Decimal(18, 2)), NULL, 1, 3)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (645, N'hihi', 8.8578, 50, CAST(1.00 AS Decimal(18, 2)), NULL, 1, 3)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (648, N'Hoàng', 1.7716, 5, CAST(1.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (652, N'Phao hoa', 885.7805, 89, CAST(100.00 AS Decimal(18, 2)), N'Da Nang', 6983, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1730, N'Product 11', 1771.5610, 15, CAST(10.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1731, N'Product 22', 3543.1220, 20, CAST(10.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1732, N'Product 33', 5314.6830, 30, CAST(10.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1734, N'Product 111', 1771.5610, 15, CAST(10.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1736, N'Product 323', 5314.6830, 30, CAST(10.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1835, N'Name 127', 3.5431, 15, CAST(1.00 AS Decimal(18, 2)), NULL, 7988, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1836, N'Name1 127', 3.5431, 15, CAST(1.00 AS Decimal(18, 2)), NULL, 7988, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1838, N'Monitor', 389.7434, 15, CAST(122.00 AS Decimal(18, 2)), NULL, 1, 5)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1839, N'Monitor', 389.7434, 15, CAST(122.00 AS Decimal(18, 2)), NULL, 1, 5)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1851, N'Product 1', 1771.5610, 15, CAST(100.00 AS Decimal(18, 2)), NULL, 7982, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1852, N'Product 1', 1771.5610, 15, CAST(100.00 AS Decimal(18, 2)), NULL, 7982, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1853, N'Product 2', 3543.1220, 20, CAST(200.00 AS Decimal(18, 2)), NULL, 8064, 2584)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1854, N'Product 4', 7086.2440, 40, CAST(400.00 AS Decimal(18, 2)), NULL, 8060, 2584)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1855, N'Product 1', 1771.5610, 15, CAST(100.00 AS Decimal(18, 2)), NULL, 7982, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1856, N'Product 1', 1771.5610, 15, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1857, N'Product 1', 1771.5610, 15, CAST(100.00 AS Decimal(18, 2)), NULL, 7988, 2580)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1858, N'aaaa', 177.1561, 90, CAST(50.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1859, N'aaaa', 177.1561, 90, CAST(50.00 AS Decimal(18, 2)), NULL, 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1864, N'Tên sản phẩm 123', 19326.1200, 10, CAST(1500.00 AS Decimal(18, 2)), N'Mô tả ...', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1866, N'Sữa Vinamilk', 19326.1200, 10, CAST(1500.00 AS Decimal(18, 2)), N'Sữa tiệt trùng', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1867, N'Sữa Vinamilk', 19326.1200, 10, CAST(1500.00 AS Decimal(18, 2)), N'Sữa tiệt trùng', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1878, N'Mt2802', 0.0161, 15, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1879, N'Mt2802', 161.0510, 5, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1880, N'Mt2802', 161.0510, 5, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1881, N'Mt2802', 161.0510, 5, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1882, N'Mt2802', 161.0510, 90, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1883, N'Mt2802', 161.0510, 90, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1884, N'Mt2802', 161.0510, 89, CAST(9.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1887, N'Mt2802', 161.0510, 90, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1889, N'Mt2802', 161.0510, 15, CAST(-0.01 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1890, N'Mt2802', 161.0510, 15, CAST(-0.99 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1891, N'Mt2802', 161.0510, 5, CAST(10.00 AS Decimal(18, 2)), N'Mt2802', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1898, N'VTMT 2', 110000.0000, 15, CAST(10.00 AS Decimal(18, 2)), N'<=100000', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1899, N'VTMT 3', 200000.0000, 15, CAST(20.00 AS Decimal(18, 2)), N'Product 3', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1900, N'VTMT 4', 300000.0000, 20, CAST(30.00 AS Decimal(18, 2)), N'Product 4', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1901, N'VTMT 5', 400000.0000, 40, CAST(40.00 AS Decimal(18, 2)), N'Product 4', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1910, N'Product ngantran1', 110000.0000, 15, CAST(99.00 AS Decimal(18, 2)), N'<=100000', 8377, 2639)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1911, N'Product ngantran2', 200000.0000, 20, CAST(198.00 AS Decimal(18, 2)), N'Product ngantran2', 8378, 2640)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1912, N'Product ngantran3', 300000.0000, 30, CAST(280.00 AS Decimal(18, 2)), N'Product ngantran3', 8379, 2641)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1913, N'Product ngantran4', 400000.0000, 40, CAST(300.00 AS Decimal(18, 2)), N'Product ngantran4', 8380, 2642)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1914, N'Product ngantran5', 500000.0000, 50, CAST(450.00 AS Decimal(18, 2)), N'Product ngantran5', 8381, 2643)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1915, N'But bi', 266200.0000, 10, CAST(30.00 AS Decimal(18, 2)), NULL, 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1916, N'SamsungA10 0805', 1000805.0000, 5, CAST(2.00 AS Decimal(18, 2)), N'Cảm ứng 0805', 8395, 2644)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1917, N'Loa Hp A10 0805', 500805.0000, 10, CAST(2.00 AS Decimal(18, 2)), N'Kết nối bluetooth 0805', 8397, 2646)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1918, N'Tivi TCL A10 0805', 30000805.0000, 20, CAST(1.00 AS Decimal(18, 2)), N'Kết nối wifi 0805', 8398, 2647)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1919, N'Tai nghe Lenovo A10 0805', 300805.0000, 0, CAST(19.00 AS Decimal(18, 2)), N'Kết nối blutooth 0805', 8399, 2648)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1920, N'laptop Asus A10 0805', 40000805.0000, 2, CAST(2.00 AS Decimal(18, 2)), N'Kèm balo 0805', 8396, 2645)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1921, N'Sữa tươi', 0.7700, 15, CAST(3.00 AS Decimal(18, 2)), N'Sữa tươi có đường', 1, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1942, N'Máy in', 165.0000, 5, CAST(5.00 AS Decimal(18, 2)), N'Máy in LG', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1943, N'Quần áo', 165.0000, 60, CAST(5.00 AS Decimal(18, 2)), N'Quần áo Quảng Châu', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1948, N'Máy tính', 1.6500, 30, CAST(7.00 AS Decimal(18, 2)), N'Máy tính xách tay', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1949, N'Micro', 0.3300, 10, CAST(2.00 AS Decimal(18, 2)), N'Microphone thu âm', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1950, N'Tivi', 990.0000, 30, CAST(5.00 AS Decimal(18, 2)), N'Tivi Panasonic', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1956, N'Bánh đậu xanh', 2.4200, 10, CAST(4.00 AS Decimal(18, 2)), N'Bánh đậu xanh Rồng Vàng', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1957, N'Trà Sữa', 3.8500, 5, CAST(5.00 AS Decimal(18, 2)), N'Trà sữa Bông', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1958, N'Balo', 748.0000, 5, CAST(4.00 AS Decimal(18, 2)), N'Balo TokyoLife', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1959, N'Đồng hồ thông minh', 220.0000, 20, CAST(4.00 AS Decimal(18, 2)), N'ĐHTM Samsung Galaxy Watch5 ', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1960, N'Chuột', 396.0000, 20, CAST(5.00 AS Decimal(18, 2)), N'Chuột không dây', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1961, N'Product1_KII', 1.2089, 0, CAST(80.00 AS Decimal(18, 2)), N'Description for Product1', 8413, 2668)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1962, N'Product2_KII', 0.6589, 0, CAST(35.00 AS Decimal(18, 2)), N'Description for Product2', 8414, 2669)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1963, N'Product3_KII', 2.3089, 0, CAST(42.00 AS Decimal(18, 2)), N'Description for Product3', 8415, 2670)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1964, N'Product4_KII', 0.9350, 0, CAST(175.00 AS Decimal(18, 2)), N'Description for Product4', 8416, 2671)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1965, N'Product5_KII', 1.7589, 0, CAST(104.00 AS Decimal(18, 2)), N'Description for Product5', 8417, 2672)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1966, N'Product6_KII', 1.3739, 0, CAST(8.00 AS Decimal(18, 2)), N'Description for Product6', 8418, 2673)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1967, N'Product7_KII', 1.3739, 0, CAST(16.00 AS Decimal(18, 2)), N'Description for Product7', 8419, 2674)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1968, N'Máy in_H', 150.0000, 5, CAST(5.00 AS Decimal(18, 2)), N'Máy in LG', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1969, N'Quần áo_H', 150.0000, 60, CAST(5.00 AS Decimal(18, 2)), N'Quần áo Quảng Châu', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1970, N'Máy tính_H', 1.5000, 30, CAST(7.00 AS Decimal(18, 2)), N'Máy tính xách tay', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1971, N'Micro_H', 0.3000, 10, CAST(2.00 AS Decimal(18, 2)), N'Microphone thu âm', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1972, N'Tivi_H', 900.0000, 30, CAST(5.00 AS Decimal(18, 2)), N'Tivi Panasonic', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1973, N'Bánh đậu xanh_H', 2.2000, 10, CAST(4.00 AS Decimal(18, 2)), N'Bánh đậu xanh Rồng Vàng', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1974, N'Trà Sữa_H', 3.5000, 5, CAST(5.00 AS Decimal(18, 2)), N'Trà sữa Bông', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1975, N'Balo_H', 680.0000, 5, CAST(4.00 AS Decimal(18, 2)), N'Balo TokyoLife', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1976, N'Đồng hồ thông minh_H', 200.0000, 20, CAST(4.00 AS Decimal(18, 2)), N'ĐHTM Samsung Galaxy Watch5 ', 1, 6)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1977, N'Chuột_H', 360.0000, 20, CAST(5.00 AS Decimal(18, 2)), N'Chuột không dây', 1, 2)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1978, N'Máy chiếu_H', 150.0000, 5, CAST(5.00 AS Decimal(18, 2)), N'Máy chiếu LG', 1, 6)
GO
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1979, N'Máy giặt sony', 999999.0000, 5, CAST(52.00 AS Decimal(18, 2)), N'Hưng bán', 2, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1980, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1982, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1983, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (1984, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2961, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2962, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2975, N'Product 1', 10.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'Product 1 description', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2984, N'pr2802a', 330.0000, 0, CAST(5.00 AS Decimal(18, 2)), NULL, 10501, 2584)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2986, N'Product 4', 400000.0000, 44, CAST(100.00 AS Decimal(18, 2)), N' BNAHS', 1, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2987, N'Product 7', 230000.0000, 15, CAST(100.00 AS Decimal(18, 2)), N'Product E', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2988, N'LEMON', 1000100.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'LEMON', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2989, N'OHIGYRFYU', 10000030.0000, 19, CAST(50.00 AS Decimal(18, 2)), N'OHIGYRFYU', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2990, N'Product 1', 100000.0000, 20, CAST(220.00 AS Decimal(18, 2)), N'Product 1', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2991, N'BÁNH KEM', 100900.0000, 10, CAST(100.00 AS Decimal(18, 2)), N'BÁNH KEM', 1, 1)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2993, N'Product 3', 303000.0000, 30, CAST(100.00 AS Decimal(18, 2)), N'Product 3', 1, 3)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2994, N'Product 4', 400000.0000, 40, CAST(800.00 AS Decimal(18, 2)), N'Product 4', 1, 4)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2996, N'111', 10.0000, 1, CAST(1.00 AS Decimal(18, 2)), NULL, 10528, 2669)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2997, N'1111', 1.0000, 1, CAST(1.00 AS Decimal(18, 2)), NULL, 8121, 2669)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2998, N'Máy quạt nước ', 3.0000, 2, CAST(2.00 AS Decimal(18, 2)), NULL, 8075, 2657)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (2999, N'iwsvsnrzrdatuzyygjtpcymaxizszhcsibhmmfuvrouyvuhqmmirfjynwqvrzpmvcvqobsexzcwhoanycwzvdlurwzsnzuykftdu', 5.0000, 3, CAST(2.00 AS Decimal(18, 2)), NULL, 8078, 2657)
INSERT [dbo].[Products] ([Id], [Name], [Price], [Discount], [Stock], [Description], [CategoryId], [SupplierId]) VALUES (3003, N'T32', 45.0000, 45, CAST(45.00 AS Decimal(18, 2)), NULL, 10516, 2650)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (1, N'Administrators', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (2, N'Managers', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (3, N'Employees', NULL)
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Suppliers] ON 

INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (1, N'applttle', N'706905123454666', N'contactfdgt5678@sony.com', N'387489 Suziki, Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2, N'Asus', N'090X.XYZ.122', N'asus@gmail.com', N'Taiwan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (3, N'snak2802', N'0112255555', N'snake2802z@gmail.com', N'02 Hai Chau, Da Nang, Viet Nam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4, N'Samsung', N'090X.XYZ.221', N'samsung@gmail.com', N'Dong Lao')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (5, N'LG', N'090X.XYZ.222', N'lg@gmail.com', N'Korea')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (6, N'SonySony', N'099905123456', N'contactcontact@sony.com', N'38 Suziki, Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2530, N'nNameei 221122', N'08545548', N'use288562@gmail.com.vnnn', N'Ngu Hanh son cyti01177')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2532, N'nNameeii 221122', N'085455488', N'use288562@gmail.vnnn', N'Ngu Hanh cyti01177')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2534, N'nNameeii 2211522', N'0854554881', N'use288562@gmail', N'Ngu Hanh cyti011777')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2538, N'nNameeii 2211522', N'0395939465', N'yenbai123@gmail.com', N'38yenbai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2568, N'nNguyenvgg', N'n039599572', N'nye77nni@gmail.com', N'ny77nbai0')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2574, N'HN07123', N'0789123123', N'38yenbai11@gmail.com', N'38 yen bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2575, N'SONY', N'07744', N'ectb123@sony.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2576, N'TOSHIBA', N'077441', N'ectb1234@toshiba.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2580, N'SONY', N'123456789', N'contact@sony.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2581, N'TOSHIBA', N'223456789', N'contact@toshiba.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2582, N'SAMSUNG', N'323456789', N'contact@samsung.com', N'KOREA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2583, N'LG', N'423456789', N'contact@lg.com', N'KOREA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2584, N'APPLE', N'523456789', N'contact@apple.com', N'USA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2585, N'Samsung121', N'0905234561524', N'contact@samsung11.com', N'38 Suziki, Korea7')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2616, N'Samsung 1234567', N'0912345678', N'contact@samsung22.com', N'40 Seoul, Korean')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2617, N'Name 22', N'0987654321', N'abc12345@gmail.com', N'38, yenbai,danang')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2619, N'Name 23', N'09876543214', N'abc123456@gmail.com', N'40, yenbai,danang')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2622, N'MinhTam', N'357666778', N'minhtamhoangz@gmail.com', N'Hoangdieu')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2634, N'VTMT2802-1', N'0123456789', N'minhtamhoang2802@gmail.com', N'VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2635, N'VTMT2802-2', N'0123456788', N'minhtamhoang280@gmail.com', N'VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2636, N'VTMT2802-3', N'0123456787', N'minhtamhoang28@gmail.com', N'USA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2637, N'VTMT2802-4', N'0123456786', N'minhtamhoang2@gmail.com', N'VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2638, N'VTMT2802-5', N'0123456785', N'minhtamhoang@gmail.com', N'Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2639, N'La roche-Posay 0375689742', N'0375689101', N'Ngantran@laroche.com', N'France1')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2640, N'Bioderma', N'0375689102', N'Ngantran@bioderma.com', N'France2')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2641, N'Curel', N'0375689103', N'Ngantran@curel.com', N'Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2642, N'The Face Shop', N'0375689104', N'Ngantran@thefaceshop.com', N'Korea')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2643, N'Shiseido', N'0375689105', N'Ngantran@shiseido.com', N'Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2644, N'Samsung 0805', N'080512345', N'Samsung0805@gmail.com', N'0805 Nguyễn Hoàng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2645, N'Asus 0805', N'080512346', N'Asus0805@gmail.com', N'0805 Hà Huy Tập')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2646, N'Hp 0805', N'080512347', N'Hp0805@gmail.com', N'Hải Châu')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2647, N'TCL 0805', N'080512348', N'TCL0805@gmail.com', N'0805 Nguyễn Văn Linh')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2648, N'Lenovo 0805', N'080512349', N'Lenovo0805@gmail.com', N'0805 Yên Bái')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2649, N'Hậu', N'0795134581', N'hau12345@gmail.com', N'Quận Sơn Trà, TP Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2650, N'Hoà', N'0795132686', N'hoa12345@gmail.com', N'Quận Thanh Khê, TP Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2651, N'Kiên', N'0795125768', N'kien12578@gmail.com', N'Huyện Đô Lương, tỉnh Nghệ An ')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2653, N'Diểm', N'0769132612', N'diemnguyen@gmail.com', N'Huyện Đại Lộc, tỉnh Quảng Nam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2654, N'Hương', N'0869222613', N'huongphan@gmail.com', N'Huyện Quế Sơn, tỉnh Quảng Nam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2655, N'Thi', N'0128132611', N'thinguyen99@gmail.com', N'Huyện Hoà Xuân, TP Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2656, N'Công', N'0905132616', N'congnguyen1999@gmail.com', N'Quận 1, TP Hồ Chí Minh')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2657, N'Bảo Anh', N'0121132684', N'maybaoanh@gmail.com', N'Quận Hải Châu, Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2658, N'Phúc', N'0122138597', N'phucnguyen@gmail.com', N'38 Yên Bái, Quận Hải Châu, TP Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2668, N'Intel_KII', N'0888033208', N'hieu1.nt0509@outlook.com', N'45 Yen Bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2669, N'AKG_KII', N'0888033201', N'hieu2.nt0509@outlook.com', N'15 Dong Da')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2670, N'MSI_KII', N'0888033202', N'hieu3.nt0509@outlook.com', N'45 Yen Bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2671, N'NVIDA_KII', N'0888033203', N'hieu4.nt0509@outlook.com', N'45 Yen Bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2672, N'Cooler Master_KII', N'0888033204', N'hieu5.nt0509@outlook.com', N'45 Yen Bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2673, N'SAMSUNG_KII', N'0888033207', N'hieu6.nt0509@outlook.com', N'45 Yen Bai')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2674, N'Dragon_KII', N'0888033205', N'hieu7.nt0509@outlook.com', N'15 Dong Da')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2675, N'Viettel', N'0905.XYZ.122', N'viettel@gmail.com', N'Taiwan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (2690, N'Sony 0375689', N'09051234565689', N'contact0375689@sony.com', N'38 Suziki, Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (3661, N'Samsung', N'0915123456', N'contactt@sony.com', N'38 Suziki, Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (3688, N'T32', N'0967990608', N'T32@gmail.com', N'Hà Nội')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4694, N'VƯƠNG', N'01111111', N'tien9216@gmail.com', N'ĐÀ NẴNG')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4695, N'kHÁNH', N'033333333', N'ttin9216@gmail.com', N'QUẢNG NAM')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4696, N'QUỐC', N'0111555111', N'tten9216@gmail.com', N'BÌNH Ð?NH')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4697, N'LINH', N'0222111111', N'ttien9816@gmail.com', N'HÀ N?I')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4698, N'GIANG', N'0199991111', N'ttien9016@gmail.com', N'HUẾ')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4699, N'CHÂU', N'0114566111', N'ttien9266@gmail.com', N'LÂM ĐỒNG')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4700, N'LG', N'0118898111', N'ttien9566@gmail.com', N'QUẢNG TRỊ')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4701, N'HOA', N'0111118888', N'ttien4216@gmail.com', N'BÌNH DƯƠNG')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4751, N'snake2802', N'0112233555', N'bcwiwngjoyllivyvafxulyufezewlzxnjlmqlhzy@gmail.com', N'Hai Chau, Da Nang, VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4752, N'snake2802', N'0112233666', N'bcwiwngjoyllivyvafxulyufezewlzxnjlmqlhz@gmail.com', N'Hai Chau, Da Nang, VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4755, N'snake2802', N'0112233111', N'snake2802a@gmail.com', N'p7ELiSlCikP2JaiJabdaYmYtoJyB2luWTFAf2adykLuadRpCaV8SmjVHRpKx1dpDwFkKNsePEcEdeOabnuhphagEBkmS8Bpkut38HzEiPHephdgAlAVfKAx6kNXmYg5B1CBHfqL2gbQxOQmnVSaLYyL1Do7tSEC4NBqR3F8vV5bnxkIVBOc6gN0fO6JdRvJwAISr6SFaBGIFNZoqwdn7EyzKpsG4zTHcpkH8vbteVd9ZcsCp93bmmJMoI3IWlxVas9TsrU29hnaC7BWTcPMeiWSt8efUm95qLFAbAbxM1nqfdSlYQrMlXHBb6tWp3OfAQF4NJVVs9EEnXgUUMXGIMWuHwJizNTSXnBOteEUB8ARIhTJCq7FDRnr1hbiWKAAnsR4jRJMA1QXA6JBHp7Lwtc681hkcoB9FKhylMp595Ih64cyZ5JQkg67ntS29nLJCtLhG2gKDteteVAcegQUQs3hdguA08zLwQCoZSjqh0OuO7QPKx4mG')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4769, N'snake2802', N'0112233445', N'snake2802@gmail.com', N'Hai Chau, Da Nang, VietNam')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4781, N'SONY', N'1234567890', N'contact1@sony.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4782, N'TOSHIBA', N'2234567890', N'contact1@toshiba.com', N'JAPAN')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4783, N'SAMSUNG', N'3234567890', N'contact1@samsung.com', N'KOREA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4784, N'LG', N'4234567890', N'contact1@lg.com', N'KOREA')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4785, N'${name}', N'${phoneNumber}', N'${email}', N'${address}')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4787, N'JBL', N'001122222', N'contact@JBL.com', N'HaiChau DaNang')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4805, N'TestCate1', N'0781255789', N'Suppliers111@gmail.com', N'SupplierS 111 Đà Nẵng ')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4807, N'pryqdcnatybyfacievsxmspzqzmkdogjhzqnenrbvlvmpvxbytilenbrdtsnjqnyzbmalwizmqzcczjytgbrasucamexgjcztukj', N'0781255788', N'Suppliers11221@gmail.com', N'SupplierS 11221 Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4808, N'TestCate22221', N'0101504398', N'Suppliers22221@gmail.com', N'SupplierS 1 Đà Nẵng ')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4816, N'Sony123', N'09051234536', N'contact@sony654.com', N'38 Sudziki, Japuan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4820, N'Sony1293', N'090512394536', N'contact@sony6954.com', N'38 Sudziki, Japuan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4826, N'Son89y1293', N'09051238894536', N'contact@sony6yy954.com', N'38 Suduziki, Jappuan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4828, N'Song89yi1293', N'0905512@38894536', N'contact@sh!ony6yy954.com', N'38 SuduƯzriki, Japhpuan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4831, N'Sony242', N'0905123456', N'contac5465t@sony.com', N'38 Suziki, Japan')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4833, N'Suppliers NCC 2023', N'079125842', N'suppliersncc2023@gmail.com', N'09 Nguyễn Tất Thành, Hải Châu, Tp Đà Nẵng')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4836, N'12345hkkl', N'7779999', N'ttiey@gmail.com', N'tiiiiio')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4837, N'12345hkkll', N'77799990', N'ttieuy@gmail.com', N'tiiiiioi')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4838, N'12345hkkllk', N'777999909', N'ttieuyt@gmail.com', N'tiiiiioipp')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4841, N'New Name 88', N'888888888', N'newemail88@gmail.com', N'39 Yên Bái')
INSERT [dbo].[Suppliers] ([Id], [Name], [PhoneNumber], [Email], [Address]) VALUES (4847, N'abc2', N'09243254343', N'abc1248@gmail.com', N'Đà Nẵng')
SET IDENTITY_INSERT [dbo].[Suppliers] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Email], [Password], [IsActive], [RefreshToken]) VALUES (10, N'tungnt@softech.vn', N'123456789', 1, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsImlhdCI6MTY5NTc4Mzc5MCwiZXhwIjoxNjk2Mzg4NTkwfQ.QFlrN2i2YKRie9xigOJbH8x0pfuoOGjQKRu1Ma_6ebk')
INSERT [dbo].[Users] ([Id], [Email], [Password], [IsActive], [RefreshToken]) VALUES (11, N'admin', N'Tester@123', 1, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsImlhdCI6MTY5NTA4OTM5MSwiZXhwIjoxNjk1Njk0MTkxfQ.d6AD_4uemlTpFaIt7C9YbN4s_ZWPVUB4LVipmHaipEc')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
INSERT [dbo].[Users_Roles] ([userId], [roleId]) VALUES (10, 1)
INSERT [dbo].[Users_Roles] ([userId], [roleId]) VALUES (10, 2)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Categories_Name]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [UQ_Categories_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Customers_Email]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [UQ_Customers_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Customers_PhoneNumber]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [UQ_Customers_PhoneNumber] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Employees_Email]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [UQ_Employees_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Employees_PhoneNumber]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [UQ_Employees_PhoneNumber] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Persons__3214EC264D886921]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Persons] ADD UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_ad152fb549a5b88dccaaf3a1013]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [UQ_ad152fb549a5b88dccaaf3a1013] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Suppliers_Email]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Suppliers] ADD  CONSTRAINT [UQ_Suppliers_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Suppliers_PhoneNumber]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Suppliers] ADD  CONSTRAINT [UQ_Suppliers_PhoneNumber] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_884fdf47515c24dbbf6d89c2d84]    Script Date: 9/29/2023 11:15:32 AM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ_884fdf47515c24dbbf6d89c2d84] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderLogs] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DEFAULT_Orders_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Status]  DEFAULT ('WAITING') FOR [Status]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_2ecf9a3beeae11b736d9f51e4ab]  DEFAULT ('CASH') FOR [PaymentType]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Discount]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Stock]  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_a76983de563dcec678b5d869aa7]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_Orders_OrderDetails] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_Orders_OrderDetails]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_Products_OrderDetails] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_Products_OrderDetails]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employees] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Categories_Products] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Categories_Products]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Suppliers_Products] FOREIGN KEY([SupplierId])
REFERENCES [dbo].[Suppliers] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Suppliers_Products]
GO
ALTER TABLE [dbo].[Users_Roles]  WITH CHECK ADD  CONSTRAINT [FK_083c7f51819e934e4b95bf51d87] FOREIGN KEY([userId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Users_Roles] CHECK CONSTRAINT [FK_083c7f51819e934e4b95bf51d87]
GO
ALTER TABLE [dbo].[Users_Roles]  WITH CHECK ADD  CONSTRAINT [FK_d947f1cebfa6b42802cb5350d65] FOREIGN KEY([roleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[Users_Roles] CHECK CONSTRAINT [FK_d947f1cebfa6b42802cb5350d65]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_Orders_CreatedDate] CHECK  (([CreatedDate]<=[ShippedDate]))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders_CreatedDate]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_Orders_PaymentType] CHECK  (([PaymentType]='CREDIT CARD' OR [PaymentType]='CASH'))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders_PaymentType]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_Orders_Status] CHECK  (([Status]='CANCELED' OR [Status]='COMPLETED' OR [Status]='WAITING'))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders_Status]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_ShippedDate_CreatedDate] CHECK  (([ShippedDate]>=[createdDate]))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_ShippedDate_CreatedDate]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_Products_Discount] CHECK  (([Discount]>=(0) AND [Discount]<=(90)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_Products_Discount]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_Products_Price] CHECK  (([Price]>(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_Products_Price]
GO
/****** Object:  StoredProcedure [dbo].[usp_Employee_GetFullName]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Employee_GetFullName]
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProducts_With_Min_Discount]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetProducts_With_Min_Discount] 
(
  @Discount int,
  @Stock decimal(18, 2)
)

AS
BEGIN
    SELECT * FROM Products
    WHERE Discount <= @Discount AND Stock <= @Stock

END
GO
/****** Object:  StoredProcedure [dbo].[usp_Products_CheckDiscount]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Products_CheckDiscount]
	@MinimunDiscount DECIMAL(18, 2)
AS
BEGIN
	SELECT * FROM Products
	WHERE Discount <= @MinimunDiscount
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Products_CheckStock]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Products_CheckStock]
	@MinimunStock DECIMAL(18, 2)
AS
BEGIN
	SELECT * FROM Products
	WHERE Stock <= @MinimunStock
END
GO
/****** Object:  DdlTrigger [trg_Customers_PreventDropTable]    Script Date: 9/29/2023 11:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [trg_Customers_PreventDropTable]
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Customers.'
        ROLLBACK
    END
END
GO
DISABLE TRIGGER [trg_Customers_PreventDropTable] ON DATABASE
GO
