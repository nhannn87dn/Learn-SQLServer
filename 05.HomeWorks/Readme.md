# Homework - BikeStore

## 💛  Phần A: Tạo bảng

1. Viết các câu lệnh tạo bảng như phần mô tả dưới đây

### 💥 Table Categories

| No. | FieldName     | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint      | Notes |
| --- | ------------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------- | ----- |
| 1   | CategoryId   | INT      |          |            | Primary Key |             |              | IDENTITY (1, 1) |       |
| 2   | CategoryName | NVARCHAR | 50       |            |             |             |              | UNIQUE          |       |
| 3   | Description   | NVARCHAR | 500      | YES        |             |             |              |                 |       |

**Sample Data Categories**

| CategoryId | CategoryName | Description |
|-------------|---------------|-------------|
| 1           | Road          | Bicycles designed for paved roads |
| 2           | Mountain      | Off-road and trail bicycles |
| 3           | Hybrid        | Versatile bikes for various terrains |
| 4           | Cruiser       | Comfortable and stylish bikes for leisurely rides |
| 5           | Electric      | Bicycles powered by electric motors |

### 💥 Table  Brands

| No. | FieldName   | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint     | Notes |
| --- | ----------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------- | ----- |
| 1   | BrandId    | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1) |       |
| 2   | BrandName  | NVARCHAR | 100      |            |             |             |              | UNIQUE         |       |
| 3   | Description | NVARCHAR | 500      | YES        |             |             |              |                |       |



**Sample Data Brands**


| BrandId | BrandName | Description |
|----------|------------|-------------|
| 1        | Trek       | High-quality bikes for all terrains |
| 2        | Giant      | Specializing in road and mountain bikes |
| 3        | Specialized| Innovative designs for cycling enthusiasts |
| 4        | Cannondale | Known for its performance-oriented bicycles |
| 5        | Scott      | Offers a wide range of bicycles for various purposes |


### 💥 Table Customers

| No. | FieldName   | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint     | Notes |
| --- | ----------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------- | ----- |
| 1   | CustomerId | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1) |       |
| 2   | FirstName  | NVARCHAR | 50       |            |             |             |              |                |       |
| 3   | LastName   | NVARCHAR | 50       |            |             |             |              |                |       |
| 4   | Phone       | VARCHAR  | 50       |            |             |             |              | UNIQUE         |       |
| 6   | Email       | VARCHAR  | 150      |            |             |             |              | UNIQUE         |       |
| 7   | Street      | NVARCHAR | 255      |            |             |             |              |                |       |
| 7   | City        | NVARCHAR | 50       |            |             |             |              |                |       |
| 7   | State       | NVARCHAR | 50       |            |             |             |              |                |       |
| 7   | ZipCode    | VARCHAR  | 5        | YES        |             |             |              |                |       |

**Sample Data Customers**

