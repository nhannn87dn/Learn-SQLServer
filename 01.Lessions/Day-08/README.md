# Day 08

## 💛 Session 14 - Transactions

### 💥 Transaction là gì?

Transaction là một tập hợp các hoạt động được thực hiện như một đơn vị không thể chia rời. Mục tiêu chính của transaction là đảm bảo tính toàn vẹn và nhất quán của dữ liệu trong cơ sở dữ liệu trong quá trình thực hiện các hoạt động.

Transaction được sử dụng để thực hiện các thay đổi dữ liệu trong cơ sở dữ liệu, bao gồm cả việc chèn, cập nhật và xóa dữ liệu. Một transaction bao gồm ít nhất hai hoặc nhiều hơn các hoạt động dữ liệu và được xem là một đơn vị làm việc hoàn chỉnh.

Nếu một hoặc nhiều hoạt động trong transaction gặp lỗi, toàn bộ transaction sẽ bị hủy và dữ liệu sẽ được phục hồi về trạng thái ban đầu.

Transaction được xác định bằng ba tính chất ACID:

1. Atomicity (Toàn vẹn): Transaction được coi là một đơn vị toàn vẹn không thể chia rời. Nếu một phần của transaction gặp lỗi, toàn bộ transaction sẽ bị hủy và dữ liệu sẽ trở về trạng thái ban đầu.

2. Consistency (Nhất quán): Một transaction phải đảm bảo rằng dữ liệu sẽ được đưa về trạng thái nhất quán sau khi hoàn thành. Nếu dữ liệu không tuân thủ các ràng buộc hoặc quy tắc, transaction sẽ bị hủy.

3. Isolation (Cô lập): Mỗi transaction phải thực hiện một cách cô lập và không bị tác động bởi các transaction khác đang thực hiện đồng thời. Điều này đảm bảo tính nhất quán của dữ liệu và tránh xảy ra xung đột.

4. Durability (Bền vững): Một khi một transaction đã được hoàn thành thành công, các thay đổi dữ liệu phải được lưu trữ vĩnh viễn và không bị mất trong trường hợp xảy ra sự cố hệ thống.

Các ứng dụng của transaction:

- Transaction được sử dụng để đảm bảo tính toàn vẹn của dữ liệu trong các ứng dụng doanh nghiệp.
- Transaction có thể được sử dụng để thực hiện các thao tác như: chuyển tiền, thanh toán hóa đơn, đặt hàng, ...

---

### 💥 Các lệnh quản lý transaction

- **BEGIN TRANSACTION** : Dùng để bắt đầu một transaction.

- **COMMIT TRANSACTION** : Dùng để xác nhận toàn bộ một transaction.

- **COMMIT WORK** : Dùng để đánh đấu kết thúc của transaction.

- **SAVE TRANSACTION** : Dùng để tạo một savepoint trong transaction.

- **ROLLBACK WORK** : Dùng để hủy bỏ một transaction.

- **ROLLBACK TRANSACTION** : Dùng để hủy bỏ toàn bộ một transaction.

- **ROLLBACK TRANSACTION [SavepointName]** : Dùng để hủy bỏ một savepoint trong transaction

---

Xem Thêm: <https://learn.microsoft.com/en-us/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16>

### 💥 Cách sử dụng transaction

Để bắt đầu một transaction bạn sử dụng từ khóa `BEGIN TRANSACTION` hoặc `BEGIN TRAN`

```sql
-- Bước 1:  start a transaction
BEGIN TRANSACTION; -- or BEGIN TRAN

-- Bước 2:  Các câu lênh truy vấn bắt đầu ở đây INSERT, UPDATE, and DELETE

-- =====================
-- Chạy xong các câu lệnh trên thì bạn kết thúc TRANSACTION với 1 trong 2 hình thức.
-- =====================

-- Bước 3 -  1. commit the transaction
-- Để xác nhận thay đổi dữ liệu
COMMIT;

-- Bước 3 - 2. rollback -- Hồi lại những thay đổi trong những câu lệnh truy vấn ở trên. (Hủy ko thực hiện nữa, trả lại trạng thái ban đầu lúc chưa chạy)
ROLLBACK;
```

Về bản chất các câu lệnh truy vấn trên nó chưa được ghi nhận thay đổi vào dữ liệu thật mà nó tạo ra dữ liệu tạm trước.

Sau đó dựa vào Bước 3, chờ bạn quyết định như thế nào với dữ liệu tạm đó, thì nó mới chính thức đi cập nhật thay đổi với dữ liệu thật.

Ví dụ: Tạo 2 bảng mới `invoices` và `invoice_items`

```sql
-- Hóa đơn
CREATE TABLE invoices (
  id int IDENTITY(1,1) PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);
-- Chi tiết các mục ghi vào hóa đơn
CREATE TABLE invoice_items (
  id int IDENTITY(1,1),
  invoice_id int NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(18, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id),
  FOREIGN KEY (invoice_id) REFERENCES invoices (id)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);
```

Bây giờ chúng ta tạo một `TRANSACTION` thực hiện thêm mới dữ liệu vào cho 2 table cùng lúc:

```sql
-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
INSERT INTO dbo.invoices (customer_id, total)
VALUES (100, 0);
-- Thêm vào invoice_items
 INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Keyboard', 70, 0.08),
       (1, 'Mouse', 50, 0.08);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT
```

Kết quả của một tập hợp các câu lệnh truy vấn trên:

- Nếu 1 trong 3 câu lệnh THẤT BẠI ==> Tất cả sẽ đều THẤT BẠI, trả lại trạng thái ban đầu.
- Nếu cả 3 THÀNH CÔNG ==> TRANSACTION thành công, dữ liệu được cập nhật.

