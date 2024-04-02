# Day 04 - Session 06


## 💛 Modifying data

### 🔹 INSERT

Câu lệnh INSERT cho phép bạn thêm một hoặc nhiều bản ghi mới vào bảng dữ liệu.

Cú pháp:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

Nếu bạn muốn chèn nhiều bản ghi cùng một lúc, bạn có thể sử dụng cú pháp sau:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...),
       (value1, value2, value3, ...),
       (value1, value2, value3, ...);
```

Ví dụ: Tạo table `promotion` cho demo

```sql
CREATE TABLE dbo.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount DECIMAL (4, 2) DEFAULT 0,
    start_date DATE NOT NULL, --Kiểu ngày yyyy-mm-dd
    expired_date DATE NOT NULL --Kiểu ngày yyyy-mm-dd
); 
```

Thêm 1 record vào `promotion`

```sql
INSERT INTO dbo.promotions (
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      '2018 Summer Promotion',
      0.15,
      '20180601',
      '20180901'
    );
-- Lưu ý: không cần đưa promotion_id vào vì nó sẽ tự tăng
```

Thêm nhiều record vào `promotion` trong một câu truy vấn

```sql
INSERT INTO dbo.promotions (
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      '2018 Summer Promotion',
      0.15,
      '20180601',
      '20180901'
    ),
     (
      '2018 Chrismats Promotion',
      2,
      '20181201',
      '20181230'
    );
```

Bạn không thể chèn giá trị vào cột được khai báo là `IDENTITY` bởi vì nó sẽ được tạo tự động. Tuy nhiên bạn vẫn muốn làm thì SQL Server có hỗ trợ:

```sql
--Bước 1: Để câu này trước câu lệnh INSERT
SET IDENTITY_INSERT dbo.promotions ON; 
--Bước 2: Các câu lệnh INSERT
INSERT INTO dbo.promotions (
    promotion_id, --có đưa thêm trường IDENTITY
    promotion_name,
    discount,
    start_date, --Kiểu ngày yyyy-mm-dd
    expired_date --Kiểu ngày yyyy-mm-dd
)
VALUES
    (
      5, --Điền trước một giá trị đúng kiểu dữ liệu đã khai báo
      '2018 Winter Promotion',
      0.2,
      '20180701',
      '20181001'
    );
