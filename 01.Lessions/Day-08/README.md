# Day 8
💥 🔹
## 💛 Session 13 - Programming Transact-SQL

### 💥 Transact-SQL là gì ?

Transact-SQL (viết tắt là T-SQL) là một phần mở rộng của ngôn ngữ truy vấn SQL được phát triển dựa theo tiêu chuẩn ISO và ANSI (American National Standards Institute).

T-SQL là một ngôn ngữ truy vấn phổ biến được sử dụng trong hệ quản trị CSDL Microsoft SQL Server và Azure SQL Database. T-SQL là một phần mở rộng của ngôn ngữ SQL (Structured Query Language) với các tính năng bổ sung để hỗ trợ lập trình, xử lý dữ liệu và quản lý CSDL.

Dưới đây là một số điểm nổi bật về T-SQL:

1. Truy vấn dữ liệu: T-SQL cung cấp các câu lệnh như SELECT, INSERT, UPDATE và DELETE để truy vấn và thay đổi dữ liệu trong CSDL. Nó hỗ trợ các điều kiện, phép toán, và hàm tích hợp để lọc và xử lý dữ liệu theo nhu cầu.

2. Quản lý CSDL: T-SQL cung cấp các câu lệnh để tạo, sửa đổi và xóa các đối tượng CSDL như bảng, khóa ngoại, chỉ mục, thủ tục lưu trữ, chức năng và trigger. Nó cũng hỗ trợ các câu lệnh để quản lý quyền truy cập và an ninh CSDL.

3. Xử lý dữ liệu: T-SQL cung cấp các câu lệnh để thực hiện các phép tính và chức năng xử lý dữ liệu như tính toán, chuỗi kết hợp, chuyển đổi dữ liệu, phân trang và ghép nối.

4. Lập trình: T-SQL hỗ trợ các cấu trúc điều khiển như IF...ELSE, WHILE, và BEGIN...END để viết mã logic phức tạp. Nó cũng hỗ trợ biến, hằng số, tham số và các hàm người dùng để tạo các tác vụ lập trình.

5. Xử lý lỗi và gỡ lỗi: T-SQL cung cấp các cơ chế để xử lý lỗi và gỡ lỗi trong quá trình thực thi. Nó hỗ trợ các câu lệnh TRY...CATCH để bắt và xử lý các ngoại lệ trong quá trình thực thi mã.

### 💥 Transact-SQL Variables

Biến (Variables) là một đối tượng chứa một giá trị của một loại cụ thể, ví dụ: số nguyên, ngày tháng hoặc chuỗi ký tự khác nhau.


#### 🔹 Khai báo Biến

```sql
DECLARE @variable_name data_type [= value]  
```

Ví dụ:

```sql
DECLARE @model_year AS SMALLINT;
-- Hoặc khai báo nhiều biến trong 1 câu lệnh
DECLARE @model_year SMALLINT, 
        @product_name VARCHAR(MAX);
```

#### 🔹  Gán giá trị cho Biến

```sql
SET @model_year = 2018;
```

#### 🔹 Sử dụng Biến

```sql
SELECT
    product_name,
    model_year,
    price 
FROM 
    dbo.products
WHERE 
    model_year = @model_year
ORDER BY
    product_name;
```

Bạn có thể gán giá trị cho biến với một kết quả truy vấn

```sql
DECLARE @product_count INT;
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        dbo.products 
);
```

#### 🔹 Xuất giá trị Biến


```sql
SELECT @product_count;
-- Hoặc
PRINT @product_count;
```


### 💥Synonyms

Synonyms trong SQL Server là một đối tượng CSDL được sử dụng để tạo ra một tên định danh thay thế cho một đối tượng khác trong cùng CSDL hoặc CSDL khác. Synonym cho phép bạn tham chiếu đến một đối tượng bằng một tên ngắn gọn và dễ nhớ, thay vì sử dụng tên đối tượng đầy đủ và phức tạp.

