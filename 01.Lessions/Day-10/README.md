# Day 10
💥 🔹

## 💛 Session 16 - Enhancements in SQL Server 2019

Những cải tiến SQL Server 2019

Xem link: https://learn.microsoft.com/en-us/sql/sql-server/what-s-new-in-sql-server-2019?view=sql-server-ver16

### 💥 JSON Data

JSON (JavaScript Object Notation) là một định dạng dữ liệu phổ biến được sử dụng để truyền và lưu trữ dữ liệu có cấu trúc. SQL Server hỗ trợ lưu trữ và xử lý dữ liệu JSON bằng cách cung cấp các tính năng và hàm liên quan.

Trong SQL Server, JSON data là một kiểu dữ liệu mới được giới thiệu từ phiên bản SQL Server 2016 trở đi. Nó cho phép bạn lưu trữ dữ liệu JSON trong các cột JSON trong bảng SQL Server. Các cột JSON có thể chứa các đối tượng JSON, mảng JSON hoặc giá trị JSON đơn.

Dưới đây là một số tính năng và hàm quan trọng liên quan đến JSON data trong SQL Server:

1. JSON Functions: SQL Server cung cấp một loạt các hàm để xử lý và truy vấn dữ liệu JSON. Một số hàm quan trọng bao gồm JSON_VALUE, JSON_QUERY, JSON_MODIFY và JSON_EXISTS. Các hàm này cho phép bạn trích xuất, chèn, cập nhật và kiểm tra sự tồn tại của các giá trị JSON.

2. JSON Indexing: SQL Server cung cấp khả năng tạo chỉ mục trên các cột JSON, cho phép tìm kiếm và truy cập dữ liệu JSON một cách hiệu quả. Chỉ mục JSON giúp tăng tốc truy vấn và cải thiện hiệu suất khi làm việc với JSON data.

3. JSON Schema Validation: SQL Server hỗ trợ xác thực JSON data bằng cách sử dụng JSON schema. Bằng cách định nghĩa một JSON schema, bạn có thể kiểm tra tính hợp lệ của dữ liệu JSON và đảm bảo rằng nó tuân theo một cấu trúc nhất định.

4. FOR JSON Clause: SQL Server cung cấp mệnh đề FOR JSON để truy vấn dữ liệu từ cơ sở dữ liệu và xuất kết quả dưới dạng JSON. Mệnh đề này cho phép bạn truy vấn dữ liệu từ các bảng SQL Server và định dạng kết quả trả về dưới dạng JSON.

Các hàm JSON trong SQL Server:  

#### 🔹 FOR JSON PATH

Dùng để chuyển kết quả của một câu lệnh SELECT thành một đối tượng JSON. Ví dụ:

```sql
SELECT
    O.*,
    (SELECT * FROM customers AS C WHERE O.customer_id = C.customer_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS customer,
    (SELECT * FROM staffs AS S WHERE O.staff_id = S.staff_id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS staffs
FROM orders AS O
```

#### 🔹 Hàm JSON_VALUE

Dùng để trích xuất một giá trị từ một đối tượng JSON. Ví dụ: Trích xuất giá trị của thuộc tính name từ đối tượng JSON {"name": "John", "age": 30}

```sql
SELECT JSON_VALUE('{"name": "John", "age": 30}', '$.name') AS name
```

#### 🔹 Hàm JSON_QUERY

Dùng để trích xuất một đối tượng JSON từ một đối tượng JSON. Ví dụ: Trích xuất đối tượng JSON `{"name": "John", "age": 30} từ đối tượng JSON {"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}`

```sql
SELECT JSON_QUERY('{"name": "John", "age": 30, "address": {"street": "123 Main St.", "city": "New York"}}', '$.address') AS address
```

#### 🔹 Hàm JSON_MODIFY

Dùng để thay đổi một giá trị trong một đối tượng JSON. Ví dụ: Thay đổi giá trị của thuộc tính name từ John thành Jane trong đối tượng JSON {"name": "John", "age": 30}

