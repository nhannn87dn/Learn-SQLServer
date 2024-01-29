Tôi cần xây dựng  Database quản lý bán hàng sử dụng SQL Server với các yêu cầu:
- Có nhiều cửa hàng
- Có nhiều nhân viên, nhân viên này có thể thuộc cửa hàng này, cửa hàng kia.
- Có nhiều nhóm hàng ví dụ: Laptop, Điện Thoại, USB. Mỗi nhóm hàng có thể có các danh mục con. Ví dụ trong Nhóm Điện thoại có thể có: Điện thoại Xiaomi, Điện thoại Apple
- Có nhiều thương hiệu sản phẩm: Sony, Lenovo, Panasonic
- Sản phẩm có nhiều biến thể, SKU khác nhau. Tôi có thể lựa chọn biến thể khi đặt hàng. Ví dụ Giày: Màu Trắng: Size 41, 42,43,44,46, Màu Cam: Size 36,38,40. Hay iPhone 15 Pro màu Gold: Dung lượng 128GB, 256GB, Màu Black: Dung lượng 256GB, 512GB. Các biến thể trên có hình ảnh, giá khác nhau và số lượng tồn kho theo mỗi cửa hàng khác nhau.
- Tôi có thể tìm kiếm sản phẩm theo:
  - Thương hiệu
  - Theo bộ lọc biến thể, tùy chọn như: Dung lượng, màu, size...
  - Và có thể tự tạo các bộ lọc khác dựa vào thuộc tính của sản phẩm
- Tôi cần quản lý khách hàng đã mua. Khách hàng có thể mua hàng login hoặc không cần login
- Khách hàng có thể lựa chọn phương thức thanh toán khác nhau
- Khách hàng có thể lựa chọn phương thức giao hàng khác nhau
- Khách hàng có thể nhập mã giảm giá

Dưới đây là một mô hình cấu trúc SQL Server có thể giúp bạn quản lý các yêu cầu trên:

```sql
CREATE TABLE Store (
    StoreID int PRIMARY KEY,
    StoreName varchar(255) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID int PRIMARY KEY,
    EmployeeName varchar(255) NOT NULL,
    StoreID int FOREIGN KEY REFERENCES Store(StoreID)
);

CREATE TABLE ProductCategory (
    CategoryID int PRIMARY KEY,
    CategoryName varchar(255) NOT NULL,
    ParentCategoryID int FOREIGN KEY REFERENCES ProductCategory(CategoryID)
);

CREATE TABLE Brand (
    BrandID int PRIMARY KEY,
    BrandName varchar(255) NOT NULL
);

CREATE TABLE Product (
    ProductID int PRIMARY KEY,
    ProductName varchar(255) NOT NULL,
    CategoryID int FOREIGN KEY REFERENCES ProductCategory(CategoryID),
    BrandID int FOREIGN KEY REFERENCES Brand(BrandID)
);

CREATE TABLE SKU (
    SkuID int PRIMARY KEY,
    SkuName varchar(255) NOT NULL,
    ProductID int FOREIGN KEY REFERENCES Product(ProductID)
);

CREATE TABLE SkuVariant (
    VariantID int PRIMARY KEY,
    VariantName varchar(255) NOT NULL,
    SkuID int FOREIGN KEY REFERENCES SKU(SkuID),
    ImageURL varchar(255),
    Price decimal(10,2)
);

CREATE TABLE Inventory (
    StoreID int FOREIGN KEY REFERENCES Store(StoreID),
    VariantID int FOREIGN KEY REFERENCES SkuVariant(VariantID),
    StockQuantity int,
    PRIMARY KEY (StoreID, VariantID)
);

CREATE TABLE Customer (
    CustomerID int PRIMARY KEY,
    CustomerName varchar(255),
    IsRegistered bit NOT NULL
);

CREATE TABLE PaymentMethod (
    PaymentMethodID int PRIMARY KEY,
    PaymentMethodName varchar(255) NOT NULL
);

CREATE TABLE ShippingMethod (
    ShippingMethodID int PRIMARY KEY,
    ShippingMethodName varchar(255) NOT NULL
);

CREATE TABLE Order (
    OrderID int PRIMARY KEY,
    CustomerID int FOREIGN KEY REFERENCES Customer(CustomerID),
    PaymentMethodID int FOREIGN KEY REFERENCES PaymentMethod(PaymentMethodID),
    ShippingMethodID int FOREIGN KEY REFERENCES ShippingMethod(ShippingMethodID),
    DiscountCode varchar(255)
);

CREATE TABLE OrderDetail (
    OrderID int FOREIGN KEY REFERENCES Order(OrderID),
    VariantID int FOREIGN KEY REFERENCES SkuVariant(VariantID),
    Quantity int,
    PRIMARY KEY (OrderID, VariantID)
);


```

