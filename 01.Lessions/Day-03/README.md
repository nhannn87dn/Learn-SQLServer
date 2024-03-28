# Day 03


## 💛 Session 04 - Data Types

KIỂU DỮ LIỆU – DATA TYPE là một quy trình về cấu trúc, miền giá trị của dữ liệu có thể nhập vào và tập các phép toán / toán tử có thể tác động lên miền giá trị đó


**🔹 Kiểu chuỗi - String Data Types**

| Data type      | Description                                                                      | Max size                        | Storage                   |
|----------------|----------------------------------------------------------------------------------|---------------------------------|---------------------------|
| char(n)        | - Kiểu ký  tự - Không chứa Unicode - Bộ nhớ cấp phát tĩnh với tham số n          | 8,000 Ký tự                     | Defined width             |
| varchar(n)     | - Kiểu ký tự - Không chứa Unicode - Bộ nhớ cấp phát động, không vượt quá n ô nhớ | 8,000 ký tự                     | 2 bytes + number of chars |
| varchar(max)   | - Kiểu ký tự - Không chứa Unicode - Bộ nhớ cấp phát động, không giới hạn ô nhớ   | 1,073,741,824 Ký tự             | 2 bytes + number of chars |
| text           | - Lưu văn bản có độ dài lớn - Không chứa Unicode                                 | 2GB of text data                | 4 bytes + number of chars |
| nchar(n)       | - Kiểu ký  tự - Có thể chứa Unicode - Bộ nhớ cấp phát tĩnh với tham số n         | 4,000 ký  tự bao gồm cả Unicode | Defined width x 2         |
| nvarchar(n)    | - Kiểu ký tự - Có thể chứa Unicode - Bộ nhớ cấp phát động, tối đa n ô nhớ        | 4,000 Ký tự bao gồm cả Unicode  |                           |
| nvarchar(max)  | - Kiểu ký tự - Có thể chứa Unicode - Bộ nhớ cấp phát động, không giới hạn ô nhớ  | 536,870,912 Ký tự               |                           |
| ntext          | - Lưu văn bản có độ dài lớn - Có thể chứa Unicode                                | 2GB of text data                |                           |
| binary(n)      | - Chuổi nhị phân - Bộ nhớ cấp phát cứng n ô nhớ                                  | 8,000 bytes                     |                           |
| varbinary(n)   | - Chuổi nhị phân - Bộ nhớ cấp phát động, tối đa n ô nhớ                          | 8,000 bytes                     |                           |
| varbinary(max) | - Chuổi nhị phân - Bộ nhớ cấp phát động, không giới hạn ô nhớ                    | 2GB                             |                           |


**🔹 Kiểu Số - Numeric Data Types**


| Data type    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                  | Storage      |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|
| bit          | nhận giá trị 0, 1, or NULL                                                                                                                                                                                                                                                                                                                                                                                                            |              |
| tinyint      | Nhận giá trị 0 đến 255                                                                                                                                                                                                                                                                                                                                                                                                           | 1 byte       |
| smallint     | Nhận giá trị trong khoảng -32,768 đến 32,767                                                                                                                                                                                                                                                                                                                                                                                              | 2 bytes      |
| int          | Nhận giá trị trong khoảng -2,147,483,648 and 2,147,483,647                                                                                                                                                                                                                                                                                                                                                                                | 4 bytes      |
| bigint       | Nhận giá trị trong khoảng -9,223,372,036,854,775,808 and   9,223,372,036,854,775,807                                                                                                                                                                                                                                                                                                                                                      | 8 bytes      |
| decimal(p,s) | là một kiểu dữ liệu số dùng để lưu trữ các giá trị số có phần nguyên và phần thập phân có độ chính xác cố định. Trong đó: p (precision) đại diện cho tổng số chữ số được lưu trữ (bao gồm cả phần nguyên và phần thập phân). s (scale) đại diện cho số chữ số sau dấu thập phân   |
| numeric(p,s) | lưu trữ các giá trị số có độ chính xác cố định với phần nguyên và phần thập phân. Trong đó: p (precision) là tổng số chữ số được lưu trữ (bao gồm cả phần nguyên và phần thập phân). s (scale) là số chữ số sau dấu thập phân | 5-17 bytes   |
| smallmoney   | Monetary data from -214,748.3648 to 214,748.3647                                                                                                                                                                                                                                                                                                                                                                                             | 4 bytes      |
| money        | Monetary data from -922,337,203,685,477.5808 to   922,337,203,685,477.5807                                                                                                                                                                                                                                                                                                                                                                   | 8 bytes      |
| float(n)     | Lưu trữ các giá trị số dấu phẩy động from -1.79E + 308 to 1.79E + 308. The   n parameter indicates whether the field should hold 4 or 8 bytes.   float(24) holds a 4-byte field and float(53) holds an 8-byte field.   Default value of n is 53.                                                                                                                                                                                                   | 4 or 8 bytes |
| real         | Floating precision number data from -3.40E + 38 to 3.40E + 38                                                                                                                                                                                                                                                                                                                                                                                | 4 bytes      |