Bạn có thể TEST trường hợp thất bại với câu lệnh INSERT bị lỗi

```sql
--Check dữ liệu của 2 table trước khi thực hiện
select * from invoices
select * from invoice_items

-- Bước 1
BEGIN TRANSACTION; -- or BEGIN TRAN
-- Bước 2
-- Thêm vào invoices
INSERT INTO dbo.invoices (customer_id, total)
VALUES (100, 0);
--Trường ID đã khai báo IDENTITY nên bạn không thể khai báo chi tiết giá trị của id khi thêm mới
--Câu lệnh này sẽ gây lỗi IDENTITY_INSERT is set to OFF
 INSERT INTO dbo.invoice_items (id, invoice_id, item_name, amount, tax)
VALUES (3, 1, 'Keyboard v2 ', 70, 0.08),
       (4, 1, 'Mouse v2 ', 50, 0.08);
-- Thay đổi dữ liệu cho record đã chèn vào invoices
UPDATE dbo.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION; -- or COMMIT


--Check dữ liệu của 2 table SAU khi thực hiện
select * from invoices
select * from invoice_items
```

Bạn có thể kiểm tra dữ liệu, Chỉ cần 1 trong 3 câu lệnh bị lỗi thì toàn bộ transaction sẽ bị hủy.

Ví dụ 2:

```sql
-- Bước 1
BEGIN TRANSACTION;
-- Bước 2
-- Thêm vào invoice_items

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Headphone', 80, 0.08),
       (1, 'Mainboard', 30, 0.08);

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'TochPad', 20, 0.08),
       (1, 'Camera', 90, 0.08);

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Wifi', 120, 0.08),
       (1, 'Bluetooth', 20, 0.08);

--Bước 3: xác nhận HỦY thay đổi dữ liệu
ROLLBACK TRANSACTION;
```

- Các câu lệnh ở Bước 2: vẫn chạy, và đưa vào dữ liệu tạm
- Đến Bước 3, gặp câu lệnh `ROLLBACK` thì dữ liệu tạm bị HỦY, việc INSERT dữ liệu không được ghi nhận.

Ví dụ 3:

```sql
-- Bước 1
BEGIN TRANSACTION;
-- Bước 2
-- Thêm vào invoice_items

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Headphone', 80, 0.08),
       (1, 'Mainboard', 30, 0.08);

SAVE TRANSACTION Savepoint1

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'TochPad', 20, 0.08),
       (1, 'Camera', 90, 0.08);

ROLLBACK TRANSACTION Savepoint1

INSERT INTO dbo.invoice_items (invoice_id, item_name, amount, tax)
VALUES (1, 'Wifi', 120, 0.08),
       (1, 'Bluetooth', 20, 0.08);

--Bước 3: xác nhận cho phép thay đổi dữ liệu
COMMIT TRANSACTION
```

`SAVE TRANSACTION` - Nó cho phép lưu lại trạng thái hiện tại của transaction và tiếp tục thực hiện các hoạt động trong transaction. Nếu sau đó có lỗi xảy ra, bạn có thể sử dụng lệnh ROLLBACK để hủy bỏ toàn bộ transaction hoặc sử dụng lệnh ROLLBACK TRANSACTION để hủy bỏ đến điểm đã được lưu trữ bởi SAVE TRANSACTION.

Ví dụ 4:

```sql

--Mô phỏng chuyển tiền ngân hàng từ người a, sang người b

--Tạo table bank
CREATE TABLE bank
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(20),
    balance DECIMAL(10,2)
)
--Ghi log giao dich
CREATE TABLE bank_log
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    note NVARCHAR(500)
)

--chèn dữ liệu ban đầu cho a và b
INSERT bank
    (name,balance)
VALUES
    ('a', 250),
    ('b', 0)

/*
Để thực hiện chuyển 50USD từ a --> b cần các bước:
1. Trừ tiền người a: 50
2. Ghi log lịch sử transaction
3. Cộng tiền người b: 50
4. Ghi log lịch sử transaction

==> 4 bước trên được coi là 1 transaction trong ngân hàng
==> Chỉ cần 1 trong 4 lệnh trên lỗi thì transaction được coi là không thành công.
==> Trạng thái sẽ được khôi phục lại như khi chưa thực hiện transaction
*/

BEGIN TRANSACTION;

BEGIN TRY
    -- b1. Trừ tiền người a: 50
    UPDATE bank SET balance = balance - 50 WHERE name = 'a';

    -- b2. Ghi log lịch sử transaction
    INSERT INTO bank_log (note)
    VALUES ('Chuyen tien tu a sang 5, 50USD');

    -- b3. Cộng tiền người b: 50
    UPDATE bank SET balance = balance + 50 WHERE name = 'b';

    -- b4. Ghi log lịch sử transaction
    INSERT INTO bank_log (id, note)
    VALUES (2, 'Nhan tien tu nguoi a, 50USD');

    -- Nếu không có lỗi, xác nhận transaction
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Xử lý lỗi
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

    -- Nếu có lỗi, hủy bỏ transaction
    ROLLBACK TRANSACTION;
END CATCH

```

### 💥 SET XACT_ABORT ON

Khi `SET XACT_ABORT ON` được thiết lập, nếu một lỗi xảy ra trong một giao dịch, nó sẽ tự động kết thúc giao dịch đó và rollback (hoàn tác). Tất cả các thay đổi đã được thực hiện trong giao dịch. Điều này đảm bảo tính toàn vẹn dữ liệu và giúp tránh tình trạng dữ liệu không nhất quán.

---

### 💥 `@@TRANCOUNT` trong SQL Server

