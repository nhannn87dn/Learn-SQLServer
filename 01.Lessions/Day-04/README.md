# Day 4
💥 🔹
## 💛 Session 05- Creating and Managing Databases

### 💥 Database (Cơ sở dữ liệu) là gì? 

- Một Database là tập hợp của rất nhiều dữ liệu phản ánh thế giới thực hoặc một phần của thế giới thực.
- Có cấu trúc, được lưu trữ tuân theo quy tắc dựa trên lý thuyết toán học.
- Các dữ liệu trong Database có liên quan với nhau về một lĩnh vực cụ thể, được tổ chức đặc biệt cho việc lưu trữ, tìm kiếm và trích xuất dữ liệu.
- Được các Hệ cơ sở dữ liệu khai thác xử lý, tìm kiếm, tra cứu, sửa đổi, bổ sung hay loại bỏ dữ liệu trong Database.

Ở mức logic, một DATABASE gồm nhiều bảng (TABLE), mỗi bảng được xác định bằng một tên, bảng chứa dữ liệu có cấu trúc và các ràng buộc (CONSTRAINT) định nghĩa trên các bảng. Ngoài ra, Database còn có khung nhìn (VIEW), các thủ tục/ hàm….

Ở mức vật lý, DATABASE của SQL Server được lưu trữ dưới 3 loại tập tin: 

- Tập tin dữ liệu (Data-file): gồm 1 tập tin lưu trữ dữ liệu chính (`*.mdf`) chứa các dữ liệu khởi đầu và các tập tin dữ liệu thứ cấp (`*.ndf`) chứa dữ liệu phát sinh hoặc không lưu hết trong tập tin lưu trữ chính.
- Tập tin nhật ký thao tác (`*.ldf`) chứa thông tin giao tác, thường dùng để khôi phục Database nếu xảy ra sự cố. 

---

### 💥Tại sao phải tạo Database?

Như việc truy xuất, đóng mở tập tin thông thường, bạn cần tạo file lưu trữ trước khi truy xuất. Tương tự vậy, bạn cần tạo một DATABASE để lưu trữ dữ liệu trong SQL Server để tiện cho việc truy vấn sau này.

SQL Server sẽ giúp bạn quản lý, truy xuất những dữ liệu này một cách có cấu trúc và dễ dàng hơn.

---

### 💥 Cách tạo Database?

#### 🔹 Tạo bằng giao diện đồ họa GUI


#### 🔹 Tạo bằng dòng lệnh 

```sql
CREATE DATABASE  <database_name>
```

Trong đó database_name là tên mà bạn đặt cho Database bạn muốn tạo

---

### 💥 Xóa một Database?

#### 🔹 Xóa bằng giao diện đồ họa GUI


#### 🔹 Xóa bằng dòng lệnh 

```sql
DROP DATABASE <database_name>
```
Trong đó database_name là tên Database bạn muốn xóa

---

### 💥 Comment trong SQL Query

Để tạo COMMENT trong SQL, chúng ta sử dụng cú pháp

```sql
--Nội dung Comment
```
---

### 💥 Backup và Restore Một Database


//////////////////////////////////////////////////////////////////////////////////////

## 💛 Session 06- Creating Tables


### 💥 Tại sao phải tạo Table?


Trong bài trước, chúng ta đã biết DATABASE ( Cơ sở dữ liệu) dùng để lưu trữ thông tin, truy xuất dữ liệu khi cần thiết. Vậy làm sao để lưu trữ dữ liệu trong Database? Làm sao để truy xuất dữ liệu đã lưu?

>Bài toán thực tế đặt ra: 
>
>Khi muốn quản lý một trường học, bạn sẽ cần quản lý những gì? Danh sách giáo viên, danh sách học sinh, điểm thi, quá trình công tác, phòng ban…. Và khi truy vấn thì cần truy vấn như thể nào với các thông tin đó?

Vậy khi tất cả dữ liệu cùng nằm trong một Database thì cần có một cách tổ chức thể hiện các thông tin theo một hệ thống lưu trữ, đó chính là TABLE – Bảng.

