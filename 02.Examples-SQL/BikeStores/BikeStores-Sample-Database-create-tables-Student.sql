
-- create tables
CREATE TABLE dbo.categories (
	[category_id] [int] NOT NULL,
	[category_name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](500) NULL
);

CREATE TABLE dbo.brands (
	[brand_id] [int] NOT NULL,
	[brand_name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](500) NULL
);

CREATE TABLE dbo.products (
	[product_id] [int] NOT NULL,
	[product_name] [nvarchar](255) NOT NULL,
	[brand_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[model_year] [smallint] NOT NULL,
	[price] [decimal](18, 2) NOT NULL DEFAULT 0,
	[discount] [decimal](4, 2) NOT NULL DEFAULT 0,
	[description] [nvarchar](max) NULL
	
);

CREATE TABLE dbo.customers (
	[customer_id] [int] NOT NULL,
	[first_name] [nvarchar](255) NOT NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[birthday] [date] NULL,
	[street] [nvarchar](255) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[state] [nvarchar](50) NOT NULL,
	[zip_code] [varchar](5) NULL
	
);

CREATE TABLE dbo.stores (
	[store_id] [int] NOT NULL,
	[store_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[state] [nvarchar](50) NULL,
	[zip_code] [varchar](5) NULL
	
);

CREATE TABLE dbo.staffs (
	[staff_id] [int] NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[active] [tinyint] NOT NULL,
	[store_id] [int] NOT NULL,
	[manager_id] [int] NULL
);

CREATE TABLE [dbo].[orders] (
	[order_id] [int]  NOT NULL,
	[customer_id] [int] NOT NULL,
	[order_status] [tinyint] NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = cancel; 4 = Completed
	[order_date] [date] NOT NULL,
	[required_date] [date] NOT NULL,
	[shipped_date] [date] NULL,
	[store_id] [int] NOT NULL,
	[staff_id] [int] NOT NULL,
	[order_note] [nvarchar](500) NULL,
	[shipping_address] [nvarchar](500) NULL,
	[shipping_city] [nvarchar](50) NULL,
	[payment_type] [tinyint] NOT NULL,
	-- payment type: 1 = COD; 2 = Credit; 3 = ATM; 4 = Cash
	[order_amount] [decimal](18, 2) NOT NULL
);

CREATE TABLE  [dbo].[order_items] (
	[order_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](18, 2) NOT NULL,
	[discount] [decimal](4, 2) NOT NULL DEFAULT 0
);

CREATE TABLE [dbo].[stocks] (
	[store_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NULL DEFAULT 0
);

