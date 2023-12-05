
-- create tables
CREATE TABLE dbo.categories (
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](500) NULL,
	-- CONSTRAINTs
	CONSTRAINT [pk_categories_category_id] PRIMARY KEY([category_id]),
	CONSTRAINT [uq_categories] UNIQUE([category_name])
);

CREATE TABLE dbo.brands (
	[brand_id] [int] IDENTITY(1,1) NOT NULL,
	[brand_name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](500) NULL,
	-- CONSTRAINTs
	CONSTRAINT [pk_categories_brands] PRIMARY KEY([brand_id]),
	CONSTRAINT [uq_brands] UNIQUE([brand_name])
);

CREATE TABLE dbo.products (
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[product_name] [nvarchar](255) NOT NULL,
	[brand_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[model_year] [smallint] NOT NULL,
	[price] [decimal](18, 2) NOT NULL DEFAULT 0,
	[discount] [decimal](4, 2) NOT NULL DEFAULT 0,
	[description] [nvarchar](max) NULL,
	-- CONSTRAINTs
	CONSTRAINT pk_products_product_id PRIMARY KEY(product_id),
	CONSTRAINT fk_products_category_id FOREIGN KEY (category_id) REFERENCES dbo.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_products_brand_id FOREIGN KEY (brand_id) REFERENCES dbo.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT uq_products_product_name UNIQUE(product_name),
	CONSTRAINT ck_products_price CHECK(price >= 0),
	CONSTRAINT ck_products_discount CHECK(discount >= 0 AND discount <= 70)
);

CREATE TABLE dbo.customers (
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](255) NOT NULL,
	[last_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[email] [varchar](150) NOT NULL,
	[birthday] [date] NULL,
	[street] [nvarchar](255) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[state] [nvarchar](50) NOT NULL,
	[zip_code] [varchar](5) NULL,
	-- CONSTRAINTs
	CONSTRAINT [pk_customers_customer_id] PRIMARY KEY([customer_id]),
	CONSTRAINT [uq_customers_email] UNIQUE([email])
);

CREATE TABLE dbo.stores (
	[store_id] [int] IDENTITY(1,1) NOT NULL,
	[store_name] [nvarchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[state] [nvarchar](50) NULL,
	[zip_code] [varchar](5) NULL,
	-- CONSTRAINTs
	CONSTRAINT pk_stores_store_id PRIMARY KEY(store_id)
);

CREATE TABLE dbo.staffs (
	[staff_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[phone] [varchar](25) NOT NULL,
	[active] [tinyint] NOT NULL,
	[store_id] [int] NOT NULL,
	[manager_id] [int] NULL,
	-- CONSTRAINTs
	CONSTRAINT pk_staffs_staff_id PRIMARY KEY(staff_id),
	CONSTRAINT uq_staffs_email UNIQUE(email),
	CONSTRAINT uq_staffs_phone UNIQUE(phone),
	CONSTRAINT fk_staffs_store_id FOREIGN KEY (store_id) REFERENCES dbo.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_staffs_manager_id FOREIGN KEY (manager_id) REFERENCES dbo.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [dbo].[orders] (
	[order_id] [int] IDENTITY(1,1) NOT NULL,
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
	[order_amount] [decimal](18, 2) NOT NULL,

	-- CONSTRAINTs
	CONSTRAINT [pk_orders_order_id] PRIMARY KEY([order_id]),
	CONSTRAINT [fk_orders_customer_id] FOREIGN KEY ([customer_id]) REFERENCES dbo.customers([customer_id]) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [fk_orders_store_id] FOREIGN KEY ([store_id]) REFERENCES dbo.stores([store_id]) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [fk_orders_staff_id] FOREIGN KEY ([staff_id]) REFERENCES dbo.staffs([staff_id]) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT [ck_orders_order_status] CHECK([order_status] IN (1,2,3,4)),
	CONSTRAINT [ck_orders_payment_type] CHECK([payment_type] IN (1,2,3,4)),
);

CREATE TABLE  [dbo].[order_items] (
	[order_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](18, 2) NOT NULL,
	[discount] [decimal](4, 2) NOT NULL DEFAULT 0,
	CONSTRAINT [pk_order_items_order_id_item_id] PRIMARY KEY (order_id, item_id),
	CONSTRAINT [pk_order_items_order_id] FOREIGN KEY (order_id) REFERENCES dbo.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [pk_order_items_product_id] FOREIGN KEY (product_id) REFERENCES dbo.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [ck_order_items_price] CHECK(price >= 0),
	CONSTRAINT [ck_order_items_discount] CHECK(discount >= 0 AND discount <= 70),
	CONSTRAINT [ck_order_items_quantity] CHECK(quantity >= 1)
);

CREATE TABLE [dbo].[stocks] (
	[store_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NULL DEFAULT 0,
	CONSTRAINT pk_stocks_store_id_product_id PRIMARY KEY (store_id, product_id),
	CONSTRAINT fk_stocks_store_id FOREIGN KEY (store_id) REFERENCES dbo.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_stocks_product_id FOREIGN KEY (product_id) REFERENCES dbo.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_stocks_quantity CHECK(quantity >= 0)
);


CREATE TABLE dbo.taxes (
	tax_id INT IDENTITY (1, 1),
	state VARCHAR (50) NOT NULL UNIQUE,
	state_tax_rate DEC (3, 2),
	avg_local_tax_rate DEC (3, 2),
	combined_rate AS state_tax_rate + avg_local_tax_rate,
	max_local_tax_rate DEC (3, 2),
	updated_at datetime,
	CONSTRAINT [pk_taxes_tax_id] PRIMARY KEY(tax_id),
	CONSTRAINT uq_taxes_state UNIQUE(state)
);

CREATE TABLE dbo.targets
(
    target_id INT IDENTITY (1, 1), 
    percentage DECIMAL(4, 2) NOT NULL DEFAULT 0,
	CONSTRAINT [pk_targets_target_id] PRIMARY KEY(target_id)
);

CREATE TABLE dbo.commissions
(
    staff_id  INT, 
    target_id  INT, 
    base_amount DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    commission  DECIMAL(10, 2) NOT NULL DEFAULT 0,
	CONSTRAINT [pk_commissions_staff_id] PRIMARY KEY(staff_id),
    CONSTRAINT [fk_commissions_target_id] FOREIGN KEY (target_id) REFERENCES dbo.targets(target_id), 
    CONSTRAINT [fk_commissions_staff_id] FOREIGN KEY (staff_id) REFERENCES dbo.staffs(staff_id);
);