`@@TRANCOUNT` là một hàm hệ thống trong SQL Server trả về số lượng giao dịch đang hoạt động trong phiên hiện tại. Nó giúp bạn kiểm tra mức độ lồng nhau của các giao dịch và xác định xem có giao dịch nào đang mở hay không.

#### Các tình huống sử dụng `@@TRANCOUNT`

1. **Kiểm tra trạng thái giao dịch**:
   - Bạn có thể sử dụng `@@TRANCOUNT` để kiểm tra xem có giao dịch nào đang mở trước khi thực hiện các thao tác như COMMIT hoặc ROLLBACK.
2. **Quản lý giao dịch lồng nhau**:
   - Trong các giao dịch lồng nhau, `@@TRANCOUNT` giúp xác định mức độ lồng nhau của các giao dịch, từ đó quản lý chúng một cách hiệu quả.

#### Ví dụ về `@@TRANCOUNT`

**Ví dụ 1: Kiểm tra số lượng giao dịch đang hoạt động**

```sql
-- Kiểm tra số lượng giao dịch đang hoạt động trước khi bắt đầu một giao dịch mới
SELECT @@TRANCOUNT AS TranCountBefore;

-- Bắt đầu một giao dịch mới
BEGIN TRANSACTION;

-- Kiểm tra số lượng giao dịch đang hoạt động sau khi bắt đầu giao dịch
SELECT @@TRANCOUNT AS TranCountAfterBegin;

-- Hoàn thành giao dịch
COMMIT;

-- Kiểm tra số lượng giao dịch đang hoạt động sau khi hoàn thành giao dịch
SELECT @@TRANCOUNT AS TranCountAfterCommit;
```

**Kết quả**:

```
TranCountBefore  |  TranCountAfterBegin  |  TranCountAfterCommit
-----------------------------------------------------------------
        0        |            1          |           0
```

**Ví dụ 2: Giao dịch lồng nhau**

```sql
-- Kiểm tra số lượng giao dịch đang hoạt động ban đầu
SELECT @@TRANCOUNT AS TranCountInitial;

-- Bắt đầu giao dịch ngoài cùng
BEGIN TRANSACTION;
SELECT @@TRANCOUNT AS TranCountAfterOuterBegin;

-- Bắt đầu giao dịch lồng nhau
BEGIN TRANSACTION;
SELECT @@TRANCOUNT AS TranCountAfterNestedBegin;

-- Hoàn thành giao dịch lồng nhau
COMMIT;
SELECT @@TRANCOUNT AS TranCountAfterNestedCommit;

-- Hoàn thành giao dịch ngoài cùng
COMMIT;
SELECT @@TRANCOUNT AS TranCountAfterOuterCommit;
```

**Kết quả**:

```
TranCountInitial  |  TranCountAfterOuterBegin  |  TranCountAfterNestedBegin  |  TranCountAfterNestedCommit  |  TranCountAfterOuterCommit
--------------------------------------------------------------------------------------------------------------------------------------
        0         |             1              |              2              |              1               |              0
```

#### Ghi chú

- **Giao dịch lồng nhau**: Khi bắt đầu giao dịch bên trong một giao dịch hiện tại, giá trị của `@@TRANCOUNT` sẽ tăng lên. Tuy nhiên, chỉ khi giao dịch ngoài cùng được commit hoặc rollback, tất cả các thay đổi mới được áp dụng hoặc hủy bỏ.
- **COMMIT và ROLLBACK**: Khi gọi COMMIT, `@@TRANCOUNT` giảm đi 1. Khi gọi ROLLBACK, `@@TRANCOUNT` giảm xuống 0, nghĩa là tất cả các giao dịch mở hiện tại đều bị hủy bỏ.

#### Kết luận

`@@TRANCOUNT` là công cụ hữu ích để quản lý các giao dịch trong SQL Server, đặc biệt khi làm việc với các giao dịch lồng nhau hoặc khi cần kiểm tra trạng thái của các giao dịch hiện tại. Sử dụng `@@TRANCOUNT` giúp bạn kiểm soát tốt hơn và tránh các lỗi không mong muốn liên quan đến giao dịch.

---

### 💥 Các chế độ thực hiện transaction như sau

1. **Autocommit Transactions**:

Mặc định là chế độ này.

Khi ở chế độ `Autocommit Transactions`, mỗi lệnh DML (Data Manipulation Language) như `INSERT`, `UPDATE`, `DELETE` tự động bắt đầu một transaction ngầm định. Ở chế độ này cấu hình là: `SET IMPLICIT_TRANSACTIONS OFF`

Nếu lệnh DML hoàn thành thành công, SQL Server sẽ tự động COMMIT transaction. Nếu có lỗi xảy ra, SQL Server sẽ tự động ROLLBACK transaction.

Lưu ý rằng các lệnh điều khiển transaction chỉ được sử dụng với các lệnh thao tác dữ liệu DML như `INSERT`, `UPDATE` và `DELETE`. Chúng không thể được sử dụng trong lệnh `CREATE TABLE` hoặc `DROP TABLE` vì các hoạt động này được tự động được commit trong cơ sở dữ liệu.

2. **Explicit Transactions**: Mỗi transaction explicit (tường minh) bắt đầu với câu lệnh `BEGIN TRANSACTION` và kết thúc bằng `ROLLBACK` hoặc `COMMIT` transaction. Trong một explicit transaction, bạn có toàn quyền kiểm soát thời điểm bắt đầu và kết thúc giao dịch.

