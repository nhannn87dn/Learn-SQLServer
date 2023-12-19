# Một số khái niệm

- 



## Data Samples

- https://github.com/Microsoft/sql-server-samples/tree/master/samples

- https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms

## References

- https://www.sqlservertutorial.net
- https://www.w3schools.com/sql/default.asp

## Tips


Tạo số ngẫu nhiên 1-4

```sql
ABS(CHECKSUM(NEWID())) % 4 + 1
```

Tạo ngày ngẩu nhiên từ 1970-01-01 

```sql
UPDATE customers
SET birthday = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '1970-01-01', GETDATE()), '1970-01-01')
```

## Tips Performance

- https://quantricsdulieu.com/tim-hieu-index-trong-sql-server-phan-1/
- https://quantricsdulieu.com/tim-hieu-index-trong-sql-server-phan-2/
- https://quantricsdulieu.com/hanh-trinh-dem-sao-4-do-luong-hieu-suat-truy-van-t-sql/