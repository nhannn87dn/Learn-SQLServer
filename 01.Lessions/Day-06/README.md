# Day 6
💥 🔹
## 💛 Session 09- Advanced Queries and Joins - Part 2


### 💥 JOINs 

Trong SQL, joins là phép kết hợp các hàng từ hai hoặc nhiều bảng dựa trên một điều kiện kết hợp. Joins cho phép bạn kết hợp dữ liệu từ các bảng liên quan nhau để tạo ra các kết quả kết hợp mới, giúp truy vấn dữ liệu từ nhiều nguồn trở nên linh hoạt và mạnh mẽ hơn.

Tìm hiểu về các phép JOINs qua ví dụ:

```sql
--Tạo bảng a
CREATE TABLE basket_a (
    a INT PRIMARY KEY,
    fruit_a VARCHAR (50) NOT NULL
);
--Tạo bảng b
CREATE TABLE basket_b (
    b INT PRIMARY KEY,
    fruit_b VARCHAR (50) NOT NULL
);
--Chèn dữ liệu vào bảng a
INSERT INTO basket_a (a, fruit_a)
VALUES
    (1, 'Apple'),
    (2, 'Orange'),
    (3, 'Banana'),
    (4, 'Cucumber');
--Chèn dữ liệu vào bảng b
INSERT INTO basket_b (b, fruit_b)
VALUES
    (1, 'Orange'),
    (2, 'Apple'),
    (3, 'Watermelon'),
    (4, 'Pear');
```

#### 🔹 INNER JOIN / JOIN

INNER JOIN là một loại phép nối (join) trong SQL, được sử dụng để kết hợp các hàng từ hai hoặc nhiều bảng dựa trên một điều kiện kết hợp. INNER JOIN chỉ trả về các hàng có giá trị khớp trong `cả hai bảng`.

```sql
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
INNER JOIN basket_b
    ON fruit_a = fruit_b;
```

Kết quả được

![innner join](img/join-inner-join-example.png)

Phép nối Inner Join được biểu diễn với sơ đồ  Venn diagram

![innner join](img/Join-Inner-Join.png)


Ví dụ: Lấy danh sách sản phẩm bao gồm tên sản phẩm, danh mục sản phẩm, giá bán.

```sql
SELECT
    product_name,
    category_name,
    price
FROM
    dbo.products p
INNER JOIN dbo.categories c 
    ON c.category_id = p.category_id -- mối quan hệ giữ 2 bảng
ORDER BY
    product_name DESC;
```

Kết quả

![query inner join](img/SQL-Server-Inner-Join-example.png)

Bảng `products` có trường khóa ngoại `category_id`, dựa vào đó bạn móc nối với Bảng `categories` để lấy tên danh mục dựa vào khóa chính  `category_id`


#### 🔹 OUTER JOIN

OUTER JOIN là một loại phép nối  được sử dụng để kết hợp các hàng từ hai hoặc nhiều bảng dựa trên một điều kiện kết hợp, nhưng khác với INNER JOIN, OUTER JOIN có thể bao gồm các hàng không khớp từ ít nhất một bảng.

Có ba loại OUTER JOIN chính: LEFT OUTER JOIN (hoặc LEFT JOIN), RIGHT OUTER JOIN (hoặc RIGHT JOIN), FULL OUTER JOIN (hoặc FULL JOIN)

#### 🔹 LEFT JOIN

Trả về tất cả các hàng từ bảng bên trái (left table) và các hàng khớp từ bảng bên phải (right table). Nếu không có hàng khớp trong bảng bên phải, các cột từ bảng bên phải sẽ có giá trị NULL trong kết quả.

```sql
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
LEFT JOIN basket_b 
   ON fruit_a = fruit_b;
```

Kết quả

![join-left-join-example](img/join-left-join-example.png)

Phép nối Left Join được biểu diễn với sơ đồ  Venn diagram

![innner join](img/Join-Left-Join.png)


Ví dụ: Dựa vào mối quan hệ giữ `order_items` và `products` ==> Một sản phẩm có thể nằm trong nhiều đơn hàng

![item-products](img/products-order_items.png)

Hãy đưa ra thống kê sản phẩm thuộc đơn hàng nào ?

```sql
SELECT
    product_name,
    order_id
FROM
    dbo.products p
LEFT JOIN dbo.order_items o ON o.product_id = p.product_id
ORDER BY
    order_id;
```

