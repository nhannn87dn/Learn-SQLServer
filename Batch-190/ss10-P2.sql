CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY, -- ID tự tăng
    Username NVARCHAR(50) NOT NULL UNIQUE, -- Tên đăng nhập
    PasswordHash NVARCHAR(255) NOT NULL,   -- Mật khẩu đã băm
    Role NVARCHAR(20) DEFAULT 'User',      -- Vai trò (User, Admin, etc.)
    IsActive BIT DEFAULT 1,                -- Trạng thái tài khoản (1: hoạt động, 0: khóa)
    CreatedAt DATETIME DEFAULT GETDATE(),  -- Thời điểm tạo
    UpdatedAt DATETIME NULL                -- Thời điểm cập nhật lần cuối
);


SELECT PWDENCRYPT ('password')

PWDCOMPARE ( 'clear_text_password' , password_hash)
--return 1 or 0


CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL, 
    Role NVARCHAR(20) DEFAULT 'User',
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

INSERT Users (
	Username,Password
)
VALUES (
	'nhannn', '123456'
)

ALTER PROC usp_login(
	@Username NVARCHAR(50),
	@Password NVARCHAR(255)
)
AS
BEGIN
	BEGIN TRY
		-- Check trước sự tồn tại Username hoặc email trước
		IF EXISTS (SELECT 1 FROM  Users WHERE Username = @Username AND IsActive = 1)
			BEGIN
				-- Lấy thông tin để so khớp mật khẩu
				DECLARE @UserID INT;
				DECLARE @Role NVARCHAR(20);
				DECLARE @IsActive BIT;
				DECLARE @OldPassword NVARCHAR(255);
				DECLARE @Name NVARCHAR(50);
			
				SELECT 
					@UserID = UserID,
					@Name = Username,
					@OldPassword = Password,
					@Role = Role,
					@IsActive = IsActive
				FROM Users
				WHERE Username = @Username AND IsActive = 1;

				-- so sánh mật khẩu đang có trong db, với mật khẩu user nhập vào
				IF @OldPassword = @Password
					BEGIN
						SELECT @UserID, @Name, @Role, @IsActive
						RETURN; -- TRẢ VỀ THÔNG TIN NGƯỜI DÙNG
					END
				ELSE
					BEGIN
						SELECT 
						'Error' AS Status,
						'Username or passowrd is invalid' AS Message;
					END

			END
		-- Nếu không tìm thấy User thì xuất ra lỗi
		ELSE
			BEGIN
				-- Trả về thông báo lỗi
				SELECT 
					'Error' AS Status,
					'User not found' AS Message;
			END
		
	END TRY
    BEGIN CATCH
	-- Nếu có lỗi xảy ra, hiển thị thông tin lỗi
        SELECT
            'Error' AS Status,
            ERROR_MESSAGE() AS Message;
        --Ném lỗi
        THROW;
    END CATCH;
END

EXEC dbo.usp_login 'nhannn', '12345';