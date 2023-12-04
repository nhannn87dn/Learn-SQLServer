# Homework - OnlineShop

## 💛  Phần A: Tạo bảng

1. Viết các câu lệnh tạo bảng như phần mô tả CSDL OnlineShop

### 💥 Table  categories

| No. | FieldName     | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint      | Notes |
| --- | ------------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------- | ----- |
| 1   | category_id   | INT      |          |            | Primary Key |             |              | IDENTITY (1, 1) |       |
| 2   | category_name | NVARCHAR | 50       |            |             |             |              | UNIQUE          |       |
| 3   | description   | NVARCHAR | 500      | YES        |             |             |              |                 |       |

### 💥 Table  brands

| No. | FieldName   | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint     | Notes |
| --- | ----------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------- | ----- |
| 1   | brand_id    | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1) |       |
| 2   | brand_name  | NVARCHAR | 100      |            |             |             |              | UNIQUE         |       |
| 3   | description | NVARCHAR | 500      | YES        |             |             |              |                |       |

### 💥 Table customers

| No. | FieldName   | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint     | Notes |
| --- | ----------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------- | ----- |
| 1   | customer_id | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1) |       |
| 2   | first_name  | NVARCHAR | 50       |            |             |             |              |                |       |
| 3   | last_name   | NVARCHAR | 50       |            |             |             |              |                |       |
| 4   | phone       | VARCHAR  | 50       |            |             |             |              | UNIQUE         |       |
| 6   | email       | VARCHAR  | 150      |            |             |             |              | UNIQUE         |       |
| 7   | street      | NVARCHAR | 255      |            |             |             |              |                |       |
| 7   | city        | NVARCHAR | 50       |            |             |             |              |                |       |
| 7   | state       | NVARCHAR | 50       |            |             |             |              |                |       |
| 7   | zip_code    | VARCHAR  | 5        | YES        |             |             |              |                |       |


### 💥 Table  staffs

| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                  | Notes                      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------------------- | -------------------------- |
| 1   | staff_id   | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1)              |                            |
| 2   | first_name | NVARCHAR | 50       |            |             |             |              |                             |                            |
| 3   | last_name  | NVARCHAR | 50       |            |             |             |              |                             |                            |
| 4   | phone      | VARCHAR  | 50       |            |             |             |              | UNIQUE                      |                            |
| 5   | email      | VARCHAR  | 150      |            |             |             |              | UNIQUE                      |                            |
| 5   | active     | TINYINT  |          |            |             |             | 0            |                             | 0 = no active, 1 = actived |
| 5   | store_id   | INIT     |          |            |             | Foreign Key |              | Reference stores (store_id) |                            |
| 5   | manage_id  | INIT     |          |            |             | Foreign Key |              | Reference staffs (staff_id) |                            |


### 💥 Table  products


| No. | FieldName    | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                         | Notes |
| --- | ------------ | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | ---------------------------------- | ----- |
| 1   | product_id   | INT            |          |            | Primary Key |             |              | IDENTITY(1, 1)                     |       |
| 2   | product_name | NVARCHAR       | 50       |            |             |             |              |                                    |       |
| 3   | price        | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Price >= 0                  |       |
| 4   | discount     | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Discount BETWEEN 0 AND 70   |       |
| 5   | category_id  | INT            |          |            |             | Foreign Key |              | Reference categories (category_id) |       |
| 6   | brand_id     | INT            |          |            |             | Foreign Key |              | Reference brands (brand_id)        |       |
| 7   | description  | NVARCHAR       | MAX      | Yes        |             |             |              |                                    |       |
| 8   | model_year   | SMALL INIT     |          |            |             |             |              |                                    |       |




### 💥 Table  stores


| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------- |
| 1   | store_id   | INT      |          |            | Primary Key |             |              | IDENTITY (1, 1) |
| 2   | store_name | NVARCHAR | 50       |            |             |             |              | UNIQUE          |
| 3   | phone      | VARCHAR  | 50       | Yes        |             |             |              |                 |
| 4   | email      | VARCHAR  | 150      | Yes        |             |             |              |                 |
| 5   | street     | NVARCHAR | 255      | Yes        |             |             |              |                 |
| 6   | city       | NVARCHAR | 50       | Yes        |             |             |              |                 |
| 7   | state      | NVARCHAR | 50       | Yes        |             |             |              |                 |
| 8   | zip_code   | VARCHAR  | 5        | Yes        |             |             |              |                 |