Dựa vào qua hệ giữa 3 bảng sau: Bạn có thể lấy thêm nhiều thông tin hơn, bằng cách kết hợp hơn 1 phép LEFT JOIN.

![item-products](img/orders-order_items-products.png)

Hãy đưa ra thống kê sản phẩm thuộc đơn hàng nào, kèm ngày bán ra ?

```sql
SELECT
    p.product_name,
    o.order_id,
    i.item_id,
    o.order_date
FROM
    production.products p
	LEFT JOIN sales.order_items i
		ON i.product_id = p.product_id
	LEFT JOIN sales.orders o
		ON o.order_id = i.order_id
ORDER BY
    order_id;
```


#### 🔹 RIGHT JOIN

Tương tự LEFT OUTER JOIN, nhưng trả về tất cả các hàng từ bảng bên phải (right table) và các hàng khớp từ bảng bên trái (left table). Nếu không có hàng khớp trong bảng bên trái, các cột từ bảng bên trái sẽ có giá trị NULL trong kết quả.

```sql
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
RIGHT JOIN basket_b ON fruit_a = fruit_b;
```

Kết quả

![join-right-join-example](img/join-right-join-example.png)

Phép nối Rigth Join được biểu diễn với sơ đồ  Venn diagram

![right join](img/Join-Right-Join.png)

Thực tế phép này ít xài, các lập trình viên có xu hướng chuyển table bên phải qua bên trái rồi dùng LEFT JOIN.

#### 🔹 FULL JOIN

Trả về tất cả các hàng từ cả hai bảng. Nếu không có hàng khớp, các cột tương ứng sẽ có giá trị NULL trong kết quả.

```sql
SELECT
    a,
    fruit_a,
    b,
    fruit_b
FROM
    basket_a
FULL OUTER JOIN basket_b 
    ON fruit_a = fruit_b;
```
Kết quả

![join-full-outer-join-example](img/join-full-outer-join-example.png)


Phép nối Full Join được biểu diễn với sơ đồ  Venn diagram

![full join](img/Join-Full-Outer-Join.png)


#### 🔹 SEFT JOIN

SELF JOIN là một phép nối mà bạn kết hợp một bảng với chính nó. Nó cho phép bạn kết nối các hàng trong cùng một bảng dựa trên một điều kiện kết hợp, và do đó, tạo ra một tập hợp mới các cặp hàng trong bảng đó.

Cú pháp:

```sql
SELECT t1.column_name, t2.column_name
FROM table_name t1
JOIN table_name t2 ON t1.column = t2.column;
```
Cùng quan sát table `staffs` chúng ta thấy có trường manager_id, là khóa ngoại nằm tham chiếu tới chính table `staffs`

![self join](img/staffs.png)

Bạn có thể hiểu trong mô hình cây quản lý nhân sự: cấp trên <==> cấp dưới

Dựa vào trường `manager_id` dễ dàng tìm ra ai là quản lý của một người


```sql
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    dbo.staffs e
LEFT JOIN dbo.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;
```

Kết quả

![self join 2](img/Self-Join-with-LEFT-JOIN.png)

---

### 💥 Common Table Expressions (CTEs)

Common Table Expression (CTE) là một công cụ trong SQL cho phép bạn tạo ra một bảng tạm thời mà có thể được sử dụng trong câu truy vấn chính. Nó cung cấp một cách để đặt tên và tham chiếu đến một truy vấn con trong câu truy vấn chính, giúp làm cho mã SQL dễ đọc, dễ hiểu và dễ bảo trì.

CTE thường được sử dụng trong các truy vấn phức tạp hoặc truy vấn có cấu trúc lồng nhau, nơi bạn muốn sử dụng kết quả của một truy vấn con nhiều lần hoặc trong các phần khác nhau của câu truy vấn chính.

Cú pháp của CTE bao gồm hai phần chính: phần WITH và phần truy vấn chính.

Phần WITH xác định tên của CTE và các cột (nếu cần) trong CTE. Đây là nơi bạn xác định truy vấn con và đặt tên cho nó. Ví dụ:

```sql
WITH cte_name (column1, column2, ...)
AS (
    -- Truy vấn con
    SELECT column1, column2, ...
    FROM table_name
    WHERE condition
)
```

