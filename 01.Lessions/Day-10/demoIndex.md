Dưới đây là **bài viết đầy đủ** theo yêu cầu: **giới thiệu về Index trong SQL Server**, kết hợp **so sánh hiệu suất trước và sau khi tạo index**, kèm **giải thích nguyên nhân chậm** dựa trên kế hoạch thực thi (Execution Plan).

---

# 📚 Hiểu về Index trong SQL Server qua ví dụ Before & After

## ✅ Index là gì?

**Index** (chỉ mục) trong SQL Server giống như mục lục trong sách. Nó giúp **tăng tốc độ truy vấn dữ liệu** bằng cách **giảm số lượng dòng phải quét** khi bạn `SELECT`, `JOIN`, hoặc `ORDER BY`.

---

## 🔍 So sánh Before vs After khi dùng Index

### 🧪 Setup dữ liệu: 1 triệu dòng không có index

```sql
-- Tạo bảng không có primary key, không index
CREATE TABLE Customers (
    Id INT IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    City NVARCHAR(50),
    CreatedAt DATETIME
);

-- Chèn dữ liệu demo
INSERT INTO Customers (FirstName, LastName, Email, City, CreatedAt)
SELECT TOP (1000000)
    'First' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    'Last' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR),
    'user' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR) + '@example.com',
    CASE ABS(CHECKSUM(NEWID()) % 5)
        WHEN 0 THEN 'Hanoi'
        WHEN 1 THEN 'Saigon'
        WHEN 2 THEN 'Danang'
        WHEN 3 THEN 'Hue'
        ELSE 'Cantho'
    END,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1000), GETDATE())
FROM master.dbo.spt_values t1
CROSS JOIN master.dbo.spt_values t2;
```

---

### 🧾 Truy vấn 1: Lọc theo `City = 'Hanoi'`

#### 🔴 Before (chưa có index)

```sql
SELECT * FROM Customers WHERE City = 'Hanoi';
```

#### ❌ Execution Plan:

* SQL Server phải **quét toàn bộ 1 triệu dòng (Table Scan)**.
* Thời gian truy vấn: **vài giây**.
* CPU tăng mạnh.
* Hiệu suất tệ nếu bảng càng lớn.

#### ✅ After (tạo index)

```sql
CREATE NONCLUSTERED INDEX IX_Customers_City ON Customers(City);

SELECT * FROM Customers WHERE City = 'Hanoi';
```

#### ✅ Execution Plan:

* Sử dụng **Index Seek** thay vì Table Scan.
* SQL Server **nhảy thẳng** đến phần dữ liệu chứa `'Hanoi'`.
* Truy vấn nhanh gấp nhiều lần.

> 💡 **Giải thích**: Index giống như bạn tìm từ khóa trong từ điển — chỉ vài bước là đến đúng chỗ thay vì phải lật từng trang.

---

### 🧾 Truy vấn 2: Tìm theo Email (là duy nhất)

#### 🔴 Before (không index, không ràng buộc)

```sql
SELECT * FROM Customers WHERE Email = 'user123456@example.com';
```

* Dù `Email` là duy nhất, SQL Server **vẫn quét toàn bảng** nếu không có index.

#### ✅ After (tạo Unique Index)

```sql
CREATE UNIQUE NONCLUSTERED INDEX IX_Customers_Email ON Customers(Email);

SELECT * FROM Customers WHERE Email = 'user123456@example.com';
```

* SQL Server dùng **Index Seek**, truy vấn gần như tức thì.

> 💡 **Giải thích**: Unique Index không chỉ giúp truy vấn nhanh hơn mà còn **ngăn dữ liệu trùng**.

---

### 🧾 Truy vấn 3: Lọc nhiều cột `City` và `Age`

```sql
-- Giả sử có thêm cột Age INT
ALTER TABLE Customers ADD Age INT;

-- Update random Age
UPDATE Customers SET Age = ABS(CHECKSUM(NEWID()) % 60 + 18);
```