| CustomerId | FirstName | LastName | Phone       | Email                    | birthday   | Street       | City      | State | ZipCode |
|-------------|------------|-----------|-------------|--------------------------|------------|--------------|-----------|-------|----------|
| 1           | John       | Doe       | 123-456-7890| john.doe@example.com     | 1990-05-15 | 123 Main St  | Anytown   | CA    | 12345    |
| 2           | Jane       | Smith     | 456-789-0123| jane.smith@example.com   | 1985-08-20 | 456 Elm St   | Othertown | NY    | 67890    |
| 3           | Michael    | Johnson   | 789-012-3456| michael.johnson@example.com | 1978-12-25 | 789 Oak St   | AnyCity   | TX    | 23456    |
| 4           | Emily      | Brown     | 012-345-6789| emily.brown@example.com   | 1995-03-10 | 901 Pine St  | Sometown  | FL    | 78901    |
| 5           | William    | Martinez  | 234-567-8901| william.martinez@example.com | 1980-11-05 | 345 Cedar St | Othertown | CA    | 56789    |
| 6           | Olivia     | Garcia    | 567-890-1234| olivia.garcia@example.com | 1992-07-30 | 678 Maple St | AnyCity   | NY    | 01234    |
| 7           | James      | Lopez     | 890-123-4567| james.lopez@example.com   | 1987-09-18 | 890 Birch St | Sometown  | TX    | 34567    |
| 8           | Sophia     | Lee       | 123-456-7890| sophia.lee@example.com    | 1983-04-22 | 234 Oak St   | Othertown | FL    | 89012    |
| 9           | Benjamin   | Wang      | 456-789-0123| benjamin.wang@example.com | 1975-01-12 | 567 Pine St  | AnyCity   | CA    | 23456    |
| 10          | Mia        | Kim       | 789-012-3456| mia.kim@example.com       | 1998-06-28 | 890 Elm St   | Sometown  | NY    | 56789    |
| 11          | Ethan      | Nguyen    | 012-345-6789| ethan.nguyen@example.com  | 1989-02-14 | 901 Maple St | Othertown | TX    | 78901    |
| 12          | Isabella   | Patel     | 234-567-8901| isabella.patel@example.com | 1993-10-08 | 123 Cedar St | AnyCity   | FL    | 01234    |
| 13          | Aiden      | Gonzalez  | 567-890-1234| aiden.gonzalez@example.com | 1982-12-03 | 456 Oak St   | Sometown  | CA    | 34567    |
| 14          | Amelia     | Chen      | 890-123-4567| amelia.chen@example.com   | 1996-04-16 | 789 Pine St  | Othertown | NY    | 89012    |
| 15          | Oliver     | Santos    | 123-456-7890| oliver.santos@example.com | 1979-08-25 | 234 Elm St   | AnyCity   | TX    | 23456    |
| 16          | Charlotte  | Reyes     | 456-789-0123| charlotte.reyes@example.com | 1991-05-19 | 567 Maple St | Sometown  | FL    | 56789    |
| 17          | Elijah     | Wong      | 789-012-3456| elijah.wong@example.com   | 1986-02-09 | 890 Cedar St | Othertown | CA    | 01234    |

### 💥 Table  Staffs

| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                  | Notes                      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------------------- | -------------------------- |
| 1   | StaffId   | INT      |          |            | Primary Key |             |              | IDENTITY(1, 1)              |                            |
| 2   | FirstName | NVARCHAR | 50       |            |             |             |              |                             |                            |
| 3   | LastName  | NVARCHAR | 50       |            |             |             |              |                             |                            |
| 4   | Phone      | VARCHAR  | 50       |            |             |             |              | UNIQUE                      |                            |
| 5   | Email      | VARCHAR  | 150      |            |             |             |              | UNIQUE                      |                            |
| 5   | Active     | TINYINT  |          |            |             |             | 0            |                             | 0 = no Active, 1 = Actived |
| 5   | StoreId   | INIT     |          |            |             | Foreign Key |              | Reference stores (StoreId) |                            |
| 5   | ManageId  | INIT     |          |            |             | Foreign Key |              | Reference staffs (StaffId) |                            |

**Sample Data Staffs**

| StaffId | FirstName | LastName | Phone       | Email                    | Active | StoreId | ManageId |
|----------|------------|-----------|-------------|--------------------------|--------|----------|-----------|
| 1        | John       | Doe       | 123-456-7890| john.doe@example.com     | 1      | 1        | NULL      |
| 2        | Jane       | Smith     | 456-789-0123| jane.smith@example.com   | 1      | 2        | 1         |
| 3        | Michael    | Johnson   | 789-012-3456| michael.johnson@example.com | 0      | 1        | NULL      |
| 4        | Emily      | Brown     | 012-345-6789| emily.brown@example.com   | 1      | 3        | 2         |
| 5        | William    | Martinez  | 234-567-8901| william.martinez@example.com | 1      | 2        | 1         |


### 💥 Table  Products


