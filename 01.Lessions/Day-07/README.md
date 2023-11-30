# Day 7
💥 🔹
## 💛 Session 11 - Indexes

Trong SQL Server, indexs (chỉ mục) là cấu trúc dữ liệu được sử dụng để tăng tốc độ truy vấn và tìm kiếm dữ liệu trong cơ sở dữ liệu. Chúng giúp tối ưu hóa hiệu suất truy vấn bằng cách tạo ra một cấu trúc dữ liệu phụ bên cạnh bảng gốc, có thể được sắp xếp và tìm kiếm nhanh hơn.

Các loại indexs mà SQL Server hỗ trợ: https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes?view=sql-server-ver16

### 💥 Clustered index

https://learn.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16

Trong cơ sở dữ liệu, một "clustered index" (chỉ mục gom cụm) là một loại chỉ mục được tạo ra để sắp xếp và lưu trữ dữ liệu trong một bảng theo một thứ tự nhất định. Khi một clustered index được tạo, dữ liệu trong bảng sẽ được tổ chức thành một cấu trúc gom cụm dựa trên giá trị của chỉ mục đó.

Một bảng chỉ có thể có một clustered index duy nhất. Khi tạo clustered index, dữ liệu trong bảng được sắp xếp theo giá trị của chỉ mục. Chính vì vậy, clustered index ảnh hưởng trực tiếp đến vị trí lưu trữ của dữ liệu trong bảng.

Với một clustered index, việc tìm kiếm dữ liệu dựa trên giá trị chỉ mục được thực hiện nhanh chóng, vì dữ liệu đã được sắp xếp theo thứ tự của chỉ mục. Khi một truy vấn truy cập dữ liệu dựa trên clustered index, hệ quản trị cơ sở dữ liệu có thể sử dụng việc gom cụm để tìm kiếm dữ liệu hiệu quả hơn.

Tuy nhiên, việc thay đổi dữ liệu trong một bảng có clustered index có thể phức tạp hơn. Khi dữ liệu được thay đổi, các hàng có thể phải được di chuyển lại trong bảng để duy trì thứ tự của chỉ mục. Điều này có thể ảnh hưởng đến hiệu suất ghi và cập nhật dữ liệu.

Clustered index thường được sử dụng trong các truy vấn phân trang, truy vấn dựa trên phạm vi giá trị và các truy vấn sắp xếp dữ liệu.

### 💥  Cấu trúc B-TREE

Là một cấu trúc dữ liệu được sử dụng để lưu trữ dữ liệu trong cơ sở dữ liệu. Cấu trúc này được sử dụng trong các hệ quản trị cơ sở dữ liệu quan hệ như SQL Server, Oracle, MySQL, PostgreSQL, SQLite, v.v. để lưu trữ dữ liệu trong các bảng. Cấu trúc B-Tree được sử dụng để lưu trữ các chỉ mục trong các hệ quản trị cơ sở dữ liệu này.

Vễ sơ đồ B-TREE bằng mermaid


Ví dụ

```sql
--Tạo clustered index
CREATE CLUSTERED INDEX IX_Persons_Name
ON Persons (LastName, FirstName);
```

### 💥  Nonclustered index

Trong cơ sở dữ liệu, một "nonclustered index" (chỉ mục không gom cụm) là một loại chỉ mục được tạo ra để cải thiện hiệu suất tìm kiếm và truy xuất dữ liệu trong một bảng. Nonclustered index lưu trữ dữ liệu chỉ mục riêng biệt và không sắp xếp dữ liệu trong bảng dựa trên chỉ mục đó.

Khi tạo một nonclustered index, hệ quản trị cơ sở dữ liệu sẽ tạo ra một bảng thứ hai để lưu trữ chỉ mục. Bảng này chứa các cột chỉ mục và các con trỏ đến bản gốc của dữ liệu trong bảng chính. Chỉ mục này giúp tìm kiếm nhanh chóng các giá trị dựa trên các cột chỉ mục đã được xác định.

Với một nonclustered index, khi thực hiện một truy vấn tìm kiếm dữ liệu dựa trên cột có chỉ mục, hệ quản trị cơ sở dữ liệu sẽ sử dụng chỉ mục để tìm kiếm dữ liệu một cách hiệu quả. Nó có thể giúp giảm thời gian truy cập và tìm kiếm dữ liệu trong các truy vấn phức tạp.

