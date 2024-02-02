# Day 03


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

- Backup và restore từ file .bak
- Gen ra thành SQL Scrtip để thực thi: Bao gồm cấu trúc Schema và Data

### 💥 Database Snapshot

Database snapshot là một bản sao tĩnh (read-only) của một cơ sở dữ liệu tại một thời điểm cụ thể. Nó lưu trữ dữ liệu nhưng không cho phép thay đổi dữ liệu trong snapshot. Database snapshot thường được sử dụng để tạo ra các bản sao lưu (backup) của cơ sở dữ liệu hoặc để tạo ra một điểm khôi phục (restore point) để phục hồi cơ sở dữ liệu sau khi có sự cố xảy ra.

Khi tạo một snapshot, hệ thống sao chép các dữ liệu hiện có trong cơ sở dữ liệu và lưu trữ chúng trong một không gian lưu trữ riêng. Từ đó, các truy vấn đọc có thể được thực hiện trên snapshot mà không ảnh hưởng đến dữ liệu trong cơ sở dữ liệu gốc. Mỗi khi có một thay đổi dữ liệu trong cơ sở dữ liệu gốc, snapshot không bị ảnh hưởng, vẫn giữ nguyên dữ liệu lúc tạo snapshot.

Snapshot có thể được sử dụng để phục hồi cơ sở dữ liệu trong trường hợp có sự cố xảy ra, ví dụ như mất dữ liệu, lỗi trong quá trình cập nhật dữ liệu, hoặc muốn phục hồi dữ liệu về một thời điểm cụ thể. Bằng cách khôi phục cơ sở dữ liệu từ snapshot, ta có thể đảm bảo rằng dữ liệu được phục hồi trở về trạng thái tương ứng với thời điểm tạo snapshot.

Tuy nhiên, cần lưu ý rằng snapshot không phải là một phương án sao lưu hoàn chỉnh cho cơ sở dữ liệu. Nó chỉ lưu trữ dữ liệu hiện tại tại một thời điểm cụ thể và không bao gồm lịch sử thay đổi dữ liệu hoặc log giao dịch. Nếu muốn có một bản sao lưu đầy đủ và có khả năng khôi phục toàn bộ dữ liệu, cần sử dụng các phương pháp sao lưu khác như sao lưu toàn bộ cơ sở dữ liệu hoặc sao lưu theo log giao dịch.

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
--Create table categories
CREATE TABLE [dbo].[categories] (
  [category_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [category_name] NVARCHAR(50) UNIQUE NOT NULL,
  [description] NVARCHAR(500) NULL,
);
GO
--Create table  products
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) NOT NULL, --Tự tăng
  [name] NVARCHAR(100) NOT NULL,
  [price] DECIMAL(18,2) NOT NULL,
  [discount] DECIMAL(4,2) NOT NULL,
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL,
  [brand_id] INT NOT NULL
);
GO