| No. | FieldName    | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                         | Notes |
| --- | ------------ | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | ---------------------------------- | ----- |
| 1   | ProductId   | INT            |          |            | Primary Key |             |              | IDENTITY(1, 1)                     |       |
| 2   | ProductName | NVARCHAR       | 50       |            |             |             |              |                                    |       |
| 3   | Price        | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Price >= 0                  |       |
| 4   | Discount     | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Discount BETWEEN 0 AND 70   |       |
| 5   | CategoryId  | INT            |          |            |             | Foreign Key |              | Reference categories (CategoryId) |       |
| 6   | BrandId     | INT            |          |            |             | Foreign Key |              | Reference Brands (BrandId)        |       |
| 7   | Description  | NVARCHAR       | MAX      | Yes        |             |             |              |                                    |       |
| 8   | ModelYear   | SMALL INIT     |          |            |             |             |              |                                    |       |


**Sample Data Products**

| ProductId | ProductName | Price | Discount | CategoryId | BrandId | Description | ModelYear |
|------------|--------------|-------|----------|-------------|----------|-------------|------------|
| 1          | Road Bike    | 500   | 0        | 1           | 1        | Road bike for paved roads | 2022       |
| 2          | Mountain Bike| 600   | 0        | 2           | 2        | Off-road and trail bike  | 2022       |
| 3          | Hybrid Bike  | 450   | 0        | 3           | 3        | Versatile bike for various terrains | 2022 |
| 4          | Cruiser Bike | 400   | 0        | 4           | 4        | Comfortable and stylish bike for leisurely rides | 2022 |
| 5          | Electric Bike| 800   | 0        | 5           | 5        | Electric bike powered by electric motor | 2022 |
| 6          | Road Bike Pro| 1200  | 100      | 1           | 1        | Professional road bike for paved roads | 2022 |
| 7          | Mountain Bike Pro| 1500 | 120    | 2           | 2        | Professional off-road and trail bike | 2022 |
| 8          | Hybrid Bike Pro| 1000  | 80      | 3           | 3        | Professional versatile bike for various terrains | 2022 |
| 9          | Cruiser Bike Pro| 900   | 70      | 4           | 4        | Professional comfortable and stylish bike | 2022 |
| 10         | Electric Bike Pro| 1800 | 150    | 5           | 5        | Professional electric bike powered by electric motor | 2022 |
| 11         | Road Bike XL | 700   | 0        | 1           | 1        | Extra large road bike for paved roads | 2022 |
| 12         | Mountain Bike XL| 800 | 0        | 2           | 2        | Extra large off-road and trail bike | 2022 |
| 13         | Hybrid Bike XL| 600   | 0        | 3           | 3        | Extra large versatile bike for various terrains | 2022 |
| 14         | Cruiser Bike XL| 550   | 0        | 4           | 4        | Extra large comfortable and stylish bike | 2022 |
| 15         | Electric Bike XL| 1000 | 0       | 5           | 5        | Extra large electric bike powered by electric motor | 2022 |



### 💥 Table  Stores


| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------- |
| 1   | StoreId   | INT      |          |            | Primary Key |             |              | IDENTITY (1, 1) |
| 2   | StoreName | NVARCHAR | 50       |            |             |             |              | UNIQUE          |
| 3   | Phone      | VARCHAR  | 50       | Yes        |             |             |              |                 |
| 4   | Email      | VARCHAR  | 150      | Yes        |             |             |              |                 |
| 5   | Street     | NVARCHAR | 255      | Yes        |             |             |              |                 |
| 6   | City       | NVARCHAR | 50       | Yes        |             |             |              |                 |
| 7   | State      | NVARCHAR | 50       | Yes        |             |             |              |                 |
| 8   | ZipCode   | VARCHAR  | 5        | Yes        |             |             |              |                 |


**Sample Data Stores**


