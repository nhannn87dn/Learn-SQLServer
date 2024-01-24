# Day 6

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

---

### 💥 Transact-SQL Variables

Biến (Variables) là một đối tượng chứa một giá trị của một loại cụ thể, ví dụ: số nguyên, ngày tháng hoặc chuỗi ký tự khác nhau.


#### 🔹 Khai báo Biến

```sql
DECLARE @variable_name data_type [= value]  
```

Ví dụ:

```sql
DECLARE @ModelYear AS SMALLINT;
-- Hoặc khai báo nhiều biến trong 1 câu lệnh
DECLARE @ModelYear SMALLINT, 
        @ProductName VARCHAR(MAX);
```

#### 🔹  Gán giá trị cho Biến

```sql
SET @ModelYear = 2018;
```

#### 🔹 Sử dụng Biến

```sql
SELECT
    ProductName,
    ModelYear,
    Price 
FROM 
    dbo.Products
WHERE 
    ModelYear = @ModelYear
ORDER BY
    ProductName;
```

Bạn có thể gán giá trị cho biến với một kết quả truy vấn

```sql
DECLARE @product_count INT;
SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        dbo.Products 
);
```

#### 🔹 Xuất giá trị Biến


```sql
SELECT @product_count;
-- Hoặc
PRINT @product_count;
```

---

### 💥Synonyms

Synonyms trong SQL Server là một đối tượng CSDL được sử dụng để tạo ra một tên định danh thay thế cho một đối tượng khác trong cùng CSDL hoặc CSDL khác. Synonym cho phép bạn tham chiếu đến một đối tượng bằng một tên ngắn gọn và dễ nhớ, thay vì sử dụng tên đối tượng đầy đủ và phức tạp.

Ví dụ, để tạo một synonym có tên "ctm" để tham chiếu đến bảng "dbo.Customers" trong cùng CSDL:

```sql
CREATE SYNONYM ctm
FOR dbo.Customers;

-- Sau đó bạn có thể sử dụng
SELECT * FROM ctm --tên ngắn hơn
```
---

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

- Khai báo một khối lệnh. Khối lệnh là tập hộp các câu lệnh SQL thực hiện cùng với nhau
- Có thể lồng các khối lệnh vào nhau -- Nested Blocks

```sql
BEGIN
    { sql_statement | statement_block}
END
```

Ví dụ:

```sql
BEGIN
    SELECT
        ProductId,
        ProductName
    FROM
        dbo.Products
    WHERE
        Price > 100000;

    IF @@ROWCOUNT = 0
        -- In giá trị ra cửa sổ message
        PRINT 'No product with Price greater than 100000 found';
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
        @sales = SUM(Price * Quantity)
    FROM
        dbo.OrderItem AS i
        INNER JOIN dbo.Orders o ON o.OrderId = i.OrderId
    WHERE
        YEAR(OrderDate) = 2018;

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

---

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

Ví dụ: Viết 1 function trả về FullName dựa vào  FirstName và LastName từ bảng Customers

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
SELECT dbo.udsf_GetFullName(FirstName, LastName) AS full_name
FROM dbo.Customers
```

Ví dụ: Viết 1 function trả về thành tiền sản phẩm

```sql
CREATE FUNCTION udsf_GetAmountProduct(@Price decimal(18, 2), @Discount decimal(18, 2), @Quantity decimal(18, 2))
RETURNS decimal(18, 2)
AS
BEGIN
    RETURN (@Price * (100 - @Discount) / 100) * @Quantity
END
```

Sử dụng:

```sql
SELECT dbo.udsf_GetAmountProduct(Price, Discount, Quantity) AS total_amount
FROM dbo.OrderItem
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


Ví dụ: Viết một Table-valued Functions trả về danh sách các sản phẩm có giảm giá (Discount > 0)


```sql
CREATE FUNCTION udtf_PromotionProducts()
RETURNS TABLE -- return về một Table
AS
RETURN
(
    SELECT *
    FROM dbo.Products
    WHERE Discount > 0
)
```

Sử dụng funtion


```sql
SELECT * FROM dbo.udtf_PromotionProducts()
```
---

### 💥 Windown Functions

Window functions (còn được gọi là windowing functions) trong SQL Server là một tập hợp các hàm tích hợp sẵn cho phép bạn thực hiện các tính toán trên một tập hợp các hàng trong một kết quả truy vấn, dựa trên một cửa sổ hoặc phạm vi xác định.

Các window functions cho phép bạn thực hiện các tính toán như tính tổng, trung bình, lấy hàng đầu, hàng cuối, v.v. trên các tập hợp con của dữ liệu truy vấn. Một cửa sổ (window) là một tập hợp các hàng trong kết quả truy vấn, và nó có thể được xác định bằng cách sử dụng các mệnh đề ORDER BY và ROWS/RANGE BETWEEN trong cú pháp của window functions.

Cú pháp chung của một window function trong SQL Server là:

```
<window function> OVER (PARTITION BY <partitioning clause> ORDER BY <ordering clause> ROWS/RANGE BETWEEN <window frame start> AND <window frame end>)
```

Trong đó:
- `<window function>` là hàm tính toán được áp dụng lên cửa sổ.
- `<partitioning clause>` xác định cách chia dữ liệu thành các phân vùng (partitions) riêng biệt để tính toán trên mỗi phân vùng.
- `<ordering clause>` sắp xếp các hàng trong cửa sổ theo thứ tự cụ thể.
- `<window frame start>` và `<window frame end>` xác định phạm vi của cửa sổ dựa trên hàng hiện tại.

Ví dụ, một window function phổ biến là `ROW_NUMBER()` cho phép đánh số các hàng trong một cửa sổ dựa trên thứ tự xác định. Dưới đây là một ví dụ sử dụng window function `ROW_NUMBER()`:

```
SELECT 
  Col1, Col2, 
  ROW_NUMBER() OVER (ORDER BY Col1) AS RowNum
FROM 
  YourTable
```

Trong ví dụ trên, `ROW_NUMBER()` sẽ đánh số các hàng trong `YourTable` theo thứ tự tăng dần của cột `Col1`, và kết quả sẽ chứa cột mới `RowNum` chứa số thứ tự của mỗi hàng.


Ngoài ra SQL Server  còn hỗ trợ các loại funtions:

- Aggregate Functions
- Date Functions
- String Functions
- System Functions

Chi tiết xem tại: https://www.sqlservertutorial.net/sql-server-functions/

---

### 💥 Expressions

#### Mệnh đề CASE

**simple CASE expression**

Cú pháp:

```sql
CASE input   
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END
```

Ví dụ:

```sql
SELECT    
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status, 
    COUNT(OrderId) order_count
FROM    
    sales.Orders
WHERE 
    YEAR(OrderDate) = 2018
GROUP BY 
    order_status;