Phần truy vấn chính sử dụng tên CTE đã định nghĩa trong phần WITH để tham chiếu đến kết quả của truy vấn con. Ví dụ:

```sql
SELECT *
FROM cte_name
WHERE condition;
```

CTE có thể được sử dụng trong nhiều truy vấn khác nhau như SELECT, INSERT, UPDATE, DELETE, hoặc kết hợp với các phép nối (JOIN) và các biểu thức khác trong SQL.

Lợi ích của CTE bao gồm:

1. Mã SQL dễ đọc: CTE giúp tạo ra mã SQL có cấu trúc rõ ràng và dễ đọc hơn, bằng cách tách biệt các phần truy vấn con và truy vấn chính.

2. Tái sử dụng mã: Bạn có thể sử dụng CTE nhiều lần trong cùng một câu truy vấn hoặc trong các câu truy vấn khác nhau, giúp giảm việc lặp lại mã SQL và tăng tính tái sử dụng.

3. Bảo trì dễ dàng: Khi cần thay đổi truy vấn con, bạn chỉ cần chỉnh sửa nó trong phần WITH, và tất cả các truy vấn chính sử dụng CTE sẽ được cập nhật tự động.

Ví dụ: Thống kê doanh thu bán ra theo nhân viên trong năm 2018

```sql
-- Truy vấn và tạo bảng ảo
WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * price * (1 - discount)),
        YEAR(order_date)
    FROM    
        dbo.orders o
    INNER JOIN dbo.order_items i ON i.order_id = o.order_id
    INNER JOIN dbo.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)
-- Câu lệnh SELECT này phải thực hiện đồng thời với câu lệnh trên.
SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;
```
---

### 💥 Combining Data

#### 🔹 UNION

UNION là một câu lệnh SQL được sử dụng để kết hợp các kết quả của hai hoặc nhiều câu lệnh SELECT thành một tập kết quả duy nhất. Các bản ghi trong các tập kết quả được hợp nhất không có bất kỳ sự trùng lặp nào.


![union](img/SQL-Server-UNION-vs-JOIN.png)

Khi sử dụng UNION trong câu lệnh SQL, dưới đây là một số lưu ý quan trọng mà bạn nên xem xét:

1. Số lượng và kiểu dữ liệu của các cột: Các câu lệnh SELECT trong UNION phải có cùng số lượng cột và cùng kiểu dữ liệu tương ứng. Nếu không, bạn cần sử dụng các biểu thức để đảm bảo rằng các cột có cùng số lượng và kiểu dữ liệu

1. Thứ tự cột: Kết quả của UNION phụ thuộc vào thứ tự của các cột trong câu lệnh SELECT đầu tiên. Vì vậy, hãy đảm bảo rằng các cột trong cả hai câu lệnh SELECT được sắp xếp theo cùng một thứ tự

1. Loại bỏ các bản ghi trùng lặp: UNION tự động loại bỏ các bản ghi trùng lặp trong kết quả cuối cùng. Nếu bạn muốn bao gồm các bản ghi trùng lặp, bạn có thể sử dụng UNION ALL thay vì UNION

1. Sự phù hợp về dữ liệu: Các cột trong các câu lệnh SELECT phải phù hợp về mặt dữ liệu. Ví dụ, cột đầu tiên trong câu lệnh SELECT thứ nhất phải có cùng kiểu dữ liệu với cột đầu tiên trong câu lệnh SELECT thứ hai và ngược lại

1. Hiệu suất: UNION có thể tạo ra một tập kết quả lớn và tốn tài nguyên. Hãy đảm bảo rằng sử dụng UNION chỉ khi cần thiết và kiểm tra hiệu suất của câu lệnh của bạn.




Ví dụ: Nếu kết quả truy vấn thông tin từ table `staffs` và `customer` thành một danh sách:


```sql
SELECT
    first_name, last_name
FROM dbo.staffs
UNION --Loại bỏ giá trị trùng lặp sau khi kết hợp
SELECT
    first_name, last_name
FROM
    dbo.customers;
```

Câu lệnh trên sẽ loại bỏ những records trùng lặp. Nếu bạn không muốn loại bỏ records trùng thì dùng `UNION ALL`