### 💥 Table stocks

| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | ------------------------------- |
| 1   | store_id   | INT      |          |            | Primary Key | Foreign Key |              | Reference stores (store_id)     |
| 2   | product_id | INIT     |          |            | Primary Key | Foreign Key |              | Reference products (product_id) |
| 3   | quantity   | INIT     |          |            |             |             | 0            |                                 |


### 💥 Table  orders

| No. | FieldName        | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                        | Notes                                                                  |
| --- | ---------------- | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------------------------- | ---------------------------------------------------------------------- |
| 1   | order_id         | INT            |          |            | Primary Key |             |              | IDENTITY(1, 1)                    |                                                                        |
| 2   | customer_id      | INIT           |          |            |             | Foreign Key |              | Reference customers (customer_id) |                                                                        |
| 3   | order_status     | TINYINT        |          |            |             |             |              | 1/2/3/4                           | Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed |
| 4   | order_date       | VARCHAR        | 50       |            |             |             | NOW          |                                   |                                                                        |
| 5   | require_date     | DATETIME       |          | YES        |             |             |              |                                   |                                                                        |
| 6   | shipping_date    | DATETIME       |          |            |             |             |              |                                   |                                                                        |
| 7   | store_id         | INIT           | 50       |            |             | Foreign Key |              | Reference stores (store_id)       |                                                                        |
| 8   | staff_id         | INIT           | 20       |            |             | Foreign Key |              | Reference staffs (staff_id)       |                                                                        |
| 9   | order_note       | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 10  | shipping_address | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 11  | shipping_city    | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 12  | payment_type     | TINYINT        |          |            |             |             | 4            | 1/2/3/4                           | payment type: 1 = COD; 2 = Credit; 3 = ATM; 4 = Cash                   |
| 13  | order_amount     | DECIMAL(18, 2) |          |            |             |             | 0            |                                   |                                                                        |


### 💥 Table order_items

| No. | FieldName  | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                       |
| --- | ---------- | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------------------------- |
| 1   | order_id   | INT            |          |            | Primary Key | Foreign Key |              | Reference orders (order_id)      |
| 2   | item_id    | INT            |          |            | Primary Key |             |              |                                  |
| 3   | product_id | INT            |          |            |             | Foreign Key |              | Reference products (product_id)  |
| 3   | quantity   | INIT           |          |            |             |             | 0            | Check: Quantity >= 0             |
| 4   | price      | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Price >= 0                |
| 5   | discount   | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Discount BETWEEN 0 AND 70 |


---

2. Tạo mỗi bảng từ 5-10 records: Sử dụng câu lệnh INSERT, thứ tự nhập dữ liệu cho các 
tables:
Categories
Suppliers
Customers
Employees
Products
Orders
OrderDetails

---

## 💛  Phần B: Câu lệnh INSERT, UPDATE, DELETE

1. 1. Viết câu lệnh UPDATE để cập nhật Price với điều kiện: Các mặt hàng có Price <= 100000 thì tăng thêm 10%
1. 1. Viết câu lệnh UPDATE để cập nhật DISCOUNT với điều kiện: Các mặt hàng có Discount <= 10% thì tăng thêm 5%
1. 1. Viết câu lệnh XOÁ tất cả các mặt hàng có Stock là 0

## 💛  Phần C: Truy vấn cơ bản

