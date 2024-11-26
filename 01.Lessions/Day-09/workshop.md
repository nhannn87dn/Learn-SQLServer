# Worshop

```sql
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL, 
    Role NVARCHAR(20) DEFAULT 'User',
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);
```

- Tạo View
- Chèn dữ liệu thông qua View
- Viết Proc để lấy thông tin User có IsActive = 1 với đầu vào là Username, Password. Nếu không có thì trả về một kết quả Message với giá trị: Sai thông tin đăng nhập.