Trong mô hình này:
- `Store` chứa danh sách các cửa hàng.
- `Employee` chứa danh sách các nhân viên, liên kết với bảng `Store` thông qua khóa ngoại `StoreID`.
- `ProductCategory` chứa danh sách các nhóm hàng, với khóa ngoại `ParentCategoryID` để xác định danh mục con.
- `Brand` chứa danh sách các thương hiệu sản phẩm.
- `Product` chứa danh sách các sản phẩm, liên kết với bảng `ProductCategory` và `Brand` thông qua các khóa ngoại `CategoryID` và `BrandID`.
- `SKU` và `SkuVariant` chứa danh sách các SKU và biến thể của SKU, tương tự như trong mô hình trước.
- `Inventory` chứa số lượng tồn kho cho mỗi biến thể tại mỗi cửa hàng.
- `Customer`, `PaymentMethod`, `ShippingMethod`, `Order`, và `OrderDetail` được sử dụng để quản lý đơn hàng và khách hàng. Trong đó, `OrderDetail` chứa thông tin về số lượng mỗi biến thể trong mỗi đơn hàng.


Để tránh việc sử dụng mệnh đề `LIKE` và để có thể lọc theo các thuộc tính cụ thể như RAM và bộ nhớ, bạn có thể tạo thêm một bảng `VariantAttribute` để lưu trữ các thuộc tính của biến thể SKU. Dưới đây là cách bạn có thể thay đổi cấu trúc cơ sở dữ liệu:

```sql
CREATE TABLE VariantAttribute (
    VariantID int FOREIGN KEY REFERENCES SkuVariant(VariantID),
    AttributeName varchar(255) NOT NULL,
    AttributeValue varchar(255) NOT NULL,
    PRIMARY KEY (VariantID, AttributeName)
);
```

Để lọc các sản phẩm điện thoại có RAM 4GB hoặc 8GB, bộ nhớ 256GB, giá dưới 25 triệu đồng, và sắp xếp theo giá tăng dần, bạn có thể thực hiện truy vấn SQL như sau:

```sql
WITH PhoneVariants AS (
    SELECT sv.VariantID
    FROM Product p
    JOIN SKU s ON p.ProductID = s.ProductID
    JOIN SkuVariant sv ON s.SkuID = sv.SkuID
    JOIN ProductCategory pc ON p.CategoryID = pc.CategoryID
    WHERE (pc.CategoryName = 'Điện thoại' OR pc.ParentCategoryID IN (
        SELECT CategoryID FROM ProductCategory WHERE CategoryName = 'Điện thoại'
    )) AND sv.Price < 25000000
), RamVariants AS (
    SELECT VariantID
    FROM VariantAttribute
    WHERE AttributeName = 'RAM' AND AttributeValue IN ('4GB', '8GB')
), HddVariants AS (
    SELECT VariantID
    FROM VariantAttribute
    WHERE AttributeName = 'HDD' AND AttributeValue = '256GB'
)
SELECT p.ProductName, sv.VariantName, sv.Price
FROM Product p
JOIN SKU s ON p.ProductID = s.ProductID
JOIN SkuVariant sv ON s.SkuID = sv.SkuID
WHERE sv.VariantID IN (
    SELECT VariantID FROM PhoneVariants
    INTERSECT
    SELECT VariantID FROM RamVariants
    INTERSECT
    SELECT VariantID FROM HddVariants
)
ORDER BY sv.Price ASC;
```