**🔹 Kiểu dữ liệu ngày tháng**

| Data type      | Description                                                                                                                                                                                                                         | Storage    |
----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|
 datetime       | Kiểu dữ liệu ngày tháng, Có miền giá trị từ 1/1/1753 00:00:00 đến 31/12/9999 23:59:59                                                                                                                                                   | 8 bytes    |
 datetime2      | Kiểu dữ liệu ngày tháng và thời gian, Có miền giá trị từ 1/1/0001 00:00:00 đến 31/12/9999 23:59:59.997                                                                                                                                                     | 6-8 bytes  |
 smalldatetime  | Kiểu dữ liệu ngày tháng và thời gian, có miền giá trị từ 1/1/1900 00:00:00 đến 6/6/2079 23:59:59                                                                                                                                                                   | 4 bytes    |
 date           | Kiểu ngày. Có miền giá trị từ 1/1/0001 đến 31/12/9999                                                                                                                                                                        | 3 bytes    |
 time           |  Kiểu dữ liệu thời gian, có miền giá trị từ 00:00:00.0000000 đến 23:59:59.9999999                                                                                                                                                                                 | 3-5 bytes  |
 datetimeoffset | Lưu trữ một thời điểm cụ thể kèm theo thông tin về độ lệch múi giờ                                                                                                                                                                       | 8-10 bytes |
| timestamp      | Lưu trữ một số duy nhất được cập nhật mỗi khi một hàng được tạo hoặc sửa đổi. Giá trị dấu thời gian dựa trên đồng hồ bên trong và không tương ứng với thời gian thực. Mỗi bảng chỉ có thể có một biến dấu thời gian |            |

### Tại sao phải dùng các kiểu dữ liệu riêng?

Tại sao không thể dùng chung một kiểu dữ liệu cho tất cả các Column (Trường thuộc tính) trong một Table hoặc một Database?

Nếu việc lưu trữ các dữ liệu cùng một kiểu, bạn không thể phân loại đâu là ngày tháng, đâu là chuỗi, đâu là số…. Vì vậy việc thực hiện các toán tử, tìm kiếm cũng trở nên rất khó khăn trong quá trình truy vấn dữ liệu.

Mặt khác, đặt ra một bài toán thực tế: Khi bạn thiết kế một CSDL thương mại, việc cài đặt Database lưu trữ rất quan trọng. Ta có một ví dụ nhỏ như sau, giả sử:

- Trong một Table, cứ 1 record (bản ghi) tương ứng 1 byte bộ nhớ.
- Một ngày bạn lưu 1.000.000 records sẽ chiếm 1.000.000 byte.
- Nếu lưu một năm sẽ là 365.000.000 byte.

Vậy nếu lưu trữ thừa 1byte/ ngày, bạn sẽ gây ra thất thoát dung lượng đến 365.000.000 byte /năm. Ngược lại, việc thiếu dung lượng gây ra trì trệ hệ thống như lỗi thiếu bộ nhớ, không đủ dung lượng lưu trữ. Đó chỉ là một bài toán minh họa nhỏ, còn thực tế thường gấp nhiều lần như vậy.

Các máy tính Desktop có RAM lớn, có thể chịu được thất thoát. Nhưng bạn lập trình cho App Mobile thì sao ?

---


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

## 💛Homeworks Guide - Session 2-3-4