Ví dụ, để tạo một synonym có tên "ctm" để tham chiếu đến bảng "dbo.customers" trong cùng CSDL:

```sql
CREATE SYNONYM ctm
FOR dbo.customers;

-- Sau đó bạn có thể sử dụng
SELECT * FROM ctm --tên ngắn hơn
```

### 💥 Program Flow Statements

Như đã đề cập trên T-SQL là một ngôn ngữ lập trình mở rộng, cho nên nó cũng được trang bị các các câu lệnh điều khiển luồng chương trình như:

- IF...ELSE
- WHILE
- BREAK
- CONTINUE
- GOTO
- RETURN
- WAITFOR
- TRY...CATCH
- THROW
- BEGIN...END

Và một số câu lệnh khác.

#### 🔹  BEGIN...END

Khai báo một khối lệnh

```sql
BEGIN
    { sql_statement | statement_block}
END
```

#### 🔹  IF...ELSE

```sql
IF Boolean_expression
BEGIN
    -- Statement block executes when the Boolean expression is TRUE
END
ELSE
BEGIN
    -- Statement block executes when the Boolean expression is FALSE
END
```

Ví dụ: Xem năm 2028 có đạt chi tiêu doanh số bán ra không. Nếu có hãy in ra một lời chúc.

```sql
BEGIN
    DECLARE @sales INT;

    SELECT 
        @sales = SUM(price * quantity)
    FROM
        dbo.order_items AS i
        INNER JOIN dbo.orders o ON o.order_id = i.order_id
    WHERE
        YEAR(order_date) = 2018;

    SELECT @sales;

    IF @sales > 1000000
    BEGIN
        PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
    END
    ELSE
    BEGIN
        PRINT 'Sales amount in 2018 did not reach 1,000,000';
    END
END

```

Bạn hoàn toàn có thể lồng cách câu lênh IF...ELSE vào nhau như trong các ngôn ngữ lập trình khác

```sql
BEGIN
    DECLARE @x INT = 10,
            @y INT = 20;

    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 and x < y';
        ELSE
            PRINT 'x > 0 and x >= y';
    END			
END
```

#### 🔹  WHILE

Cú pháp

```sql
WHILE Boolean_expression   
     { sql_statement | statement_block} 
```
Ví dụ

```sql
DECLARE @counter INT = 1;

WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END
```


#### 🔹 BREAK

BREAK được sử dụng để kết thúc một khối lệnh hoặc vòng lặp. Nó thường được sử dụng trong cấu trúc điều khiển như WHILE hoặc LOOP để thoát khỏi vòng lặp hoặc dừng việc thực thi các lệnh trong khối.


```sql
DECLARE @counter INT = 0;

WHILE @counter <= 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 4
        BREAK; -- Bỏ qua những lệnh phía sau nó
    PRINT @counter;
END

```

#### 🔹 CONTINUE

CONTINUE được sử dụng để bỏ qua phần còn lại của vòng lặp hiện tại và chuyển đến lần lặp tiếp theo. Khi lệnh CONTINUE được thực thi, các lệnh sau nó trong vòng lặp sẽ bị bỏ qua và chương trình sẽ chuyển đến lần lặp tiếp theo của vòng lặp.

```sql
DECLARE @counter INT = 0;

WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1;
    IF @counter = 3
        CONTINUE; --Tiếp tục vòng lặp, bỏ qua câu lệnh sau nó
    PRINT @counter;
END
```


#### 🔹 GOTO

GOTO được sử dụng để chuyển quyền điều khiển đến một điểm nhãn (label) cụ thể trong mã SQL. Nó cho phép nhảy tới một vị trí khác trong chương trình mà không cần tuân thủ thứ tự thực hiện các lệnh.

```sql
DECLARE @i int = 1
WHILE @i <= 10 BEGIN
    IF @i = 5 BEGIN
        GOTO label
    END
    PRINT @i
    SET @i = @i + 1
END
label:
PRINT 'Done'
```

