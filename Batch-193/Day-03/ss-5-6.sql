-- cua so lenh
-- 1. tao database bang dong lenh
-- Syntax: 
-- CREATE DATABASE [database_name]
CREATE DATABASE Batch193
--2. Xoa Database
DROP DATABASE [ManagementHR] -- Neu ko ton tai --> bao loi
-- DROP DATABASE IF EXISTS [ManagementHR] --> ko ton tai --> ko bao loi

--3. Rename Database

--4. Comment -- ghi chu
/*
 Chi chu nhieu dong
 dong 1
 dong 2
*/

--5. Tạo Table
--5.1. Tạo Table = GUI
--5.2. Tạo Table = TSQL

USE Batch193 -- lua chon database su dung
GO -- doi dong lenh tren chay xong thi moi chay tiep
CREATE TABLE Teacher (
	--Khai bao cac columns o day
	teacher_id	INT NOT NULL,
	name		NVARCHAR(50) NOT NULL, -- bat buoc dien
	email		VARCHAR(50) NULL, -- cho phep ko dien
)
GO

CREATE TABLE [dbo].[myTable] (
    Id              INT,
    Age             TINYINT,
    Price           DECIMAL(18,2),
    Discount        DECIMAL(4,2),
    ProductName     NVARCHAR(255),
    BirthDay        DATE, --Kiểu ngày yyyy-mm-dd
    CreatedAt       DATETIME2, --kiểu yyyy-mm-dd H:i:s
    StartAt         TIME (0), -- H:i:s
    EndAt           TIME (0), -- H:i:s
    IsActive        BIT, -- 0 or 1
    Content         NVARCHAR(MAX), --Nội dung dài
    ModuleId        UNIQUEIDENTIFIER DEFAULT NEWID()
)


--6. Xoa table
DROP TABLE IF EXISTS [dbo].[Teacher]
create table [ba la] (
	id INT NOT NULL
)
DROP TABLE IF EXISTS dbo.[ba la]

--7. Chinh sua Table
---7.1 sua kieu du lieu mot column
ALTER TABLE dbo.myTable
ALTER column ProductName NVARCHAR(200) NULL
---7.2 sua ten column
EXEC sp_rename 'table_name.old_column_name', 'new_column_name', 'COLUMN';
--7.3 Them mot cot vao table
ALTER TABLE dbo.myTable
ADD slug NVARCHAR(200) NOT NULL
--7.4 Xoa mot cot vao table
ALTER TABLE dbo.myTable
DROP column slug



--8 Một số quy tắc cơ bản cần nắm
-- trong việc đặt tên
--8.1 Đặt tên database
-- + Mang tính gợi nhớ
-- + Cú pháp: tên dự án + tên loại hình Database
-- + ví dụ: softech_HRManagement
--8.1 Đặt tên table
-- + Mang tính gợi nhớ
-- + Phản ánh bản chất của thực thể 
-- + Tên nên đặt là tiếng anh dạng số nhiều
-- + Ví dụ: Students, Teachers, Employees
-- + Sinh_vien, giao_vien ==> ko de xuat
--8.3 Đặt tên cột
-- + Mang tính gợi nhớ
-- + Cần tuân theo 1 trong 3 style:
-- Pascal Case: FirstName (Các từ viết liền nhau, Kí tự đầu tiên mỗi từ HOA)
-- camel Case: firstName (Các từ viết liền nhau, Kí tự đầu tiên của từ thứ 2 trở đi HOA)
-- Snake Case: first_name (Các từ nối nhau bằng gạch dưới và viết thường hết)

