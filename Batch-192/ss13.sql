--1. Khai bao bien
--Syntax: DECLARE @<name> <data type> [= value];

DECLARE @TenBien NVARCHAR(50); 
--> Định nghĩa biến nhưng chưa
-- gán giá trị

--Gán giá trị cho biến
SET @TenBien = N'Giá trị'

DECLARE @MyName NVARCHAR(50) = N'Nhân';
--> Định nghĩa biến có gán giá trị