| StoreId | StoreName    | Phone      | Email              | Street         | City       | State | ZipCode |
|----------|---------------|------------|--------------------|----------------|------------|-------|----------|
| 1        | Main Store    | 123-456-789| main@store.com     | 123 Main St    | Anytown    | CA    | 12345    |
| 2        | Downtown Store| 456-789-012| downtown@store.com | 456 Elm St     | Downtown   | NY    | 67890    |
| 3        | West Store    | 789-012-345| west@store.com     | 789 Oak St     | Westside   | TX    | 23456    |
| 4        | East Store    | 012-345-678| east@store.com     | 012 Pine St    | Eastside   | FL    | 78901    |
| 5        | South Store   | 345-678-901| south@store.com    | 345 Maple St   | Southside  | WA    | 56789    |


### 💥 Table Stocks

| No. | FieldName  | DataType | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                      |
| --- | ---------- | -------- | -------- | ---------- | ----------- | ----------- | ------------ | ------------------------------- |
| 1   | StoreId   | INT      |          |            | Primary Key | Foreign Key |              | Reference stores (StoreId)     |
| 2   | ProductId | INIT     |          |            | Primary Key | Foreign Key |              | Reference products (ProductId) |
| 3   | Quantity   | INIT     |          |            |             |             | 0            |                                 |


**Sample Data Stocks**

| StoreId | ProductId | Quantity |
|----------|------------|----------|
| 1        | 1          | 100      |
| 2        | 2          | 150      |
| 3        | 3          | 200      |
| 4        | 4          | 120      |
| 5        | 5          | 80       |
| 1        | 6          | 50       |
| 2        | 7          | 70       |
| 3        | 8          | 90       |
| 4        | 9          | 110      |
| 5        | 10         | 60       |
| 1        | 11         | 130      |
| 2        | 12         | 140      |
| 3        | 13         | 100      |
| 4        | 14         | 85       |
| 5        | 15         | 95       |


### 💥 Table  Orders

| No. | FieldName        | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                        | Notes                                                                  |
| --- | ---------------- | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | --------------------------------- | ---------------------------------------------------------------------- |
| 1   | OrderId         | INT            |          |            | Primary Key |             |              | IDENTITY(1, 1)                    |                                                                        |
| 2   | CustomerId      | INIT           |          |            |             | Foreign Key |              | Reference customers (CustomerId) |                                                                        |
| 3   | OrderStatus     | TINYINT        |          |            |             |             |              | 1/2/3/4                           | Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed |
| 4   | OrderDate       | VARCHAR        | 50       |            |             |             | NOW          |                                   |                                                                        |
| 5   | RequireDate     | DATETIME       |          | YES        |             |             |              |                                   |                                                                        |
| 6   | ShippingDate    | DATETIME       |          |            |             |             |              |                                   |                                                                        |
| 7   | StoreId         | INIT           | 50       |            |             | Foreign Key |              | Reference stores (StoreId)       |                                                                        |
| 8   | StaffId         | INIT           | 20       |            |             | Foreign Key |              | Reference staffs (StaffId)       |                                                                        |
| 9   | OrderNote       | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 10  | ShippingAddress | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 11  | ShippingCity    | NVARCHAR       |          | YES        |             |             |              |                                   |                                                                        |
| 12  | PaymentType     | TINYINT        |          |            |             |             | 4            | 1/2/3/4                           | payment type: 1 = COD; 2 = Credit; 3 = ATM; 4 = Cash                   |
| 13  | OrderAmount     | DECIMAL(18, 2) |          |            |             |             | 0            |                                   |                                                                        |



### 💥 Table OrderItems

| No. | FieldName  | DataType       | DataSize | Allow null | Key         | Foreign Key | DefaultValue | Constraint                       |
| --- | ---------- | -------------- | -------- | ---------- | ----------- | ----------- | ------------ | -------------------------------- |
| 1   | OrderId   | INT            |          |            | Primary Key | Foreign Key |              | Reference orders (OrderId)      |
| 2   | ItemId    | INT            |          |            | Primary Key |             |              |                                  |
| 3   | ProductId | INT            |          |            |             | Foreign Key |              | Reference products (ProductId)  |
| 3   | Quantity   | INIT           |          |            |             |             | 0            | Check: Quantity >= 0             |
| 4   | Price      | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Price >= 0                |
| 5   | Discount   | DECIMAL(18, 2) |          |            |             |             | 0            | Check: Discount BETWEEN 0 AND 70 |




