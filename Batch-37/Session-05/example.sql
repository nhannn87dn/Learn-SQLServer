CREATE TABLE classes (
	--att_name type allow null
	class_id int not null,
	class_name nvarchar(50) not null,
	class_description nvarchar(500) null
)

--Thay đổi class_description varchar(100)

ALTER TABLE classes 
ALTER COLUMN class_description nvarchar(500) null

--Thêm một trường mới vào table đang tồn tại
ALTER TABLE classes
ADD class_position varchar(3) null -- 001,002, 009

--Xóa một cột trong table
ALTER TABLE classes
DROP COLUMN class_position

--Đổi tên bảng
--sp_rename 'Tên_Bảng_Cũ', 'Tên_Bảng_Mới'

-- Lấy tất cả các trường dữ liệu từ một bảng
SELECT * FROM classes

-- Chèn dữ liệu vào table class
INSERT classes (
class_id, class_name, class_description
)
VALUES (
3, 'Batch36', 'Lập trình React' -- Lỗi tiếng việt
)


INSERT classes (
class_id, class_name, class_description
)
VALUES (
5, 'Batch32', N'Lập trình React' -- Không lỗi tiếng việt
)


--Chèn 1 lúc nhiều record
INSERT classes (
class_id, class_name, class_description
)
VALUES (
5, 'Batch32', N'Lập trình React' -- Không lỗi tiếng việt
),
(
6, 'Batch31', N'Lập trình Html' -- Không lỗi tiếng việt
)

--Thay đổi dữ liệu của table
-- Đổi tên Batch31 = Batch34 tại dòng class_id = 6
UPDATE dbo.classes SET
class_name = 'Batch34'
WHERE class_id = 6 
--Bắt buộc dùng mệnh đề WHERE để xác phạm vi tác động

-- Nếu không chỉ định WHERE 
-- => phạm tác động = toàn bộ records
UPDATE dbo.classes SET
class_description = N'Học lập trình tại Softech'

-- Xóa dữ liệu trong bảng
-- Xóa toàn bộ data có class_id = 6
DELETE dbo.classes 
WHERE class_id = 6 

-- XÓa tất cả record trong table
DELETE dbo.classes;
--hoặc
TRUNCATE TABLE dbo.classes