```

Kết quả:

![case simple](img/SQL-Server-CASE-Expression-Using-Simple-CASE-in-SELECT-clause.png)


**searched CASE expression**

Cú pháp:

```sql
CASE  
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END 
```

Ví dụ:

```sql
SELECT    
    o.OrderId, 
    SUM(Quantity * Price) order_value,
    CASE
        WHEN SUM(Quantity * Price) <= 500 
            THEN 'Very Low'
        WHEN SUM(Quantity * Price) > 500 AND 
            SUM(Quantity * Price) <= 1000 
            THEN 'Low'
        WHEN SUM(Quantity * Price) > 1000 AND 
            SUM(Quantity * Price) <= 5000 
            THEN 'Medium'
        WHEN SUM(Quantity * Price) > 5000 AND 
            SUM(Quantity * Price) <= 10000 
            THEN 'High'
        WHEN SUM(Quantity * Price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    dbo.Orders o
INNER JOIN sales.OrderItem i ON i.OrderId = o.OrderId
WHERE 
    YEAR(OrderDate) = 2018
GROUP BY 
    o.OrderId;

```

### COALESCE

COALESCE là một hàm dùng để trả về giá trị đầu tiên không null từ danh sách các biểu thức. Nó được sử dụng để xác định một giá trị mặc định hoặc thay thế khi giá trị ban đầu là null.

Ví dụ:

```sql
SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;
--Kết quả: Hi
```

Ví dụ thực tế:

```sql
SELECT 
    FirstName, 
    LastName, 
    COALESCE(Phone,'N/A') Phone, 
    Email
FROM 
    dbo.Customers
ORDER BY 
    FirstName, 
    LastName;
```

Trường Phone nếu NULL thì trả về 'N/A', còn không thì lấy chính nó.

Xem thêm: https://www.sqlservertutorial.net/sql-server-basics/sql-server-coalesce/

#### NULLIF

NULLIF là một hàm được sử dụng để so sánh hai biểu thức. Nếu hai biểu thức bằng nhau, NULLIF sẽ trả về giá trị null. Nếu hai biểu thức không bằng nhau, NULLIF sẽ trả về giá trị của biểu thức đầu tiên.

Cú pháp:

```sql
NULLIF(expression1, expression2)
```

Ví dụ:

```sql
SELECT NULLIF(10, 10) result; --=> NULL
SELECT NULLIF(20, 10) result; --=> 20
SELECT NULLIF('Hello', 'Hi') result; --=> 'Hello'
```

Xem thêm: https://www.sqlservertutorial.net/sql-server-basics/sql-server-nullif/

---

## 💛 Session 15 - Error Handing

Tóm tắt nội dung:

1. Hiểu được cách thức hoạt động của error handling
1. Cách sử dụng TRY...CATCH
1. Cách sử dụng RAISEERROR, THROW
1. Cách sử dụng @@ERROR, ERROR_NUMBER, ERROR_SEVERITY, 
ERROR_STATE, ERROR_PROCEDURE, ERROR_LINE, ERROR_MESSAGE

---

### 💥 Các loại lỗi trong SQL Server

- Lỗi cú pháp (Syntax errors)
- Lỗi thời gian chạy (Runtime errors)

#### 🔹 Lỗi cú pháp (Syntax errors)
Là lỗi xảy ra khi câu lệnh SQL không được viết đúng cú pháp.

#### 🔹 Lỗi thời gian chạy (Runtime errors)

Là lỗi xảy ra khi câu lệnh SQL được viết đúng cú pháp nhưng không thể thực thi được do sai logic hoặc do dữ liệu không hợp lệ.

---

### 💥  TRY...CATCH
Là cấu trúc dùng để bắt lỗi trong SQL Server. Được giới thiệu từ phiên bản SQL Server 2005. Ví dụ:

Cú pháp:

```sql
BEGIN TRY  
   -- statements that may cause exceptions
END TRY 
BEGIN CATCH  
   -- statements that handle exception
END CATCH  

```

Ví dụ:


```sql
BEGIN
    BEGIN TRY
        SELECT 1/0 -- Chia một số cho 0
    END TRY
    BEGIN CATCH
        --Bắt lỗi, và hiển ra thành một table
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
END;
```

Bạn có thể dùng lại đoạn code bắt lỗi trên rất nhiều do vậy bạn có thể viết thành một Store.


```sql
CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO;
```

Ví dụ trên bạn có thể rút gọn lại



```sql
BEGIN
    BEGIN TRY
        SELECT 1/0 -- Chia một số cho 0
    END TRY
    BEGIN CATCH
        --Bắt lỗi, và hiển ra thành một table
        -- report exception
        EXEC usp_report_error;
    END CATCH
END;
```

---

### 💥 RAISERROR

Là câu lệnh dùng để tạo ra một lỗi do người dùng tự định nghĩa. Ví dụ: Tạo một lỗi do người dùng tự định nghĩa

```sql
-- Cú pháp
RAISERROR(ErrorMessage, ErrorSeverity, ErrorState);
-- Ví dụ:
RAISERROR('This is a custom error', 16, 1)
```
Trong đó: severity level là một số nguyên 0 - 25

- 0–10 Informational messages
- 11–18 Errors
- 19–25 Fatal errors

state: là một số nguyên 0 - 255. hầu hết hay để là 1

Levels of severity: https://learn.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver16

---

### 💥  THROW

Là câu lệnh dùng để tạo ra một lỗi do người dùng tự định nghĩa. Được giới thiệu từ phiên bản SQL Server 2012. Do đơn giản hơn RAISERROR nên nên được ưu tiên sử dụng.

Ví dụ: Tạo một lỗi do người dùng tự định nghĩa

```sql
THROW 50000, 'This is a custom error', 1
```

Ví dụ 2:

```sql
-- Tạo table t1
CREATE TABLE t1(
    id int primary key
);
GO
--
BEGIN TRY
    INSERT INTO t1(id) VALUES(1);
    --  cause error
    INSERT INTO t1(id) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH

```

---

### 💥  Biến @@ERROR

Là một biến toàn cục, chứa mã lỗi của lỗi gần nhất xảy ra. Ví dụ:

```sql
SELECT 1/0
SELECT @@ERROR
```

Kết quả:

```text
Msg 8134, Level 16, State 1, Line 1
Divide by zero error encountered.
8134
```

### 💥  ERROR_NUMBER()

Là hàm trả về mã lỗi của lỗi gần nhất xảy ra.

### 💥  ERROR_SEVERITY()

Là hàm trả về mức độ nghiêm trọng của lỗi gần nhất xảy ra.

### 💥  ERROR_STATE()

Là hàm trả về trạng thái của lỗi gần nhất xảy ra.

### 💥  ERROR_PROCEDURE()

Là hàm trả về tên của stored procedure hay trigger gây ra lỗi gần nhất xảy ra.

### 💥  ERROR_LINE()

Là hàm trả về số dòng gây ra lỗi gần nhất xảy ra.

### 💥  ERROR_MESSAGE()

Là hàm trả về thông điệp lỗi gần nhất xảy ra.

---



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

Trong SQL Server hoạt động theo các chế độ giao dịch sau:

- Transaction tự động xác nhận (Autocommit transactions)
- Mỗi câu lệnh riêng lẻ được coi là một giao dịch.

Các ứng dụng của transaction:

- Transaction được sử dụng để đảm bảo tính toàn vẹn của dữ liệu trong các ứng dụng doanh nghiệp.
- Transaction có thể được sử dụng để thực hiện các thao tác như: chuyển tiền, thanh toán hóa đơn, đặt hàng, ...

---

### 💥  Các lệnh quản lý transaction

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

Lưu ý Để đúng như phần lý thuyết bạn nên kiểm tra lại cấu hình `XACT_ABORT`:

- Khi "SET XACT_ABORT ON" được thiết lập, nếu một lỗi xảy ra trong một giao dịch, nó sẽ tự động kết thúc giao dịch đó và rollback (hoàn tác) tất cả các thay đổi đã được thực hiện trong giao dịch. Điều này đảm bảo tính toàn vẹn dữ liệu và giúp tránh tình trạng dữ liệu không nhất quán.

- Khi "SET XACT_ABORT OFF" (giá trị mặc định) được thiết lập, một lỗi trong một giao dịch không đảm bảo sẽ kết thúc giao dịch tự động. Trong trường hợp này, các lệnh trong giao dịch có thể tiếp tục thực hiện sau khi xảy ra lỗi, và phải thực hiện rollback thủ công để hoàn tác các thay đổi.

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
VALUES (1, 'HeadPhone', 80, 0.08),
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
VALUES (1, 'HeadPhone', 80, 0.08),
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

---

### 💥 Locks

Trong SQL Server, locks (khóa) là cơ chế được sử dụng để kiểm soát truy cập và sửa đổi dữ liệu trong quá trình thực hiện các giao dịch. Khi một giao dịch yêu cầu truy cập vào dữ liệu, SQL Server áp dụng các locks trên dữ liệu tương ứng để đảm bảo tính nhất quán và độc lập của dữ liệu trong môi trường đa người dùng.

Có nhiều loại lock khác nhau trong SQL Server, bao gồm:

1. Shared Lock (Shared Read Lock):
   - Được sử dụng khi giao dịch muốn đọc (truy vấn) dữ liệu.
   - Nhiều shared locks có thể được áp dụng trên cùng một dữ liệu.
   - Shared locks không ngăn được các shared locks khác trên cùng một dữ liệu.
   - Shared locks không cho phép exclusive lock được áp dụng lên dữ liệu.

2. Exclusive Lock (Write Lock):
   - Được sử dụng khi giao dịch muốn thay đổi (ghi) dữ liệu.
   - Không thể có bất kỳ shared locks hoặc exclusive locks khác trên cùng một dữ liệu.
   - Exclusive locks ngăn cả shared locks và exclusive locks khác.

3. Update Lock:
   - Được sử dụng trong các trường hợp cần đảm bảo rằng dữ liệu không được đọc hoặc chỉnh sửa trong quá trình thực hiện giao dịch.
   - Update locks được nâng cấp thành exclusive lock khi giao dịch cần thực hiện các thay đổi.

4. Intent Lock:
   - Là các locks nhỏ hơn được áp dụng trên các cấu trúc dữ liệu phức tạp hơn như bảng, trang, phân vùng.
   - Intent locks đại diện cho ý định của giao dịch để áp dụng shared locks hoặc exclusive locks trên các đối tượng con của cấu trúc dữ liệu.

5. Schema Lock:
   - Được sử dụng khi giao dịch thay đổi cấu trúc của cơ sở dữ liệu như tạo, sửa đổi hoặc xóa bảng, quyền truy cập, thủ tục lưu trữ, v.v.

SQL Server cũng hỗ trợ các mức độ khóa khác nhau như row-level locks (khóa mức hàng), page-level locks (khóa mức trang) và table-level locks (khóa mức bảng) để tối ưu hiệu suất và sử dụng tài nguyên. Hệ thống quản lý locks trong SQL Server đảm bảo tính nhất quán và độc lập của dữ liệu trong quá trình thực hiện các giao dịch đồng thời.

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


## 💛 Review Homeworks

Giải các bài tập homework theo nội dung vừa học, áp dụng view, store để tái sử dụng code
