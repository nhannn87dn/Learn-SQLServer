# E-Commerce Data Model


```sql
-- Bảng categories
CREATE TABLE categories (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- Bảng products
CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  brand_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Bảng sku
CREATE TABLE sku (
  id INT PRIMARY KEY,
  sku_code VARCHAR(20) UNIQUE NOT NULL,
  product_id INT NOT NULL,
  color VARCHAR(20),
  capacity INT,
  price DECIMAL(10,2),
  slug VARCHAR(50) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng image
CREATE TABLE image (
  id INT PRIMARY KEY,
  sku_id INT NOT NULL,
  image_url VARCHAR(100) NOT NULL,
  FOREIGN KEY (sku_id) REFERENCES sku(id)
);

-- Bảng stock
CREATE TABLE stock (
  id INT PRIMARY KEY,
  sku_id INT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (sku_id) REFERENCES sku(id)
);

-- Bảng stores
CREATE TABLE stores (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- Bảng brands
CREATE TABLE brands (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  logo VARCHAR(100) NOT NULL
);

-- Bảng orders
-- Tạo bảng orders
CREATE TABLE orders (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  shipping_address VARCHAR(100) NOT NULL,
  billing_address VARCHAR(100) NOT NULL,
  shipping_method INT NOT NULL,
  payment_method INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (store_id) REFERENCES stores(id),
  FOREIGN KEY (shipping_method) REFERENCES delivery_methods(id),
  FOREIGN KEY (payment_method) REFERENCES payment_methods(id)
);

-- Bảng order_item
CREATE TABLE order_item (
  id INT PRIMARY KEY,
  order_id INT NOT NULL,
  sku_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (sku_id) REFERENCES sku(id)
);

-- Bảng customers
CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  password VARCHAR(50) NOT NULL,
  address VARCHAR(100) NOT NULL,
  loyalty_points INT NOT NULL
);

-- Bảng staffs
CREATE TABLE staffs (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  password VARCHAR(50) NOT NULL,
  store_id INT NOT NULL,
  role_id INT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(id),
  FOREIGN KEY (role_id) REFERENCES roles(id)
);


-- Tạo bảng delivery_log
CREATE TABLE delivery_log (
  id INT PRIMARY KEY,
  order_id INT NOT NULL,
  staff_id INT NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  status VARCHAR(20) NOT NULL,
  note VARCHAR(100),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (staff_id) REFERENCES staffs(id)
);

-- Tạo bảng payment_methods
CREATE TABLE payment_methods (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255)
);

-- Tạo bảng payment_log
CREATE TABLE payment_log (
  id INT PRIMARY KEY,
  order_id INT NOT NULL,
  method VARCHAR(20) NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  status VARCHAR(20) NOT NULL,
  transaction_id VARCHAR(50),
  FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- Tạo bảng modules
CREATE TABLE modules (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NOT NULL
);

-- Tạo bảng permisions
CREATE TABLE permisions (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NOT NULL
);

-- Tạo bảng module_permision
CREATE TABLE module_permision (
  module_id INT NOT NULL,
  permision_id INT NOT NULL,
  PRIMARY KEY (module_id, permision_id),
  FOREIGN KEY (module_id) REFERENCES modules(id),
  FOREIGN KEY (permision_id) REFERENCES permisions(id)
);

-- Tạo bảng roles
CREATE TABLE roles (
  id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NOT NULL
);

-- Tạo bảng role_module_permision
CREATE TABLE role_module_permision (
  role_id INT NOT NULL,
  module_id INT NOT NULL,
  permision_id INT NOT NULL,
  PRIMARY KEY (role_id, module_id, permision_id),
  FOREIGN KEY (role_id) REFERENCES roles(id),
  FOREIGN KEY (module_id, permision_id) REFERENCES module_permision(module_id, permision_id)
);




-- Thêm dữ liệu vào bảng categories
INSERT INTO categories (id, name, parent_id)
VALUES
(1, 'Điện thoại', NULL),
(2, 'Máy tính', NULL),
(3, 'Phụ kiện', NULL),
(4, 'iPhone', 1),
(5, 'Samsung', 1);

-- Thêm dữ liệu vào bảng products
INSERT INTO products (id, name, description, category_id, brand_id)
VALUES
(1, 'iPhone 12 Pro', 'Một chiếc điện thoại thông minh cao cấp của Apple', 4, 1),
(2, 'Samsung Galaxy S21', 'Một chiếc điện thoại thông minh cao cấp của Samsung', 5, 2),
(3, 'MacBook Pro', 'Một chiếc máy tính xách tay cao cấp của Apple', 2, 1),
(4, 'Dell XPS 13', 'Một chiếc máy tính xách tay cao cấp của Dell', 2, 3),
(5, 'AirPods Pro', 'Một chiếc tai nghe không dây cao cấp của Apple', 3, 1);

-- Thêm dữ liệu vào bảng sku
INSERT INTO sku (id, sku_code, product_id, color, capacity, price, slug)
VALUES
(1, 'IP12P-G-120', 1, 'Gold', 120, 999.99, 'iphone-12-pro-color-gold-capacity-120gb'),
(2, 'IP12P-G-512', 1, 'Gold', 512, 1299.99, 'iphone-12-pro-color-gold-capacity-512gb'),
(3, 'IP12P-S-120', 1, 'Silver', 120, 999.99, 'iphone-12-pro-color-silver-capacity-120gb'),
(4, 'IP12P-S-512', 1, 'Silver', 512, 1299.99, 'iphone-12-pro-color-silver-capacity-512gb'),
(5, 'SGS21-B-128', 2, 'Black', 128, 899.99, 'samsung-galaxy-s21-color-black-capacity-128gb');

-- Thêm dữ liệu vào bảng image
INSERT INTO image (id, sku_id, image_url)
VALUES
(1, 1, 'https://example.com/images/ip12p-g-120.jpg'),
(2, 2, 'https://example.com/images/ip12p-g-512.jpg'),
(3, 3, 'https://example.com/images/ip12p-s-120.jpg'),
(4, 4, 'https://example.com/images/ip12p-s-512.jpg'),
(5, 5, 'https://example.com/images/sgs21-b-128.jpg');

-- Thêm dữ liệu vào bảng stock
INSERT INTO stock (id, sku_id, quantity)
VALUES
(1, 1, 50),
(2, 2, 20),
(3, 3, 40),
(4, 4, 30),
(5, 5, 60);

-- Thêm dữ liệu vào bảng stores
INSERT INTO stores (id, name, address, phone, email)
VALUES
(1, 'Cửa hàng A', '123 Đường A, Quận 1, TP.HCM', '0123456789', 'cuahangA@example.com'),
(2, 'Cửa hàng B', '456 Đường B, Quận 2, TP.HCM', '0987654321', 'cuahangB@example.com'),
(3, 'Cửa hàng C', '789 Đường C, Quận 3, TP.HCM', '0123987654', 'cuahangC@example.com'),
(4, 'Cửa hàng D', '321 Đường D, Quận 4, TP.HCM', '0987123456', 'cuahangD@example.com'),
(5, 'Cửa hàng E', '654 Đường E, Quận 5, TP.HCM', '0123456987', 'cuahangE@example.com');

-- Thêm dữ liệu vào bảng brands
INSERT INTO brands (id, name, logo)
VALUES
(1, 'Apple', 'https://example.com/images/apple-logo.png'),
(2, 'Samsung', 'https://example.com/images/samsung-logo.png'),
(3, 'Dell', 'https://example.com/images/dell-logo.png'),
(4, 'HP', 'https://example.com/images/hp-logo.png'),
(5, 'Sony', 'https://example.com/images/sony-logo.png');

-- Thêm dữ liệu vào bảng orders
INSERT INTO orders (id, customer_id, store_id, status, shipping_address, billing_address, shipping_method, payment_method, total)
VALUES
(1, 101, 1, 'Đang xử lý', '12 Nguyễn Văn Cừ, Q.5, TP HCM', '12 Nguyễn Văn Cừ, Q.5, TP HCM', 1, 2, 550000),
(2, 102, 2, 'Đang giao', '25 Lê Lợi, Q.1, TP HCM', '25 Lê Lợi, Q.1, TP HCM', 2, 1, 300000),
(3, 103, 3, 'Đã giao', '34 Trần Hưng Đạo, Q.3, TP HCM', '34 Trần Hưng Đạo, Q.3, TP HCM', 1, 3, 600000);

-- Thêm dữ liệu vào bảng order_item
INSERT INTO order_item (id, order_id, sku_id, quantity, price)
VALUES
(1, 1, 1, 2, 250000),
(2, 1, 2, 1, 50000),
(3, 2, 3, 1, 200000),
(4, 2, 4, 1, 100000),
(5, 3, 5, 2, 400000),
(6, 3, 6, 1, 200000);


-- Thêm dữ liệu vào bảng customers
INSERT INTO customers (id, name, email, phone, password, address, loyalty_points)
VALUES
(1, 'Nguyễn Văn A', 'nguyenvana@example.com', '0123456789', '123456', '123 Đường A, Quận 1, TP.HCM', 100),
(2, 'Trần Thị B', 'tranb@example.com', '0987654321', '654321', '456 Đường B, Quận 2, TP.HCM', 200),
(3, 'Lê Văn C', 'levanc@example.com', '0123987654', '987654', '789 Đường C, Quận 3, TP.HCM', 300),
(4, 'Phạm Thị D', 'phamd@example.com', '0987123456', '456789', '321 Đường D, Quận 4, TP.HCM', 400),
(5, 'Hoàng Văn E', 'hoange@example.com', '0123456987', '789456', '654 Đường E, Quận 5, TP.HCM', 500);


-- Thêm dữ liệu vào bảng payment_methods
INSERT INTO payment_methods (id, name, description)
VALUES
(1, 'Thanh toán khi nhận hàng', 'Khách hàng thanh toán tiền mặt cho nhân viên giao hàng khi nhận được hàng'),
(2, 'Thanh toán trực tuyến', 'Khách hàng thanh toán qua thẻ tín dụng, thẻ ghi nợ, ví điện tử hoặc chuyển khoản ngân hàng'),
(3, 'Thanh toán trả góp', 'Khách hàng thanh toán một phần tiền trước, còn lại trả dần theo kỳ hạn và lãi suất đã thỏa thuận');

-- Thêm dữ liệu vào bảng staffs
INSERT INTO staffs (id, name, email, phone, password, store_id, role_id)
VALUES
(1, 'Nguyễn Văn A', 'nguyenvana@example.com', '0123456789', '123456', 1, 1),
(2, 'Trần Thị B', 'tranb@example.com', '0987654321', '654321', 2, 2),
(3, 'Lê Văn C', 'levanc@example.com', '0123987654', '987654', 3, 3),
(4, 'Phạm Thị D', 'phamd@example.com', '0987123456', '456789', 4, 2),
(5, 'Hoàng Văn E', 'hoange@example.com', '0123456987', '789456', 5, 3);

-- Thêm dữ liệu vào bảng modules
INSERT INTO modules (id, name, description)
VALUES
(1, 'Sản phẩm', 'Module quản lý các sản phẩm của hệ thống'),
(2, 'Bài viết', 'Module quản lý các bài viết của hệ thống'),
(3, 'Đơn hàng', 'Module quản lý các đơn hàng của hệ thống');

-- Thêm dữ liệu vào bảng permisions
INSERT INTO permisions (id, name, description)
VALUES
(1, 'Thêm mới', 'Quyền thêm mới dữ liệu'),
(2, 'Sửa', 'Quyền sửa dữ liệu'),
(3, 'Xóa', 'Quyền xóa dữ liệu'),
(4, 'Xem', 'Quyền xem dữ liệu');

-- Thêm dữ liệu vào bảng module_permision
INSERT INTO module_permision (module_id, permision_id)
VALUES
(1, 1), -- Module sản phẩm có quyền thêm mới
(1, 2), -- Module sản phẩm có quyền sửa
(1, 3), -- Module sản phẩm có quyền xóa
(1, 4), -- Module sản phẩm có quyền xem
(2, 1), -- Module bài viết có quyền thêm mới
(2, 2), -- Module bài viết có quyền sửa
(2, 3), -- Module bài viết có quyền xóa
(2, 4), -- Module bài viết có quyền xem
(3, 2), -- Module đơn hàng có quyền sửa
(3, 4); -- Module đơn hàng có quyền xem

-- Thêm dữ liệu vào bảng roles
INSERT INTO roles (id, name, description)
VALUES
(1, 'Quản lý', 'Vai trò quản lý hệ thống'),
(2, 'Nhân viên bán hàng', 'Vai trò nhân viên bán hàng'),
(3, 'Nhân viên giao hàng', 'Vai trò nhân viên giao hàng');

-- Thêm dữ liệu vào bảng role_module_permision
INSERT INTO role_module_permision (role_id, module_id, permision_id)
VALUES
(1, 1, 1), -- Vai trò quản lý có quyền thêm mới trên module sản phẩm
(1, 1, 2), -- Vai trò quản lý có quyền sửa trên module sản phẩm
(1, 1, 3), -- Vai trò quản lý có quyền xóa trên module sản phẩm
(1, 1, 4), -- Vai trò quản lý có quyền xem trên module sản phẩm
(1, 2, 1), -- Vai trò quản lý có quyền thêm mới trên module bài viết
(1, 2, 2), -- Vai trò quản lý có quyền sửa trên module bài viết
(1, 2, 3), -- Vai trò quản lý có quyền xóa trên module bài viết
(1, 2, 4), -- Vai trò quản lý có quyền xem trên module bài viết
(1, 3, 2), -- Vai trò quản lý có quyền sửa trên module đơn hàng
(1, 3, 4), -- Vai trò quản lý có quyền xem trên module đơn hàng
(2, 1, 4), -- Vai trò nhân viên bán hàng có quyền xem trên module sản phẩm
(2, 2, 4), -- Vai trò nhân viên bán hàng có quyền xem trên module bài viết
(2, 3, 2), -- Vai trò nhân viên bán hàng có quyền sửa trên module đơn hàng
(2, 3, 4), -- Vai trò nhân viên bán hàng có quyền xem trên module đơn hàng
(3, 1, 4), -- Vai trò nhân viên giao hàng có quyền xem trên module sản phẩm
(3, 3, 4); -- Vai trò nhân viên giao hàng có quyền xem trên module đơn hàng

```