```sql
SELECT JSON_MODIFY('{"name": "John", "age": 30}', '$.name', 'Jane') AS name
```

#### 🔹 Hàm ISJSON

Dùng để kiểm tra một chuỗi có phải là một đối tượng JSON hay không. Ví dụ: Kiểm tra chuỗi {"name": "John", "age": 30} có phải là một đối tượng JSON hay không

```sql
SELECT ISJSON('{"name": "John", "age": 30}') AS is_json
```

#### 🔹 Hàm OPENJSON

Dùng để chuyển một đối tượng JSON thành một bảng. Ví dụ: Chuyển đối tượng JSON {"name": "John", "age": 30} thành bảng

```sql
SELECT * FROM OPENJSON('{"name": "John", "age": 30}')
```
---

## 💛 Session 17 - PolyBase, Query Store, and Stretch Database

### 💥 PolyBase

PolyBase là một tính năng trong SQL Server, được giới thiệu từ phiên bản SQL Server 2016 trở đi. Nó cung cấp khả năng truy vấn và tích hợp dữ liệu từ các nguồn dữ liệu bên ngoài SQL Server, bao gồm dữ liệu trong các hệ thống Hadoop, Azure Blob Storage, Oracle, Teradata và nhiều nguồn dữ liệu khác.

PolyBase cho phép người dùng truy vấn dữ liệu từ các nguồn khác nhau thông qua ngôn ngữ truy vấn SQL tiêu chuẩn và cung cấp một giao diện đơn giản để làm việc với các nguồn dữ liệu không liên quan. Nó tận dụng sự mạnh mẽ của SQL Server để xử lý và truy vấn dữ liệu từ các nguồn khác nhau như một phần của một truy vấn SQL duy nhất.

PolyBase cho phép tạo các bảng bên trong SQL Server có thể truy vấn trực tiếp dữ liệu từ các nguồn bên ngoài. Nó cung cấp các trình điều khiển (drivers) để kết nối và truy vấn dữ liệu từ các nguồn khác nhau, và các truy vấn PolyBase có thể được viết giống như các truy vấn SQL thông thường.

Ví dụ, bạn có thể tạo một bảng trong SQL Server và sử dụng PolyBase để truy vấn dữ liệu từ Hadoop. Bằng cách sử dụng câu lệnh SELECT thông thường, bạn có thể kết hợp dữ liệu từ bảng trong SQL Server và dữ liệu từ Hadoop trong cùng một truy vấn.

PolyBase cũng cung cấp khả năng tối ưu hóa truy vấn và truyền dữ liệu song song giữa SQL Server và các nguồn dữ liệu bên ngoài, giúp cải thiện hiệu suất và khả năng mở rộng của hệ thống.

Tóm lại, PolyBase là một tính năng quan trọng trong SQL Server, cho phép truy vấn và tích hợp dữ liệu từ các nguồn dữ liệu không liên quan vào SQL Server bằng cách sử dụng ngôn ngữ truy vấn SQL tiêu chuẩn. Nó mở ra khả năng kết hợp và phân tích dữ liệu từ nhiều nguồn khác nhau trong một môi trường SQL Server đơn giản và hiệu quả.

---

### 💥 Query Store

Query Store là một tính năng trong SQL Server từ phiên bản SQL Server 2016 trở đi, được thiết kế để giúp quản lý và tối ưu hóa hiệu suất các truy vấn trong cơ sở dữ liệu. Nó giám sát, lưu trữ và phân tích thông tin về các truy vấn được thực thi trong SQL Server, cho phép người quản trị và nhà phát triển dễ dàng xem và phân tích các hoạt động truy vấn.

Các khái niệm quan trọng trong Query Store bao gồm:

1. Query Store Database: Query Store sử dụng một cơ sở dữ liệu riêng gọi là Query Store Database để lưu trữ thông tin về các truy vấn. Cơ sở dữ liệu này tồn tại bên trong SQL Server và được quản lý tự động bởi hệ thống.