3. **Implicit Transactions**: Một transaction tự động bắt đầu mà không cần lệnh `BEGIN TRANSACTION`, nhưng bạn vẫn cần kết thúc chúng bằng lệnh `COMMIT` hoặc `ROLLBACK`. Chế độ này được kích hoạt bằng cách sử dụng SET `IMPLICIT_TRANSACTIONS ON`. Mỗi lệnh SQL đầu tiên sau khi lệnh trước đó được kết thúc sẽ tự động bắt đầu một giao dịch mới.

4. **Batch-scoped Transactions**: Chỉ áp dụng cho các tập kết quả hoạt động đa dạng (MARS), một transaction SQL rõ ràng hoặc ngầm định bắt đầu dưới một phiên MARS trở thành một transaction phạm vi batch.

---

### 💥 Các chế độ thực hiện transaction như sau

**Isolation levels** trong SQL Server xác định mức độ cách ly giữa các giao dịch đang thực thi. Mỗi isolation level xác định cách một giao dịch có thể nhìn thấy các thay đổi do các giao dịch khác thực hiện. Dưới đây là các isolation levels trong SQL Server:

#### 1. Read Uncommitted

- **Mô tả**: Giao dịch có thể đọc các thay đổi chưa được commit từ các giao dịch khác, dẫn đến hiện tượng "dirty read".
- **Ưu điểm**: Nhanh nhất, không khóa các tài nguyên.
- **Nhược điểm**: Có thể dẫn đến dữ liệu không nhất quán và lỗi.

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
```

Ví dụ:

Giao dịch 1: Chuyển 50 USD từ tài khoản A sang tài khoản B
Giao dịch 2: Đọc số dư của tài khoản A và B

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
-- Chưa commit

-- Giao dịch 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Có thể đọc số dư đã bị trừ 50 USD mặc dù Giao dịch 1 chưa commit

```

Giao dịch có thể đọc các thay đổi chưa được commit từ các giao dịch khác, dẫn đến hiện tượng "dirty read".

#### 2. Read Committed

- **Mô tả**: Giao dịch chỉ có thể đọc các thay đổi đã được commit từ các giao dịch khác. Đây là mức cách ly mặc định trong SQL Server.
- **Ưu điểm**: Tránh được hiện tượng "dirty read".
- **Nhược điểm**: Có thể dẫn đến hiện tượng "non-repeatable read" và "phantom read".

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

Ví dụ:

Giao dịch 1: Chuyển 50 USD từ tài khoản A sang tài khoản B
Giao dịch 2: Đọc số dư của tài khoản A và B

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
-- Chưa commit

-- Giao dịch 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Không thể đọc số dư bị trừ 50 USD cho đến khi Giao dịch 1 commit

```

Giao dịch chỉ có thể đọc các thay đổi đã được commit từ các giao dịch khác. Đây là mức cách ly mặc định trong SQL Server.

#### 3. Repeatable Read

- **Mô tả**: Đảm bảo rằng nếu một giao dịch đọc dữ liệu một lần, nó sẽ thấy cùng dữ liệu đó nếu nó đọc lại trong cùng một giao dịch (ngăn chặn "non-repeatable read").
- **Ưu điểm**: Tránh được hiện tượng "dirty read" và "non-repeatable read".
- **Nhược điểm**: Có thể dẫn đến hiện tượng "phantom read".

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

Ví dụ:

Giao dịch 1: Chuyển 50 USD từ tài khoản A sang tài khoản B
Giao dịch 2: Đọc số dư của tài khoản A và B hai lần

```sql
-- Giao dịch 2
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Lần đọc đầu tiên

-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
COMMIT;

-- Giao dịch 2
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Lần đọc thứ hai, vẫn thấy số dư như lần đọc đầu tiên
COMMIT;

```

Đảm bảo rằng nếu một giao dịch đọc dữ liệu một lần, nó sẽ thấy cùng dữ liệu đó nếu nó đọc lại trong cùng một giao dịch

#### 4. Serializable

- **Mô tả**: Giao dịch đảm bảo tính tuần tự, nghĩa là các giao dịch được thực hiện một cách tuần tự, một sau một (ngăn chặn cả "non-repeatable read" và "phantom read").
- **Ưu điểm**: Cung cấp mức độ cách ly cao nhất.
- **Nhược điểm**: Hiệu suất chậm nhất do các khóa lâu dài.

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

Ví dụ:

Giao dịch 1: Chuyển 50 USD từ tài khoản A sang tài khoản B
Giao dịch 2: Đọc và cập nhật số dư của tài khoản A

```sql
-- Giao dịch 2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Đọc số dư

-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A'; -- Sẽ bị khóa và chờ cho đến khi Giao dịch 2 hoàn thành
COMMIT;

-- Giao dịch 2
UPDATE dbo.bank SET balance = balance + 10 WHERE name = 'A'; -- Cập nhật số dư
COMMIT;

```

Giao dịch đảm bảo tính tuần tự, nghĩa là các giao dịch được thực hiện một cách tuần tự, một sau một.

#### 5. Snapshot

- **Mô tả**: Giao dịch đọc các bản sao nhất quán của dữ liệu tại thời điểm giao dịch bắt đầu. Giao dịch không bị khóa bởi các thay đổi chưa commit từ các giao dịch khác.
- **Ưu điểm**: Tránh được cả "dirty read", "non-repeatable read", và "phantom read".
- **Nhược điểm**: Sử dụng nhiều tài nguyên để lưu trữ các bản sao dữ liệu.

```sql
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
```

Ví dụ:

Giao dịch 1: Chuyển 50 USD từ tài khoản A sang tài khoản B
Giao dịch 2: Đọc số dư của tài khoản A và B trong cùng một thời điểm

```sql
-- Giao dịch 2
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRANSACTION;
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Đọc số dư tại thời điểm bắt đầu giao dịch

-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
COMMIT;