Một bảng có thể có nhiều nonclustered index được tạo ra trên các cột khác nhau để hỗ trợ các truy vấn khác nhau. Tuy nhiên, việc tạo quá nhiều chỉ mục có thể ảnh hưởng đến hiệu suất ghi và cập nhật dữ liệu, vì khi dữ liệu thay đổi, các chỉ mục cần được cập nhật tương ứng.

Nonclustered index thường được sử dụng trong các truy vấn tìm kiếm, phân trang và sắp xếp dữ liệu.

Ví dụ

```sql
--Tạo nonclustered index
CREATE NONCLUSTERED INDEX IX_Persons_Name
ON persons (LastName, FirstName);
```

### 💥   Unique index

Trong cơ sở dữ liệu, một "unique index" (chỉ mục duy nhất) là một loại chỉ mục được tạo ra để đảm bảo tính duy nhất của các giá trị trong một cột hoặc một nhóm cột trong một bảng dữ liệu. Unique index đảm bảo rằng không có hai bản ghi nào trong cơ sở dữ liệu có cùng giá trị cho cột hoặc nhóm cột được chỉ mục.

Mục đích chính của unique index là ngăn chặn việc xuất hiện các giá trị trùng lặp trong một cột hoặc nhóm cột quan trọng. Khi một unique index được áp dụng cho một cột, hệ quản trị cơ sở dữ liệu sẽ kiểm tra tự động mỗi khi có thay đổi dữ liệu, đảm bảo rằng không có giá trị trùng lặp nào được chèn vào cột đó.

Unique index cũng có thể cung cấp một cách nhanh chóng để tìm kiếm dữ liệu theo giá trị duy nhất. Khi một unique index được tạo trên một cột, việc tìm kiếm dữ liệu dựa trên giá trị của cột đó sẽ nhanh chóng hơn do việc tạo chỉ mục.

Đôi khi unique index cũng được gọi là "unique constraint" (ràng buộc duy nhất), bởi vì nó tạo ra một ràng buộc trên dữ liệu đảm bảo tính duy nhất.

Ví dụ

```sql
--Tạo unique index
CREATE UNIQUE INDEX IX_PersonID
ON Persons (Email);
```

### 💥  Full-text

https://learn.microsoft.com/en-us/sql/relational-databases/search/populate-full-text-indexes?view=sql-server-ver16

Full-text search (tìm kiếm toàn văn bản) trong SQL Server là một tính năng cho phép tìm kiếm và truy vấn dữ liệu dựa trên nội dung của văn bản, bao gồm cả từ đơn, cụm từ và các biểu thức tìm kiếm phức tạp. Tính năng full-text search được thiết kế để cung cấp khả năng tìm kiếm nhanh chóng và hiệu quả trong các cơ sở dữ liệu lớn chứa dữ liệu văn bản.

Khi kích hoạt full-text search cho một cơ sở dữ liệu hoặc bảng trong SQL Server, hệ thống sẽ xây dựng và duy trì một chỉ mục toàn văn bản (full-text index) dựa trên các cột chứa dữ liệu văn bản. Chỉ mục này sẽ phân tích và lưu trữ thông tin về từ và cụm từ trong dữ liệu văn bản, tạo nên một cơ sở dữ liệu toàn văn bản riêng biệt.

Lợi ích chính của full-text search trong SQL Server bao gồm:

- Tìm kiếm nhanh chóng: Chỉ mục toàn văn bản giúp cải thiện hiệu suất tìm kiếm và truy vấn dữ liệu văn bản. Nó sử dụng các thuật toán tối ưu để tìm kiếm và truy xuất kết quả nhanh chóng.

- Tìm kiếm đa dạng: Full-text search hỗ trợ các biểu thức tìm kiếm phức tạp như tìm kiếm theo từ đơn, cụm từ, kết hợp các điều kiện tìm kiếm, sử dụng các toán tử logic, và tìm kiếm gần giống (fuzzy search).