1. Hiển thị tất cả các mặt hàng có giảm giá <= 10%
1. Hiện thị tất cả các mặt hàng không có giảm giá
1. Hiển thị tất cả các mặt hàng có số lượng tồn kho <= 5
1. Hiển thị tất cả các mặt hàng có Giá bán sau khi đã giảm giá <= 100.000
1. Hiện thị tất cả các mặt hàng thuộc danh mục CPU, RAM
1. Hiển thị tất cả các khách hàng có địa chỉ ở Quận Hải Châu
1. Hiển thị tất cả các khách hàng có địa chỉ ở Quận Hải Châu hoặc Quận Thanh Khê
1. Hiển thị tất cả các khách hàng có năm sinh 1990.
1. Hiển thị tất cả các khách hàng có tuổi trên 60.
1. Hiển thị tất cả các khách hàng có tuổi từ 20 đến 30.
1. Hiển thị tất cả các khách hàng có sinh nhật là hôm nay. Gợi ý: dùng hàm GETDATE(), MONTH(), DAY()
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED trong ngày hôm nay
1. Hiển thị tất cả các đơn hàng chưa hoàn thành trong tháng này
1. Hiển thị tất cả các đơn hàng có trạng thái là CANCELED
1. Hiển thị tất cả các đơn hàng có trạng thái là CANCELED trong ngày hôm nay
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED trong tháng này
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED trong tháng 1 năm 2021
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED trong năm 2021
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là CASH
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là CREADIT CARD
1. Hiển thị tất cả các đơn hàng có địa chỉ giao hàng là Hà Nội
1. Hiển thị tất cả các nhân viên có sinh nhật là tháng này
1. Hiển thị tất cả các nhà cung cấp có tên là: (SONY, SAMSUNG, TOSHIBA, APPLE)
1. Hiển thị tất cả các nhà cung cấp không có tên là: (SAMSUNG, APPLE)
1. Hiển thị tất cả các nhà cung cấp có địa chỉ ở Quận Hải Châu và Quận Thanh Khê.
1. Hiển thị tất cả các nhà cung cấp có địa chỉ ở Quận Hải Châu hoặc Quận Thanh Khê.
1. Hiển thị tất cả các khách hàng có sinh nhật là ngày hôm nay.
1. Hiển thị xem có bao nhiêu mức giảm giá khác nhau.
1. Hiển thị xem có bao nhiêu mức giảm giá khác nhau và số lượng mặt hàng có mức giảm giá đó.
1. Hiển thị xem có bao nhiêu mức giảm giá khác nhau và số lượng mặt hàng có mức giảm giá đó, sắp xếp theo số lượng giảm giá giảm dần.
1. Hiển thị xem có bao nhiêu mức giảm giá khác nhau và số lượng mặt hàng có mức giảm giá đó, sắp xếp theo số lượng giảm giá tăng dần, chỉ hiển thị các mức giảm giá có số lượng mặt hàng >= 5
1. Hiển thị xem có bao nhiêu mức tuổi khác nhau của khách hàng và số lượng khách hàng có mức tuổi đó, sắp xếp theo số lượng khách hàng tăng dần.
1. Hiển thị xem có bao nhiêu mức tuổi khác nhau của nhân viên và số lượng nhân viên có mức tuổi đó, sắp xếp theo số lượng nhân viên giảm dần.
1. Hiển thị số lượng đơn hàng theo từng ngày khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng tháng khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần, chỉ hiển thị các năm có số lượng đơn hàng >= 5.

## 💛  Phần D: Truy vấn nâng cao

1. Hiển thị tất cả các mặt hàng cùng với CategoryName.
SELECT ProductName, CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryId = Categories.Id

1. Hiển thị tất cả các mặt hàng cùng với SupplierName.
SELECT ProductName, SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierId = Suppliers.Id

1. Hiển thị tất cả các mặt hàng cùng với thông tin chi tiết của Category và Supplier.
SELECT ProductName, CategoryName, SupplierName
FROM Products
INNER JOIN Categories ON Products.CategoryId = Categories.Id
INNER JOIN Suppliers ON Products.SupplierId = Suppliers.Id

