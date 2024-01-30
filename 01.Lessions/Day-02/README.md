# Day 02 

## 💛Session 02 - Normalization

### 💥 Database Normalization là gì ?

Chuẩn hóa cơ sở dữ liệu là một nguyên tắc thiết kế cơ sở dữ liệu để tổ chức dữ liệu một cách có tổ chức và nhất quán.

Nó giúp bạn tránh sự dư thừa và duy trì tính toàn vẹn của cơ sở dữ liệu. Nó cũng giúp bạn loại bỏ các đặc điểm không mong muốn liên quan đến việc chèn, xóa và cập nhật.


### 💥 Mục đích của việc chuẩn hóa dữ liệu

Mục đích chính của việc chuẩn hóa cơ sở dữ liệu là tránh sự phức tạp, loại bỏ sự trùng lặp và sắp xếp dữ liệu một cách nhất quán. Trong quá trình chuẩn hóa, dữ liệu được chia thành nhiều bảng được liên kết với nhau bằng các mối quan hệ.

Có thể đạt được các mối quan hệ này bằng cách sử dụng `khóa chính`, `khóa ngoại` và `khóa tổng hợp`.

Để làm được việc này, khóa chính trong một bảng, chẳng hạn như nhân viên_wages, có liên quan đến giá trị từ một bảng khác, chẳng hạn như dữ liệu nhân viên.

N.B.: Khóa chính là cột xác định duy nhất các hàng dữ liệu trong bảng đó. Đó là mã định danh duy nhất như ID nhân viên, ID sinh viên, số nhận dạng cử tri (VIN), v.v.

Khóa ngoại là trường liên quan đến khóa chính trong bảng khác.

Khóa tổng hợp giống như khóa chính nhưng thay vì có một cột, nó có nhiều cột.

### 💥 Các bước phân tích, thiết kế CSDL

Trong thiết kế CSDL SQL Server, các khái niệm Normal 1 (1NF), Normal 2 (2NF) và Normal 3 (3NF) liên quan đến quy tắc bảo toàn tính nguyên vẹn dữ liệu trong quá trình lưu trữ và truy xuất dữ liệu. 

Các nguyên tắc chuẩn hóa giúp tăng tính nhất quán, hiệu quả và dễ quản lý cho CSDL SQL Server, giúp tránh các vấn đề như sự lặp lại dữ liệu, phụ thuộc phi chức năng và không nhất quán dữ liệu.

---



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

### 💥 Xét ví dụ (Normalization)

| EmployeeId | ProjectId | ProjectName       | EmployeeName | Grade | Salary |
|------------|-----------|-------------------|--------------|-------|--------|
| 142        | 113, 124  | BLUE STAR, MAGNUM | John         | A     | 20,000 |
| 168        | 113       | BLUE STAR         | James        | B     | 15,000 |
| 263        | 113       | BLUE STAR         | Andrew       | C     | 10,000 |
| 109        | 124       | MAGNUM            | Bob          | C     | 10,000 |

Bảng trên bao gồm các điểm dị thường sau:

- Insertion Anomaly
- Deletion Anomaly
- Updation Anomaly
- Redundancy / Duplication / Repetition

---

#### 🔹 Điểm dị thường về INSERTION

- Cột "ProjectId" trong hàng đầu tiên có giá trị "113, 124". Điều này chỉ ra rằng một nhân viên có thể tham gia vào nhiều dự án (113 và 124). Tuy nhiên, trong các hàng tiếp theo, cột "ProjectId" chỉ chứa một giá trị duy nhất cho mỗi hàng. Điều này tạo ra sự không nhất quán trong dữ liệu khi INSERT vào bảng.
- Cột "ProjectName" trong hàng đầu tiên có giá trị "BLUE STAR, MAGNUM", chỉ ra rằng dự án này có tên gồm hai phần "BLUE STAR" và "MAGNUM". Tuy nhiên, trong các hàng tiếp theo, cột "ProjectName" chỉ chứa một tên dự án duy nhất cho mỗi hàng. Điều này cũng tạo ra sự không nhất quán trong dữ liệu khi INSERT vào bảng.