- Xếp hạng kết quả: Khi tìm kiếm dựa trên full-text search, kết quả trả về có thể được xếp hạng theo độ phù hợp với yêu cầu tìm kiếm. Điều này giúp hiển thị các kết quả quan trọng hơn đầu tiên và cung cấp khả năng tùy chỉnh xếp hạng.

Full-text search được sử dụng trong các ứng dụng nhu cầu tìm kiếm văn bản phong phú, như hệ thống blog, hệ thống quản lý nội dung, diễn đàn, trang web thương mại điện tử và các ứng dụng có nhu cầu tìm kiếm dựa trên nội dung văn bản mạnh

### 💥  Columnstore index

Columnstore index (chỉ mục cột) là một loại chỉ mục trong cơ sở dữ liệu, được thiết kế đặc biệt để tối ưu hóa truy vấn phân tích dữ liệu trong các hệ thống quản lý cơ sở dữ liệu. Columnstore index lưu trữ và quản lý dữ liệu theo cột (columnar storage) thay vì theo hàng như trong chỉ mục truyền thống.

Với columnstore index, dữ liệu trong một bảng được tổ chức và lưu trữ theo cột, tức là các giá trị trong một cột được lưu trữ liên tiếp trong bộ nhớ hoặc đĩa. Điều này mang lại nhiều lợi ích về hiệu suất khi truy vấn dữ liệu.

Một trong những lợi ích chính của columnstore index là khả năng nén dữ liệu. Do các giá trị trong một cột thường có tính chất tương tự và lặp lại, columnstore index có thể nén dữ liệu hiệu quả hơn so với chỉ mục truyền thống. Điều này giúp giảm dung lượng lưu trữ cần thiết và cải thiện hiệu suất truy vấn.

Columnstore index cũng cung cấp khả năng xử lý dữ liệu hàng loạt (batch processing) cho các truy vấn phân tích dữ liệu. Khi truy vấn được thực thi, columnstore index có thể đọc và xử lý các cột liên tiếp, giúp tối ưu hóa việc truy cập dữ liệu và thực hiện các phép tính trên dữ liệu một cách hiệu quả.

Columnstore index thường được sử dụng trong các hệ thống quản lý cơ sở dữ liệu dành cho phân tích dữ liệu (data analytics), nơi hiệu suất truy vấn và xử lý dữ liệu là yếu tố quan trọng. Nó thường được áp dụng trong các tình huống có khối lượng dữ liệu lớn và các truy vấn phức tạp.

### 💥   Filtered index

Filtered index trong SQL Server là một loại chỉ mục có điều kiện, chỉ lưu trữ và xử lý dữ liệu cho một phần nhỏ của các hàng trong một bảng dựa trên một điều kiện được xác định trước. Nó cho phép bạn tạo chỉ mục trên một tập hợp con của dữ liệu trong bảng thay vì toàn bộ dữ liệu.

Khi tạo filtered index, bạn chỉ định một điều kiện WHERE để chỉ định các hàng nào sẽ được lưu trữ trong chỉ mục. Chỉ các hàng thỏa mãn điều kiện này mới được lưu trữ trong filtered index, trong khi các hàng không thỏa mãn điều kiện sẽ không được đưa vào chỉ mục.

Lợi ích chính của filtered index bao gồm:

Giảm kích thước chỉ mục: Vì chỉ mục chỉ lưu trữ các hàng thỏa mãn điều kiện, nó có thể giảm kích thước của chỉ mục so với chỉ mục truyền thống, giảm không gian lưu trữ và tối ưu hóa hiệu suất truy vấn.

Cải thiện hiệu suất truy vấn: Filtered index giúp cung cấp một chỉ mục nhỏ hơn để tìm kiếm nhanh chóng dữ liệu thỏa mãn điều kiện được xác định. Nó cải thiện hiệu suất truy vấn bằng cách giảm số lượng bảng dữ liệu cần được quét và chỉ tập trung vào các hàng quan trọng.

Giảm tải và tối ưu hóa dữ liệu: Với filtered index, các hoạt động ghi và cập nhật chỉ cần thay đổi dữ liệu trong chỉ mục mà thỏa mãn điều kiện, giảm tải và tối ưu hóa quá trình ghi dữ liệu.