```

Lưu ý với các table có quan hệ, chứ khóa ngoại thì bạn cần tạo table tham chiếu trước. Trong ví dụ trên bạn phải tạo table categories, brands trước khi tạo products


#### 🔹Giải thích lệnh GO

```sql
--Tạo databse
CREATE DATABASE Batch37
GO
--Sử dụng database
USE Batch37
GO
-- Tạo table vào databse Batch37
CREATE TABLE [dbo].[categories] (
  [category_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [category_name] NVARCHAR(50) UNIQUE NOT NULL,
  [description] NVARCHAR(500) NULL,
);
GO
```

#### 🔹 Tạo table và chỉ định lưu vào một filegroup cụ thể

Cú pháp:

```sql
CREATE TABLE TenBang
(
    Cot1 datatype1,
    Cot2 datatype2,
    ...
)
ON TenFileGroup
```

Ví dụ

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    EmployeeName NVARCHAR(100)
)
ON HR --file group with name "HR"
```

#### 🔹 Quy tắc đặt tên các cột trong Table

Trong SQL Server, có một số quy tắc và khuyến nghị khi đặt tên cột để đảm bảo tính rõ ràng, dễ đọc và dễ hiểu trong quá trình phát triển và bảo trì cơ sở dữ liệu. Dưới đây là một số quy tắc thường được sử dụng:

1. Sử dụng tên có ý nghĩa: Đặt tên cột dựa trên ý nghĩa và nội dung của dữ liệu mà cột đại diện. Tên cột nên phản ánh mục đích và thông tin liên quan của nó.

2. Sử dụng đúng kiểu từ: Đặt tên cột bằng các từ ngữ rõ ràng, dễ hiểu và không gây nhầm lẫn. Tránh việc sử dụng các từ viết tắt, chữ số hoặc ký tự đặc biệt trong tên cột.

3. Sử dụng kiểu đặt tên theo quy ước: Có thể sử dụng các quy ước về đặt tên như Pascal Case (ví dụ: EmployeeName), Camel Case (ví dụ: employeeName) hoặc Snake Case (ví dụ: employee_name). Quy ước này giúp tạo ra tên cột dễ đọc và dễ nhìn.

4. Tránh sử dụng các từ khóa: Đảm bảo rằng tên cột không trùng với các từ khóa được sử dụng trong câu lệnh SQL hoặc trong hệ quản trị cơ sở dữ liệu.

5. Sử dụng tên cột ngắn gọn và đủ mô tả: Tránh đặt tên cột quá dài hoặc quá ngắn. Đặt tên cột sao cho nó cung cấp thông tin đủ để hiểu nó đại diện cho dữ liệu nào, nhưng đồng thời không quá dài để làm cho các truy vấn và mã SQL trở nên phức tạp.

6. Sử dụng phân cách hợp lý: Sử dụng ký tự phân cách (như dấu gạch dưới "_") hoặc phân cách từ (như dấu cách) để tách các từ trong tên cột. Điều này giúp làm rõ từng thành phần của tên cột và làm cho nó dễ đọc hơn.

7. Tuân thủ quy tắc đặt tên chung: Ngoài các quy tắc cụ thể cho SQL Server, hãy tuân thủ các quy tắc đặt tên chung trong lĩnh vực phát triển phần mềm, nhưng hãy đảm bảo tuân thủ quy tắc cụ thể cho SQL Server.

Lưu ý rằng quy tắc đặt tên có thể khác nhau tùy thuộc vào quy ước của dự án hoặc tổ chức. Quan trọng nhất là đảm bảo tính rõ ràng, dễ đọc và duy trì của tên cột trong quá trình phát triển và bảo trì cơ sở dữ liệu.

---

### 💥 Cách Xóa Table

#### 🔹 Xóa bằng giao diện đồ họa GUI


CLick phải lên tên table --> Delete.

#### 🔹 Xóa bằng dòng lệnh 

```sql
-- Xóa table categories, Nếu table không tồn tại thì gây lỗi
DROP TABLE [dbo].[categories];
-- Xóa table categories với mệnh đề IF EXISTS để check tồn tại thì mới xóa, ==> tránh lỗi
DROP TABLE IF EXISTS [dbo].[categories];
```
---


### 💥 Alert Table

Các thao tác này bạn có thể thực hiện với giao diện đồ họa GUI

#### 🔹 Thêm một Column Table

```sql
--Thêm vào table customers một cột email
ALTER TABLE customers
ADD email varchar(255);
```

#### 🔹 Xóa một Column Table

```sql
--Xóa cột email từ table customers
ALTER TABLE customers
DROP COLUMN email;
```

#### 🔹 Thay đổi tên của Column Table

```sql
EXEC sp_rename 'table_name.old_column_name', 'new_column_name', 'COLUMN';
```

Ref: https://learn.microsoft.com/vi-vn/sql/relational-databases/tables/rename-columns-database-engine?view=sql-server-ver16

#### 🔹 Thay đổi Data Type của Column Table

```sql
ALTER TABLE customers
ALTER COLUMN email nvarchar(255);
```


#### 🔹 Thay đổi tên của Table

```sql
EXEC sp_rename 'old_table_name', 'new_table_name'
```

---


### 💥 TRUNCATE

Xóa dữ liệu của một table và dữ lại cấu trúc

TRUNCATE TABLE [schema_name].[table_name]

Temporary Tables (Bảng tạm thời) là các bảng được tạo ra trong cơ sở dữ liệu để lưu trữ tạm thời dữ liệu trong quá trình thực thi của một phiên làm việc. Chúng tồn tại trong bộ nhớ hoặc trên đĩa trong một thời gian ngắn và được xóa tự động sau khi phiên làm việc kết thúc hoặc sau khi chúng không còn cần thiết.

Bạn có thể tìm thấy bảng tạm ở: `System Databases > tempdb > Temporary Tables`

#### 🔹 Tạo bảng tạm

```sql
CREATE TABLE #tmp_products  -- bắt đầu với kí tự #
(
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);
```

Sau khi tạo xong bạn có thể chèn dữ liệu vào

```sql
INSERT INTO #tmp_products
SELECT
    product_name,
    list_price
FROM 
    dbo.products
WHERE
    brand_id = 2;
```

Truy vấn từ bảng tạm


```sql
SELECT * FROM #tmp_products
```

- Lưu ý: các câu lệnh trên thực hiện liên tiếp nhau vì bảng tạm chỉ tồn tại trong phiên truy vấn. Dữ liệu sẽ mất khi kết thúc truy vấn.

- Tuy nhiên bạn có thể tạo một bảng tạm với cấp độ toàn cục (Global), bạn có thể truy vấn tại bất kỳ một phiên truy vấn nào.

```sql
CREATE TABLE ##heller_products -- Sử dụng 2 dấu ## ở trước tên
(
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);
```

---

### 💥 Modifying data

#### 🔹 INSERT

Câu lệnh INSERT cho phép bạn thêm một hoặc nhiều bản ghi mới vào bảng dữ liệu.

Cú pháp:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

Nếu bạn muốn chèn nhiều bản ghi cùng một lúc, bạn có thể sử dụng cú pháp sau:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...),
       (value1, value2, value3, ...),
       (value1, value2, value3, ...);
