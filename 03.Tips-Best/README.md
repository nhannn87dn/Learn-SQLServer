# Tips Improve SQL Query Performance

NHỮNG YẾU TỐ NÀO ẢNH HƯỞNG ĐẾN HIỆU SUẤT DATABASE ?

- SQL Server Performance Essentials – Full Course: https://www.youtube.com/watch?v=HvxmF0FUwrM
- https://github.com/iCodeMechanic/Essentials-of-Sql-Server-Performance-for-Every-Developer/tree/master

- https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver16

- [https://www.sqlshack.com/searching-the-sql-server-query-plan-cache/](https://www.sqlshack.com/searching-the-sql-server-query-plan-cache/)

- [https://www.sqlshack.com/understanding-sql-server-query-plan-cache/](https://www.sqlshack.com/understanding-sql-server-query-plan-cache/)

- https://www.sqlshack.com/query-optimization-techniques-in-sql-server-parameter-sniffing/

- https://www.sqlshack.com/filtered-indexes-performance-analysis-and-hidden-costs/

- https://www.sqlshack.com/sql-server-query-store-overview/

- https://use-the-index-luke.com/sql/anatomy/the-tree



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

- <https://quantricsdulieu.com/tim-hieu-index-trong-sql-server-phan-1/>
- <https://quantricsdulieu.com/tim-hieu-index-trong-sql-server-phan-2/>
- <https://quantricsdulieu.com/hanh-trinh-dem-sao-4-do-luong-hieu-suat-truy-van-t-sql/>
