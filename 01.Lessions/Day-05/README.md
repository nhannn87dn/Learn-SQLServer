# Day 5
💥 🔹
## 💛 Session 07- Azure SQL


### 💥 Giới thiệu SQL Azure

SQL Azure là một dịch vụ cơ sở dữ liệu quan hệ dựa trên đám mây, thúc đẩy các công nghệ SQL Server hiện có. Microsoft SQL Azure mở rộng chức năng của Microsoft SQL Server để phát triển các ứng dụng dựa trên web, có khả năng mở rộng và được phân phối. SQL Azure cho phép người dùng thực hiện các truy vấn quan hệ, hoạt động tìm kiếm và đồng bộ hóa dữ liệu với người dùng di động và các office từ xa. SQL Azure có thể lưu trữ và lấy cả dữ liệu có cấu trúc và phi cấu trúc.


Quy trình hoạt động của SQL Azure được giải thích trong mô hình như được trình bày bên dưới:

![](https://images.viblo.asia/63d95cfa-351a-44a6-a537-fa8976f1929c.png)

### 💥  Mô hình hoạt động của SQL Azure

Ba đối tượng cốt lõi trong mô hình hoạt động của SQL Azure như sau:

1. Tài khoản

Đầu tiên phải tạo một tài khoản SQL Azure. Tài khoản này được tạo ra cho mục đích thanh toán. Thuê bao tài khoản được ghi lại và đo lường, được tính tiền theo lượng sử dụng. Sau khi tài khoản người dùng được tạo ra, các yêu cầu cần phải được cung cấp cho cơ sở dữ liệu SQL Azure, bao gồm số lượng cơ sở dữ liệu cần thiết, kích thước cơ sở dữ liệu, v.v...

2. Server

Máy chủ SQL Azure là đối tượng giúp tương tác giữa tài khoản và cơ sở dữ liệu. Sau khi tài khoản được đăng ký, cơ sở dữ liệu được cấu hình sử dụng máy chủ SQL Azure. Các thiết lập khác như thiết lập tường lửa và gán tên miền (DNS) cũng được cấu hình trong máy chủ SQL Azure.

3. Database

Cơ sở dữ liệu SQL Azure lưu trữ tất cả dữ liệu theo cách tương tự như bất kỳ cơ sở dữ liệu SQL Server tại chỗ. Mặc dù lưu trữ bằng công nghệ đám mây, cơ sở dữ liệu SQL Azure có tất cả các chức năng của một RDBMS bình thường như table, view, query, function, thiết lập bảo mật, v.v...

Ngoài những đối tượng cốt lõi thì còn một đối tượng bổ sung trong SQL Azure. Đối tượng này là công nghệ Đồng bộ dữ liệu SQL Azure. Công nghệ Đồng bộ dữ liệu SQL Azure được xây dựng trên Microsoft Sync Framework và cơ sở dữ liệu SQL Azure.

SQL Azure Data Sync giúp đồng bộ hóa dữ liệu trên SQL Server cục bộ với các dữ liệu trên SQL Azure như được trình bày trong hình dưới:

Data Sync còn có khả năng quản lý dữ liệu giúp chia sẻ dữ liệu dễ dàng giữa các cơ sở dữ liệu SQL khác nhau. Data Sync không chỉ được sử dụng để đồng bộ hóa tại chỗ với SQL Azure, mà còn để đồng bộ hóa một tài khoản SQL Azure với tài khoản khác.

### 💥  Các lợi ích của SQL Azure

1. Chi phí thấp hơn

SQL Azure cung cấp một số hàm tương tự như trên SQL Server tại chỗ với chi phí thấp hơn so với SQL Server tại chỗ. Ngoài ra, khi SQL Azure trên nền tảng đám mây, nó có thể được truy cập từ bất kỳ vị trí nào. Do đó, không có thêm chi phí cần thiết để phát triển một cơ sở hạ tầng CNTT chuyên dụng và phòng ban để quản lý cơ sở dữ liệu.

2. Sử dụng TDS

TDS được sử dụng trong các cơ sở dữ liệu SQL Server tại chỗ cho các thư viện máy khách. Do đó, hầu hết các nhà phát triển đã quen thuộc với TDS và cách sử dụng tiện ích này. Cùng một loại giao diện TDS được sử dụng trong SQL Azure để xây dựng các thư viện máy khách. Do đó, các nhà phát triển làm việc trên SQL Azure dễ dàng hơn

3. Biện pháp chuyển đổi dự phòng tự động

SQL Azure lưu trữ nhiều bản sao dữ liệu trên các vị trí vật lý khác nhau. Thậm chí khi có lỗi phần cứng do sử dụng nhiều hoặc tải quá mức, SQL Azure giúp duy trì các hoạt động kinh doanh bằng cách cung cấp khả năng sẵn sàng của dữ liệu thông qua các địa điểm vật lý khác.

4. Tính linh hoạt trong việc sử dụng dịch vụ

Ngay cả các tổ chức nhỏ cũng có thể sử dụng SQL Azure bởi mô hình định giá cho SQL Azure được dựa trên khả năng lưu trữ được tổ chức sử dụng. Nếu tổ chức cần lưu trữ nhiều hơn, giá có thể thay đổi cho phù hợp với nhu cầu. Điều này giúp các tổ chức có được sự linh hoạt trong việc đầu tư tùy thuộc vào việc sử dụng dịch vụ.

5. Hỗ trợ Transact-SQL

Do SQL Azure hoàn toàn dựa trên mô hình cơ sở dữ liệu quan hệ, nó cũng hỗ trợ các hoạt động và truy vấn Transact-SQL. Khái niệm này cũng tương tự như hoạt động của các SQL Server tại chỗ. Do đó, các quản trị viên không cần bất kỳ đào tạo hoặc hỗ trợ bổ sung nào để sử dụng SQL Azure

### 💥  Sự khác biệt giữa SQL Azure và SQL Server

Một số khác biệt quan trọng khác giữa SQL Azure và SQL Server phía khách hàng như sau:

- Các công cụ – SQL Server phía khách hàng cung cấp một số công cụ để theo dõi và quản lý. Tất cả những công cụ này có thể không được hỗ trợ bởi SQL Azure bởi có một số tập hợp công cụ hạn chế có sẵn trong phiên bản này
- Sao lưu – Sao lưu và phục hồi chức năng phải được hỗ trợ trong SQL Server phía khách hàng để khắc phục thảm họa. Đối với SQL Azure, do tất cả các dữ liệu là trên nền tảng điện toán đám mây, sao lưu và phục hồi là không cần thiết
- Câu lệnh USE – Câu lệnh USE không được SQL Azure hỗ trợ. Do đó, người dùng không thể chuyển đổi giữa các cơ sở dữ liệu trong SQL Azure so với SQL Server phía khách hàng.
- Xác thực – SQL Azure chỉ hỗ trợ xác thực SQL Server và SQL Server phía khách hàng hỗ trợ cả xác thực SQL Server và xác thực của Windows
Hỗ trợ Transact-SQL – Không phải tất cả các chức năng - Transact-SQL đều được SQL Azure hỗ trợ
Tài khoản và đăng nhập – Trong SQL Azure, các tài khoản quản trị được tạo ra trong cổng thông tin quản lý Azure. Do đó, không có thông tin đăng nhập người dùng mức thể hiện cấp riêng biệt
- Tường lửa – Các thiết lập tường lửa cho các cổng và địa chỉ IP cho phép có thể được quản lý trên máy chủ vật lý cho SQL Server phía khách hàng. Bởi cơ sở dữ liệu SQL Azure có mặt trên điện toán đám mây, xác thực thông qua các thông tin đăng nhập là phương pháp duy nhất để xác minh người dùng


## 💛 Session 08- Accessing Data

Chi tiết xem link: https://documents.aptech.io/docs/aptech-mssql/A.Presentations/session-08


### 💥 Câu lệnh SELECT

Trong SQL SELECT là câu lệnh phức tạp nhất, bởi nó có thể kết hợp thêm nhiều mệnh đề khác để truy vấn đến kết quả cuối cùng mong muốn.

Dưới đây là cú pháp đầy đủ của câu lệnh SELECT trong SQL Server:

```sql
SELECT [DISTINCT | ALL]
    [TOP (expression) [PERCENT] [WITH TIES]]
    column1, column2, ...
FROM
    table_name
[WITH (table_hint [,...])]
[WHERE condition]
[GROUP BY grouping_column1, grouping_column2, ...]
[HAVING search_condition]
[ORDER BY order_column1 [ASC | DESC], order_column2 [ASC | DESC], ...]
[OFFSET {integer_constant | offset_row_count_expression} {ROW | ROWS}]
    [FETCH {FIRST | NEXT} {integer_constant | fetch_row_count_expression} {ROW | ROWS} ONLY]
[OPTION (query_hint [,...])];
```

Giải thích các thành phần chính của cú pháp:

- DISTINCT: Lọc các giá trị trùng lặp trong kết quả.
- ALL: Trả về tất cả các giá trị, bao gồm cả các giá trị trùng lặp.
- TOP: Xác định số lượng bản ghi đầu tiên được trả về.
- PERCENT: Xác định số phần trăm bản ghi đầu tiên được trả về.
- WITH TIES: Bao gồm các bản ghi có giá trị cuối cùng tương đương với bản ghi cuối cùng trong phạm vi TOP.
- column1, column2, ...: Các cột hoặc biểu thức được chọn để trả về.
- FROM: Xác định bảng hoặc các bảng được truy vấn.
- WHERE: Xác định điều kiện để lọc bản ghi.
- GROUP BY: Nhóm các bản ghi dựa trên các cột được chỉ định.
- HAVING: Xác định điều kiện cho nhóm bản ghi.
- ORDER BY: Xác định thứ tự sắp xếp của kết quả.
- OFFSET-FETCH: Xác định số hàng bỏ qua và số hàng trả về từ kết quả.
- OPTION: Xác định các gợi ý thực thi cho câu lệnh.

Lưu ý rằng không phải tất cả các thành phần đều bắt buộc trong một câu lệnh SELECT. Bạn có thể điều chỉnh cú pháp để phù hợp với yêu cầu truy vấn cụ thể của mình.

#### 🔹 SELECT * - Lấy tất cả

Lấy tất cả các column từ table `Categories`
```sql
SELECT * FROM [dbo].[Categories]
```

Lưu ý: Khi chạy thực tế, hạn chế dùng cách này vì nó có thể dẫn đến lổ hỏng bảo mật: https://www.w3schools.com/sql/sql_injection.asp


#### 🔹 SELECT cụ thể columns cần lấy

Ví dụ: Lấy Column Id, FirstName, LastName từ table `Customers`

```sql
SELECT [Id], [FirstName], [LastName] FROM [dbo].[Categories]
```

#### 🔹 SELECT với một biểu thức

Ví dụ: Dựa vào FirstName, LastName hãy tạo một cột FullName khi lấy.

```sql
SELECT [Id], [FirstName], [LastName], [FirstName] + ' ' + [LastName] AS FullName FROM [dbo].[Categories]
```

- Nối 2 cột bằng toán tử +
- Dùng mệnh đề AS để đặt tên / Đổi tên cho một Cột


#### 🔹 SELECT với mệnh đề WHERE

- Dùng khi bạn muốn truy vấn muốn nhận kết quả dựa vào điều kiện nào đó.
- Thông thường kết hợp cùng các toán tử

**Các phép toán lô-gíc (logical)**

*   AND: dùng để kết hợp các mệnh đề với nhau, trả về TRUE nếu tất cả các mệnh đề đều đúng.
*   OR: dùng để kết hợp các mệnh đề với nhau, trả về TRUE nếu một trong các mệnh đề đúng.
*   NOT: dùng để phủ định kết quả của mệnh đề.
*   LIKE: dùng để so sánh một giá trị với một chuỗi ký tự.
*   IN: dùng để kiểm tra xem một giá trị có nằm trong một danh sách các giá trị hay không.
*   BETWEEN: value1 AND value2 dùng để kiểm tra xem một giá trị có nằm trong một khoảng giá trị hay không.
*   EXISTS: dùng để kiểm tra sự tồn tại của một bản ghi trong một bảng con.
*   ANY: dùng để so sánh với một danh sách các giá trị và trả về TRUE nếu bất kỳ giá trị nào trong danh sách đó khớp với giá trị được so sánh.
*   SOME: cũng tương tự như ANY, nó cũng dùng để so sánh với một danh sách các giá trị và trả về TRUE nếu bất kỳ giá trị nào trong danh sách đó khớp với giá trị được so sánh.
*   ALL: dùng để so sánh với một danh sách các giá trị và trả về TRUE nếu tất cả các giá trị trong danh sách đó khớp với giá trị được so sánh.

**Các phép toán so sánh (comparison)**

`=` `<>` `!=` `>` `>=` `<` `<=`


Ví dụ: Tìm những sản phẩm có giá bán >= 50.000

```sql
SELECT * FROM Products WHERE Price >= 500000
```
Ví dụ: Tìm những sản phẩm có giá bán >= 20.000 và <= 50.000

```sql
SELECT * FROM Products WHERE Price >= 200000 AND Price <= 500000
```

Ví dụ: Tìm những sản phẩm có Discount = 10 hoặc 20

```sql
SELECT * FROM Products WHERE Discount = 10 OR Discount = 20
```

Ví dụ: Tìm những sản phẩm được nhập mô tả Description (Tức khác NULL)

```sql
SELECT * FROM Products WHERE Description IS NOT NULL
```

Ví dụ: Tìm những sản phẩm thuộc danh mục có ID 2 hoặc 3

```sql
SELECT * FROM Products WHERE CategoryID IN (2,3)
--Câu lệnh trên tương đương với toán tử OR
SELECT * FROM Products WHERE CategoryID = 2 OR CategoryID = 3
```

Ví dụ: Tìm những khách hàng có năm sinh từ 2000 - 2002


```sql
SELECT *
FROM Customers
WHERE Birthday BETWEEN '2000-01-01' AND '2002-12-30';


--- Chuyển đổi chuỗi sang kiểu ngày
SELECT *
FROM Customers
WHERE Birthday BETWEEN CONVERT(DATE, '2000-01-01') AND CONVERT(DATE, '2002-12-30');


--- Ép kiểu: chuỗi --> Date
SELECT *
FROM Customers
WHERE Birthday BETWEEN CAST('1990-01-01' AS DATE) AND CAST('2002-12-30' AS DATE);
```

Ví dụ: Tìm tên khách hàng có số điện thoại đuôi 678

```sql
SELECT *
FROM Customers
WHERE PhoneNumber LIKE '%678'
```

Dưới đây là một bảng giải thích các ký tự đại diện (wildcard) phổ biến được sử dụng với LIKE:

| Ký tự đại diện (Wildcard) | Mô tả                                                                                     |
|-------------------------|------------------------------------------------------------------------------------------|
| %                       | Đại diện cho bất kỳ chuỗi ký tự nào (bao gồm cả chuỗi rỗng)                               |
| _                       | Đại diện cho bất kỳ ký tự đơn lẻ nào                                                          |
| [character_list]        | Đại diện cho bất kỳ ký tự nào trong danh sách các ký tự được chỉ định                            |
| [^character_list]       | Đại diện cho bất kỳ ký tự nào không nằm trong danh sách các ký tự được chỉ định                 |
| [range_of_characters]   | Đại diện cho bất kỳ ký tự nào nằm trong một khoảng các ký tự được chỉ định                       |

Ví dụ về việc sử dụng wildcard trong mệnh đề LIKE:

- `WHERE column_name LIKE 'A%'`: Tìm tất cả các giá trị trong cột "column_name" bắt đầu bằng "A".
- `WHERE column_name LIKE '%B'`: Tìm tất cả các giá trị trong cột "column_name" kết thúc bằng "B".
- `WHERE column_name LIKE '%C%'`: Tìm tất cả các giá trị trong cột "column_name" chứa "C" ở bất kỳ vị trí nào.
- `WHERE column_name LIKE '_D%'`: Tìm tất cả các giá trị trong cột "column_name" có chữ cái đầu tiên là bất kỳ ký tự nào, sau đó là "D".
- `WHERE column_name LIKE '[ABC]%'`: Tìm tất cả các giá trị trong cột "column_name" bắt đầu bằng "A", "B" hoặc "C".
- `WHERE column_name LIKE '[^XYZ]%'`: Tìm tất cả các giá trị trong cột "column_name" không bắt đầu bằng "X", "Y" hoặc "Z".
- `WHERE column_name LIKE '[A-Z]%'`: Tìm tất cả các giá trị trong cột "column_name" bắt đầu bằng một ký tự trong khoảng từ "A" đến "Z".

Lưu ý rằng mệnh đề LIKE được sử dụng trong câu lệnh SELECT của SQL để tìm kiếm các giá trị phù hợp với mẫu chuỗi được chỉ định.



#### 🔹 SELECT với mệnh đề ORDER BY

- Dùng để sắp xếp kết quả truy vấn theo một hoặc nhiều cột.
- Mặc định sắp xếp theo thứ tự tăng dần (ASC), nhưng bạn cũng có thể chỉ định thứ tự giảm dần (DESC).

Ví dụ: Sắp xếp tất cả các sản phẩm theo giá bán tăng dần:

```sql
SELECT Id, Name, Price
FROM Products
ORDER BY Price ASC --Mặc định không set thì là ASC
```

Ví dụ: Sắp xếp tất cả các sản phẩm theo giá bán giảm dần:

```sql
SELECT Id, Name, Price
FROM Products
ORDER BY Price DESC
```


Ví dụ: Sắp xếp tất cả các sản phẩm theo giá bán và tên:

```sql
SELECT Id, Name, Price
FROM Products
ORDER BY Price, Name DESC
```

#### 🔹 SELECT với mệnh đề OFFSET-FETCH

- Dùng để phân trang kết quả truy vấn.
- Mệnh đề OFFSET xác định số hàng bỏ qua từ kết quả bắt đầu trả về.
- Mệnh đề FETCH xác định số hàng trả về từ kết quả.

Ví dụ: Truy vấn tất cả các sản phẩm và bỏ qua 10 hàng đầu tiên, chỉ lấy 5 hàng tiếp theo:

```sql
SELECT *
FROM Products
ORDER BY ProductID
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY;
```

Lưu ý: Mệnh đề OFFSET-FETCH chỉ được hỗ trợ từ SQL Server 2012 (bao gồm cả SQL Server 2012) trở đi.

Xem thêm: https://www.sqlservertutorial.net/sql-server-basics/sql-server-offset-fetch/


#### 🔹 SELECT với mệnh đề DISTINCT

Dùng để loại bỏ các giá trị trùng lặp trong kết quả truy vấn.

```sql
--- Lấy danh sách các mức giảm giá từ Table Products
SELECT Discount
FROM Products
ORDER BY Discount ASC
---
--- Kết quả trùng lặp giá trị và bạn muốn khử trùng lặp
---

SELECT DISTINCT Discount
FROM Products
ORDER BY Discount ASC

```


Nếu bạn chỉ định nhiều cột, mệnh đề DISTINCT sẽ đánh giá sự trùng lặp dựa trên sự kết hợp các giá trị của các cột này.

```sql
--- Truy vấn ở Database w3school
SELECT 
  DISTINCT Country, City 
FROM Customers;
```

Xem thêm: https://www.sqlservertutorial.net/sql-server-basics/sql-server-select-distinct/

#### 🔹 SELECT với mệnh đề TOP & TOP PERCENT

Mệnh đề SELECT TOP được sử dụng để chỉ định số lượng bản ghi cần trả về.

Ví dụ: Lấy 10 bản ghi đầu tiên trong kết quả trả về table Products

```sql
SELECT TOP 10 * 
FROM Products
```

Ví dụ lấy 5% số lượng bản ghi đầu tiên từ table Products

```sql
--- Mang tính tương đối
SELECT TOP 5 PERCENT * 
FROM Products
```

#### 🔹 SELECT với mệnh đề WITH TIES

Mệnh đề WITH TIES được sử dụng trong câu lệnh ORDER BY của SQL để bao gồm các hàng có giá trị "ràng buộc" (ties) trong kết quả sắp xếp. Một "ràng buộc" xảy ra khi hai hoặc nhiều hàng có giá trị sắp xếp bằng nhau theo cùng một tiêu chí.

Khi sử dụng WITH TIES, các hàng có giá trị "ràng buộc" sẽ được bao gồm trong kết quả cuối cùng của câu lệnh ORDER BY, chứ không chỉ có các hàng có giá trị duy nhất.

```sql
SELECT TOP 10 WITH TIES Id, Name, Price 
FROM Products
ORDER BY Price DESC
```


#### 🔹 SELECT với mệnh đề GROUP BY,GROUP BY với HAVING

Mệnh đề GROUP BY dùng để nhóm các hàng dữ liệu thành các nhóm dựa trên giá trị của một hoặc nhiều cột. Nó cho phép bạn thực hiện các phép tính tổng hợp (aggregate) trên các nhóm dữ liệu này.

Khi sử dụng GROUP BY, dữ liệu sẽ được phân chia thành các nhóm dựa trên giá trị của cột được chỉ định trong mệnh đề GROUP BY. Các bản ghi có giá trị giống nhau trong cột này sẽ thuộc cùng một nhóm.

Ví dụ: Lấy tất cả các mức giảm giá Discount của sản phẩm theo thứ tự tăng dần.

```sql
SELECT Discount
FROM Products
GROUP BY Discount
ORDER BY Discount ASC
--- Câu lệnh này tương đương bạn dùng DISTINCT
```

Ví dụ: Lấy tất cả các mức giảm giá Discount của sản phẩm theo thứ tự tăng dần, đồng thời thống kê số lượng sản phẩm có mức giảm giá đó.


```sql
SELECT 
  Discount, 
  COUNT(Id) AS Total --- Đếm dựa vào ID và đặt tên là Total
FROM Products
GROUP BY Discount
ORDER BY Discount ASC
```

Ví dụ: Lấy tất cả các mức giảm giá Discount của sản phẩm theo thứ tự tăng dần, đồng thời thống kê số lượng sản phẩm có mức giảm giá đó. Chỉ lấy những mức Discount >= 5

```sql
SELECT 
  Discount, 
  COUNT(Id) AS Total --- Đếm dựa vào ID và đặt tên là Total
FROM Products
GROUP BY Discount
HAVING Discount >= 5 --- Lọc sau khi nhóm xong
ORDER BY Discount ASC
```


#### 🔹 SELECT với mệnh đề INTO

Dùng để tạo bảng mới từ kết quả truy vấn

```sql
SELECT * INTO CustomersBackup2019
FROM Customers;
```

Bạn có thể tận dụng tính năng này để backup một table


## 💛 Session 09- Advanced Queries and Joins - Part 1

Chi tiết xem link: https://documents.aptech.io/docs/aptech-mssql/A.Presentations/session-09