-- Giao dịch 2
SELECT balance FROM dbo.bank WHERE name = 'A'; -- Vẫn thấy số dư như tại thời điểm bắt đầu giao dịch
COMMIT;

```

Giao dịch đọc các bản sao nhất quán của dữ liệu tại thời điểm giao dịch bắt đầu

#### Tóm tắt các hiện tượng có thể xảy ra

- **Dirty Read**: Đọc dữ liệu chưa được commit từ một giao dịch khác.
- **Non-repeatable Read**: Dữ liệu thay đổi giữa các lần đọc trong cùng một giao dịch do các giao dịch khác commit thay đổi.
- **Phantom Read**: Kết quả của một truy vấn thay đổi vì một giao dịch khác đã thêm hoặc xóa hàng.

#### Bảng so sánh

| Isolation Level  | Dirty Read | Non-repeatable Read | Phantom Read |
| ---------------- | ---------- | ------------------- | ------------ |
| Read Uncommitted | Có         | Có                  | Có           |
| Read Committed   | Không      | Có                  | Có           |
| Repeatable Read  | Không      | Không               | Có           |
| Serializable     | Không      | Không               | Không        |
| Snapshot         | Không      | Không               | Không        |

Việc chọn isolation level phù hợp phụ thuộc vào yêu cầu về hiệu suất và tính nhất quán dữ liệu của ứng dụng.

### 💥 Locks

Trong SQL Server, locks (khóa) là cơ chế được sử dụng để kiểm soát truy cập và sửa đổi dữ liệu trong quá trình thực hiện các transaction. Khi một transaction yêu cầu truy cập vào dữ liệu, SQL Server áp dụng các locks trên dữ liệu tương ứng để đảm bảo tính nhất quán và độc lập của dữ liệu trong môi trường đa người dùng.

Có nhiều loại lock khác nhau trong SQL Server, bao gồm:

1. Shared Lock (Shared Read Lock):

   - Được sử dụng khi transaction muốn đọc (truy vấn) dữ liệu.
   - Nhiều shared locks có thể được áp dụng trên cùng một dữ liệu.
   - Shared locks không ngăn được các shared locks khác trên cùng một dữ liệu.
   - Shared locks không cho phép exclusive lock được áp dụng lên dữ liệu.

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
SELECT * FROM dbo.bank WHERE name = 'A';
-- Shared lock được đặt trên bảng `bank`

-- Giao dịch 2
BEGIN TRANSACTION;
SELECT * FROM dbo.bank WHERE name = 'A';
-- Cũng đặt shared lock trên bảng `bank` và không gây xung đột với Giao dịch 1

COMMIT; -- Kết thúc giao dịch 1
COMMIT; -- Kết thúc giao dịch 2

```

2. Exclusive Lock (Write Lock):

   - Được sử dụng khi transaction muốn thay đổi (ghi) dữ liệu.
   - Không thể có bất kỳ shared locks hoặc exclusive locks khác trên cùng một dữ liệu.
   - Exclusive locks ngăn cả shared locks và exclusive locks khác.

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
-- Exclusive lock được đặt trên bảng `bank`

-- Giao dịch 2
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance + 50 WHERE name = 'A';
-- Giao dịch 2 phải chờ cho đến khi Giao dịch 1 kết thúc vì exclusive lock

COMMIT; -- Kết thúc giao dịch 1
-- Giao dịch 2 bây giờ có thể tiếp tục và đặt exclusive lock

COMMIT; -- Kết thúc giao dịch 2

```

3. Update Lock:

   - Được sử dụng trong các trường hợp cần đảm bảo rằng dữ liệu không được đọc hoặc chỉnh sửa trong quá trình thực hiện transaction.
   - Update locks được nâng cấp thành exclusive lock khi transaction cần thực hiện các thay đổi.

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
SELECT * FROM dbo.bank WITH (UPDLOCK) WHERE name = 'A';
-- Update lock được đặt trên bảng `bank`

-- Giao dịch 2
BEGIN TRANSACTION;
SELECT * FROM dbo.bank WITH (UPDLOCK) WHERE name = 'A';
-- Giao dịch 2 phải chờ cho đến khi Giao dịch 1 hoàn thành vì update lock

COMMIT; -- Kết thúc giao dịch 1
-- Giao dịch 2 bây giờ có thể tiếp tục và đặt update lock

COMMIT; -- Kết thúc giao dịch 2

```

4. Intent Lock:

   - Là các locks nhỏ hơn được áp dụng trên các cấu trúc dữ liệu phức tạp hơn như bảng, trang, phân vùng.
   - Intent locks đại diện cho ý định của transaction để áp dụng shared locks hoặc exclusive locks trên các đối tượng con của cấu trúc dữ liệu.

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
SELECT * FROM dbo.bank WHERE name = 'A';
-- Intent shared lock (IS) được đặt trên bảng `bank`

-- Giao dịch 2
BEGIN TRANSACTION;
UPDATE dbo.bank SET balance = balance - 50 WHERE name = 'A';
-- Intent exclusive lock (IX) được đặt trên bảng `bank`

COMMIT; -- Kết thúc giao dịch 1
-- Giao dịch 2 có thể tiếp tục và đặt exclusive lock trên hàng cụ thể

COMMIT; -- Kết thúc giao dịch 2

```

5. Schema Lock:
   - Được sử dụng khi transaction thay đổi cấu trúc của cơ sở dữ liệu như tạo, sửa đổi hoặc xóa bảng, quyền truy cập, thủ tục lưu trữ, v.v.

SQL Server cũng hỗ trợ các mức độ khóa khác nhau như row-level locks (khóa mức hàng), page-level locks (khóa mức trang) và table-level locks (khóa mức bảng) để tối ưu hiệu suất và sử dụng tài nguyên. Hệ thống quản lý locks trong SQL Server đảm bảo tính nhất quán và độc lập của dữ liệu trong quá trình thực hiện các transaction đồng thời.

```sql
-- Giao dịch 1
BEGIN TRANSACTION;
SELECT * FROM dbo.bank;
-- Schema stability lock (Sch-S) được đặt trên bảng `bank`

