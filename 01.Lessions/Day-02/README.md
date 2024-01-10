# Day 02 

## 💛Session 02 - Normalization

### 💥 Các bước phân tích, thiết kế CSDL

Trong thiết kế CSDL SQL Server, các khái niệm Normal 1 (1NF), Normal 2 (2NF) và Normal 3 (3NF) liên quan đến quy tắc bảo toàn tính nguyên vẹn dữ liệu trong quá trình lưu trữ và truy xuất dữ liệu. 

Các nguyên tắc chuẩn hóa giúp tăng tính nhất quán, hiệu quả và dễ quản lý cho CSDL SQL Server, giúp tránh các vấn đề như sự lặp lại dữ liệu, phụ thuộc phi chức năng và không nhất quán dữ liệu.

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
    
Trong bảng trên, cột "ProjectName" phụ thuộc vào cả khóa chính {"EmployeeId", "ProjectId"} và không phụ thuộc vào bất kỳ trường phi khóa nào khác. 

Vì vậy, không cần thực hiện thay đổi.

---

### 💥 Third Normal Form (3NF)

*   Để đạt được 3NF, bảng cần thỏa mãn các điều kiện sau:
    
    *   Cần đạt được 2NF.
    *   Tất cả các trường phi khóa không được phụ thuộc vào nhau: Điều này có nghĩa là không có sự phụ thuộc không cần thiết giữa các trường phi khóa.

Nếu có sự phụ thuộc không cần thiết giữa các trường phi khóa, ta cần tách bảng thành các bảng riêng biệt để loại bỏ sự phụ thuộc không cần thiết này. Bằng cách này, ta giảm thiểu sự phụ thuộc không cần thiết, loại bỏ sự lặp lại dữ liệu và đảm bảo tính nhất quán trong cơ sở dữ liệu.

3NF là một bước tiến quan trọng trong việc chuẩn hóa cơ sở dữ liệu và giúp cải thiện tính nhất quán, hiệu quả và khả năng bảo trì của cơ sở dữ liệu.


*   Cách làm như sau:

Trong bảng trên, cột "Salary" phụ thuộc vào cả khóa chính {"EmployeeId", "ProjectId"} và cột "Grade" không phụ thuộc vào cả khóa chính. Vì vậy, ta cần tách bảng thành hai bảng riêng biệt.

**📰 Bảng "Employees":**

| EmployeeId | EmployeeName |
|------------|--------------|
| 142        | John         |
| 168        | James        |
| 263        | Andrew       |
| 109        | Bob          |

**📰 Bảng "Projects":**

| ProjectId | ProjectName |
|-----------|-------------|
| 113       | BLUE STAR   |
| 124       | MAGNUM      |

**📰 Bảng "EmployeeProjects":**

| EmployeeId | ProjectId | Grade | Salary |
|------------|-----------|-------|--------|
| 142        | 113       | A     | 20,000 |
| 142        | 124       | A     | 20,000 |
| 168        | 113       | B     | 15,000 |
| 263        | 113       | C     | 10,000 |
| 109        | 124       | C     | 10,000 |

---

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