```

Ví dụ: Tạo table `promotion` cho demo

```sql
CREATE TABLE dbo.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount DECIMAL (4, 2) DEFAULT 0,
    start_date DATE NOT NULL, --Kiểu ngày yyyy-mm-dd
    expired_date DATE NOT NULL --Kiểu ngày yyyy-mm-dd
); 
```

Thêm 1 record vào `promotion`

```sql
INSERT INTO dbo.promotions (
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      '2018 Summer Promotion',
      0.15,
      '20180601',
      '20180901'
    );
-- Lưu ý: không cần đưa promotion_id vào vì nó sẽ tự tăng
```

Thêm nhiều record vào `promotion` trong một câu truy vấn

```sql
INSERT INTO dbo.promotions (
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      '2018 Summer Promotion',
      0.15,
      '20180601',
      '20180901'
    ),
     (
      '2018 Chrismats Promotion',
      2,
      '20181201',
      '20181230'
    );
```

Bạn không thể chèn giá trị vào cột được khai báo là `IDENTITY` bởi vì nó sẽ được tạo tự động. Tuy nhiên bạn vẫn muốn làm thì SQL Server có hỗ trợ:

```sql
--Bước 1: Để câu này trước câu lệnh INSERT
SET IDENTITY_INSERT dbo.promotions ON; 
--Bước 2: Các câu lệnh INSERT
INSERT INTO dbo.promotions (
    promotion_id, --có đưa thêm trường IDENTITY
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      5, --Điền trước một giá trị đúng kiểu dữ liệu đã khai báo
      '2018 Winter Promotion',
      0.2,
      '20180701',
      '20181001'
    );