```sql
SELECT
    first_name, last_name
FROM dbo.staffs
UNION ALL -- Giữ giá trị trùng lặp sau khi kết hợp
SELECT
    first_name, last_name
FROM
    dbo.customers;
```

#### 🔹 INTERSECT

Dùng để lấy các bản ghi chung của 2 hoặc nhiều câu lệnh SELECT. Các câu lệnh SELECT phải có cùng số lượng cột và kiểu dữ liệu tương ứng.

![SQL-Server-INTERSECT-Illustration](img/SQL-Server-INTERSECT-Illustration.png)

Ví dụ có `order_items` và `products` ==> cả 2 đều cho trường product_id.

![o-p](img/products-order_items.png)


Dựa vào đó bạn có thể: Lấy ra danh sách những sản phẩm ĐÃ được bán ra.


```sql
SELECT
    product_id
FROM
    dbo.products
INTERSECT
SELECT
    product_id
FROM
    dbo.order_items;
```

#### 🔹 EXCEPT

Dùng để lấy các bản ghi của câu lệnh SELECT đầu tiên mà không có trong các câu lệnh SELECT sau. Các câu lệnh SELECT phải có cùng số lượng cột và kiểu dữ liệu tương ứng.

![SQL-Server-EXCEPT-illustration](img/SQL-Server-EXCEPT-illustration.png)


Dựa vào đó bạn có thể: Lấy ra danh sách những sản phẩm CHƯA được bán ra.

```sql
SELECT
    product_id
FROM
    dbo.products
EXCEPT
SELECT
    product_id
FROM
    dbo.order_items;
```

---

## 💛 Session 10- View, Stored Procedures and Querying Metadata

### 💥 View

Khái niệm "view" trong SQL Server đề cập đến một đối tượng CSDL ảo được tạo ra từ một hoặc nhiều bảng hoặc các view khác. Một view là một câu truy vấn SQL đã được đặt tên và lưu trữ trong CSDL, và nó có thể được sử dụng như một bảng thông thường để truy vấn dữ liệu.

View trong SQL Server hoạt động như một "cửa sổ ảo" cho phép người dùng nhìn vào dữ liệu từ các bảng gốc hoặc các view khác mà không cần truy cập trực tiếp vào các bảng đó. Khi tạo một view, bạn xác định các trường dữ liệu cần hiển thị và các điều kiện để lọc dữ liệu. Sau đó, bạn có thể truy vấn view như bạn truy vấn dữ liệu từ bất kỳ bảng nào.

Việc sử dụng view trong SQL Server có nhiều lợi ích. Dưới đây là một số ví dụ:

1. Đơn giản hóa truy vấn dữ liệu: View cho phép bạn định nghĩa các truy vấn phức tạp một lần và sau đó sử dụng lại chúng dễ dàng theo nhu cầu. Bạn có thể tạo view để hiển thị chỉ các trường dữ liệu cần thiết và ẩn các thông tin không cần thiết, giúp đơn giản hóa việc truy vấn và xử lý dữ liệu.

2. Bảo mật và quyền truy cập: Khi bạn sử dụng view, bạn có thể kiểm soát quyền truy cập vào dữ liệu. Bạn có thể cấu hình quyền truy cập vào view mà không cần cấu hình trực tiếp trên các bảng gốc. Điều này giúp bảo vệ dữ liệu và cung cấp mức độ bảo mật cao hơn cho hệ thống.

3. Đơn giản hóa quản lý dữ liệu: Khi cấu trúc CSDL thay đổi, bạn có thể thay đổi logic của view mà không cần thay đổi các ứng dụng sử dụng view đó. Điều này giảm thiểu sự phụ thuộc giữa ứng dụng và cấu trúc CSDL và đơn giản hóa quá trình quản lý và bảo trì dữ liệu.

Ví dụ: Câu lệnh bên dưới trả về doanh số bán ra của mỗi sản phẩm theo ngày:

```sql
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.price AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;
```

Và lần tới bạn lại muốn dùng lại kết quả truy vấn trê, hay thành viên trong TEAM của bạn cũng muốn dùng kết quả đó. Thì bạn có thể lưu thành file SQLQuery rồi thực thi. `Nhưng với cách này khi bạn backup data thì câu lệnh truy vấn không được kèm theo`.

SQL Server cung cấp cho bạn một cách khác HAY HO hơn là `VIEW`, và dĩ nhiên nó đươc backup kèm cùng với Database

