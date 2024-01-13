# Day 02 

## 💛Session 02 - Normalization

### 💥 Database Normalization là gì ?

Chuẩn hóa cơ sở dữ liệu là một nguyên tắc thiết kế cơ sở dữ liệu để tổ chức dữ liệu một cách có tổ chức và nhất quán.

Nó giúp bạn tránh sự dư thừa và duy trì tính toàn vẹn của cơ sở dữ liệu. Nó cũng giúp bạn loại bỏ các đặc điểm không mong muốn liên quan đến việc chèn, xóa và cập nhật.


### 💥 Mục đích của việc chuẩn hóa dữ liệu

Mục đích chính của việc chuẩn hóa cơ sở dữ liệu là tránh sự phức tạp, loại bỏ sự trùng lặp và sắp xếp dữ liệu một cách nhất quán. Trong quá trình chuẩn hóa, dữ liệu được chia thành nhiều bảng được liên kết với nhau bằng các mối quan hệ.

Có thể đạt được các mối quan hệ này bằng cách sử dụng `khóa chính`, `khóa ngoại` và `khóa tổng hợp`.


- Khóa chính là cột xác định duy nhất các hàng dữ liệu trong bảng đó. Đó là mã định danh duy nhất như ID nhân viên, ID sinh viên, số nhận dạng cử tri (VIN), v.v.

- Khóa ngoại là trường liên quan đến khóa chính trong bảng khác.

- Khóa tổng hợp giống như khóa chính nhưng thay vì có một cột, nó có nhiều cột.

### 💥 1NF 2NF and 3NF là gì ?

1NF, 2NF, and 3NF là một trong các kiểu chuẩn hóa dữ liệu. Chúng có tên gọi chuẩn là: first normal form, second normal form, và third normal form.

Ngoài ra còn có các chuẩn như: 4NF (fourth normal form) và  5NF (fifth normal form) . Thậm chí còn có 6NF (sixth normal form), nhưng dạng bình thường phổ biến nhất mà bạn sẽ thấy là 3NF (third normal form).


#### 🔹 First Normal Form – 1NF

Một table (bảng) để đạt được chuẩn 1NF phải đảm bảo các yêu cầu sau:

- Giá trị tại mỗi cột dữ liệu phải là giá trị đơn và có cùng kiểu dữ liệu.
- Phải có từ khóa chính (primary key) để định danh tính duy nhất cho một hàng dữ liệu (record)
- Không có hàng, hoặc cột bị trùng lặp

==> 1NF loại bỏ tính trùng lặp dữ liệu.

#### 🔹 Second Normal Form – 2NF

1NF chỉ loại bỏ các nhóm lặp lại chứ không loại bỏ sự dư thừa. Đó là lý do tại sao có 2NF.

Để đạt được chuẩn 2NF bạn cần đảm bảo:

- Đã đạt được chuẩn 1NF
- Không có sự phụ thuộc một phần. Có nghĩa là tất cả các trường phi khóa (non-key fields) phải phụ thuộc vào toàn bộ khóa chính (primary key).

#### 🔹 Third Normal Form – 3NF

Khi đạt được chuẩn 2NF thì nó sẽ loại bỏ các nhóm lặp lại và sự dư thừa, nhưng nó không loại bỏ sự phụ thuộc một phần bắc cầu (khi giữa các thực thể có quan hệ NHIỀU-NHIỀU)

Điều này có nghĩa là một thuộc tính không phải nguyên tố (thuộc tính không phải là một phần của khóa ứng viên) sẽ phụ thuộc vào một thuộc tính không phải nguyên tố khác. Đây là điều mà dạng chuẩn thứ ba (3NF) loại bỏ.

Để đạt được chuẩn 3NF cần đảm bảo:

- Đạt được chuẩn 2NF
- Không có sự phụ thuộc một phần bắc cầu.

---

### 💥 Ví dụ

Có một bảng dữ liệu thô chưa được chuẩn hóa như sau:

| employee_id | name  | job_code | job       | state_code | home_state |
|------------|-------|------------|---------------------|------------|------------|
| E001       | Alice | J01,   J02 | Chef,   Waiter      | 26         | Michigan   |
| E002       | Bob   | J02,   J03 | Waiter,   Bartender | 56         | Wyoming    |
| E003       | Alice | J01        | Chef                | 56         | Wyomin     |


Bảng trên bao gồm các điểm dị thường sau:

- Insertion Anomaly
- Deletion Anomaly
- Updation Anomaly
- Redundancy / Duplication / Repetition


Phân tích:

- Giá trị tại mỗi ô chưa phải là giá trị đơn
- Đã có khóa chính

Để đạt được chuẩn 1NF bạn cần xử lý lại thành:

| employee_id | name  | job_code | job       | state_code | home_state |
|-------------|-------|----------|-----------|------------|------------|
| E001        | Alice | J01      | Chef     | 26         | Michigan   |
| E001        | Alice | J02      | Waiter    | 26         | Michigan   |
| E002        | Bob   | J02      | Waiter    | 56         | Wyoming    |
| E002        | Bob   | J03      | Bartender | 56         | Wyoming    |
| E003        | Alice | J01      | Chef      | 56         | Wyoming    |


Nhưng ngay cả khi bạn chỉ biết `employee_id` của một người, bạn vẫn có thể xác định tên, `home_state` và `state_code` của họ (vì họ là cùng một người). Điều này có nghĩa là tên, `home_state` và `state_code` phụ thuộc vào `employee_id` (là một phần của khóa chính composite).