1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết nhân viên Employee.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer và nhân viên Employee.
1. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục
Dùng INNER JOIN + GROUP BY với lệnh COUNT
Dùng SubQuery với lệnh COUNT
1. Hiển thị tất cả nhà cung cấp (Suppliers) với số lượng hàng hóa mỗi nhà cung cấp
Dùng INNER JOIN + GROUP BY với lệnh COUNT
Dùng SubQuery với lệnh COUNT
1. Hiển thị tất cả các mặt hàng được bán trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả các khách hàng mua hàng trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả các khách hàng mua hàng (với tổng số tiền) trong khoảng từ ngày, đến ngày
Dùng INNER JOIN + GROUP BY với lệnh SUM
Dùng SubQuery với lệnh SUM
1. Hiển thị tất cả đơn hàng với tổng số tiền của đơn hàng đó
1. Hiển thị tất cả các nhân viên bán hàng với tổng số tiền bán được
1. Hiển thị tất cả các mặt hàng không bán được
1. Hiển thị tất cả các nhà cung cấp không bán được trong khoảng từ ngày, đến ngày
1. Hiển thị top 3 các nhân viên bán hàng với tổng số tiền bán được từ cao đến thấp trong khoảng từ ngày, đến ngày
1. Hiển thị top 5 các khách hàng mua hàng với tổng số tiền mua được từ cao đến thấp trong khoảng từ ngày, đến ngày
1. Hiển thị danh sách các mức giảm giá của cửa hàng
1. Hiển thị tất cả danh mục (Categories) với tổng số tiền bán được trong mỗi danh mục
Dùng INNER JOIN + GROUP BY với lệnh SUM
Dùng SubQuery với lệnh SUM
1. Hiển thị tất cả đơn hàng với tổng số tiền mà đã được giao hàng thành công trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả đơn hàng có tổng số tiền bán hàng nhiều nhất trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả đơn hàng có tổng số tiền bán hàng ít nhất trong khoảng từ ngày, đến ngày
1. Hiển thị trung bình cộng giá trị các đơn hàng trong khoảng từ ngày, đến ngày
1. Hiển thị các đơn hàng có giá trị cao nhất
1. Hiển thị các đơn hàng có giá trị thấp nhất

## 💛  Phần E: Views

1. Hiển thị danh sách các mức giảm giá của cửa hàng cùng với số lượng mặt hàng được giảm giá đó, gồm các fields: Discount, NumberOfProducts, Total.
1. Hiển thị tất cả các mặt hàng cùng với thông tin chi tiết của Category và Supplier gồm các fields: Id, Name, Price, Discount, CategoryId, CategoryName, SupplierId, SupplierName.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer và Employee gồm các fields: Id, OrderDate, Status, CustomerId, CustomerName, CustomerAddress, CustomerPhone, EmployeeId, EmployeeName, EmployeeAddress, EmployeePhone, Total.
1. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục, gồm các fields: Id, Name, Description, NumberOfProducts.
Dùng INNER JOIN + GROUP BY với lệnh COUNT
Dùng SubQuery với lệnh COUNT
1. Hiển thị tất cả nhà cung cấp (Suppliers) với số lượng hàng hóa mỗi nhà cung cấp, gồm các fields: Id, Name, Address, PhoneNumber, NumberOfProducts.
Dùng INNER JOIN + GROUP BY với lệnh COUNT
Dùng SubQuery với lệnh COUNT
1. Hiển thị tất cả các khách hàng mua hàng với tổng số tiền mua hàng, gồm các fields: Id, Name, Address, PhoneNumber, Total.

- Dùng INNER JOIN + GROUP BY với lệnh SUM
- Dùng SubQuery với lệnh SUM

Dùng Sub Query


1. Hiển thị tất cả các nhân viên bán hàng với tổng số tiền bán được, gồm các fields: Id, Name, Address, PhoneNumber, Total.
Dùng INNER JOIN + GROUP BY với lệnh SUM
Dùng SubQuery với lệnh SUM
1. Hiển thị tất cả các mặt hàng không bán được, gồm các fields: Id, Name, Price, Discount, CategoryId, CategoryName, SupplierId, SupplierName.

1. Hiển thị tất cả các nhà cung cấp không bán được, gồm các fields: Id, Name, Address, PhoneNumber.
1. Hiển thị tất cả các nhân viên không bán được hàng, gồm các fields: Id, Name, Address, PhoneNumber.


## 💛  Phần F: Stored Procedures

1. Hiển thị tất cả các mặt hàng có giảm giá <= @MinDiscount
1. Hiển thị tất cả các mặt hàng có số lượng tồn kho <= @MinStock
1. Hiển thị tất cả các mặt hàng có Giá bán sau khi đã giảm giá <= @Total
1. Hiển thị tất cả các khách hàng có địa chỉ ở @Address
1. Hiển thị tất cả các khách hàng có năm sinh @YearOfBirth
1. Hiển thị tất cả các khách hàng có tuổi từ @MinAge đến MaxAge.
1. Hiển thị tất cả các khách hàng có sinh nhật là @Date
1. Hiển thị tất cả các đơn hàng có trạng thái là @Status trong ngày @Date
1. Hiển thị tất cả các đơn hàng chưa hoàn thành trong tháng @Month của năm @Year
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là @PaymentMethod
1. Hiển thị tất cả đơn hàng theo trạng thái @Status với tổng số tiền của đơn hàng đó trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các nhân viên bán hàng theo trạng thái @Status với tổng số tiền bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các mặt hàng không bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các nhà cung cấp không bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các khách hàng mua hàng với tổng số tiền trong khoảng từ ngày @FromDate, đến ngày @ToDate