Filtered index thường được sử dụng trong các tình huống như:

Có một phần nhỏ dữ liệu trong bảng mà thường được truy cập hơn so với phần còn lại.
Các truy vấn thường xuyên yêu cầu dữ liệu thỏa mãn một điều kiện cụ thể.
Các bảng có kích thước lớn và tối ưu hóa hiệu suất truy vấn là yếu tố quan trọng.

### 💥  Spatial index

Spatial index trong SQL Server là một loại chỉ mục được thiết kế đặc biệt để hỗ trợ việc lưu trữ, truy vấn và xử lý dữ liệu không gian (dữ liệu liên quan đến vị trí và hình học). Nó cho phép tối ưu hóa truy vấn dựa trên thông tin không gian, như tìm kiếm các vị trí trong phạm vi, tính toán khoảng cách, xác định tương tác giữa các đối tượng không gian, và nhiều hoạt động không gian khác.

Spatial index sử dụng các thuật toán và cấu trúc dữ liệu đặc biệt để hiệu quả trong việc lưu trữ và truy vấn dữ liệu không gian. Chỉ mục này sẽ tổ chức dữ liệu không gian thành các tầng (levels) và quadtree (một cấu trúc dữ liệu phân chia không gian), cho phép tìm kiếm nhanh chóng các đối tượng không gian.

Lợi ích chính của spatial index trong SQL Server bao gồm:

- Hiệu suất truy vấn: Spatial index cải thiện hiệu suất truy vấn dữ liệu không gian bằng cách giảm số lượng dữ liệu cần được quét và tập trung vào khu vực chứa các đối tượng không gian quan trọng.

- Tìm kiếm nhanh chóng: Với spatial index, bạn có thể tìm kiếm các vị trí trong phạm vi, tính toán khoảng cách, xác định tương tác giữa các đối tượng không gian một cách hiệu quả và nhanh chóng.

Hỗ trợ các hoạt động không gian phức tạp: Spatial index cho phép thực hiện các hoạt động phức tạp như tìm kiếm đối tượng gần nhất, tính toán đường đi ngắn nhất, tìm kiếm đối tượng theo hình dạng, v.v.

Spatial index được sử dụng trong các ứng dụng liên quan đến dữ liệu không gian như hệ thống thông tin địa lý (GIS), quản lý tài sản, phân tích địa lý, và bất kỳ ứng dụng nào có nhu cầu truy vấn và xử lý dữ liệu không gian.

### 💥   XML index

https://learn.microsoft.com/en-us/sql/relational-databases/xml/xml-indexes-sql-server?view=sql-server-ver16

XML index trong SQL Server là một loại chỉ mục được tạo ra để tối ưu hóa việc truy vấn và xử lý dữ liệu XML trong cơ sở dữ liệu. Khi một XML index được tạo, nó cung cấp cấu trúc và cách lưu trữ dữ liệu XML để hỗ trợ các truy vấn XML hiệu quả.

XML index trong SQL Server có hai loại chính:

- Primary XML index: Đây là loại chỉ mục được tạo tự động cho cột XML trong bảng khi sử dụng tính năng XML trong SQL Server. Primary XML index sẽ tạo ra một cấu trúc đặc biệt để lưu trữ và tối ưu hóa việc truy vấn dữ liệu XML.

- Secondary XML index: Đây là loại chỉ mục được tạo thủ công trên một cột XML đã có primary XML index. Secondary XML index cung cấp một cấu trúc lưu trữ khác để tối ưu hóa các truy vấn XML khác nhau, ví dụ: truy vấn theo giá trị của các thuộc tính trong XML, truy vấn theo vị trí (path) của các thành phần trong XML, và truy vấn sử dụng các hàm XML.

Lợi ích chính của XML index trong SQL Server bao gồm:

- Hiệu suất truy vấn: XML index giúp cải thiện hiệu suất truy vấn dữ liệu XML bằng cách tạo ra một cấu trúc lưu trữ và cách truy xuất tối ưu cho dữ liệu XML. Nó giúp giảm số lượng dữ liệu cần quét và tập trung vào các phần quan trọng của dữ liệu XML.