-- Giao dịch 2
BEGIN TRANSACTION;
ALTER TABLE dbo.bank ADD COLUMN new_column INT;
-- Schema modification lock (Sch-M) phải chờ cho đến khi Sch-S lock được giải phóng

COMMIT; -- Kết thúc giao dịch 1
-- Giao dịch 2 có thể tiếp tục và đặt schema modification lock

COMMIT; -- Kết thúc giao dịch 2
```

---

### 💥 Xử lý Locks

Ví dụ giả lập tình trạng Lock trong thực tế có thể xảy ra làm TREO CPU

1. Mở một cùng lúc 2 cửa sổ Query như sau

![lock](img/lock.png)

- Cửa sổ 1: chạy lệnh UPDATE số dư của người a
- Cửa sổ 2: Xóa người a

2. Bạn thực hiện tuần từ 1 xong đến 2. Bạn sẽ thấy trạng thái `Executing query...` xoay miết không ngừng. ==> Transaction này đã bị TREO.

Lí do là bên cửa sổ 1. Transaction đã chạy rồi, nhưng không có lệnh để đóng transaction lại. ==> Thể hiện transaction chưa thực hiện xong.

==> Đó là hiện tượng LOCKED

Làm sao để xử lý Lock để Server không bị ĐƠ (Quá tải CPU)

Bạn hãy mở thêm một instance Server mới

1. Kích phải lên instance chọn `Activity Monitor`

![lock process](img/lock-2.png)

2. Xổ mục Processes ra để xem danh sách các tiến trình đang chạy
3. Tại mục 3, click đúp 2 lần vào cột `Blocked by` để sắp xếp giảm dần.

Như hình bạn thấy dòng `Session ID` 64 đang lock một session có giá trị 53.

Bạn có thể click phải lên các dòng và chọn `Detail` để xem chi tiết câu lệnh SQL đang thực hiện.

4. Để xử lí LOCK bạn có thể thực hiện `Kill Process` bằng cách click phải lên dòng bị lock. Trong trường hợp trên thì dòng `53` bị lock bởi `64`. Sau đó chọn `Kill Process`

5. Quay lại màn hình truy vấn trước đó. Bạn sẽ thấy cửa số 2 đã có trạng thái `disconect`. Kết nối này bị đóng.

![kill process](img/lock-3.png)

---

## 💛 Session 12 - Triggers

### 💥 Trigger là gì?

- Trigger là một đối tượng trong SQL Server, nó được sử dụng để thực thi một tập hợp các câu lệnh SQL khi một sự kiện xảy ra. Sự kiện có thể là một câu lệnh INSERT, UPDATE hoặc DELETE. Trigger có thể được kích hoạt trước hoặc sau khi sự kiện xảy ra.

- Không giống như stored procedure, trigger không được gọi bởi một ứng dụng hoặc một người dùng. Trigger được kích hoạt bởi một sự kiện như INSERT, UPDATE, DELETE và không thể được gọi như một stored procedure

## Xem Doc: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16

### 💥 DML Trigger

Là loại trigger được kích hoạt bởi các câu lệnh DML như INSERT, UPDATE hoặc DELETE. Có hai loại DML trigger:

- **After trigger**: được kích hoạt sau khi sự kiện xảy ra.
- **Instead of trigger**: được kích hoạt thay thế cho sự kiện.

> Lưu ý: Có 2 bảng inserted và deleted được sử dụng trong trigger. Bảng inserted chứa các bản ghi được thêm vào bởi câu lệnh INSERT hoặc UPDATE. Table deleted chứa các bản ghi bị xóa bởi câu lệnh DELETE hoặc UPDATE.

Thứ tự thực thi của các DML trigger:

- Các trigger INSTEAD OF được kích hoạt trước.
- Các trigger AFTER được kích hoạt sau.

Xem thêm: https://learn.microsoft.com/en-us/sql/relational-databases/triggers/dml-triggers?view=sql-server-ver16

#### 🔹 AFTER Trigger

Cú pháp:

```sql
CREATE [OR ALTER] TRIGGER [schema_name.]trigger_name
ON table_name
AFTER  {[INSERT],[UPDATE],[DELETE]}
[NOT FOR REPLICATION]
AS
BEGIN
    {sql_statements}
END;
```

Ví dụ: Tình huống gặp trong thực tế. Khi có đơn đặt hàng, và đơn đã xác nhận thanh toán thành công, thì phải cập nhật trạng thái tồn kho giảm đi = số lượng sản phẩm có trong đơn hàng đã mua.

Và theo cách thông thường: Khi gọi câu lệnh cập nhật xác nhận thanh toán thành công. Bạn làm tiếp câu lệnh cập nhật số lượng tồn kho.

Thay vì thế chúng ta có thể tạo một Trigger thực hiện cập nhật tồn kho một cách tự động (chạy ngầm) khi một đơn hàng được xác nhận thanh toán thành công.

```sql

CREATE TRIGGER trg_OrderItems_Update_ProductStock
ON order_items
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        UPDATE stocks
            SET quantity = s.quantity - i.quantity
        FROM
        stocks as s
        INNER JOIN inserted AS i ON s.product_id = i.product_id
        INNER JOIN orders AS o ON o.order_id = i.order_id AND o.store_id = s.store_id;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