Chúng ta còn thấy sự dư thừa về dữ liệu: 56 và Wyoming

Do đó, bảng này không đạt chuẩn 2NF. Chúng ta nên tách chúng thành một bảng riêng biệt để đạt chuẩn 2NF.

**📰 Bảng employee_roles**

| employee_id | job_code |
|-------------|----------|
| E001        | J01      |
| E001        | J02      |
| E002        | J02      |
| E002        | J03      |
| E003        | J01      |

**📰 Bảng employees**

| employee_id | name  | state_code | home_state |
|-------------|-------|------------|------------|
| E001        | Alice | 26         | Michigan   |
| E002        | Bob   | 56         | Wyoming    |
| E003        | Alice | 56         | Wyoming    |

**📰 Bảng jobs**

| job_code | job       |
|----------|-----------|
| J01      | Chef      |
| J02      | Waiter    |
| J03      | Bartender |


`home_state` hiện tại phụ thuộc vào `state_code`. Vì vậy, nếu bạn biết `state_code`, bạn có thể tìm giá trị của `home_state`.

Để tiến xa hơn, chúng ta nên tách chúng thành một bảng riêng biệt khác để đạt chuẩn 3NF.


**📰 Bảng employee_roles**

| employee_id | job_code |
|-------------|----------|
| E001        | J01      |
| E001        | J02      |
| E002        | J02      |
| E002        | J03      |
| E003        | J01      |

**📰 Bảng employees**

| employee_id | name  | state_code |
|-------------|-------|------------|
| E001        | Alice | 26         |
| E002        | Bob   | 56         |
| E003        | Alice | 56         |


**📰 Bảng states**

| state_code | home_state |
|------------|------------|
| 26         | Michigan   |
| 56         | Wyoming    |

**📰 Bảng jobs**

| job_code | job       |
|----------|-----------|
| J01      | Chef      |
| J02      | Waiter    |
| J03      | Bartender |


Đọc thêm:

- https://learn.microsoft.com/en-us/office/troubleshoot/access/database-normalization-description
- https://www.guru99.com/database-normalization.html
- https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/

---

## 💛Session 03 - Introduction to SQL Server 2019

- Cách cài đặt phần mềm
  - SQL SERVER 2019 EXPRESS EDITION: https://www.microsoft.com/en-us/sql-server/sql-server-downloads --> Tải bản Express
  - SQL SERVER MANAGEMENT STUDIO (SSMS): https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

- Hướng dẫn cài đặt: https://diadem.in/blog/sql-server-2019-express-installation


////////////////////////////////////////////
---


## 💛 Session 04 - Transact SQL

Transact-SQL (T-SQL) là một ngôn ngữ truy vấn và lập trình được sử dụng trong hệ quản trị cơ sở dữ liệu SQL Server của Microsoft. Nó mở rộng cú pháp của SQL chuẩn với các tính năng bổ sung để làm việc với SQL Server.

T-SQL cho phép bạn thực hiện các thao tác truy vấn dữ liệu, tạo, sửa đổi và xóa cấu trúc đối tượng trong CSDL, cũng như điều khiển luồng thực thi và xử lý lỗi. Nó cung cấp các câu lệnh như SELECT, INSERT, UPDATE, DELETE để truy vấn và thay đổi dữ liệu trong bảng. Ngoài ra, T-SQL cũng hỗ trợ các câu lệnh điều khiển như IF, WHILE, CURSOR để thực hiện các câu lệnh điều kiện và vòng lặp.

T-SQL cũng cung cấp các khối lệnh như STORED PROCEDURE, FUNCTION và TRIGGER, cho phép bạn viết mã lập trình phức tạp để xử lý logic doanh nghiệp và tự động hóa các tác vụ trong SQL Server.

Tính năng Transact-SQL:

- data types: Các kiểu dữ liệu
- temporary objects: Đối tượng tạm thời
- extended stored procedures: Các thủ tục mở rộng
- Scrollable cursors: Con trỏ có thể cuộn
- conditional processing: Xử lý điều kiện
- transaction control: Điều khiển giao dịch
- exception and error-handling: bắt lỗi, xử lý lỗi

---

### 💥 Data Definition Language (DDL)

Data Definition Language (DDL) là một phần của ngôn ngữ truy vấn trong hệ quản trị cơ sở dữ liệu (DBMS) dùng để định nghĩa và quản lý cấu trúc của cơ sở dữ liệu. DDL cung cấp các câu lệnh để tạo, thay đổi và xóa các đối tượng cơ sở dữ liệu như bảng, chỉ mục, ràng buộc, quyền truy cập và các đối tượng khác

---

### 💥 Data Definition Language (DDL)

Data Manipulation Language (DML) là một phần của ngôn ngữ truy vấn trong hệ quản trị cơ sở dữ liệu (DBMS) dùng để thao tác và thay đổi dữ liệu trong cơ sở dữ liệu. DML cung cấp các câu lệnh để truy vấn, chèn, cập nhật và xóa dữ liệu từ các bảng và đối tượng khác trong cơ sở dữ liệu.

---

### 💥 Data Control Language (DCL)

Data Control Language (DCL) là một phần của ngôn ngữ truy vấn trong hệ quản trị cơ sở dữ liệu (DBMS) dùng để quản lý quyền truy cập và phân quyền trong cơ sở dữ liệu. DCL cung cấp các câu lệnh để cấp quyền, thu hồi quyền và điều khiển quyền truy cập đối với người dùng và vai trò trong cơ sở dữ liệu.

---

### 💥 Data Types

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

## 💛 HomeWork Guide - Normalization