- Truy vấn phức tạp: XML index hỗ trợ các truy vấn XML phức tạp như truy vấn theo giá trị thuộc tính, truy vấn theo vị trí thành phần, và truy vấn sử dụng các hàm XML. Nó cung cấp khả năng tìm kiếm nhanh chóng và hiệu quả trong dữ liệu XML phong phú.

XML index được sử dụng trong các ứng dụng liên quan đến dữ liệu XML như hệ thống quản lý nội dung, dịch vụ web, tích hợp dữ liệu từ các nguồn XML, và các ứng dụng có nhu cầu truy vấn và xử lý dữ liệu XML mạnh.

Để tạo, xóa và đổi tên index trong SQL Server, bạn có thể sử dụng các câu lệnh SQL sau đây:

1. Tạo index:
   - Tạo Clustered Index:
     ```sql
     CREATE CLUSTERED INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)
     ```
   - Tạo Nonclustered Index:
     ```sql
     CREATE NONCLUSTERED INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)
     ```
   - Tạo Unique Index:
     ```sql
     CREATE UNIQUE INDEX [IndexName] ON [TableName] ([Column1], [Column2], ...)
     ```
   - Tạo Columnstore Index:
     ```sql
     CREATE CLUSTERED COLUMNSTORE INDEX [IndexName] ON [TableName]
     ```
   - Tạo Full-Text Index:
     ```sql
     CREATE FULLTEXT INDEX ON [TableName] ([Column1], [Column2], ...)
     ```
   - Tạo Spatial Index:
     ```sql
     CREATE SPATIAL INDEX [IndexName] ON [TableName] ([Column1])
     ```

2. Xóa index:
   - Xóa index:
     ```sql
     DROP INDEX [IndexName] ON [TableName]
     ```
   - Xóa clustered index:
     ```sql
     ALTER TABLE [TableName] DROP CONSTRAINT [IndexName]
     ```

3. Đổi tên index:
   - Đổi tên index:
     ```sql
     EXEC sp_rename '[TableName].[OldIndexName]', '[NewIndexName]', 'INDEX'
     ```
   - Đổi tên clustered index:
     ```sql
     EXEC sp_rename '[TableName].[OldIndexName]', '[NewIndexName]', 'OBJECT'
     ```

Lưu ý: Trước khi thực hiện các thay đổi trên index, hãy đảm bảo rằng bạn có quyền thực hiện các câu lệnh CREATE, ALTER và DROP trên cơ sở dữ liệu và bảng tương ứng. Hãy cẩn thận khi xóa hoặc đổi tên index, vì nó có thể ảnh hưởng đến hiệu suất và tính khả dụng của cơ sở dữ liệu.



## 💛 Session 12 - Triggers

### 💥 Trigger là gì?

- Trigger là một đối tượng trong SQL Server, nó được sử dụng để thực thi một tập hợp các câu lệnh SQL khi một sự kiện xảy ra. Sự kiện có thể là một câu lệnh INSERT, UPDATE hoặc DELETE. Trigger có thể được kích hoạt trước hoặc sau khi sự kiện xảy ra.

- Không giống như stored procedure, trigger không được gọi bởi một ứng dụng hoặc một người dùng. Trigger được kích hoạt bởi một sự kiện như INSERT, UPDATE, DELETE và không thể được gọi như một stored procedure


### 💥 DML Trigger

Là loại trigger được kích hoạt bởi các câu lệnh DML như INSERT, UPDATE hoặc DELETE. Có hai loại DML trigger:

- **After trigger**: được kích hoạt sau khi sự kiện xảy ra.
- **Instead of trigger**: được kích hoạt thay thế cho sự kiện.

> Lưu ý: Có 2 bảng inserted và deleted được sử dụng trong trigger. Bảng inserted chứa các bản ghi được thêm vào bởi câu lệnh INSERT hoặc UPDATE. Table deleted chứa các bản ghi bị xóa bởi câu lệnh DELETE hoặc UPDATE.

Thứ tự thực thi của các DML trigger:

- Các trigger INSTEAD OF được kích hoạt trước.
- Các trigger AFTER được kích hoạt sau.

```sql
sp_settriggerorder [@triggername = ] 'triggername' , [@order = ] 'order' , [@stmttype = ] 'stmttype'
```

