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

### 💥 Combining Data

#### 🔹 UNION

Dùng để kết hợp các bản ghi của 2 hoặc nhiều câu lệnh SELECT lại với nhau. Các câu lệnh SELECT phải có cùng số lượng cột và kiểu dữ liệu tương ứng. UNION sẽ loại bỏ các bản ghi trùng lặp.

![union](img/SQL-Server-UNION-vs-JOIN.png)

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


## 💛 Session 10- View, Stored Procedures and Querying Metadata