```

---

Ví dụ 2: Tạo một trigger AFTER để ngăn chặn việc cập nhật / xóa đơn hàng khi đơn hàng (orders) có trạng thái order_status = 4 (COMPLETED)

```sql
CREATE TRIGGER trg_Orders_Prevent_UpdateDelete
ON orders
AFTER UPDATE, DELETE -- Ngăn cách nhau bởi dấy phẩu khi có nhiều action
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot update order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh UPDATE trước đó vào orders
    END

    IF EXISTS (SELECT * FROM deleted WHERE [order_startus] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
    END
END;
```

Trong SQL Server, mỗi lệnh DML (Data Manipulation Language) như `INSERT`, `UPDATE`, `DELETE` tự động bắt đầu một transaction ngầm định, nên không cần phải gọi `BEGIN TRANSACTION` trước khi gọi ROLLBACK trong trigger.

Lệnh `ROLLBACK` sẽ hủy bỏ tất cả các thay đổi được thực hiện trong giao dịch hiện tại, bao gồm cả thay đổi được thực hiện bởi lệnh UPDATE hoặc DELETE đã kích hoạt trigger.

---

Ví dụ 3: Tạo một trigger AFTER để ngăn chặn việc cập nhật / thêm mới / xóa chi tiết đơn hàng (orders) có trạng thái order_status = 4 (COMPLETED)

```sql
CREATE OR ALTER TRIGGER trg_OrderItems_Prevent_InsertUpdateDelete
ON order_items
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM
        inserted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
        WHERE [order_status] = 4
    )
    BEGIN
        PRINT 'Cannot insert or update order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END

    IF EXISTS (
        SELECT * FROM
        deleted AS oi INNER JOIN dbo.orders AS o ON oi.order_id = o.order_id
    )
    BEGIN
        PRINT 'Cannot delete order details having order''s status = 4 (COMPLETED).'
        ROLLBACK
    END
END
```

#### 🔹 INSTEAD OF Trigger

INSTEAD OF trigger là một trigger cho phép bạn bỏ qua một câu lệnh INSERT, DELETE hoặc UPDATE đối với một bảng hoặc một view và thay vào đó thực thi các câu lệnh khác được định nghĩa trong trigger. Thực tế, việc INSERT, DELETE hoặc UPDATE không xảy ra.

```sql
CREATE OR ALTER TRIGGER [schema_name.]trigger_name
ON table_name
INSTEAD OF  {[INSERT],[UPDATE],[DELETE]}
[NOT FOR REPLICATION]
AS
BEGIN
    {sql_statements}
END
```

Ví dụ: Tạo một trigger INSTEAD OF để ngăn chặn việc thêm dữ liệu vào bảng customers

```sql
CREATE TRIGGER trg_customers_PreventInsert
ON customers
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Cannot insert data into the Customers table.'
END
```

---

### 💥 DDL Trigger

DDL Trigger được kích hoạt bởi sự kiện ở cấp độ Server hoặc Database.

Các sự kiện này được tạo ra bởi câu lệnh Transact-SQL thường bắt đầu bằng một trong các từ khóa sau: CREATE, ALTER, DROP, GRANT, DENY, REVOKE hoặc UPDATE STATISTICS.

Xem thêm: https://learn.microsoft.com/en-us/sql/relational-databases/triggers/ddl-triggers?view=sql-server-ver16

Các trigger DDL rất hữu ích trong các trường hợp sau:

- Ghi lại các thay đổi trong cấu trúc CSDL.
- Ngăn chặn một số thay đổi cụ thể trong cấu trúc CSDL.
- Phản hồi một thay đổi trong cấu trúc CSDL.

Lưu ý: Triggler loại này lưu ở `Databse Name --> Programmability --> Database Triggers`

Cấu trúc:

```sql
CREATE TRIGGER trigger_name
ON { DATABASE |  ALL SERVER}
[WITH ddl_trigger_option]
FOR {event_type | event_group }
AS {sql_statement}

```

Ví dụ:

**Cấu trúc bảng `bank`:**

```sql
CREATE TABLE bank (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50),
    balance DECIMAL(10, 2)
);

CREATE TABLE bank_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    note NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE()
);
```

---

**Trigger minh họa:**

```sql
CREATE TRIGGER trg_log_balance_changes
ON bank
AFTER UPDATE
AS
BEGIN
    -- Ghi log cho các thay đổi liên quan đến số dư
    INSERT INTO bank_log (note)
    SELECT 
        CONCAT(
            'Account ID: ', INSERTED.id,
            ', Old Balance: ', DELETED.balance,
            ', New Balance: ', INSERTED.balance,
            ', Name: ', INSERTED.name
        )
    FROM INSERTED
    INNER JOIN DELETED
    ON INSERTED.id = DELETED.id
    WHERE INSERTED.balance <> DELETED.balance; -- Chỉ log nếu số dư thay đổi
END;
```

---

**Giải thích:**

1. **`INSERTED`**:
   - Chứa bản ghi mới (sau khi cập nhật).
   - Phản ánh trạng thái hiện tại của các hàng được cập nhật.

2. **`DELETED`**:
   - Chứa bản ghi cũ (trước khi cập nhật).
   - Phản ánh trạng thái trước khi các hàng được cập nhật.

3. **Trigger hoạt động**:
   - Khi thực hiện lệnh `UPDATE`, SQL Server tạo hai bảng ảo là `INSERTED` và `DELETED` để lưu trữ các giá trị mới và cũ tương ứng.

---

**Ví dụ minh họa:**

**1. Thêm dữ liệu ban đầu:**

```sql
INSERT INTO bank (name, balance)
VALUES ('Alice', 500.00),
       ('Bob', 1000.00);