--Bước 3: Tắt tính năng tự động sinh giá trị IDENTITY 
SET IDENTITY_INSERT dbo.promotions OFF; 
```

Nếu bạn không thiết lập `IDENTITY_INSERT` bạn sẽ gặp lỗi:

```bash
Cannot insert explicit value for identity column in table 'promotions' when IDENTITY_INSERT is set to OFF.
```


**INSERT Với giá trị Unicode**

Để hỗ trợ lưu trữ và hiển thị các giá trị là chuỗi Unicode bạn cần:8

```sql
INSERT INTO table_name (column1, column2) VALUES (N'Xin Chào', N'SQL Server khá dễ học');
```

Trong đó, tiền tố "N" trước chuỗi ký tự đảm bảo rằng chuỗi được coi là một chuỗi Unicode.


**INSERT INTO SELECT statement**

Để chèn dữ liệu từ table đến table khác bạn có thể sử dụng mệnh đề `INSERT INTO SELECT`

Cú pháp:

```sql
INSERT  [ TOP ( expression ) [ PERCENT ] ] 
INTO target_table (column_list)
query;
```

Ví dụ:

```sql
-- Tạo cấu trúc bảng regions
CREATE TABLE dbo.regions (
    address_id INT IDENTITY PRIMARY KEY,
    street VARCHAR (255) NOT NULL,
    city VARCHAR (50),
    state VARCHAR (25),
    zip_code VARCHAR (5)
); 
-- Lấy dữ liệu từ table customer đổ qua cho regions
INSERT INTO dbo.regions (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    dbo.customers
ORDER BY
    first_name,
    last_name; 
```

**INSERT Với kiểu dữ liệu thời gian**


Ví dụ có bảng

```sql
CREATE TABLE dbo.visits (
    visit_id INT PRIMARY KEY IDENTITY,
    customer_name VARCHAR (50) NOT NULL,
    phone VARCHAR (25),
    store_id INT NOT NULL,
    visit_on DATE NOT NULL,
    start_at TIME (0) NOT NULL,
    end_at TIME (0) NOT NULL,
    create_at DATETIME2 NOT NULL, --kiểu yyyy-mm-dd H:i:s, không tự động tạo
    modified_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP --kiểu yyyy-mm-dd H:i:s, tự động tạo
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);

--Chèn dữ liệu
INSERT INTO sales.visits (
    customer_name,
    phone,
    store_id,
    visit_on,
    start_at,
    end_at,
    create_at
)
VALUES
    (
        'John Doe',
        '(408)-993-3853',
        1,
        '2018-06-23',
        '09:10:00',
        '09:30:00',
        '2018-06-23 09:30:00'
    );
-- Trường visit_id, modified_at không cần đưa vào vì nó sẽ tạo tự động

```



#### 🔹 UPDATE

Mệnh đề UPDATE dùng để thay đổi dữ liệu trong table

Cú pháp

```sql
UPDATE [schame_name].[table_name]
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
```

Lưu ý: Câu lệnh UPDATE nên đi kèm với mệnh đề WHERE để giới hạn phạm vi tác động của dữ liệu, để giảm bớt sai sót nếu nhầm lẫn logic xử lý.

**UPDATE JOIN syntax**

```sql
UPDATE 
    t1
SET 
    t1.c1 = t2.c2,
    t1.c2 = expression,
    ...   
FROM 
    t1
    [INNER | LEFT] JOIN t2 ON join_predicate
WHERE 
    where_predicate;
```

Tạo dữ liệu demo

```sql
DROP TABLE IF EXISTS dbo.targets;

CREATE TABLE dbo.targets
(
    target_id  INT	PRIMARY KEY, 
    percentage DECIMAL(4, 2) 
        NOT NULL DEFAULT 0
);

INSERT INTO 
    dbo.targets(target_id, percentage)
VALUES
    (1,0.2),
    (2,0.3),
    (3,0.5),
    (4,0.6),
    (5,0.8);

CREATE TABLE dbo.commissions
(
    staff_id    INT PRIMARY KEY, 
    target_id   INT, 
    base_amount DECIMAL(10, 2) 
        NOT NULL DEFAULT 0, 
    commission  DECIMAL(10, 2) 
        NOT NULL DEFAULT 0, 
    FOREIGN KEY(target_id) 
        REFERENCES sales.targets(target_id), 
    FOREIGN KEY(staff_id) 
        REFERENCES sales.staffs(staff_id),
);

INSERT INTO 
    dbo.commissions(staff_id, base_amount, target_id)
VALUES
    (1,100000,2),
    (2,120000,1),
    (3,80000,3),
    (4,900000,4),
    (5,950000,5);
```

Yêu cầu Cập nhật tiền thưởng (trường commissions) ở table `commissions` theo công thức: `commissions = base_amount * percentage` mặc định nhân viên mới sẽ có mức chiết khấu percentage = 0.1


```sql
UPDATE 
    dbo.commissions
SET  
    dbo.commissions.commission = 
        c.base_amount  * COALESCE(t.percentage,0.1) -- COALESCE trả về 0.1 nếu percentage là NULL
FROM  
    dbo.commissions AS c
    LEFT JOIN dbo.targets t -- tham chiếu đến targets để lấy trường percentage
        ON c.target_id = t.target_id;
```

#### 🔹 DELETE

Câu lệnh DELETE cho phép bạn loại bỏ dữ liệu không cần thiết, không chính xác hoặc không muốn từ một bảng cụ thể trong cơ sở dữ liệu.

Cú pháp:

```sql
DELETE [ TOP ( expression ) [ PERCENT ] ]  
FROM table_name
[WHERE search_condition];
```

Ví dụ các trường hợp:

```sql
-- Xóa tất cả records từ table target_table
DELETE FROM target_table;
-- Xóa 1 dòng đầu tiên
DELETE TOP 10 FROM target_table;  
-- Xóa 10 % records ngẫu nhiên trong table
DELETE TOP 10 PERCENT FROM target_table;
```

**DELETE với mệnh đề WHERE**

Thông thường câu lệnh DELETE đi kèm điều kiện WHERE để xác định cụ thể bản ghi nào cần xóa

```sql
DELETE FROM dbo.commissions WHERE staff_id = 1
```



### 💥 SQL CONSTRAINT

CONSTRAINT (ràng buộc) là một khối mã hoặc một quy tắc được áp dụng cho một hoặc nhiều cột trong một bảng để định nghĩa và bảo vệ tính toàn vẹn dữ liệu. Ràng buộc định nghĩa các quy tắc và giới hạn cho dữ liệu được lưu trữ trong cơ sở dữ liệu.

Các CONSTRAINT phổ biến:

#### 🔹 PRIMARY KEY

Primary key (Khóa chính) là một thuộc tính hoặc tập hợp các thuộc tính trong một bảng dùng để định danh duy nhất mỗi hàng trong bảng đó. Khóa chính đảm bảo tính duy nhất và xác định của các bản ghi trong bảng

Là sự kết hợp giữa 2 CONSTRAINT `UNIQUE` và `NOT NULL`

```sql
-- Định nghĩa PRIMARY KEY ngay khi tạo table
CREATE TABLE [dbo].[products] (
    product_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL
)
-- Định nghĩa PRIMARY KEY cho table đã tồn tại
ALTER TABLE [dbo].[products]
ADD PRIMARY KEY (product_id);
-- Hoặc, bạn có thể đặt tên cho contraint là PK_products_product_id
--Khuyên dùng cách này để xảy ra lỗi thì dễ dàng nhận biết vì có tên
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [PK_products_product_id] PRIMARY KEY ([product_id]);
```

==> Sử dụng tiếp đầu ngữ `pk_` để nhận biết đó là khóa chính

Ngoài cách dùng `IDENTITY` bạn có thể sử một phương thức mới hơn là `GUID`

```sql
SELECT NEWID() AS GUID;
-- Cho ra được: 3297F0F2-35D3-4231-919D-1CFCF4035975
-- Đảm bảo được tính duy nhất khi làm khóa chính
```

Bạn có thể áp dụng GUID làm `primary key`

```sql
CREATE TABLE dbo.customers(
    customer_id UNIQUEIDENTIFIER DEFAULT NEWID(),
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL
);
-- Trong đó: UNIQUEIDENTIFIER ==> Đảm bảo định danh duy nhất, không trùng lặp, 
-- DEFAULT NEWID() --> tự động tạo
```
**Xóa Khóa chính**

```sql
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;
```

Ví dụ

```sql
ALTER TABLE dbo.products
DROP CONSTRAINT PK_products_product_id;
```


Nếu như khóa chính chưa set tự động tăng trước đó bạn có thể tạo như sau

```sql
-- xóa khóa chính
ALTER TABLE dbo.products
DROP CONSTRAINT PK_products_product_id;
--xóa cột product_id
ALTER TABLE dbo.products DROP COLUMN product_id
--tạo lại product_id với IDENTITY
ALTER TABLE dbo.products
ADD product_id INT IDENTITY(1,1)
--Thiết lập lại khóa chính
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [PK_products_product_id] PRIMARY KEY ([product_id]);
--
Go
```




#### 🔹 FOREIGN KEY 

- Foreign key (khóa ngoại) là một cột hoặc tập hợp các cột trong một bảng tham chiếu đến khóa chính của một bảng khác. Khóa ngoại tạo ra một mối quan hệ giữa hai bảng dựa trên giá trị của cột hoặc các cột được liên kết.

- Bảng chứa khóa ngoại được gọi là bảng tham chiếu hoặc bảng con. Và bảng được tham chiếu bởi khóa ngoại được gọi là bảng được tham chiếu hoặc bảng cha.

- Một bảng có thể có nhiều khóa ngoại tùy thuộc vào mối quan hệ của nó với các bảng khác.

- Bạn xác định khóa ngoại bằng cách sử dụng ràng buộc khóa ngoại. Ràng buộc khóa ngoại giúp duy trì tính toàn vẹn tham chiếu của dữ liệu giữa bảng con và bảng cha.

- Ràng buộc khóa ngoại chỉ ra rằng các giá trị trong một cột hoặc một nhóm cột trong bảng con bằng với các giá trị trong một cột hoặc một nhóm cột của bảng cha.

```sql
-- Tạo khóa ngoại category_id, brand_id ngay khi tạo mới Table
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [product_name] NVARCHAR(100) NOT NULL,
  [price] DECIMAL(18,2) NOT NULL,
  [discount] DECIMAL(4,2) NOT NULL,
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL,
  [brand_id] INT NOT NULL,
  CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
  CONSTRAINT FK_products_brand_id FOREIGN KEY (brand_id) 
        REFERENCES brands(brand_id) --Khóa ngoại brand_id
);
```

==> Sử dụng tiếp đầu ngữ `fk_` để nhận biết đó là khóa ngoại


Hoặc bạn có thể tạo khóa ngoại cho một table đã tồn tại

```sql
--Tạo khóa ngoại  FOREIGN KEY (category_id) tham chiếu đến khóa chính categories(Id)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_categories] FOREIGN KEY ([category_id]) REFERENCES [dbo].[categories] ([category_id]);
GO
--Tạo khóa ngoại FOREIGN KEY (brand_id) tham chiếu đến khóa chính brands(brand_id)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [FK_products_brands_id] FOREIGN KEY ([brand_id]) REFERENCES [dbo].[brands] ([brand_id]);
```

**Xóa Khóa phụ**

```sql
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;
```

Ví dụ

```sql
ALTER TABLE dbo.products
DROP CONSTRAINT FK_products_brands_id
```

**📢 Khóa ngoại với tùy chọn tham chiếu**

Câu lệnh FOREIGN KEY trong SQL Server được sử dụng để tạo ràng buộc khóa ngoại giữa hai bảng trong cơ sở dữ liệu. Ràng buộc khóa ngoại đảm bảo tính toàn vẹn dữ liệu bằng cách xác định mối quan hệ giữa các bảng thông qua khóa ngoại và khóa chính.

Cú pháp chung của câu lệnh FOREIGN KEY như sau:

```sql
FOREIGN KEY (foreign_key_columns)
    REFERENCES parent_table(parent_key_columns)
    ON UPDATE CASCADE |  SET NULL | SET DEFAULT | NO ACTION | RESTRICT
    ON DELETE CASCADE |  SET NULL | SET DEFAULT | NO ACTION | RESTRICT;