2. Query Store Data: Query Store thu thập và lưu trữ các dữ liệu liên quan đến các truy vấn, bao gồm thông tin về kế hoạch truy vấn, thống kê, thời gian thực thi, và tài nguyên sử dụng. Các dữ liệu này được lưu trữ trong các bảng và chế độ xem (views) trong Query Store Database.

3. Query Store Configuration: Query Store cung cấp các tùy chọn cấu hình để điều chỉnh cách nó hoạt động. Các tùy chọn này bao gồm cấu hình khoảng thời gian lưu trữ dữ liệu, mức độ chi tiết của thông tin thu thập, và các cấu hình khác liên quan đến quản lý truy vấn.

4. Query Store Reports: Query Store cung cấp các báo cáo và giao diện đồ họa để hiển thị và phân tích thông tin về các truy vấn. Các báo cáo này cho phép người dùng xem các truy vấn được thực thi, thay đổi kế hoạch truy vấn, tài nguyên sử dụng, và các thống kê liên quan khác.

5. Query Performance Insights: Query Store giúp cung cấp cái nhìn sâu sắc về hiệu suất truy vấn. Nó cho phép người dùng xác định các truy vấn chậm, truy vấn tiêu tốn nhiều tài nguyên, truy vấn đã thay đổi kế hoạch thực thi, và các vấn đề khác liên quan đến hiệu suất.

Tóm lại, Query Store là một tính năng quan trọng trong SQL Server, giúp quản lý và tối ưu hóa hiệu suất các truy vấn. Nó thu thập thông tin về các truy vấn và cung cấp cơ sở dữ liệu, cấu hình, báo cáo và giao diện để phân tích và giám sát hiệu suất truy vấn.

---

### 💥 Stretch Database

Stretch Database là một tính năng có sẵn trong SQL Server từ phiên bản SQL Server 2016 trở đi, được thiết kế để mở rộng khả năng lưu trữ dữ liệu và cải thiện hiệu suất truy vấn trong SQL Server bằng cách tự động chuyển dữ liệu giữa cơ sở dữ liệu local và Azure SQL Database.

Khái niệm chính trong Stretch Database bao gồm:

1. Local Database: Đây là cơ sở dữ liệu SQL Server chứa dữ liệu của bạn trên môi trường nội bộ. Dữ liệu trong Local Database được tổ chức và quản lý như bình thường.

2. Azure SQL Database: Đây là một dịch vụ cơ sở dữ liệu quản lý của Microsoft chạy trên nền tảng điện toán đám mây Azure. Azure SQL Database là nơi dữ liệu bên ngoài được chuyển đến và lưu trữ.

3. Stretch Database Table: Stretch Database cho phép bạn chọn các bảng trong Local Database để chuyển dữ liệu lên Azure SQL Database. Những bảng này gọi là Stretch Database Tables. Dữ liệu trong các bảng này được chia thành hai phần: một phần lưu trữ trong Local Database và một phần được chuyển lên Azure SQL Database.

4. Data Migration: Khi bạn chọn một bảng là Stretch Database Table, dữ liệu trong bảng đó sẽ được chuyển lên Azure SQL Database theo một quy trình tự động. Dữ liệu cũ được lưu trữ trong Local Database, trong khi dữ liệu mới và thay đổi được gửi đến Azure SQL Database.

5. Transparent Data Access: Một khi dữ liệu đã được chuyển lên Azure SQL Database, bạn vẫn có thể truy cập và truy vấn dữ liệu đó thông qua Local Database. Stretch Database sẽ tự động xử lý việc truy xuất dữ liệu từ cả hai nơi mà không đòi hỏi sự can thiệp từ phía người dùng.

Stretch Database là một công cụ hữu ích để quản lý dữ liệu lớn trong SQL Server bằng cách tận dụng điện toán đám mây. Nó giúp mở rộng khả năng lưu trữ và cải thiện hiệu suất truy vấn bằng cách tự động chuyển dữ liệu giữa Local Database và Azure SQL Database.