```

**2. Cập nhật số dư tài khoản:**

```sql
UPDATE bank
SET balance = 800.00
WHERE id = 1;
```

**3. Log được ghi trong bảng `bank_log`:**

```sql
SELECT * FROM bank_log;
```

**Kết quả:**

```
id | note                                                                | created_at
1  | Account ID: 1, Old Balance: 500.00, New Balance: 800.00, Name: Alice | 2024-11-23 10:00:00
```

---

### **Cách kiểm tra `INSERTED` và `DELETED`:**

Để dễ hiểu hơn, bạn có thể tạm thời xem nội dung của `INSERTED` và `DELETED` bằng cách sử dụng:

```sql
SELECT * FROM INSERTED;
SELECT * FROM DELETED;
```

Thêm dòng debug tạm thời vào trigger như sau:

```sql
CREATE TRIGGER trg_debug_inserted_deleted
ON bank
AFTER UPDATE
AS
BEGIN
    -- Hiển thị giá trị mới (INSERTED)
    SELECT * FROM INSERTED;

    -- Hiển thị giá trị cũ (DELETED)
    SELECT * FROM DELETED;

    -- Log ví dụ
    INSERT INTO bank_log (note)
    SELECT 
        CONCAT('Debug - New Balance: ', INSERTED.balance, ', Old Balance: ', DELETED.balance)
    FROM INSERTED
    INNER JOIN DELETED
    ON INSERTED.id = DELETED.id;
END;
```

Khi thực hiện `UPDATE`, nội dung của `INSERTED` và `DELETED` sẽ được hiển thị. 

---

**Tóm lại:**
- **`INSERTED`**: Chứa giá trị mới (sau `UPDATE`).
- **`DELETED`**: Chứa giá trị cũ (trước `UPDATE`). 
- Chúng giúp dễ dàng so sánh thay đổi trước và sau khi thực hiện cập nhật.

---

Ví dụ: Tạo một trigger để ngăn chặn việc xóa VÀ sửa bảng basket_a

```sql
CREATE TRIGGER trg_prevent_table_modifications
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA()
    DECLARE @ObjectName NVARCHAR(MAX)

    -- Lấy tên bảng từ EVENTDATA
    SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(MAX)')

    -- Kiểm tra nếu tên bảng là bảng cụ thể cần bảo vệ
    IF @ObjectName = 'basket_a'
    BEGIN
        RAISERROR ('Không được phép xóa hoặc sửa đổi bảng basket_a.', 16, 1)
        ROLLBACK
    END
END
-- Thực hiện lệnh thì báo lỗi
DROP table basket_a
```

Ví dụ 2: Tạo một trigger để ghi nhật ký sửa đổi cấu trúc bảng basket_a

```sql
-- Tạo table logs trước
CREATE TABLE dbo.logs (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    [Date] DATETIME,
    [User] NVARCHAR(100),
    [Host] NVARCHAR(100),
    [Action] NVARCHAR(100),
    [Table] NVARCHAR(100)
);

-- Thêm trigger
CREATE TRIGGER trg_prevent_table_modifications
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA()
    DECLARE @ObjectName NVARCHAR(MAX)

    -- Lấy tên bảng từ EVENTDATA
    SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(MAX)')

    -- Kiểm tra nếu tên bảng là bảng cụ thể cần bảo vệ
    IF @ObjectName = 'basket_a'
    BEGIN
        RAISERROR ('Không được phép xóa hoặc sửa đổi bảng basket_a.', 16, 1);

        BEGIN
            INSERT INTO dbo.logs ([Date], [User], [Host], [Action], [Table])
            SELECT GETDATE(), USER_NAME(), HOST_NAME(), 'DROP_TABLE OR ALTER_TABLE', 'basket_a'
        END
        
        ROLLBACK;
    END
END

```

---

### 💥 Logon Trigger

Xem Doc: https://learn.microsoft.com/en-us/sql/relational-databases/triggers/logon-triggers?view=sql-server-ver16

### 💥 Disable Trigger

Vô hiệu hóa hoạt động của một Trigger

```sql
DISABLE TRIGGER [schema_name.][trigger_name]
ON [object_name | DATABASE | ALL SERVER]

```

Vô hiệu hóa một trigger trên một table cụ thể

```sql
DISABLE TRIGGER tigger_name ON table_name;
```

Vô hiệu hóa tất cả trigger trên một table

```sql
DISABLE TRIGGER ALL ON table_name;
```

Vô hiệu hóa một trigger trên một Databse

```sql
DISABLE TRIGGER trigger_name ON DATABASE;
```

Vô hiệu hóa tất cả trigger trên một Databse

```sql
DISABLE TRIGGER ALL ON DATABASE;
```

---

### 💥 Enable Trigger

Kích hoạt lại Trigger

```sql
ENABLE TRIGGER [schema_name.][trigger_name]
ON [object_name | DATABASE | ALL SERVER]
```

---

### 💥 List ALl Triggers

Liệt kê danh sách tất cả Triggers

```sql
SELECT
    name,
    is_instead_of_trigger
FROM
    sys.triggers
WHERE
    type = 'TR';
```

---

### 💥 Delete Trigger

Cú pháp:

```sql
DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]
ON { DATABASE | ALL SERVER };
```

### 💥 Xem chi tiết Triggers

```sql
SELECT
    definition
FROM
    sys.sql_modules
WHERE
    object_id = OBJECT_ID('dbo.trg_customers_LogAlterTable');
--- Hoăc
EXEC sp_helptext 'dbo.trg_customers_LogAlterTable' ;

```

## 💛 Nguồn học Thêm

Xem từ:

- https://www.sqlservertutorial.net/sql-server-triggers/