```

- `foreign_key_columns`: Là danh sách các cột trong bảng hiện tại, được định nghĩa là khóa ngoại và sẽ tham chiếu đến khóa chính trong bảng cha.
- `parent_table`: Là tên của bảng cha, tức là bảng mà các cột khóa chính được tham chiếu đến.
- `parent_key_columns`: Là danh sách các cột khóa chính trong bảng cha.
- `ON UPDATE action`: Xác định hành động khi giá trị của khóa chính trong bảng cha được cập nhật. Có thể là `CASCADE`, `SET NULL`, `SET DEFAULT`, `NO ACTION` hoặc `RESTRICT`.
- `ON DELETE action`: Xác định hành động khi một hàng trong bảng cha bị xóa. Có thể là `CASCADE`, `SET NULL`, `SET DEFAULT`, `NO ACTION` hoặc `RESTRICT`.

Trong đó:

1. SET DEFAULT: Khi sử dụng "SET DEFAULT", nếu một bản ghi trong bảng cha (parent table) được cập nhật hoặc xóa, và có các bản ghi tương ứng trong bảng con (child table) sử dụng khóa ngoại, giá trị của các cột khóa ngoại trong bảng con sẽ được đặt về giá trị mặc định (default value) đã được xác định trước đó. Nếu không có giá trị mặc định, thì một lỗi có thể xảy ra.

2. NO ACTION: Khi sử dụng "NO ACTION", nếu có sự thay đổi trong bảng cha, nhưng các bản ghi trong bảng con vẫn có tham chiếu đến các bản ghi trong bảng cha, thì NO ACTION sẽ ngăn chặn các thay đổi này. Nghĩa là, hệ thống sẽ không thực hiện thay đổi hoặc xóa bản ghi trong bảng cha nếu có các bản ghi con liên quan. Điều này đảm bảo tính nhất quán của dữ liệu, nhưng có thể gây ra lỗi nếu không được xử lý cẩn thận.

3. RESTRICT: RESTRICT tương tự như NO ACTION, nghĩa là nó ngăn chặn sự thay đổi hoặc xóa bản ghi trong bảng cha khi có các bản ghi con liên quan. RESTRICT cũng được sử dụng để đảm bảo ràng buộc dữ liệu và tính nhất quán, và có thể gây ra lỗi nếu không được xử lý cẩn thận.

4. CASCADE: Khi sử dụng "CASCADE" trong mệnh đề FOREIGN KEY, nếu có sự thay đổi trong bảng cha, như cập nhật hoặc xóa bản ghi, các thay đổi tương ứng sẽ được tự động lan truyền (cascade) đến bảng con. Nghĩa là, các bản ghi trong bảng con có khóa ngoại trùng khớp sẽ được cập nhật hoặc xóa một cách tự động.

5. SET NULL: Khi sử dụng "SET NULL", nếu một bản ghi trong bảng cha được cập nhật hoặc xóa, và có các bản ghi tương ứng trong bảng con sử dụng khóa ngoại, giá trị của các cột khóa ngoại trong bảng con sẽ được đặt về NULL. Điều này cho phép tồn tại các bản ghi trong bảng con không có liên kết với bảng cha.

Tóm lại, khi sử dụng các từ khóa trong mệnh đề FOREIGN KEY, chúng ta có thể xác định cách thức xử lý dữ liệu liên quan đến khóa ngoại khi có sự thay đổi trong bảng cha. Mỗi từ khóa có ý nghĩa và tác động khác nhau lên dữ liệu và các bảng liên quan. Lựa chọn từ khóa phù hợp phụ thuộc vào yêu cầu kinh doanh và mô hình dữ liệu của hệ thống.


Ví dụ, để tạo một ràng buộc khóa ngoại trong bảng "Orders" tham chiếu đến khóa chính "OrderID" trong bảng "Customers", và khi khóa chính trong bảng "Customers" được cập nhật hoặc xóa, các hành động tương ứng được thực hiện, bạn có thể sử dụng câu lệnh sau:

```sql
ALTER TABLE Orders
ADD FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
ON UPDATE CASCADE
ON DELETE SET NULL;
```

Trong ví dụ trên, cột "CustomerID" trong bảng "Orders" được định nghĩa là khóa ngoại, tham chiếu đến cột "CustomerID" trong bảng "Customers".

- Khi khóa chính trong bảng "Customers" được cập nhật, các bản ghi tương ứng trong bảng "Orders" sẽ được cập nhật theo (`ON UPDATE CASCADE`). 
- Khi một bản ghi trong bảng "Customers" bị xóa, giá trị khóa ngoại trong bảng "Orders" sẽ được đặt thành NULL (`ON DELETE SET NULL`).




#### 🔹 UNIQUE

SQL cung cấp cho bạn ràng buộc UNIQUE để duy trì tính duy nhất của dữ liệu một cách chính xác.

Khi có ràng buộc UNIQUE, mỗi khi bạn chèn một hàng mới, nó sẽ kiểm tra xem giá trị đã có trong bảng chưa. Nó từ chối thay đổi và đưa ra lỗi nếu giá trị đã tồn tại. Quá trình tương tự được thực hiện để cập nhật dữ liệu hiện có.

```sql
--Tạo UNIQUE ngay khi tạo mới table
CREATE TABLE [dbo].[categories] (
  [category_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [category_name] NVARCHAR(50) UNIQUE NOT NULL, -- UNIQUE
  [description] NVARCHAR(500) NULL,
);
GO
```

Bạn cũng có thể tạo UNIQUE cho một table đã tồn tại

```sql
ALTER TABLE [dbo].[categories]
ADD CONSTRAINT [UQ_categories_category_name] UNIQUE ([category_name]); --UQ_categories_Name là tên bạn đặt cho CONTRAINT
GO
```

==> Sử dụng tiếp đầu ngữ `uq_` để nhận biết đó là UNIQUE

**Xóa UNIQUE Contraint**

```sql
ALTER TABLE table_name
DROP CONSTRAINT uq_constraint_name;

```


#### 🔹 NOT NULL

Trong lý thuyết cơ sở dữ liệu, NULL đại diện cho thông tin chưa biết hoặc thiếu thông tin. NULL không giống như một chuỗi trống hoặc số 0.

Giả sử bạn cần chèn địa chỉ email của một liên hệ vào bảng. Bạn có thể yêu cầu địa chỉ email của người đó. Tuy nhiên, nếu bạn không biết người liên hệ đó có địa chỉ email hay không, bạn có thể chèn NULL vào cột địa chỉ email. Trong trường hợp này, NULL chỉ ra rằng địa chỉ email không được biết tại thời điểm ghi.

NULL rất đặc biệt. Nó không bằng bất cứ thứ gì, kể cả chính nó. Biểu thức NULL = NULL trả về NULL vì điều đó có nghĩa là hai giá trị chưa biết không được bằng nhau.

Định nghĩa NOT NULL ngay khi tạo mới table

```sql
CREATE TABLE [dbo].[categories] (
  [category_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Khóa chính tự tăng
  [category_name] NVARCHAR(50) UNIQUE NOT NULL, -- UNIQUE
  [description] NVARCHAR(500),
);
GO
```
Hoặc cho table đã tồn tại

```sql
ALTER TABLE [dbo].[categories]
ALTER COLUMN [name] NVARCHAR(50) UNIQUE NOT NULL;
```


#### 🔹 DEFAULT

DEFAULT là một thuộc tính được sử dụng trong cơ sở dữ liệu để định nghĩa giá trị mặc định cho một cột khi không có giá trị nào được cung cấp trong quá trình chèn dữ liệu mới hoặc cập nhật dữ liệu trong cột đó.

Định nghĩa `DEFAULT CONTRAINT` ngay khi tạo mới Table

price, discount mặc định = 0

```sql
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [product_name] NVARCHAR(100) NOT NULL,
  [price] DECIMAL(18,2) NOT NULL DEFAULT 0,
  [discount] DECIMAL(4,2) NOT NULL DEFAULT 0,
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL,
  [brand_id] INT NOT NULL,
  CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
  CONSTRAINT FK_products_brand_id FOREIGN KEY (brand_id) 
        REFERENCES brands(brand_id) --Khóa ngoại brand_id

);
GO

```
Với kiểu dữ liệu thời gian ví dụ như ghi nhận thời gian thêm mới đơn hàng `order_date`

Ví dụ:

```sql
CREATE TABLE [dbo].[orders] (
	[order_id] [int]  NOT NULL,
	[customer_id] [int] NOT NULL,
	[order_status] [tinyint] NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = cancel; 4 = Completed
	[order_date] [datetime2] NOT NULL DEFAULT CURRENT_TIMESTAMP,
	[required_date] [datetime2] NOT NULL,
	[shipped_date] [datetime2] NULL,
	[store_id] [int] NOT NULL,
	[staff_id] [int] NOT NULL,
	[order_note] [nvarchar](500) NULL,
	[shipping_address] [nvarchar](500) NULL,
	[shipping_city] [nvarchar](50) NULL,
	[payment_type] [tinyint] NOT NULL,
	-- payment type: 1 = COD; 2 = Credit; 3 = ATM; 4 = Cash
	[order_amount] [decimal](18, 2) NOT NULL
);
GO
```



#### 🔹 CHECK

Check Contraint là một loại ràng buộc cho phép bạn chỉ định xem các giá trị trong một cột có phải đáp ứng một yêu cầu cụ thể hay không.

Nếu các giá trị vượt qua quá trình kiểm tra, PostgreSQL sẽ chèn hoặc cập nhật các giá trị này vào cột. Nếu không, PostgreSQL sẽ từ chối các thay đổi và đưa ra lỗi vi phạm ràng buộc.


Tạo table  products FULL Các CONTRAINT, ngay khi tạo mới

```sql
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL, --Tự tăng
  [product_name] NVARCHAR(100) NOT NULL,
  [price] DECIMAL(18,2) DEFAULT 0 CHECK (price >=0),
  [discount] DECIMAL(4,2) DEFAULT 0 NOT NULL CHECK (discount >=0 AND discount <= 70),
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL,
  [brand_id] INT NOT NULL,
  CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
  CONSTRAINT FK_products_brand_id FOREIGN KEY (brand_id) 
        REFERENCES brands(brand_id) --Khóa ngoại brand_id

);
GO