Nếu gặp giá trị = 5, lập tức nhảy đến vị trí `label:` và chạy tiếp


#### 🔹 RETURN

Trả về giá trị, dùng trong function

```sql
CREATE FUNCTION udsf_GetFullName
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END
```


#### 🔹 WAITFOR

WAITFOR được sử dụng để tạm dừng thực thi một khối lệnh hoặc truy vấn trong một khoảng thời gian nhất định. Nó thường được sử dụng để tạo độ trễ hoặc đồng bộ hóa các hoạt động trong cơ sở dữ liệu.

```sql
PRINT 'Start';
WAITFOR DELAY '00:00:05'; --Dừng 5s rồi chạy lệnh Sau nó
PRINT 'End';
```


### 💥 Transact-SQL Functions

T-SQL (Transact-SQL) Functions là các hàm được cung cấp bởi Microsoft SQL Server và Azure SQL Database để thực hiện các thao tác xử lý dữ liệu, tính toán và truy vấn trong môi trường CSDL. T-SQL Functions cho phép bạn thực hiện các phép tính, chuyển đổi dữ liệu, truy xuất thông tin và thực hiện các tác vụ xử lý dữ liệu phức tạp.

Các nhóm Funtions trong SQL Server:

- Aggregate Functions
- Date Functions
- String Functions
- System Functions
- Window Functions

Xem chi tiết các sử dụng: https://www.sqlservertutorial.net/sql-server-functions/

Dựa vào cách thức trả về (return) của function, function được chia thành 2 loại:

#### 🔹  Scalar-valued functions

**Scalar-valued Functions**: nó nhận đầu vào và trả về một giá trị duy nhất.

**Tạo function**

Nhưng function người dùng tạo ra được gọi là  `User-defined function`

Cú pháp:

```sql
CREATE OR ALTER FUNCTION [schema_name.]function_name (parameter_list)
        RETURN data_type AS
        BEGIN
            statements
            RETURN value
        END
```

Ví dụ: Viết 1 function trả về FullName dựa vào  FirstName và LastName từ bảng customers

```sql
-- Dùng từ khóa CREATE FUNCTION
-- udsf_ prefix = User-defined Scalar function
CREATE FUNCTION udsf_GetFullName
(
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END
```

Sử dụng


```sql
SELECT dbo.udsf_GetFullName(first_name, last_name) AS full_name
FROM dbo.customers
```

Ví dụ: Viết 1 function trả về thành tiền sản phẩm

```sql
CREATE FUNCTION udsf_GetAmountProduct(@Price money, @Discount decimal(18, 2), @Quantity decimal(18, 2))
RETURNS decimal(18, 2)
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END
```

Sử dụng:

```sql
SELECT dbo.udsf_GetAmountProduct(price, discount, quantity) AS total_amount
FROM dbo.order_items
```


**Sửa function**


```sql
--Dùng từ khóa ALTER FUNCTION
ALTER FUNCTION udsf_GetFullName
(
    @FirstName nvarchar(50),
    @LastName nvarchar(50)
)
RETURNS nvarchar(100)
AS
BEGIN
    DECLARE @FullName nvarchar(100)
    SET @FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END
```

**Xóa function**

```sql
DROP FUNCTION [schema_name.]function_name;
```

#### 🔹 Table-valued Functions

**Table-valued Functions**: nó nhận đầu vào và trả về một bảng (table)


Ví dụ: Viết một Table-valued Functions trả về danh sách các sản phẩm có giảm giá (discount > 0)


```sql
CREATE FUNCTION udtf_PromotionProducts()
RETURNS TABLE -- return về một Table
AS
RETURN
(
    SELECT *
    FROM dbo.products
    WHERE discount > 0
)
```

Sử dụng funtion


```sql
SELECT * FROM dbo.udtf_PromotionProducts()
```



## 💛 Session 14 - Transactions