#### 🔴 Before:

```sql
SELECT * FROM Customers WHERE City = 'Danang' AND Age = 25;
```

* SQL Server **scan toàn bộ bảng**, vì không có chỉ mục đa cột phù hợp.

#### ✅ After: Composite Index

```sql
CREATE NONCLUSTERED INDEX IX_Customers_City_Age ON Customers(City, Age);

SELECT * FROM Customers WHERE City = 'Danang' AND Age = 25;
```

* SQL Server dùng **Index Seek với filter chính xác**.

> 💡 **Giải thích**: Composite index hiệu quả khi truy vấn **lọc theo nhiều điều kiện đồng thời**.

```sql
SELECT * FROM Customers WHERE Age = 25 AND City = 'Danang';
```

- ❓ Về mặt cú pháp, câu SQL vẫn cho kết quả chính xác.

- ✅ Nhưng SQL Server vẫn sử dụng Index Seek như trên, vì toàn bộ điều kiện vẫn được cung cấp (City vẫn có trong điều kiện).

- 👉 Quan trọng: Thứ tự cột trong WHERE không ảnh hưởng nếu tất cả các cột trong index được dùng đầy đủ.

Nhưng nếu thiếu cột đầu tiên thì khác

Giả sử vẫn giữ index (City, Age), nhưng bạn chỉ lọc theo Age:

```sql
SELECT * FROM Customers WHERE Age = 25;
```
❌ SQL Server không thể sử dụng Index Seek cho Age, vì City là cột đầu tiên trong index, và nó bị bỏ qua.

👉 Kết quả: Table Scan hoặc Index Scan


---

### 🧾 Truy vấn 4: Chỉ lấy một vài cột (dạng "covering query")

#### 🔴 Before:

```sql
SELECT Email, City FROM Customers WHERE Email = 'user300000@example.com';
```

* SQL Server có thể dùng Index Seek nhưng vẫn cần **truy cập vào bảng chính (Key Lookup)** để lấy cột `City`.

#### ✅ After: Covering Index (Include)

```sql
CREATE NONCLUSTERED INDEX IX_Customers_Email_Include
ON Customers(Email)
INCLUDE (City);

SELECT Email, City FROM Customers WHERE Email = 'user300000@example.com';
```

* SQL Server **không cần truy cập bảng chính nữa**, vì mọi dữ liệu cần đều có trong index.

> 💡 **Giải thích**: Đây gọi là **Covering Index** — cực kỳ hiệu quả cho các truy vấn nhẹ chỉ đọc vài cột.



---

## 📈 Tổng kết so sánh hiệu suất

| Truy vấn                           | Trước (chậm)            | Sau khi có index (nhanh)   |
| ---------------------------------- | ----------------------- | -------------------------- |
| `WHERE City = 'Hanoi'`             | Table Scan              | Index Seek                 |
| `WHERE Email = ?`                  | Table Scan              | Index Seek + Unique        |
| `WHERE City AND Age`               | Table Scan              | Composite Index Seek       |
| `SELECT Email, City WHERE Email=?` | Index Seek + Key Lookup | Covering Index (no lookup) |

---

## ✅ Kết luận

* **Index giúp cải thiện hiệu suất** truy vấn rõ rệt, đặc biệt với các bảng lớn.
* Cần **phân tích thói quen truy vấn** để chọn loại index phù hợp.
* Đừng lạm dụng quá nhiều index: sẽ làm chậm khi **INSERT, UPDATE, DELETE** vì SQL Server phải cập nhật index.

---

Nếu bạn muốn mình đóng gói tất cả demo này thành file `.sql`, mình có thể tạo giúp bạn ngay. Bạn cũng có thể yêu cầu thêm ví dụ về **Clustered Index**, **Full-Text Index**, hoặc hướng dẫn **phân tích Execution Plan chi tiết**.
