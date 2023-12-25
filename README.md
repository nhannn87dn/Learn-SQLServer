# Learn SQL Server

## Outline

1. Day 01

- Session 01 - RDBMS Concepts
- Session 02 - Entity-Relationship (E-R) Model

2. Day 02

- Session 02 - Normalization
- Session 03 - Introduction to SQL Server 2019

3. Day 03

- Session 04 - Transact SQL - Data Types

4. Day 04

- Session 05 - Creating and Managing Databases
- Session 06 - Creating Tables, INSERT, UPDATE, DELETE

5. Day 05

- Session 08 - Accessing Data : SELECT
- Session 09 - Advanced Queries and Joins - Part 1: GROUP BY, HAVING, GROUPING SETS

6. Day 06

- Session 09 - Advanced Queries and Joins - Part 2: JOINs
- Session 14 - Transactions

7. Day 07

- Session 13 - Programming Transact-SQL - User Functions, Window Functions
- Session 15 - Error Handing

8. Day 08

- Session 12 - Triggers
- Session 10 - View, Stored Procedures and Querying Metadata

9. Day 09

- Session 16 - Enhancements in SQL Server 2019
- Session 17 - PolyBase, Query Store, and Stretch Database

10. Day 10

- Session 11 - Indexes
- Session 07 - Azure SQL

## Data Samples

- <https://github.com/Microsoft/sql-server-samples/tree/master/samples>

- <https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms>

## References

- <https://www.sqlservertutorial.net>
- <https://www.w3schools.com/sql/default.asp>

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