## 💛  Phần G: Functions

1. Viết 1 scalar function ghép FirstName @FirstName và LastName @LastName, tên function là udf_GetFullName
1. Viết 1 scalar funtion tính total price (@Price, @Discount, @Quantity), tên function là udf_Product_GetTotalPrice
1. Viết 1 scalar function tính total price của 1 Order (@OrderID), tên function là udf_Order_GetTotalPrice
1. Viết table function trả về table gồm các fields: OrderId, ProductId, ProductName, CategoryId, CategoryName, Quantity, Price, Discount, Total với tham số @OrderId, tên function là udf_Order_GetOrderDetails
1. Viết table function trả về các mức giá của 1 danh mục loại sản phẩm, với tham số @CategoryId, tên function là udf_Category_GetCategoryPrices
1. Viết table function trả về các mức giảm giá của 1 danh mục loại sản phẩm, với tham số @CategoryId, tên function là udf_Category_GetCategoryDiscounts
1. Viết scalar function nhập vào năm sinh, trả về số tuổi, tên function là udf_CalculateAge
1. Viết scalar function chuyển đổi UNICODE có dấu sang không dấu, tên function là udf_ConvertUnicodeToNonUnicode, ví dụ: udf_ConvertUnicodeToNonUnicode(N'Ngô Thanh Tùng') -> 'Ngo Thanh Tung'.


1. Viết scalar function chuyển đổi tên sản phẩm thành SEO Url, tên function là udf_ConvertToSeoUrl, ví dụ: udf_ConvertToSeoUrl(N'Điện thoại iPhone 12 Pro Max 256GB') -> 'dien-thoai-iphone-12-pro-max-256gb'.


## 💛  H: Triggers

1. Tạo 1 trigger trên bảng Orders: chặn update bảng Orders khi các Orders có Status = 'COMPLETED' hoặc 'CANCELLED'.
1. Tạo 1 trigger trên bảng Orders: chặn delete bảng Orders khi các Orders có Status = 'COMPLETED' hoặc 'CANCELLED'.
1. Tạo 1 trigger trên bảng OrderDetails: chặn update bảng OrderDetails khi các Orders có Status = 'COMPLETED' hoặc 'CANCELLED'.
1. Tạo 1 trigger trên bảng OrderDetails: chặn delete bảng OrderDetails khi các Orders có Status = 'COMPLETED' hoặc 'CANCELLED'.
1. Tạo 1 trigger trên bảng Orders: cập nhật tồn kho (Stock), trừ đi số lượng đã bán (Quantity) khi Orders có Status = 'WAITING', cộng lại số lượng đã bán (Quantity) khi Orders có Status = 'CANCELED'.
1. Tạo 1 trigger trên bảng Orders: ghi nhật ký khi Orders được giao hàng thành công (Status = 'COMPLETED'), Ghi vào bảng OrderLogs (Id, OrderId, Status, CreatedDate, EmployeeId, CustomerId)

## 💛  Phần I: Transactions

1. Tạo store procedure với 1 transaction để thêm 1 Order mới, với các OrderDetails, và cập nhật tồn kho (Stock) của các mặt hàng, gồm các bước:
Kiểm tra tồn kho (Stock) của mặt hàng có ProductId = @ProductId, nếu Stock < @Quantity thì rollback transaction, và trả về lỗi 'Số lượng tồn kho không đủ'
1. Tạo 1 Order mới, với Status = 'WAITING', CreatedDate = GETDATE(), EmployeeId = @EmployeeId, CustomerId = @CustomerId
1. Tạo 1 OrderDetail mới, với OrderId = OrderId vừa tạo, ProductId = @ProductId, Quantity = @Quantity, Price = Product.Price, Discount = Product.Discount
1. Cập nhật tồn kho (Stock) của mặt hàng có ProductId = @ProductId, trừ đi @Quantity.