---

2. Tạo mỗi bảng từ 5-10 records: Sử dụng câu lệnh INSERT, thứ tự nhập dữ liệu cho các tables:

- Categories
- Brands
- Customers
- Staffs
- Products
- Stores
- Stocks
- Orders
- Order_items


---

## 💛  Phần B: Câu lệnh  UPDATE, DELETE

1. Viết câu lệnh UPDATE để cập nhật Price với điều kiện: Các sản phẩm có Price <= 100 thì tăng thêm 10%
1. Viết câu lệnh UPDATE để cập nhật DISCOUNT với điều kiện: Các sản phẩm có Discount <= 10% thì tăng thêm 5%
1. Viết câu lệnh XOÁ tất cả các sản phẩm có Quantity là 0
1. Chèn vào table Brands thêm 3 thương hiệu nữa rồi sau đó viết câu lệnh XÓA 3 thương hiệu vừa thêm


## 💛  Phần C: Truy vấn cơ bản

1. Hiển thị tất cả các sản phẩm có giảm giá (Discount)  <= 10%
1. Hiện thị tất cả các sản phẩm không có giảm giá (Discount) 
1. Hiển thị tất cả các sản phẩm có Giá bán sau khi đã giảm giá (Discount)  <= 100
1. Hiện thị tất cả các sản phẩm thuộc danh mục có CategoryId = 4 và thương hiệu = 5
1. Hiện thị tất cả các sản phẩm thuộc danh mục có CategoryId = 2 và 4.
1. Hiện thị tất cả các sản phẩm có model sản xuất (ModelYear) từ 2017 - 2020.
1. Hiển thị tất cả các khách hàng có địa chỉ ở `City = 'New York'`
1. Hiển thị tất cả các khách hàng có địa chỉ ở `City = 'New York'` hoặc `City = 'Victoria'`
1. Hiển thị tất cả các khách hàng có năm sinh 1990.
1. Hiển thị tất cả các khách hàng có tuổi trên 60.
1. Hiển thị tất cả các khách hàng có tuổi từ 20 đến 30.
1. Hiển thị tất cả các khách hàng có số đuôi điện thoại '500'
1. Hiển thị tất cả các khách hàng có tên chứa ký tự `de`.
1. Hiển thị tất cả các khách hàng có sinh nhật là hôm nay. Gợi ý: dùng hàm GETDATE(), MONTH(), DAY()
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (OrderStatus = 4)
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (OrderStatus = 4) trong ngày hôm nay
1. Hiển thị tất cả các đơn hàng chưa hoàn thành trong tháng này
1. Hiển thị tất cả các đơn hàng có trạng thái là CANCELED (OrderStatus = 3)
1. Hiển thị tất cả các đơn hàng có trạng thái là CANCELED (OrderStatus = 3) trong ngày hôm nay
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (OrderStatus = 4) trong tháng này
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (OrderStatus = 4) trong tháng 1 năm 2021
1. Hiển thị tất cả các đơn hàng có trạng thái là COMPLETED (OrderStatus = 4) trong năm 2021
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là CASH (PaymentType = 4)
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là CREADIT CARD (PaymentType = 2)
1. Hiển thị tất cả các đơn hàng có địa chỉ giao hàng ở thành phố `Houton`
1. Hiển thị tất cả các nhân viên có sinh nhật là tháng này
1. Hiển thị tất cả các thương hiệu (Brands) có tên là: (Electra, Haro, Heller, Trek)
1. Hiển thị tất cả các thương hiệu (Brands) không có tên là: (Heller, Trek)
1. Hiển thị tất cả các khách hàng có sinh nhật là ngày hôm nay.
1. Hiển thị xem có bao nhiêu mức giảm giá (Discount)  khác nhau.
1. Hiển thị xem có bao nhiêu mức giảm giá (Discount)  khác nhau và số lượng sản phẩm có mức giảm giá (Discount)  đó.
1. Hiển thị xem có bao nhiêu mức giảm giá (Discount)  khác nhau và số lượng sản phẩm có mức giảm giá (Discount)  đó, sắp xếp theo số lượng giảm giá (Discount)  giảm dần.
1. Hiển thị xem có bao nhiêu mức giảm giá (Discount)  khác nhau và số lượng sản phẩm có mức giảm giá (Discount)  đó, sắp xếp theo số lượng giảm giá (Discount)  tăng dần, chỉ hiển thị các mức giảm giá (Discount)  có số lượng sản phẩm >= 5
1. Hiển thị xem có bao nhiêu mức tuổi khác nhau của khách hàng và số lượng khách hàng có mức tuổi đó, sắp xếp theo số lượng khách hàng tăng dần.
1. Hiển thị xem có bao nhiêu mức tuổi khác nhau của nhân viên và số lượng nhân viên có mức tuổi đó, sắp xếp theo số lượng nhân viên giảm dần.
1. Hiển thị số lượng đơn hàng theo từng ngày khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng tháng khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần.
1. Hiển thị số lượng đơn hàng theo từng năm khác nhau sắp xếp theo số lượng đơn hàng giảm dần, chỉ hiển thị các năm có số lượng đơn hàng >= 5.

