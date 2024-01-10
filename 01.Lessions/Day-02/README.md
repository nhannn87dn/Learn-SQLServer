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


## 💛Session 03 - Introduction to SQL Server 2019

- Cách cài đặt phần mềm
  - SQL SERVER 2019 EXPRESS EDITION: https://www.microsoft.com/en-us/sql-server/sql-server-downloads --> Tải bản Express
  - SQL SERVER MANAGEMENT STUDIO (SSMS): https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

- Hướng dẫn cài đặt: https://diadem.in/blog/sql-server-2019-express-installation


### Load Data mẫu:

Bước 1: Tải 2 file .sql về máy tính mình ở thưc mục `02.Examples-SQL\BikeStores`

- 1. BikeStores-Sample-Database-create-tables-Student.sql
- 2. BikeStores-Sample-Database-load-data-Student.sql

Bước 2

- Mở Microsoft SQL Server Management Studio (MSSMS) lên.

- Kết nối với chế độ xác thực là windown authentication

Bước 3

- Menu FIle --> Open --> File (Hoặc Ctrl + O)
- Chọn file .sql đã tải ở trên theo thứ tự lần lượt

Bước 4

- Chạy file số 1 trước, sau đó đến file số 2 bằng cách nhấn f5 (Nút Excute)

Bước 5

Kiểm tra lại dữ liệu trong table bằng cách, show mục table tại database, Click phải lên table bạn muốn xem dữ liệu --> chọn `Select top 1000 rows`


## 💛 HomeWork Guide - Normalization