Một Database bao gồm nhiều Table, giữa các Table có mối liên hệ với nhau thể hiện qua KHÓA CHÍNH & KHÓA NGOẠI. 

---

### 💥 Vậy Table (Bảng) là gì?

Là đối tượng được Database sử dụng để tổ chức và lưu trữ dữ liệu.

Mỗi Table trong Database có thể liên kết với một hoặc nhiều Table khác, ở một hoặc nhiều thuộc tính

---

### 💥 Cách tạo Table

#### 🔹 Tạo bằng giao diện đồ họa GUI


#### 🔹 Tạo bằng dòng lệnh 

Tạo Table với các column, CONSTRAINT được định nghĩa ngay khi tạo mới Table

```sql
--Create table Categories
CREATE TABLE [dbo].[Categories] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [Name] NVARCHAR(50) UNIQUE NOT NULL,
  [Description] NVARCHAR(500) NULL,
);
GO
--Create table  Products
CREATE TABLE [dbo].[Products] (
  [Id] INT IDENTITY(1,1) NOT NULL, --Tự tăng
  [Name] NVARCHAR(100) NOT NULL,
  [Price] MONEY NOT NULL,
  [Discount] DECIMAL(18,2) NOT NULL,
  [Stock] DECIMAL(18,2) NOT NULL,
  [Description] NVARCHAR(MAX) NULL,
  [CategoryId] INT NOT NULL,
  [SupplierId] INT NOT NULL
);
GO

```

Lưu ý với các table có quan hệ, chứ khóa ngoại thì bạn cần tạo table tham chiếu trước. Trong ví dụ trên bạn phải tạo table Categories, Suppliers trước khi tạo Products

---

### 💥 Cách Xóa Table

#### 🔹 Xóa bằng giao diện đồ họa GUI


#### 🔹 Xóa bằng dòng lệnh 

```sql
-- Xóa table Categories, Nếu table không tồn tại thì gây lỗi
DROP TABLE [dbo].[Categories];
-- Xóa table Categories với mệnh đề IF EXISTS để check tồn tại thì mới xóa, ==> tránh lỗi
DROP TABLE IF EXISTS [dbo].[Categories];
```
---

### 💥 Alert Table

Các thao tác này bạn có thể thực hiện với giao diện đồ họa GUI

#### 🔹 Thêm một Column Table

```sql
--Thêm vào table Customers một cột Email
ALTER TABLE Customers
ADD Email varchar(255);
```

#### 🔹 Xóa một Column Table

```sql
--Xóa cột Email từ table Customers
ALTER TABLE Customers
DROP COLUMN Email;
```

#### 🔹 Thay đổi tên của Column Table

```sql
ALTER TABLE table_name
RENAME COLUMN old_name to new_name;
```

#### 🔹 Thay đổi Data Type của Column Table

```sql
ALTER TABLE Customers
ALTER COLUMN Email nvarchar(255);
```

---

### 💥 SQL CONSTRAINT

CONSTRAINT (ràng buộc) là một khối mã hoặc một quy tắc được áp dụng cho một hoặc nhiều cột trong một bảng để định nghĩa và bảo vệ tính toàn vẹn dữ liệu. Ràng buộc định nghĩa các quy tắc và giới hạn cho dữ liệu được lưu trữ trong cơ sở dữ liệu.

Các CONSTRAINT phổ biến:

#### 🔹 PRIMARY KEY

Primary key (Khóa chính) là một thuộc tính hoặc tập hợp các thuộc tính trong một bảng dùng để định danh duy nhất mỗi hàng trong bảng đó. Khóa chính đảm bảo tính duy nhất và xác định của các bản ghi trong bảng

Là sự kết hợp giữa 2 CONSTRAINT `UNIQUE` và `NOT NULL`

```sql
-- Định nghĩa PRIMARY KEY ngay khi tạo table
CREATE TABLE [dbo].[Products] (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL
)
-- Định nghĩa PRIMARY KEY cho table đã tồn tại
ALTER TABLE [dbo].[Products]
ADD PRIMARY KEY (Id);
-- Hoặc, bạn có thể đặt tên cho contraint là PK_Products
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [PK_Products] PRIMARY KEY ([Id]);
```


#### 🔹 FOREIGN KEY 

