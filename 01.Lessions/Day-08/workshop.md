# Bài tập


### **Bài 1: Transaction - Chuyển tiền giữa hai tài khoản**

Viết một Transaction thực hiện nghiệp vụ chuyển tiền giữa hai tài khoản ngân hàng. Yêu cầu: 
- Trừ tiền từ tài khoản người gửi.
- Cộng tiền vào tài khoản người nhận.
- Kiểm tra số dư người gửi đủ trước khi thực hiện giao dịch.
- Ghi log giao dịch thành công hoặc thất bại.

---

### **Bài 2: Trigger - Ghi log khi chuyển tiền**

Tạo một trigger tự động ghi log vào bảng `bank_log` khi có thay đổi số dư trong bảng `bank`. Yêu cầu:
- Log đầy đủ chi tiết giao dịch (ID tài khoản, số dư trước và sau, thời gian cập nhật).
- Đảm bảo trigger chỉ ghi log khi có thay đổi thực sự (không ghi log nếu số dư không đổi).

---

### **Bài 3: Trigger - Ngăn không cho số dư âm**

Viết một trigger trên bảng `bank` để ngăn không cho bất kỳ tài khoản nào có số dư âm. Yêu cầu:
- Hủy giao dịch `UPDATE` hoặc `INSERT` nếu phát hiện số dư bị âm.
- Ghi log thông báo lý do vào bảng `bank_log` nếu giao dịch bị hủy.

---

### **Bài 4: Transaction - Rút tiền**

Viết stored procedure để xử lý nghiệp vụ rút tiền từ tài khoản. Yêu cầu:
- Trừ tiền từ tài khoản rút.
- Kiểm tra số dư tài khoản đủ trước khi thực hiện.
- Nếu rút tiền thất bại, không thay đổi dữ liệu.

---

### **Bài 5: Trigger - Giới hạn số lần giao dịch hàng ngày**

Tạo trigger để kiểm tra số lần giao dịch của mỗi tài khoản trong một ngày. Yêu cầu:
- Mỗi tài khoản chỉ được giao dịch tối đa 5 lần/ngày.
- Nếu vượt quá giới hạn, hủy giao dịch và ghi log thông báo.

---

### **Bài 6: Transaction & Trigger - Hoàn tiền khi giao dịch thất bại**

Mô phỏng nghiệp vụ hoàn tiền:
- Viết một stored procedure cho phép chuyển tiền.
- Nếu giao dịch thất bại (do lỗi trigger hoặc kiểm tra khác), rollback toàn bộ thay đổi và ghi log giao dịch thất bại.

---

### **Bài 7: Trigger - Gửi cảnh báo khi số dư thấp**

Tạo trigger để kiểm tra số dư trong tài khoản sau khi giao dịch. Yêu cầu:
- Nếu số dư dưới 100, tự động ghi log cảnh báo trong bảng `bank_log`.
- Cảnh báo phải chứa thông tin ID tài khoản và số dư hiện tại.

---

### **Bài 8: Transaction - Giao dịch hàng loạt**

Viết một stored procedure để thực hiện nhiều giao dịch chuyển tiền từ danh sách tài khoản (danh sách này được truyền vào dạng bảng). Yêu cầu:
- Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu.
- Nếu bất kỳ giao dịch nào trong danh sách thất bại, rollback toàn bộ giao dịch.

---

### **Bài 9: Trigger - Kiểm tra giới hạn giao dịch**

Tạo trigger trên bảng `bank` để kiểm tra:
- Giao dịch không được vượt quá 1,000,000 trong một lần chuyển tiền.
- Nếu vi phạm, hủy giao dịch và ghi log lý do.

---

### **Bài 10: Trigger - Ghi log lịch sử giao dịch chi tiết**

Tạo trigger để lưu chi tiết tất cả các giao dịch (INSERT, UPDATE, DELETE) trong một bảng `bank_history` mới. Yêu cầu:
- Lưu tất cả thông tin trước và sau khi thay đổi.
- Lưu loại thao tác (INSERT, UPDATE, DELETE).

---

### **Bảng dữ liệu tham khảo**

#### **Bảng `bank`**:
```sql
CREATE TABLE bank (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50),
    balance DECIMAL(10, 2) CHECK (balance >= 0)
);
```

#### **Bảng `bank_log`**:
```sql
CREATE TABLE bank_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    note NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE()
);
```

#### **Bảng `bank_history`** (cho bài 10):
```sql
CREATE TABLE bank_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    bank_id INT,
    operation NVARCHAR(10),
    old_balance DECIMAL(10,2),
    new_balance DECIMAL(10,2),
    created_at DATETIME DEFAULT GETDATE()
);
```

---