Truy vấn này sẽ trả về tên và giá của tất cả sản phẩm Điện thoại có RAM 4GB hoặc 8GB, bộ nhớ 256GB, giá dưới 25 triệu đồng, bao gồm cả sản phẩm thuộc danh mục con của nhóm Điện thoại, và sắp xếp theo giá tăng dần. Hãy chắc chắn rằng bạn đã nhập đúng tên danh mục, dung lượng RAM, dung lượng bộ nhớ, và giá trong truy vấn. Truy vấn này giả định rằng `AttributeName` và `AttributeValue` trong bảng `VariantAttribute` chứa thông tin về RAM và bộ nhớ, và `Price` trong bảng `SkuVariant` chứa giá của sản phẩm. Nếu không, bạn cần điều chỉnh truy vấn phù hợp với cấu trúc dữ liệu của bạn. Truy vấn này cũng giả định rằng giá được lưu trữ bằng đơn vị đồng. Nếu bạn sử dụng đơn vị tiền tệ khác, bạn cần điều chỉnh số liệu tương ứng. Truy vấn này cũng giả định rằng giá được lưu trữ bằng đơn vị đồng. Nếu bạn sử dụng đơn vị tiền tệ khác, bạn cần điều chỉnh số liệu tương ứng.



Dưới đây là một số dữ liệu mẫu cho các bảng trong cấu trúc cơ sở dữ liệu mà tôi đã đề xuất:

```sql
-- Dữ liệu mẫu cho bảng Store
INSERT INTO Store (StoreID, StoreName) VALUES (1, 'Cửa hàng 1'), (2, 'Cửa hàng 2');

-- Dữ liệu mẫu cho bảng Employee
INSERT INTO Employee (EmployeeID, EmployeeName, StoreID) VALUES (1, 'Nhân viên 1', 1), (2, 'Nhân viên 2', 2);

-- Dữ liệu mẫu cho bảng ProductCategory
INSERT INTO ProductCategory (CategoryID, CategoryName, ParentCategoryID) VALUES (1, 'Điện thoại', NULL), (2, 'Điện thoại Xiaomi', 1), (3, 'Điện thoại Apple', 1);

-- Dữ liệu mẫu cho bảng Brand
INSERT INTO Brand (BrandID, BrandName) VALUES (1, 'Sony'), (2, 'Lenovo'), (3, 'Panasonic');

-- Dữ liệu mẫu cho bảng Product
INSERT INTO Product (ProductID, ProductName, CategoryID, BrandID) VALUES (1, 'Xiaomi Redmi Note 10', 2, 1), (2, 'Apple iPhone 15', 3, 2);

-- Dữ liệu mẫu cho bảng SKU
INSERT INTO SKU (SkuID, SkuName, ProductID) VALUES (1, 'Redmi Note 10 - 4GB/64GB', 1), (2, 'iPhone 15 - 8GB/256GB', 2);

-- Dữ liệu mẫu cho bảng SkuVariant
INSERT INTO SkuVariant (VariantID, VariantName, SkuID, ImageURL, Price) VALUES (1, 'Màu đen', 1, 'url_to_image', 5000000), (2, 'Màu trắng', 2, 'url_to_image', 20000000);

-- Dữ liệu mẫu cho bảng Inventory
INSERT INTO Inventory (StoreID, VariantID, StockQuantity) VALUES (1, 1, 100), (2, 2, 50);

-- Dữ liệu mẫu cho bảng Customer
INSERT INTO Customer (CustomerID, CustomerName, IsRegistered) VALUES (1, 'Khách hàng 1', 1), (2, 'Khách hàng 2', 0);

-- Dữ liệu mẫu cho bảng PaymentMethod
INSERT INTO PaymentMethod (PaymentMethodID, PaymentMethodName) VALUES (1, 'Thanh toán khi nhận hàng'), (2, 'Thanh toán qua thẻ');

-- Dữ liệu mẫu cho bảng ShippingMethod
INSERT INTO ShippingMethod (ShippingMethodID, ShippingMethodName) VALUES (1, 'Giao hàng tiêu chuẩn'), (2, 'Giao hàng nhanh');

-- Dữ liệu mẫu cho bảng Order
INSERT INTO Order (OrderID, CustomerID, PaymentMethodID, ShippingMethodID, DiscountCode) VALUES (1, 1, 1, 1, 'DISCOUNT10'), (2, 2, 2, 2, NULL);

-- Dữ liệu mẫu cho bảng OrderDetail
INSERT INTO OrderDetail (OrderID, VariantID, Quantity) VALUES (1, 1, 2), (2, 2, 1);
```