## 💛  Phần D: Truy vấn nâng cao

1. Hiển thị tất cả các sản phẩm cùng với tên danh mục (CategoryName).
1. Hiển thị tất cả các sản phẩm cùng với tên thương hiệu (BrandName).

1. Hiển thị tất cả các sản phẩm cùng với thông tin chi tiết của categories và Brands
1. Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết nhân viên Staff.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer và nhân viên Staff.
1. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục

- Dùng INNER JOIN + GROUP BY với lệnh COUNT
- Dùng SubQuery với lệnh COUNT

1. Hiển thị tất cả thương hiệu (Brands) với số lượng hàng hóa mỗi thương hiệu (Brands)

- Dùng INNER JOIN + GROUP BY với lệnh COUNT
- Dùng SubQuery với lệnh COUNT

1. Hiển thị tất cả các sản phẩm được bán trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả các khách hàng mua hàng trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả các khách hàng mua hàng (với tổng số tiền) trong khoảng từ ngày, đến ngày

- Dùng INNER JOIN + GROUP BY với lệnh SUM
- Dùng SubQuery với lệnh SUM

1. Hiển thị tất cả đơn hàng với tổng số tiền của đơn hàng đó
1. Hiển thị tất cả các nhân viên bán hàng với tổng số tiền bán được
1. Hiển thị tất cả các sản phẩm không bán được
1. Hiển thị tất cả các thương hiệu (Brands) không bán được trong khoảng từ ngày, đến ngày
1. Hiển thị top 3 các nhân viên bán hàng với tổng số tiền bán được từ cao đến thấp trong khoảng từ ngày, đến ngày
1. Hiển thị top 5 các khách hàng mua hàng với tổng số tiền mua được từ cao đến thấp trong khoảng từ ngày, đến ngày
1. Hiển thị danh sách các mức giảm giá (Discount)  của cửa hàng
1. Hiển thị tất cả danh mục (Categories) với tổng số tiền bán được trong mỗi danh mục

- Dùng INNER JOIN + GROUP BY với lệnh SUM
- Dùng SubQuery với lệnh SUM

1. Hiển thị tất cả đơn hàng với tổng số tiền mà đã được giao hàng thành công trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả đơn hàng có tổng số tiền bán hàng nhiều nhất trong khoảng từ ngày, đến ngày
1. Hiển thị tất cả đơn hàng có tổng số tiền bán hàng ít nhất trong khoảng từ ngày, đến ngày
1. Hiển thị trung bình cộng giá trị các đơn hàng trong khoảng từ ngày, đến ngày
1. Hiển thị các đơn hàng có giá trị cao nhất
1. Hiển thị các đơn hàng có giá trị thấp nhất

## 💛  Phần E: Views