- Foreign key (khóa ngoại) là một cột hoặc tập hợp các cột trong một bảng tham chiếu đến khóa chính của một bảng khác. Khóa ngoại tạo ra một mối quan hệ giữa hai bảng dựa trên giá trị của cột hoặc các cột được liên kết.

- Bảng chứa khóa ngoại được gọi là bảng tham chiếu hoặc bảng con. Và bảng được tham chiếu bởi khóa ngoại được gọi là bảng được tham chiếu hoặc bảng cha.

- Một bảng có thể có nhiều khóa ngoại tùy thuộc vào mối quan hệ của nó với các bảng khác.

- Bạn xác định khóa ngoại bằng cách sử dụng ràng buộc khóa ngoại. Ràng buộc khóa ngoại giúp duy trì tính toàn vẹn tham chiếu của dữ liệu giữa bảng con và bảng cha.

- Ràng buộc khóa ngoại chỉ ra rằng các giá trị trong một cột hoặc một nhóm cột trong bảng con bằng với các giá trị trong một cột hoặc một nhóm cột của bảng cha.

```sql
-- Tạo khóa ngoại CategoryID, SupplierId ngay khi tạo mới Table
CREATE TABLE [dbo].[Products] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [Name] NVARCHAR(100) UNIQUE NOT NULL, --UNIQUE
  [Price] MONEY NOT NULL,
  [Discount] DECIMAL(18,2) NOT NULL,
  [Stock] DECIMAL(18,2) NOT NULL,
  [Description] NVARCHAR(MAX) NULL,
  [CategoryId] INT NOT NULL,
  [SupplierId] INT NOT NULL,
  CONSTRAINT fk_Products_CategoryID FOREIGN KEY (CategoryID) 
        REFERENCES Categories(Id), --Khóa ngoại CategoryID
  CONSTRAINT fk_Products_SupplierId FOREIGN KEY (SupplierId) 
        REFERENCES Suppliers(Id) --Khóa ngoại SupplierId
);
```

Hoặc bạn có thể tạo khóa ngoại cho một table đã tồn tại

```sql
--Tạo khóa ngoại  FOREIGN KEY (CategoryId) tham chiếu đến khóa chính Categories(Id)
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]);
GO
--Tạo khóa ngoại FOREIGN KEY (SupplierId) tham chiếu đến khóa chính Suppliers(Id)
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY ([SupplierId]) REFERENCES [dbo].[Suppliers] ([Id]);
```

#### 🔹 UNIQUE

SQL cung cấp cho bạn ràng buộc UNIQUE để duy trì tính duy nhất của dữ liệu một cách chính xác.

Khi có ràng buộc UNIQUE, mỗi khi bạn chèn một hàng mới, nó sẽ kiểm tra xem giá trị đã có trong bảng chưa. Nó từ chối thay đổi và đưa ra lỗi nếu giá trị đã tồn tại. Quá trình tương tự được thực hiện để cập nhật dữ liệu hiện có.

```sql
--Tạo UNIQUE ngay khi tạo mới table
CREATE TABLE [dbo].[Categories] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [Name] NVARCHAR(50) UNIQUE NOT NULL, -- UNIQUE
  [Description] NVARCHAR(500) NULL,
);
GO
```

Bạn cũng có thể tạo UNIQUE cho một table đã tồn tại

```sql
ALTER TABLE [dbo].[Categories]
ADD CONSTRAINT [UQ_Categories_Name] UNIQUE ([Name]); --UQ_Categories_Name là tên bạn đặt cho CONTRAINT
GO
```

#### 🔹 NOT NULL

Trong lý thuyết cơ sở dữ liệu, NULL đại diện cho thông tin chưa biết hoặc thiếu thông tin. NULL không giống như một chuỗi trống hoặc số 0.

Giả sử bạn cần chèn địa chỉ email của một liên hệ vào bảng. Bạn có thể yêu cầu địa chỉ email của người đó. Tuy nhiên, nếu bạn không biết người liên hệ đó có địa chỉ email hay không, bạn có thể chèn NULL vào cột địa chỉ email. Trong trường hợp này, NULL chỉ ra rằng địa chỉ email không được biết tại thời điểm ghi.