```

Bạn cũng có thể tạo CONTRAINT CHECK cho table đã tồn tại


```sql
-- Create CHECK (price > 0)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_price] CHECK ([price] > 0);
GO

--Create CHECK (discount >= 0 AND discount <= 90)
ALTER TABLE [dbo].[products]
ADD CONSTRAINT [CK_products_discount] CHECK ([discount] >= 0 AND [discount] <= 90);
GO

```

==> Sử dụng tiếp đầu ngữ `ck_` để nhận biết đó là Check

**Xóa Check Contraint**

```sql
ALTER TABLE table_name
DROP CONSTRAINT check_constraint_name;
```

**Tắt Check Contraint**

Cú pháp

```sql
ALTER TABLE table_name
NO CHECK CONSTRAINT check_constraint_name;
```

## 💛 Kết Luận

Tổng hợp các vấn đề trên bạn có thể thực hiện tạo bảng, với đầy đủ tính năng trong lần tạo mới như sau:

- Có Khóa chính tự tăng được đặt tên
- Có khóa ngoại được đặt tên
- Có các contraints

```sql
CREATE TABLE [dbo].[products] (
  [product_id] INT IDENTITY(1,1) NOT NULL, --Tự tăng
  [product_name] NVARCHAR(100) NOT NULL UNIQUE, --Tên không được trùng
  [price] DECIMAL(18,2) DEFAULT 0,
  [discount] DECIMAL(4,2) DEFAULT 0,
  [description] NVARCHAR(MAX) NULL,
  [category_id] INT NOT NULL,
  [brand_id] INT NOT NULL,
  -- Khóa chính
  CONSTRAINT PK_products_product_id PRIMARY KEY (product_id),
  -- Danh sách khóa ngoại nếu có
  CONSTRAINT FK_products_category_id FOREIGN KEY (category_id) 
        REFERENCES categories(category_id), --Khóa ngoại category_id
  CONSTRAINT FK_products_brand_id FOREIGN KEY (brand_id) 
        REFERENCES brands(brand_id), --Khóa ngoại brand_id
    -- Danh sách các contraints nếu có
    CONSTRAINT [UQ_produtcs_product_name] UNIQUE ([product_name]),
    CONSTRAINT [CK_products_price] CHECK ([price] > 0),
    CONSTRAINT [CK_products_discount] CHECK ([discount] >= 0 AND [discount] <= 90)

);
```



## 💛Homeworks Guide - Session 2-3-4