1. Hiển thị danh sách các mức giảm giá (Discount)  của cửa hàng cùng với số lượng sản phẩm được giảm giá (Discount)  đó, gồm các fields: Discount, NumberOfProducts, Total.
1. Hiển thị tất cả các sản phẩm cùng với thông tin chi tiết của Category và Brand gồm các fields: ProductId, ProductName, Price, Discount, CategoryId, CategoryName, BrandId, BrandName.
1. Hiển thị tất cả các đơn hàng cùng với thông tin chi tiết khách hàng Customer và Staff gồm các fields: OrderId, OrderDate, OrderStatus, CustomerId, customer_name, Street, Phone, StaffId, staff_name, staff_address, Phone, total.
1. Hiển thị tất cả danh mục (Categories) với số lượng hàng hóa trong mỗi danh mục, gồm các fields: CategoryId, CategoryName, Description, NumberOfProducts.

- Dùng INNER JOIN + GROUP BY với lệnh COUNT
- Dùng SubQuery với lệnh COUNT

1. Hiển thị tất cả thương hiệu (Brands) với số lượng hàng hóa mỗi thương hiệu (Brands), gồm các fields: BrandId, BrandName, NumberOfProducts.

- Dùng INNER JOIN + GROUP BY với lệnh COUNT
- Dùng SubQuery với lệnh COUNT

1. Hiển thị tất cả các khách hàng mua hàng với tổng số tiền mua hàng, gồm các fields: CustomerId, customer_name, address (Street + City, State), Phone, total.

- Dùng INNER JOIN + GROUP BY với lệnh SUM
- Dùng SubQuery với lệnh SUM


1. Hiển thị tất cả các nhân viên bán hàng với tổng số tiền bán được, gồm các fields: StaffId, staff_name,  Phone, total.

- Dùng INNER JOIN + GROUP BY với lệnh SUM
- Dùng SubQuery với lệnh SUM

1. Hiển thị tất cả các sản phẩm không bán được, gồm các fields: ProductId, ProductName, Price, Discount, CategoryId, CategoryName, BrandId, BrandName.

1. Hiển thị tất cả các thương hiệu (Brands) không bán được, gồm các fields: BrandId, BrandName
1. Hiển thị tất cả các nhân viên không bán được hàng, gồm các fields: StaffId, staff_name,  Phone


## 💛  Phần F: Stored Procedures

1. Hiển thị tất cả các sản phẩm có giảm giá (Discount)  <= @MinDiscount
1. Hiển thị tất cả các sản phẩm có số lượng tồn kho <= @MinStock
1. Hiển thị tất cả các sản phẩm có Giá bán sau khi đã giảm giá (Discount)  <= @Total
1. Hiển thị tất cả các khách hàng có địa chỉ ở @Address
1. Hiển thị tất cả các khách hàng có năm sinh @YearOfBirth
1. Hiển thị tất cả các khách hàng có tuổi từ @MinAge đến MaxAge.
1. Hiển thị tất cả các khách hàng có sinh nhật là @Date
1. Hiển thị tất cả các đơn hàng có trạng thái là @Status trong ngày @Date
1. Hiển thị tất cả các đơn hàng chưa hoàn thành trong tháng @Month của năm @Year
1. Hiển thị tất cả các đơn hàng có hình thức thanh toán là @PaymentMethod
1. Hiển thị tất cả đơn hàng theo trạng thái @Status với tổng số tiền của đơn hàng đó trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các nhân viên bán hàng theo trạng thái @Status với tổng số tiền bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các sản phẩm không bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các thương hiệu (Brands) không bán được trong khoảng từ ngày @FromDate, đến ngày @ToDate
1. Hiển thị tất cả các khách hàng mua hàng với tổng số tiền trong khoảng từ ngày @FromDate, đến ngày @ToDate

## 💛  Phần G: Functions

