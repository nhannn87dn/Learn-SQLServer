# Day 02 

## 💛Session 02 - Normalization

Các bước phân tích, thiết kế CSDL

Trong thiết kế CSDL SQL Server, các khái niệm Normal 1 (1NF), Normal 2 (2NF) và Normal 3 (3NF) liên quan đến quy tắc bảo toàn tính nguyên vẹn dữ liệu trong quá trình lưu trữ và truy xuất dữ liệu. Dưới đây là giải thích cho từng khái niệm:

1. Normal 1 (1NF - First Normal Form): Đây là mức độ cơ bản nhất của chuẩn hóa dữ liệu. Theo quy tắc 1NF, một bảng được coi là tuân thủ khi không có giá trị lặp lại trong bất kỳ cột nào và mỗi cột chỉ chứa một giá trị duy nhất. Nó loại bỏ sự lặp lại và không cho phép các trường có nhiều giá trị.

2. Normal 2 (2NF - Second Normal Form): 2NF áp dụng khi dữ liệu trong bảng đã tuân thủ 1NF. Nó yêu cầu rằng một bảng phải có một khóa chính duy nhất và tất cả các cột phi khóa phải phụ thuộc vào toàn bộ khóa chính. Điều này đảm bảo rằng mọi cột phi khóa liên quan chức năng duy nhất với toàn bộ khóa chính, giúp loại bỏ sự phụ thuộc phi chức năng.

3. Normal 3 (3NF - Third Normal Form): 3NF áp dụng khi dữ liệu trong bảng đã tuân thủ 2NF. Quy tắc 3NF yêu cầu rằng mọi cột phi khóa phải phụ thuộc trực tiếp vào khóa chính, không được phụ thuộc vào nhau. Điều này đảm bảo rằng dữ liệu không có sự phụ thuộc chéo giữa các cột phi khóa và giúp giảm thiểu sự trùng lặp và các vấn đề liên quan đến cập nhật dữ liệu không nhất quán.

Các nguyên tắc chuẩn hóa này giúp tăng tính nhất quán, hiệu quả và dễ quản lý cho CSDL SQL Server, giúp tránh các vấn đề như sự lặp lại dữ liệu, phụ thuộc phi chức năng và không nhất quán dữ liệu.




## 💛Session 03 - Introduction to SQL Server 2019

- Cách cài đặt phần mềm
  - SQL SERVER 2019 EXPRESS EDITION: https://go.microsoft.com/fwlink/p/?linkid=2216019&culture=en-us&country=ww
  - SQL SERVER MANAGEMENT STUDIO (SSMS): https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16
- Sử dụng phần mềm cơ bản 