### 🔹 AFTER Trigger

Ví dụ: Tình huống gặp trong thực tế. Khi có đơn đặt hàng, và đơn đã xác nhận thanh toán thành công, thì phải cập nhật trạng thái tồn kho giảm đi = số lượng sản phẩm có trong đơn hàng đã mua.

Và theo cách thông thường: Khi gọi câu lệnh cập nhật xác nhận thanh toán thành công. Bạn làm tiếp câu lệnh cập nhật số lượng tồn kho.

Thay vì thế chúng ta có thể tạo một Trigger thực hiện cập nhật tồn kho một cách tự động (chạy ngầm) khi một đơn hàng được xác nhận thanh toán thành công.

```sql

CREATE TRIGGER trg_OrderItems_Update_ProductStock
ON order_items
AFTER INSERT
AS
BEGIN
    UPDATE stocks
        SET quantity = s.quantity - i.quantity
    FROM
       stocks as s
    INNER JOIN inserted AS i ON s.product_id = i.product_id
	INNER JOIN orders AS o ON o.order_id = i.order_id AND o.store_id = s.store_id;
END;
```

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

    IF EXISTS (SELECT * FROM deleted WHERE [order_status] = 4)
    BEGIN
        PRINT 'Cannot delete order having status = 4 (COMPLETED).'
        ROLLBACK -- Hủy lệnh DELETE trước đó vào orders
    END
END;
```

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

### 🔹 INSTEAD OF Trigger

INSTEAD OF trigger là một trigger cho phép bạn bỏ qua một câu lệnh INSERT, DELETE hoặc UPDATE đối với một bảng hoặc một view và thay vào đó thực thi các câu lệnh khác được định nghĩa trong trigger. Thực tế, việc INSERT, DELETE hoặc UPDATE không xảy ra.


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


### 💥 DDL Trigger

DDL Trigger được kích hoạt bởi sự kiện ở cấp độ Server hoặc Databse. 

Các sự kiện này được tạo ra bởi câu lệnh Transact-SQL thường bắt đầu bằng một trong các từ khóa sau: CREATE, ALTER, DROP, GRANT, DENY, REVOKE hoặc UPDATE STATISTICS.


Các trigger DDL rất hữu ích trong các trường hợp sau:

- Ghi lại các thay đổi trong cấu trúc CSDL.
- Ngăn chặn một số thay đổi cụ thể trong cấu trúc CSDL.
- Phản hồi một thay đổi trong cấu trúc CSDL.


Lưu ý: Triggler loại này lưu ở `Databse Name --> Programmability --> Database Triggers`


Ví dụ: Tạo một trigger để ngăn chặn việc xóa bảng customers

```sql
CREATE TRIGGER trg_customers_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        PRINT 'Cannot drop the table: Customers.'
        ROLLBACK
    END
END;
```

Ví dụ 2: Tạo một trigger để ghi nhật ký sửa đổi cấu trúc bảng customers

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
CREATE TRIGGER trg_customers_LogAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
    BEGIN
        INSERT INTO dbo.logs ([Date], [User], [Host], [Action], [Table])
        SELECT GETDATE(), USER_NAME(), HOST_NAME(), 'ALTER TABLE', 'customers'
    END
END
```


### 💥 Disable Trigger

Vô hiệu hóa hoạt động của một Trigger

```sql
DISABLE TRIGGER [schema_name.][trigger_name] 
ON [object_name | DATABASE | ALL SERVER]

```
Ví dụ:

```sql
DISABLE TRIGGER dbo.trg_customers_LogAlterTable 
ON dbo.customers;
```

Vô hiệu hóa tất cả trigger trên một table

```sql
DISABLE TRIGGER ALL ON table_name;
```



Vô hiệu hóa tất cả trigger trên một Databse

```sql
DISABLE TRIGGER ALL ON DATABASE;
```


### 💥 Enable Trigger

Kích hoạt lại Trigger

```sql
ENABLE TRIGGER [schema_name.][trigger_name] 
ON [object_name | DATABASE | ALL SERVER]

```

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

### 💥 Delete Trigger

Cú pháp:

```sql
DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]   
ON { DATABASE | ALL SERVER };
```