--Bước 3: Tắt tính năng tự động sinh giá trị IDENTITY 
SET IDENTITY_INSERT dbo.promotions OFF; 
```

Nếu bạn không thiết lập `IDENTITY_INSERT` bạn sẽ gặp lỗi:

```bash
Cannot insert explicit value for identity column in table 'promotions' when IDENTITY_INSERT is set to OFF.
```


**INSERT Với giá trị Unicode**

Để hỗ trợ lưu trữ và hiển thị các giá trị là chuỗi Unicode bạn cần:8

```sql
INSERT INTO table_name (column1, column2) VALUES (N'Xin Chào', N'SQL Server khá dễ học');
```

Trong đó, tiền tố "N" trước chuỗi ký tự đảm bảo rằng chuỗi được coi là một chuỗi Unicode.


**INSERT INTO SELECT statement**

Để chèn dữ liệu từ table đến table khác bạn có thể sử dụng mệnh đề `INSERT INTO SELECT`

Cú pháp:

```sql
INSERT  [ TOP ( expression ) [ PERCENT ] ] 
INTO target_table (column_list)
query;
```

Ví dụ:

```sql
-- Tạo cấu trúc bảng regions
CREATE TABLE dbo.regions (
    address_id INT IDENTITY PRIMARY KEY,
    street VARCHAR (255) NOT NULL,
    city VARCHAR (50),
    state VARCHAR (25),
    zip_code VARCHAR (5)
); 
-- Lấy dữ liệu từ table customer đổ qua cho regions
INSERT INTO dbo.regions (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    dbo.customers
ORDER BY
    first_name,
    last_name; 
```

**INSERT Với kiểu dữ liệu thời gian**


Ví dụ có bảng

```sql
CREATE TABLE dbo.visits (
    visit_id INT PRIMARY KEY IDENTITY,
    customer_name VARCHAR (50) NOT NULL,
    phone VARCHAR (25),
    store_id INT NOT NULL,
    visit_on DATE NOT NULL,
    start_at TIME (0) NOT NULL,
    end_at TIME (0) NOT NULL,
    create_at DATETIME2 NOT NULL, --kiểu yyyy-mm-dd H:i:s, không tự động tạo
    modified_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP --kiểu yyyy-mm-dd H:i:s, tự động tạo
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);

--Chèn dữ liệu
INSERT INTO sales.visits (
    customer_name,
    phone,
    store_id,
    visit_on,
    start_at,
    end_at,
    create_at
)
VALUES
    (
        'John Doe',
        '(408)-993-3853',
        1,
        '2018-06-23',
        '09:10:00',
        '09:30:00',
        '2018-06-23 09:30:00'
    );
-- Trường visit_id, modified_at không cần đưa vào vì nó sẽ tạo tự động

```



### 🔹 UPDATE

Mệnh đề UPDATE dùng để thay đổi dữ liệu trong table

Cú pháp

```sql
UPDATE [schame_name].[table_name]
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
```

Lưu ý: Câu lệnh UPDATE nên đi kèm với mệnh đề WHERE để giới hạn phạm vi tác động của dữ liệu, để giảm bớt sai sót nếu nhầm lẫn logic xử lý.

**UPDATE JOIN syntax**

```sql
UPDATE 
    t1
SET 
    t1.c1 = t2.c2,
    t1.c2 = expression,
    ...   
FROM 
    t1
    [INNER | LEFT] JOIN t2 ON join_predicate
WHERE 
    where_predicate;
```

Tạo dữ liệu demo

```sql
DROP TABLE IF EXISTS dbo.targets;

CREATE TABLE dbo.targets
(
    target_id  INT	PRIMARY KEY, 
    percentage DECIMAL(4, 2) 
        NOT NULL DEFAULT 0
);

INSERT INTO 
    dbo.targets(target_id, percentage)
VALUES
    (1,0.2),
    (2,0.3),
    (3,0.5),
    (4,0.6),
    (5,0.8);

CREATE TABLE dbo.commissions
(
    staff_id    INT PRIMARY KEY, 
    target_id   INT, 
    base_amount DECIMAL(10, 2) 
        NOT NULL DEFAULT 0, 
    commission  DECIMAL(10, 2) 
        NOT NULL DEFAULT 0, 
    FOREIGN KEY(target_id) 
        REFERENCES sales.targets(target_id), 
    FOREIGN KEY(staff_id) 
        REFERENCES sales.staffs(staff_id),
);

INSERT INTO 
    dbo.commissions(staff_id, base_amount, target_id)
VALUES
    (1,100000,2),
    (2,120000,1),
    (3,80000,3),
    (4,900000,4),
    (5,950000,5);
```

Yêu cầu Cập nhật tiền thưởng (trường commissions) ở table `commissions` theo công thức: `commissions = base_amount * percentage` mặc định nhân viên mới sẽ có mức chiết khấu percentage = 0.1


```sql
UPDATE 
    dbo.commissions
SET  
    dbo.commissions.commission = 
        c.base_amount  * COALESCE(t.percentage,0.1) -- COALESCE trả về 0.1 nếu percentage là NULL
FROM  
    dbo.commissions AS c
    LEFT JOIN dbo.targets t -- tham chiếu đến targets để lấy trường percentage
        ON c.target_id = t.target_id;
```

### 🔹 DELETE

Câu lệnh DELETE cho phép bạn loại bỏ dữ liệu không cần thiết, không chính xác hoặc không muốn từ một bảng cụ thể trong cơ sở dữ liệu.

Cú pháp:

```sql
DELETE [ TOP ( expression ) [ PERCENT ] ]  
FROM table_name
[WHERE search_condition];
```

Ví dụ các trường hợp:

```sql
-- Xóa tất cả records từ table target_table
DELETE FROM target_table;
-- Xóa 1 dòng đầu tiên
DELETE TOP 10 FROM target_table;  
-- Xóa 10 % records ngẫu nhiên trong table
DELETE TOP 10 PERCENT FROM target_table;
```

**DELETE với mệnh đề WHERE**

Thông thường câu lệnh DELETE đi kèm điều kiện WHERE để xác định cụ thể bản ghi nào cần xóa

```sql
DELETE FROM dbo.commissions WHERE staff_id = 1
```
