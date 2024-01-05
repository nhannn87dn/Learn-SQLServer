# Homework

## ERD and Normalization

### Bài 1 (BikeStores)

Cho mẫu dữ liệu sau

| ProductId | CategoryId | CategoryName           | ProductName       | BrandId | BrandName | Price |
|-----------|------------|------------------------|-------------------|------------|--------------|-------|
| 142       | 113, 124   | FASHION, SMART DEVICES | Apple Watch       | 120        | APPLE        | 1,200 |
| 168       | 113        | FASHION                | T-SHIRT           | 122        | CK           | 700   |
| 263       | 113        | FASHION                | DRESS             | 145        | TOMMY        | 350   |
| 109       | 124        | SMART DEVICES          | iPhone 14 PRO MAX | 120        | APPLE        | 2,200 |


- Hãy phân tích và chuẩn hóa thành chuẩn 3NF
- Sau đó vẽ sơ đồ E.R.D

### Bài 2 (BikeStores)

Cho mẫu dữ liệu Orders sau:

| OrderId | CustomerId | CustomerName | CreatedAt  | StaffId | StaffName | Status | StatusName |
|---------|------------|--------------|------------|------------|--------------|--------|------------|
| 142     | 124        | James        | 2023-04-10 | 334        | Jack         | P      | Pending    |
| 168     | 113        | Peter        | 2023-04-10 | 453        | Mary         | P      | Pending    |
| 263     | 113        | Peter        | 2023-04-05 | 234        | Andrew       | C      | Completed  |
| 109     | 124        | James        | 2023-03-12 | 112        | Tom          | C      | Completed  |


Cho mẫu dữ liệu Order_Items sau:


| OrderId | ProductId | ProductName | Price | Quantity | Unit  | Discount |
|---------|-----------|-------------|-------|----------|-------|----------|
| 142     | P001      | Pencil      | 10    | 1        | Item  | 0        |
| 142     | P987      | Ruler       | 5     | 2        | Item  | 0        |
| 263     | P987      | Ruler       | 5     | 3        | Item  | 0        |
| 3109    | P098      | Paper       | 2     | 50       | Paper | 10       |


- Hãy phân tích và chuẩn hóa thành chuẩn 3NF
- Sau đó vẽ sơ đồ E.R.D


### Bài 3 

Khai thác yêu cầu khách hàng thực tế ==> Chuyển thành Database

Tình huống:

- Chủ khách sạn muốn số hóa việc quản lý phòng, đặt phòng khách sạn muốn:
  - Quản lý phòng: Xem được danh sách phòng khách sạn đang có, bao gồm số lượng phòng cho mỗi loại phòng, phòng nào đang trống...
  - Quản lý Danh mục phòng: Ví dụ phòng Standard, Superior, Deluxe, Suite
  - Đặt phòng: Quản lí đơn đặt phòng
  - Quản lý nhân viên: Danh sách nhân viên

Hãy vẽ sơ đồ E.R.D và chuẩn hóa thành chuẩn 3NF