NULL rất đặc biệt. Nó không bằng bất cứ thứ gì, kể cả chính nó. Biểu thức NULL = NULL trả về NULL vì điều đó có nghĩa là hai giá trị chưa biết không được bằng nhau.

Định nghĩa NOT NULL ngay khi tạo mới table

```sql
CREATE TABLE [dbo].[Categories] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [Name] NVARCHAR(50) UNIQUE NOT NULL, -- UNIQUE
  [Description] NVARCHAR(500) NULL,
);
GO
```
Hoặc cho table đã tồn tại

```sql
ALTER TABLE [dbo].[Categories]
ALTER COLUMN [Name] NVARCHAR(50) UNIQUE NOT NULL;
```


#### 🔹 DEFAULT

DEFAULT là một thuộc tính được sử dụng trong cơ sở dữ liệu để định nghĩa giá trị mặc định cho một cột khi không có giá trị nào được cung cấp trong quá trình chèn dữ liệu mới hoặc cập nhật dữ liệu trong cột đó.

Định nghĩa `DEFAULT CONTRAINT` ngay khi tạo mới Table

Price, Discount, Stock mặc định = 0

```sql
CREATE TABLE [dbo].[Products] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [Name] NVARCHAR(100) UNIQUE NOT NULL,
  [Price] MONEY NOT NULL DEFAULT 0,
  [Discount] DECIMAL(18,2) DEFAULT 0 NOT NULL,
  [Stock] DECIMAL(18,2) DEFAULT 0 NOT NULL,
  [Description] NVARCHAR(MAX) NULL,
  [CategoryId] INT NOT NULL,
  [SupplierId] INT NOT NULL,
  CONSTRAINT fk_Products_CategoryID FOREIGN KEY (CategoryID) 
        REFERENCES Categories(Id), --Khóa ngoại CategoryID
  CONSTRAINT fk_Products_SupplierId FOREIGN KEY (SupplierId) 
        REFERENCES Suppliers(Id) --Khóa ngoại SupplierId

);
GO

```

#### 🔹 CHECK

Check Contraint là một loại ràng buộc cho phép bạn chỉ định xem các giá trị trong một cột có phải đáp ứng một yêu cầu cụ thể hay không.

Nếu các giá trị vượt qua quá trình kiểm tra, PostgreSQL sẽ chèn hoặc cập nhật các giá trị này vào cột. Nếu không, PostgreSQL sẽ từ chối các thay đổi và đưa ra lỗi vi phạm ràng buộc.


Tạo table  Products FULL Các CONTRAINT, ngay khi tạo mới

```sql
CREATE TABLE [dbo].[Products] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [Name] NVARCHAR(100) UNIQUE NOT NULL,
  [Price] MONEY NOT NULL DEFAULT 0 CHECK (Price >=0),
  [Discount] DECIMAL(18,2) DEFAULT 0 NOT NULL CHECK (Discount >=0 AND Discount <= 80),
  [Stock] DECIMAL(18,2) DEFAULT 0 NOT NULL CHECK (Stock >=0),
  [Description] NVARCHAR(MAX) NULL,
  [CategoryId] INT NOT NULL,
  [SupplierId] INT NOT NULL,
  CONSTRAINT fk_Products_CategoryID FOREIGN KEY (CategoryID) 
        REFERENCES Categories(Id), --Khóa ngoại CategoryID
  CONSTRAINT fk_Products_SupplierId FOREIGN KEY (SupplierId) 
        REFERENCES Suppliers(Id) --Khóa ngoại SupplierId

);
GO

```

Bạn cũng có thể tạo CONTRAINT CHECK cho table đã tồn tại


```sql
-- Create CHECK (Price > 0)
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [CK_Products_Price] CHECK ([Price] > 0);
GO

--Create CHECK (Discount >= 0 AND Discount <= 90)
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [CK_Products_Discount] CHECK ([Discount] >= 0 AND [Discount] <= 90);
GO
--Create CHECK (Stock >= 0)
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [CK_Products_Stock] CHECK ([Stock] >= 0);
GO
```


## 💛Homeworks Guide - Session 2-3-4