#### 🔹 Tạo VIEW với `CREATE VIEW`

```sql
CREATE VIEW dbo.v_daily_sales --đặt tên với prefix v_
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.price AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;
--- ==> Kết quả nó tạo ra một table ảo, chứa kết quả của câu lệnh truy vấn SELECT
```
Sau đó bạn tái sử dụng kết quả truy vấn bằng cách:

```sql
SELECT * FROM dbo.v_daily_sales 
-- SELCT mọi thứ từ một table ảo
```
#### 🔹 Xóa VIEW với `DROP VIEW`

```sql
DROP VIEW IF EXISTS dbo.v_daily_sales
-- Xóa nhiều VIEW
DROP VIEW IF EXISTS 
    dbo.v_daily_sales, dbo.v_product_info
```

#### 🔹 Đổi tên VIEW 

```sql
EXEC sp_rename 
    @objname = 'v_daily_sales',
    @newname = 'daily_sales';
```

#### 🔹 Sửa VIEW với `ALTER VIEW`

```sql
ALTER VIEW dbo.v_daily_sales 
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;
```

#### 🔹 Quy tắc Tạo VIEW

- Tên VIEW không được đặt trùng nhau, không trùng với tên table thật.
- Tên cột trong VIEW phải là duy nhất và không được trùng với tên cột trong các view hoặc bảng khác
- VIEW không thể tạo từ  temporary tables
- VIEW không thể có full-text index
- VIEW không thể chưa giá trị định nghĩa DEFAULT
- VIEW không thể dùng với ORDER BY trừ khi bạn dùng kèm với mệnh đề TOP
- VIEW chỉ tham chiếu tối đa 1.024 cột đến tabel thật
- VIEW không thể tạo khi dụng mệnh đề INTO

#### 🔹 Các tùy chọn khi tạo VIEW

**WITH SCHEMABINDING**

Với việc sử dụng WITH SCHEMABINDING, view sẽ được ràng buộc với các đối tượng khác trong cơ sở dữ liệu. Nếu bạn thực hiện thay đổi cấu trúc của các đối tượng được ràng buộc (như thay đổi tên cột, tên bảng, ...), bạn sẽ không thể thực hiện được.


```sql
CREATE VIEW dbo.v_daily_sales
WITH SCHEMABINDING -- ràng buộc cấu trúc với các table tham chiếu
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;
```

**WITH ENCRYPTION**

Với việc sử dụng WITH ENCRYPTION, mã nguồn của đối tượng sẽ được mã hóa và không thể đọc hoặc truy cập trực tiếp thông qua các công cụ SQL Server Management Studio (SSMS) hoặc các công cụ khác. Khi một đối tượng được mã hóa, SQL Server sẽ chỉ thực thi đối tượng đó mà không cung cấp truy cập vào mã nguồn.


```sql
CREATE VIEW dbo.v_daily_sales
WITH ENCRYPTION -- Mã hóa, ko cho xem cấu trúc của VIEW
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    p.product_name,
    p.discount,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id;
```

**WITH CHECK OPTION**

WITH CHECK OPTION là một cấu hình được sử dụng trong câu lệnh CREATE VIEW để đảm bảo rằng các dòng dự liệu được chọn trong View cũng phải thỏa mãn điều kiện của View. Nếu bạn thêm hoặc cập nhật dữ liệu thông qua View, nó chỉ cho phép các thay đổi đáp ứng điều kiện của View.


```sql
CREATE VIEW dbo.v_daily_sales
AS
SELECT
    p.product_id,
    p.product_name,
    p.discount,
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    (i.quantity * i.price) AS sales
FROM
    dbo.orders AS o
INNER JOIN dbo.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN dbo.products AS p
    ON p.product_id = i.product_id
WHERE p.discount > 2 -- Nếu không thõa mãn WHERE thì VIEW sẽ không chạy được
WITH CHECK OPTION;
```

Ví dụ:

```sql
UPDATE dbo.v_daily_sales SET discount = 1 WHERE product_id = 8
```

Giã sử câu lệnh UPDATE trên chạy được thì nó làm cho thay đổi discount thành 1. Khi đó mệnh đề WHERE của VIEW sẽ không chạy được vì không thõa điệu kiện.