Lưu ý rằng bạn cần thay thế `'url_to_image'` bằng URL thực sự của hình ảnh sản phẩm. Ngoài ra, bạn cũng cần điều chỉnh các giá trị để phù hợp với dữ liệu thực tế của bạn. Đây chỉ là dữ liệu mẫu và có thể không phản ánh đúng dữ liệu thực tế của bạn. Trong thực tế, bạn sẽ cần phải xử lý việc thêm dữ liệu vào cơ sở dữ liệu một cách cẩn thận để đảm bảo tính nhất quán và độ chính xác của dữ liệu.


```sql
-- Dữ liệu mẫu cho bảng VariantAttribute
INSERT INTO VariantAttribute (VariantID, AttributeName, AttributeValue) VALUES 
(1, 'RAM', '4GB'), 
(1, 'HDD', '64GB'), 
(2, 'RAM', '8GB'), 
(2, 'HDD', '256GB');
```

Trong dữ liệu mẫu này, biến thể SKU có `VariantID` là 1 (Redmi Note 10 - 4GB/64GB) có thuộc tính 'RAM' với giá trị '4GB' và thuộc tính 'HDD' với giá trị '64GB'. Tương tự, biến thể SKU có `VariantID` là 2 (iPhone 15 - 8GB/256GB) có thuộc tính 'RAM' với giá trị '8GB' và thuộc tính 'HDD' với giá trị '256GB'.


Dĩ nhiên, tôi sẽ giải thích cho bạn. Câu lệnh SQL trên được chia thành nhiều phần:

1. **WITH Clause (Common Table Expressions - CTEs)**: Các CTE `PhoneVariants`, `RamVariants` và `HddVariants` được tạo ra để lọc các biến thể SKU phù hợp. 
    - `PhoneVariants` lọc ra các biến thể SKU thuộc nhóm 'Điện thoại' hoặc danh mục con của nhóm 'Điện thoại' và có giá dưới 25 triệu đồng.
    - `RamVariants` lọc ra các biến thể SKU có thuộc tính 'RAM' với giá trị là '4GB' hoặc '8GB'.
    - `HddVariants` lọc ra các biến thể SKU có thuộc tính 'HDD' với giá trị là '256GB'.

2. **SELECT Statement**: Câu lệnh `SELECT` trả về tên sản phẩm, tên biến thể SKU, và giá từ các bảng `Product`, `SKU`, và `SkuVariant`. 

3. **WHERE Clause**: Điều kiện `WHERE` lọc ra các biến thể SKU nằm trong tập hợp các `VariantID` thu được từ ba CTEs trên. Toán tử `IN` được sử dụng để kiểm tra xem `VariantID` của mỗi biến thể SKU có nằm trong tập hợp các `VariantID` thu được từ CTEs hay không.

4. **ORDER BY Clause**: Câu lệnh `ORDER BY` sắp xếp kết quả theo giá tăng dần (`ASC`).

Kết quả cuối cùng của câu lệnh này là danh sách tên và giá của tất cả sản phẩm Điện thoại có RAM 4GB hoặc 8GB, bộ nhớ 256GB, giá dưới 25 triệu đồng, bao gồm cả sản phẩm thuộc danh mục con của nhóm Điện thoại, và được sắp xếp theo giá tăng dần. Hãy chắc chắn rằng bạn đã nhập đúng tên danh mục, dung lượng RAM, dung lượng bộ nhớ, và giá trong truy vấn. Truy vấn này giả định rằng `AttributeName` và `AttributeValue` trong bảng `VariantAttribute` chứa thông tin về RAM và bộ nhớ, và `Price` trong bảng `SkuVariant` chứa giá của sản phẩm. Nếu không, bạn cần điều chỉnh truy vấn phù hợp với cấu trúc dữ liệu của bạn. Truy vấn này cũng giả định rằng giá được lưu trữ bằng đơn vị đồng. Nếu bạn sử dụng đơn vị tiền tệ khác, bạn cần điều chỉnh số liệu tương ứng. Tr