1. Viết 1 scalar function ghép FirstName @FirstName và LastName @LastName, tên function là udf_GetFullName
1. Viết 1 scalar funtion tính total Price (@Price, @Discount, @Quantity), tên function là udf_Product_GetTotalPrice
1. Viết 1 scalar function tính total Price của 1 Order (@OrderID), tên function là udf_Order_GetTotalPrice
1. Viết table function trả về table gồm các fields: OrderId, ProductId, ProductName, CategoryId, CategoryName, Quantity, Price, Discount, total với tham số @OrderId, tên function là udf_Order_GetOrderItems
1. Viết table function trả về các mức giá của 1 danh mục loại sản phẩm, với tham số @CategoryId, tên function là udf_Category_GetCategoryPrices
1. Viết table function trả về các mức giảm giá (Discount)  của 1 danh mục loại sản phẩm, với tham số @CategoryId, tên function là udf_Category_GetCategoryDiscounts
1. Viết scalar function nhập vào năm sinh, trả về số tuổi, tên function là udf_CalculateAge
1. Viết scalar function chuyển đổi UNICODE có dấu sang không dấu, tên function là udf_ConvertUnicodeToNonUnicode, ví dụ: udf_ConvertUnicodeToNonUnicode(N'Học lập trình SQL tại Softech') -> 'Hoc lap trinh SQL tai Softech'.
1. Viết scalar function chuyển đổi tên sản phẩm thành SEO Url, tên function là udf_ConvertToSeoUrl, ví dụ: udf_ConvertToSeoUrl(N'Điện thoại iPhone 12 Pro Max 256GB') -> 'dien-thoai-iPhone-12-pro-max-256gb'.


## 💛  H: Triggers

1. Tạo 1 trigger trên bảng Orders: chặn update bảng Orders khi các Orders có OrderStatus =  'COMPLETED (OrderStatus = 4)' hoặc 'CANCELED (OrderStatus = 3)'.
1. Tạo 1 trigger trên bảng Orders: chặn delete bảng Orders khi các Orders có OrderStatus =  'COMPLETED (OrderStatus = 4)' hoặc 'CANCELED (OrderStatus = 3)'.
1. Tạo 1 trigger trên bảng OrderItems: chặn update bảng OrderItems khi các Orders có OrderStatus =  'COMPLETED (OrderStatus = 4)' hoặc 'CANCELED (OrderStatus = 3)'.
1. Tạo 1 trigger trên bảng OrderItems: chặn delete bảng OrderItems khi các Orders có OrderStatus =  'COMPLETED (OrderStatus = 4)' hoặc 'CANCELED (OrderStatus = 3)'.
1. Tạo 1 trigger trên bảng Orders: cập nhật tồn kho (Quantity), trừ đi số lượng đã bán (Quantity) khi Orders có OrderStatus =  'PENDING (OrderStatus = 1)', cộng lại số lượng đã bán (Quantity) khi Orders có OrderStatus =  'CANCELED (OrderStatus = 3)'.
1. Tạo 1 trigger trên bảng Orders: ghi nhật ký khi Orders được giao hàng thành công (OrderStatus =  'COMPLETED (OrderStatus = 4)'), Ghi vào bảng OrderLogs (Id, OrderId, Status, CreatedDate, StaffId, CustomerId)

## 💛  Phần I: Transactions

1. Tạo store procedure với 1 transaction để thêm 1 Order mới, với các OrderItems, và cập nhật tồn kho (Quantity) của các sản phẩm, gồm các bước:

- Kiểm tra tồn kho (Quantity) của sản phẩm có ProductId = @ProductId, nếu Quantity < @Quantity thì rollback transaction, và trả về lỗi 'Số lượng tồn kho không đủ'
- Tạo 1 Order mới, với OrderStatus = 1, order-date = GETDATE(), StaffId = @StaffId, CustomerId = @CustomerId
- Tạo 1 OrderItems mới, với OrderId = OrderId vừa tạo, ProductId = @ProductId, Quantity = @Quantity, Price = products.Price, Discount = products.Discount
- Cập nhật tồn kho (Quantity) của sản phẩm có ProductId = @ProductId, trừ đi @Quantity.