Chính vì thế, mà VIEW sẽ ngăn không cho câu lệnh UPDATE trên thực thi, để đảm bảo VIEW luôn luôn có tính khả dụng để CHẠY.



---

### 💥 Stored Procedures

Trong SQL Server, Stored Procedures (thủ tục lưu trữ) là một khối mã SQL có thể được lưu trữ trong cơ sở dữ liệu. Một Stored Procedure là một tập hợp các câu lệnh SQL được đặt tên và gán một cách lưu trữ trong hệ thống quản lý cơ sở dữ liệu.

Stored Procedures được sử dụng để thực hiện các tác vụ hoặc thao tác dữ liệu phức tạp trong cơ sở dữ liệu. Chúng có thể chứa các câu lệnh SELECT, INSERT, UPDATE, DELETE, và các câu lệnh điều khiển như IF, WHILE, và các cấu trúc điều khiển khác. Một Stored Procedure có thể nhận đầu vào (tham số) và trả về giá trị đầu ra (kết quả).

Một số lợi ích của Stored Procedures trong SQL Server bao gồm:

1. Hiệu suất: Stored Procedures có thể được biên dịch và lưu trữ lại trong bộ nhớ của SQL Server. Khi được gọi, chúng không cần phải được phân tích và biên dịch lại từng lần thực thi, giúp cải thiện hiệu suất và tăng tốc độ thực thi.

2. Tái sử dụng: Stored Procedures có thể được sử dụng lại trong nhiều ứng dụng và truy vấn khác nhau. Chúng giúp đơn giản hóa việc phát triển ứng dụng và quản lý logic truy vấn trong cơ sở dữ liệu.

3. Bảo mật: Stored Procedures cung cấp một lớp bảo mật bổ sung bằng cách cho phép quản trị viên cấp quyền truy cập vào Stored Procedures mà không cần cấp quyền trực tiếp trên các bảng. Điều này giúp bảo vệ dữ liệu và kiểm soát quyền truy cập từ các ứng dụng và người dùng.

4. Quản lý dữ liệu: Stored Procedures cho phép bạn thực hiện các thao tác dữ liệu phức tạp, xử lý logic phức tạp và thực hiện các tác vụ như ghi log, kiểm tra dữ liệu, và xử lý lỗi. Chúng giúp đơn giản hóa quá trình quản lý và bảo trì dữ liệu.

#### 🔹 Tạo STORE

Cách tạo khá giống với VIEW

Ví dụ: Lấy danh sách sản phẩm

```sql
--Sử dụng từ khóa CREATE PROCEDURE
CREATE PROCEDURE usp_ProductList -- đặt tên với prefix usp_
AS
BEGIN
    SELECT 
        product_name, 
        price
    FROM 
        dbo.products
    ORDER BY 
        product_name;
END;
```
Sau khi tạo xong bạn có thể thấy store được lưu ở `Programmability > Stored Procedures`


#### 🔹 Tạo Store có tham số OUTPUT

Ví dụ: Lấy danh sách đơn hàng bán ra từ ngày đến ngày.

```sql
@FromDate DATETIME,
@ToDate DATETIME,
@Total INT OUTPUT
AS
BEGIN
  SELECT @Total = COUNT(*) FROM orders WHERE order_date BETWEEN @FromDate AND @ToDate
END;
```

#### 🔹 Sử dụng STORE

```sql
EXECUTE usp_ProductList
--Hoặc
EXEC usp_ProductList

--Chạy một Store có tham số

DECLARE @Total INT
EXEC usp_GetOrders '2021-01-01', '2021-01-31', @Total OUTPUT
SELECT @Total
```

#### 🔹 Sửa STORE

```sql
--Sử dụng từ khóa CREATE PROCEDURE
ALTER PROCEDURE usp_ProductList -- đặt tên với prefix usp_
AS
BEGIN
    SELECT 
        product_id, --thêm mới
        product_name, --thêm mới
        price,
        discount
    FROM 
        dbo.products
    ORDER BY 
        product_id;
END;
```

#### 🔹 Xóa STORE

```sql
DROP PROCEDURE usp_ProductList;
--Hoặc
DROP PROC usp_ProductList;
```

#### 🔹  Các tùy chọn khi tạo stored procedure

**WITH ENCRYPTION**