>LƯU Ý
Điểm dị thường INSERTION trên liên quan đến việc chèn (INSERT) dữ liệu vào bảng, khi các giá trị của cột "ProjectId" và "ProjectName" không được đồng nhất cho các hàng tương ứng. Điều này cần được sửa chữa để đảm bảo tính nhất quán và chuẩn hóa dữ liệu trong cơ sở dữ liệu.

---

#### 🔹Điểm dị thường về DELETION

- Nếu bạn muốn xóa thông tin về một dự án cụ thể, ví dụ như dự án có "ProjectId" là 113, việc xóa dự án này sẽ không chỉ xóa hàng chứa dự án này mà còn ảnh hưởng đến các hàng khác. Ví dụ, nếu bạn xóa hàng chứa dự án có "ProjectId" là 113, thì hàng của nhân viên James và Andrew cũng sẽ bị xóa vì cả hai nhân viên này đều tham gia dự án 113. Điều này gây ra sự không nhất quán và mất mát dữ liệu trong bảng.
- Nếu bạn muốn xóa thông tin về một nhân viên cụ thể, việc xóa nhân viên này cũng sẽ ảnh hưởng đến các hàng khác. Ví dụ, nếu bạn xóa hàng chứa thông tin về nhân viên James, thì hàng của dự án có "ProjectId" là 113 cũng sẽ bị xóa vì nhân viên James tham gia dự án 113. Điều này cũng dẫn đến sự không nhất quán và mất mát dữ liệu trong bảng.

>LƯU Ý:
Điểm dị thường DELETION trên liên quan đến việc xóa dữ liệu trong bảng, khi việc xóa một hàng có thể ảnh hưởng đến các hàng khác trong bảng. Điều này cần được xử lý một cách thích hợp để đảm bảo tính nhất quán và bảo toàn dữ liệu trong cơ sở dữ liệu.

---

#### 🔹 Điểm dị thường về UPDATION

- Cột "ProjectId": Điểm dị thường ở đây là cập nhật giá trị của cột "ProjectId" trong một hàng. Vì cột "ProjectId" trong bảng ghi đầu tiên chứa giá trị "113, 124", việc cập nhật giá trị này thành một giá trị duy nhất sẽ gây ra sự không nhất quán trong dữ liệu. Nếu chỉ cập nhật "ProjectId" thành một giá trị duy nhất, ví dụ như 113 hoặc 124, thì thông tin về việc nhân viên tham gia vào nhiều dự án sẽ bị mất.
- Cột "ProjectName": Điểm dị thường ở đây là cập nhật giá trị của cột "ProjectName" trong một hàng. Vì cột "ProjectName" trong bảng ghi đầu tiên chứa giá trị "BLUE STAR, MAGNUM", việc cập nhật giá trị này thành một tên dự án duy nhất sẽ gây ra sự không nhất quán trong dữ liệu. Nếu chỉ cập nhật "ProjectName" thành một tên dự án duy nhất, ví dụ như "BLUE STAR" hoặc "MAGNUM", thì thông tin về việc một dự án có nhiều tên sẽ bị mất.

>LƯU Ý:
Điểm dị thường UPDATION trên liên quan đến việc cập nhật dữ liệu trong bảng, khi cập nhật giá trị của các cột "ProjectId" và "ProjectName" có thể gây ra sự không nhất quán và mất mát thông tin trong dữ liệu. Điều này cần được xử lý một cách cẩn thận để đảm bảo tính nhất quán và bảo toàn dữ liệu trong cơ sở dữ liệu.

---

#### 🔹Điểm dị thường về REPEATION

