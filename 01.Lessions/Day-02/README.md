# Day 02 

## 💛Session 02 - Normalization

### 💥 Các bước phân tích, thiết kế CSDL

Trong thiết kế CSDL SQL Server, các khái niệm Normal 1 (1NF), Normal 2 (2NF) và Normal 3 (3NF) liên quan đến quy tắc bảo toàn tính nguyên vẹn dữ liệu trong quá trình lưu trữ và truy xuất dữ liệu. Dưới đây là giải thích cho từng khái niệm:

1. Normal 1 (1NF - First Normal Form): Đây là mức độ cơ bản nhất của chuẩn hóa dữ liệu. Theo quy tắc 1NF, một bảng được coi là tuân thủ khi không có giá trị lặp lại trong bất kỳ cột nào và mỗi cột chỉ chứa một giá trị duy nhất. Nó loại bỏ sự lặp lại và không cho phép các trường có nhiều giá trị.

2. Normal 2 (2NF - Second Normal Form): 2NF áp dụng khi dữ liệu trong bảng đã tuân thủ 1NF. Nó yêu cầu rằng một bảng phải có một khóa chính duy nhất và tất cả các cột phi khóa phải phụ thuộc vào toàn bộ khóa chính. Điều này đảm bảo rằng mọi cột phi khóa liên quan chức năng duy nhất với toàn bộ khóa chính, giúp loại bỏ sự phụ thuộc phi chức năng.

3. Normal 3 (3NF - Third Normal Form): 3NF áp dụng khi dữ liệu trong bảng đã tuân thủ 2NF. Quy tắc 3NF yêu cầu rằng mọi cột phi khóa phải phụ thuộc trực tiếp vào khóa chính, không được phụ thuộc vào nhau. Điều này đảm bảo rằng dữ liệu không có sự phụ thuộc chéo giữa các cột phi khóa và giúp giảm thiểu sự trùng lặp và các vấn đề liên quan đến cập nhật dữ liệu không nhất quán.

Các nguyên tắc chuẩn hóa này giúp tăng tính nhất quán, hiệu quả và dễ quản lý cho CSDL SQL Server, giúp tránh các vấn đề như sự lặp lại dữ liệu, phụ thuộc phi chức năng và không nhất quán dữ liệu.

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
    *   Xác định khóa cho mỗi hàng.
*   Cách làm như sau:
    
    *   Tách bảng thành hai bảng riêng biệt: một bảng cho thông tin về nhân viên (Employees) và một bảng cho thông tin về dự án (Projects).
    *   Bảng Employees:
        *   Các cột trong bảng Employees sẽ bao gồm: EmployeeId, EmployeeName, Grade và Salary, ProjectId.
        *   Trong bảng Employees, EmployeeId và ProjectId sẽ là khóa chính (primary key) để định danh mỗi nhân viên một cách duy nhất.
    *   Bảng Projects:
        *   Các cột trong bảng Projects sẽ bao gồm: ProjectId và ProjectName.
        *   Trong bảng Projects, ProjectId sẽ là khóa chính (primary key) để định danh mỗi dự án một cách duy nhất.
        
**📰 Bảng Employees**

| EmployeeId | ProjectId | EmployeeName | Grade | Salary |
|------------|-----------|--------------|-------|--------|
| 142        | 113       | John         | A     | 20,000 |
| 142        | 124       | John         | A     | 20,000 |
| 168        | 113       | James        | B     | 15,000 |
| 263        | 113       | Andrew       | C     | 10,000 |
| 109        | 124       | Bob          | C     | 10,000 |

**📰 Bảng Projects**

| ProjectId | ProjectName |
|-----------|-------------|
| 113       | BLUE STAR   |
| 124       | MAGNUM      |

---

### 💥 Second Normal Form (2NF)

*   Để đạt được 2NF, bảng cần thỏa mãn các điều kiện sau:
    
    *   Cần đạt được 1NF.
    *   Các cột không phải là khóa chính (non-key columns) phải phụ thuộc vào toàn bộ khóa chính (entire primary key).
    *   Xây dựng mối quan hệ giữa các bảng.
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
    *   Tất cả các thuộc tính không khóa trong 3NF được yêu cầu là phải phụ thuộc trực tiếp vào mỗi khóa của quan hệ
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

## 💛Session 03 - Introduction to SQL Server 2019

- Cách cài đặt phần mềm
  - SQL SERVER 2019 EXPRESS EDITION: https://go.microsoft.com/fwlink/p/?linkid=2216019&culture=en-us&country=ww
  - SQL SERVER MANAGEMENT STUDIO (SSMS): https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

- Hướng dẫn cài đặt: https://diadem.in/blog/sql-server-2019-express-installation

- Sử dụng phần mềm cơ bản 

## 💛 HomeWork Guide - Normalization