Với việc sử dụng WITH ENCRYPTION, mã nguồn của đối tượng sẽ được mã hóa và không thể đọc hoặc truy cập trực tiếp thông qua các công cụ SQL Server Management Studio (SSMS) hoặc các công cụ khác. Khi một đối tượng được mã hóa, SQL Server sẽ chỉ thực thi đối tượng đó mà không cung cấp truy cập vào mã nguồn.

```sql
CREATE PROCEDURE usp_GetOrders
WITH ENCRYPTION
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END
```

**WITH RECOMPILE**

Với việc sử dụng WITH RECOMPILE, stored procedure sẽ được biên dịch lại mỗi khi thực thi. Điều này sẽ giúp tăng hiệu suất thực thi của stored procedure.

```sql
CREATE PROCEDURE usp_GetOrders
WITH RECOMPILE
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END
```

**WITH EXECUTE AS**

Với việc sử dụng WITH EXECUTE AS, stored procedure sẽ được thực thi với quyền của người dùng được chỉ định.

Tạo stored procedure và thực thi với quyền của người dùng được chỉ định

```sql
CREATE PROCEDURE usp_GetOrders
WITH EXECUTE AS 'dbo'
  @FromDate DATETIME,
  @ToDate DATETIME
AS
BEGIN
  SELECT o.*, od.product_id, od.quantity, od.price, od.discount
  FROM orders AS o
    INNER JOIN order_items AS od ON o.order_id = od.order_id
  WHERE o.order_date BETWEEN @FromDate AND @ToDate
END
```


### 💥 Querying Metadata

Trong SQL Server, querying metadata (truy vấn siêu dữ liệu) là quá trình truy vấn thông tin về cấu trúc và thông tin liên quan đến cơ sở dữ liệu, bảng, cột, view, Stored Procedure và các đối tượng khác trong hệ thống quản lý cơ sở dữ liệu.

Thông tin metadata cung cấp mô tả về cấu trúc và đặc điểm của cơ sở dữ liệu, bảng, cột và các đối tượng khác trong cơ sở dữ liệu. Bằng cách truy vấn metadata, bạn có thể tìm hiểu về cấu trúc của cơ sở dữ liệu, xem thông tin về các đối tượng và thu thập thông tin để phân tích và quản lý cơ sở dữ liệu.

Có một số hệ thống bảng dữ liệu (system tables) và hàm metadata dành riêng trong SQL Server để truy vấn thông tin metadata. Dưới đây là một số ví dụ về cách truy vấn metadata trong SQL Server:

1. Truy vấn thông tin về bảng và cột: Bạn có thể sử dụng các hệ thống bảng như sys.tables, sys.columns để truy vấn thông tin về các bảng và cột trong cơ sở dữ liệu. Ví dụ:

```sql
SELECT *
FROM sys.tables
WHERE name = 'Tên_Bảng'

SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Tên_Bảng')
```

2. Truy vấn thông tin về Stored Procedure: Bạn có thể sử dụng hệ thống bảng như sys.procedures để truy vấn thông tin về các Stored Procedure trong cơ sở dữ liệu. Ví dụ:

```sql
SELECT *
FROM sys.procedures
WHERE name = 'Tên_Stored_Procedure'
```

3. Truy vấn thông tin về view: Bạn có thể sử dụng hệ thống bảng như sys.views để truy vấn thông tin về các view trong cơ sở dữ liệu. Ví dụ:

```sql
SELECT *
FROM sys.views
WHERE name = 'Tên_View'
```
4. Truy vấn thông tin về ràng buộc (constraints), chỉ mục (indexes) và khóa ngoại (foreign keys): Bạn có thể sử dụng các hệ thống bảng như sys.foreign_keys, sys.indexes, sys.key_constraints để truy vấn thông tin chi tiết về các ràng buộc, chỉ mục và khóa ngoại trong cơ sở dữ liệu.

Truy vấn metadata cung cấp cho bạn một cái nhìn tổng quan về cấu trúc và thông tin liên quan đến cơ sở dữ liệu và đối tượng trong SQL Server. Điều này giúp bạn hiểu rõ hơn về cấu trúc dữ liệu và có khả năng xây dựng các truy vấn và tác vụ phức tạp dựa trên thông tin metadata.

## Review Homeworks

Giải các bài tập homework theo nội dung vừa học, áp dụng view, store để tái sử dụng code