- Cột "ProjectId" và "ProjectName" trong bảng trên chứa các giá trị lặp lại. Ví dụ, dự án có "ProjectId" là 113 và 124 có tên là "BLUE STAR, MAGNUM". Điều này dẫn đến sự lặp lại dữ liệu trong bảng.
- Cột "Grade" tương ứng với Salary trong bảng trên cũng chứa các giá trị lặp lại. Ví dụ, nhân viên có "EmployeeId" là 109 và 263 đều có "Grade" là C và đều là 10,000. Điều này dẫn đến sự lặp lại dữ liệu trong bảng.

---

### 💥 First Normal Form (1NF)

*   Để đảm bảo tính nhất quán và chuẩn hóa dữ liệu trong cơ sở dữ liệu, các điểm dị thường INSERTION, DELETION và UPDATION cần được xử lý một cách thích hợp. Để làm được điều này, bảng cần được chuyển đổi thành First Normal Form (1NF).
    
*   Để đạt được 1NF, bảng cần thỏa mãn các điều kiện sau:
    
    *   Các giá trị trong mỗi cột phải là giá trị đơn (Atomic value).
    *   Các giá trị trong mỗi cột cùng một kiểu dữ liệu (Data type).
    *   Các hàng trong bảng phải có một `khóa chính duy nhất` để xác định một cách duy nhất mỗi hàng dữ liệu trong bảng.


Để đạt được 1NF, nếu có một trường có giá trị lặp lại trong một hàng dữ liệu, ta cần chia thành các bảng riêng biệt và tạo quan hệ giữa chúng bằng cách sử dụng khóa chính và khóa ngoại.

Mục tiêu của chuẩn 1NF là loại bỏ các phần tử đa trị (multivalued) và lặp lại (repeating) trong bảng dữ liệu, giúp tăng tính nhất quán và hiệu quả trong việc truy xuất dữ liệu.


*   Cách làm như sau:
    
 Ở bảng trên, cột "ProjectId" chứa nhiều giá trị phân tách bằng dấu phẩy. Để đạt chuẩn 1NF, ta cần tách cột này thành các hàng riêng biệt.

 | EmployeeId | ProjectId | ProjectName | EmployeeName | Grade | Salary |
|------------|-----------|-------------|--------------|-------|--------|
| 142        | 113       | BLUE STAR   | John         | A     | 20,000 |
| 142        | 124       | MAGNUM      | John         | A     | 20,000 |
| 168        | 113       | BLUE STAR   | James        | B     | 15,000 |
| 263        | 113       | BLUE STAR   | Andrew       | C     | 10,000 |
| 109        | 124       | MAGNUM      | Bob          | C     | 10,000 |


### 💥 Second Normal Form (2NF)

*   Để đạt được 2NF, bảng cần thỏa mãn các điều kiện sau:
    
    *  Đạt chuẩn 1NF
    *   Các cột không phải là khóa chính (non-key columns) phải phụ thuộc vào toàn bộ khóa chính (entire primary key).
    *   Xây dựng mối quan hệ giữa các bảng.

Nếu có trường phi khóa phụ thuộc vào một phần của khóa chính, ta cần tách bảng thành các bảng riêng biệt để đảm bảo tính chất này. Bằng cách này, ta giảm thiểu sự lặp lại dữ liệu và đảm bảo tính nhất quán trong cơ sở dữ liệu.

2NF là một bước tiến quan trọng trong việc chuẩn hóa cơ sở dữ liệu và giúp cải thiện tính nhất quán và hiệu quả trong việc truy xuất dữ liệu.


