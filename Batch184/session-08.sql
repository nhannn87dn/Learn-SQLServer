SELECT * FROM dbo.brands
--1. Xem tat ca du lieu hien co cua table products
-- SELECT * ==> Lay tat ca cac truong hien co cua 1 table
SELECT * FROM dbo.products 
--2. SELECT Without FROM
SELECT GETDATE()
SELECT LEN('Hello SQL')
--3. SELECT column theo y muon
SELECT 
	product_id,
	product_name 
FROM 
	dbo.products
--4. SELECT voi Expression (Bieu thuc)
SELECT * FROM dbo.customers
SELECT
	customer_id,
	first_name + ' ' + last_name,
	(2 * 2)
FROM
	dbo.customers
--5. Doi ten cho cot trong ket qua tra ve
SELECT
	customer_id,
	first_name + ' ' + last_name AS full_name
FROM
	dbo.customers
-- doi ten truong phone thanh mobile trong ket qua tra ve cau lenh truy van
SELECT
	customer_id,
	first_name,
	phone AS mobile
FROM
	dbo.customers
--6. Tinh toan gia tri trong ket qua tra ve
SELECT
	order_id,
	product_id,
	quantity,
	price,
	discount,
	((quantity * price) - (quantity * price) * discount) AS amount
FROM
	dbo.order_items

--7. DISTINCT -- Chong trung lap ket qua
-- Liet ke cho toi: Danh sach cac bang trong du lieu khach hang hien co
SELECT
	 state
FROM
	dbo.customers 
-- voi DISTINCT
SELECT
	DISTINCT state
FROM
	dbo.customers

--8. TOP PERCENT
SELECT 
	TOP 10 * 
FROM 
	dbo.products --==> 10 records dau tien cua bang product
--
SELECT 
	TOP 5 PERCENT * 
FROM 
	dbo.products --> Top 5% record cua product
--9. WITH TIES
SELECT 
	TOP 10 WITH TIES product_id, product_name, price 
FROM 
	products
ORDER BY price DESC
--========================================================
--10. SELECT with INTO
-- = Chen du lieu vao mot bang moi tu mot cau lenh SELECT
SELECT 
	* INTO dbo.customersBackup2019
FROM 
	dbo.customers;
-- => Lay tat ca du lieu tu CUSTOMER do vao cho table customersBackup2019
-- customersBackup2019 chua ton tai thi no tao moi.
--> THuong su dung de tao BAN SAO (Backup) cho table

--================================
--11. SELECT WHERE
SELECT * FROM dbo.products
-- Lay cho toi: Danh sach cac san pham san xuat nam 2022
SELECT
	*
FROM
	dbo.products
WHERE
	model_year = 2022
-- Lay cho toi: Danh sach cac san pham co gia ban >= 10000
SELECT
	*
FROM
	dbo.products
WHERE
	price >= 10000;
-- Lay cho toi: Danh sach cac san pham co nam sx = 2016 VA thuoc danh muc
-- co category_id = 4
SELECT
	*
FROM
	dbo.products
WHERE
	model_year = 2016 AND category_id = 4
	
-- Lay cho toi: Danh sach cac san pham co thuong hieu brand_id = 4 HOAC = 6
SELECT
	*
FROM dbo.products
WHERE brand_id = 4 OR brand_id = 6

SELECT
	*
FROM dbo.products
WHERE brand_id = 4 AND brand_id = 6
-- SELECT WHERE toan tu NOT
SELECT * FROM dbo.staffs
UPDATE dbo.staffs SET birthday = NULL WHERE staff_id = 10
-- Lay danh sach Staffs co birthday khong phai NULL
SELECT * FROM dbo.staffs WHERE birthday IS NULL
SELECT * FROM dbo.staffs WHERE birthday IS NOT NULL

-- TOAN TU LIKE
-- Lay cho toi danh sach Staff co first_name bat dau la 'Ven'
SELECT 
	* 
FROM 
	dbo.staffs 
WHERE first_name LIKE 'Ven%'
-- Lay cho toi danh sach Staff co phone co duoi la '557'
SELECT 
	* 
FROM 
	dbo.staffs 
WHERE phone LIKE '%557'
-- Lay cho toi danh sach Staff co first_name CHUA tu 'an'
SELECT 
	* 
FROM 
	dbo.staffs 
WHERE first_name LIKE '%an%'
-- Khop: Tan, Tang, an

-- Toan tu BETWEEN
-- Liet ke danh sach san pham co nam san xuat tu 2016 - 2017
SELECT
	*
FROM 
	dbo.products
WHERE
	model_year >=  2016
	AND model_year <= 2017
-- voi BETWEEN
SELECT
	*
FROM 
	dbo.products
WHERE model_year BETWEEN 2016 AND 2017



--=============================
-- 12. GROUP BY
-- 
SELECT * FROM dbo.customers
-- Thong ke cho toi: Co bao nhieu khach hang o moi Bang (State)
SELECT 
	state,
	COUNT(customer_id) AS countCustomers --==> tinh toan tren nhom
FROM 
	dbo.customers
GROUP BY
	state

--> KET LUAN: Nhom ket qua tra ve theo mot nhom, khu gia tri trung lap
-- Co the tinh toan tren nhom do.

SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    dbo.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;
-- GROUP BY voi SUM
SELECT * FROM dbo.order_items
-- Tinh Tong tien cua moi don hang
SELECT
	order_id,
	SUM(((quantity * price) - (quantity * price) * discount)) AS total
FROM
	dbo.order_items
GROUP BY
	order_id
ORDER BY order_id ASC


-- SELECT with ORDER BY
SELECT
	*
FROM
	dbo.products
ORDER BY
	product_name DESC; -- ASC tang gian | DESC  giam dan

SELECT
	*
FROM
	dbo.products
ORDER BY
	price DESC; -- ASC tang gian | DESC  giam dan
-- sap xep theo model_year ASC, price DESC
SELECT
	*
FROM
	dbo.products
ORDER BY
	model_year ASC,
	price DESC;
-- Lay 10 san pham / 1 page
SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id 
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY -- page 1

--
SELECT
	product_id,
    product_name,
    price
FROM
    dbo.products
ORDER BY
    product_id
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY -- page 2