*   Cách làm như sau:
    
    *   Tạo bảng mới có tên là Employees\_Projects với các cột: EmployeeId và ProjectId.
    *   Trong bảng Employees\_Projects, cả hai cột EmployeeId và ProjectId tham gia cùng làm 1 khóa chính (primary key) để định danh mỗi hàng một cách duy nhất.
    *   Xóa cột ProjectId trong bảng Employees.
    *   Thiết lập khóa chính cho bảng Employees là cột EmployeeId.
    *   Tạo mối quan hệ giữa bảng Employees và bảng Employees\_Projects thông qua cột EmployeeId.
    *   Tạo mối quan hệ giữa bảng Projects và bảng Employees\_Projects thông qua cột ProjectId.


**📰 Bảng Employees_Projects:**

| EmployeeId | ProjectId |
|------------|-----------|
| 142        | 113       |
| 142        | 124       |
| 168        | 113       |
| 263        | 113       |
| 109        | 124       |


**📰 Bảng Projects:**

| ProjectId | ProjectName |
|-----------|-------------|
| 113       | BLUE STAR   |
| 124       | MAGNUM      |

**📰 Bảng Employees:**

| EmployeeId | EmployeeName | Grade | Salary |
|------------|--------------|-------|--------|
| 142        | John         | A     | 20,000 |
| 168        | James        | B     | 15,000 |
| 263        | Andrew       | C     | 10,000 |
| 109        | Bob          | C     | 10,000 |


---

### 💥 Third Normal Form (3NF)

*   Để đạt được 3NF, bảng cần thỏa mãn các điều kiện sau:
    
    *   Cần đạt được 2NF.
    *   Tất cả các trường phi khóa không được phụ thuộc vào nhau: Điều này có nghĩa là không có sự phụ thuộc không cần thiết giữa các trường phi khóa.

Nếu có sự phụ thuộc không cần thiết giữa các trường phi khóa, ta cần tách bảng thành các bảng riêng biệt để loại bỏ sự phụ thuộc không cần thiết này. Bằng cách này, ta giảm thiểu sự phụ thuộc không cần thiết, loại bỏ sự lặp lại dữ liệu và đảm bảo tính nhất quán trong cơ sở dữ liệu.

3NF là một bước tiến quan trọng trong việc chuẩn hóa cơ sở dữ liệu và giúp cải thiện tính nhất quán, hiệu quả và khả năng bảo trì của cơ sở dữ liệu.


*   Cách làm như sau:
    
    *   Tạo bảng Grade với các cột: Grade và Salary.
    *   Trong bảng Grade, cột Grade sẽ là khóa chính (primary key) để định danh mỗi hàng một cách duy nhất.
    *   Xóa cột Salary trong bảng Employees.
    *   Tạo mối quan hệ giữa bảng Employees và bảng Grade thông qua cột Grade.

**📰 Bảng Grade**

| Grade | Salary |
|-------|--------|
| A     | 20,000 |
| B     | 15,000 |
| C     | 10,000 |


**📰 Bảng Employees**

| EmployeeId | EmployeeName | Grade |
|------------|--------------|-------|
| 142        | John         | A     |
| 168        | James        | B     |
| 263        | Andrew       | C     |
| 109        | Bob          | C     |

**📰 Bảng Projects**

| ProjectId | ProjectName |
|-----------|-------------|
| 113       | BLUE STAR   |
| 124       | MAGNUM      |

**📰 Bảng Employees_Projects**

| EmployeeId | ProjectId |
|------------|-----------|
| 142        | 113       |
| 142        | 124       |
| 168        | 113       |
| 263        | 113       |
| 109        | 124       |

---

Đọc thêm:

- https://learn.microsoft.com/en-us/office/troubleshoot/access/database-normalization-description
- https://www.guru99.com/database-normalization.html
- https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/


## 💛Session 03 - Introduction to SQL Server 2019

- Cách cài đặt phần mềm
  - SQL SERVER 2019 EXPRESS EDITION: https://www.microsoft.com/en-us/sql-server/sql-server-downloads --> Tải bản Express
  - SQL SERVER MANAGEMENT STUDIO (SSMS): https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

- Hướng dẫn cài đặt: https://youtu.be/JIvu6wx8BSY




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