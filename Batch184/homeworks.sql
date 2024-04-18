--C.10 Hiển thị tất cả các khách hàng có tuổi trên 60
SELECT 
	* 
FROM 
	customers
WHERE
	(SELECT DATEDIFF( year , customers.birthday , GETDATE())) > 53
--C12. Hiển thị tất cả các khách hàng có số đuôi điện thoại '500'

SELECT * FROM dbo.customers WHERE phone LIKE '%500'

-- C14. Hiển thị tất cả các khách hàng có sinh nhật là hôm nay
SELECT DAY(GETDATE())
SELECT MONTH(GETDATE())
SELECT * FROM customers
WHERE DAY(birthday) = DAY(GETDATE()) AND MONTH(birthday) = MONTH(GETDATE())

--C28. Hiển thị tất cả các thương hiệu (brands) không có tên là: (Heller, Trek)
SELECT * 
FROM brands
WHERE NOT (brand_name = 'Heller' OR brand_name = 'Trek')

SELECT * 
FROM brands
WHERE brand_name != 'Heller' AND  brand_name != 'Trek'

SELECT * 
FROM brands
WHERE brand_name NOT IN ('Heller', 'Trek')

--C30 Hiển thị xem có bao nhiêu mức giảm giá (discount) khác nhau
SELECT * FROM products
SELECT 
	 discount
	--COUNT(product_id) ==> cau c31
FROM products
GROUP BY
	discount
ORDER BY discount 

--D4.Hiển thị tất cả các sản phẩm có số lượng tồn kho <= 5
SELECT * FROM stocks
SELECT
	p.*,
	s.quantity
FROM products AS p
INNER JOIN stocks AS s ON s.product_id = p.product_id
WHERE
	s.quantity <= 5

--D19 Hiển thị tất cả các sản phẩm được bán trong khoảng từ ngày, đến ngày
SELECT * FROM order_items
SELECT * FROM orders
-- tìm những sp bán ra từ ngày 2016-01-25 - 2016-01-30
SELECT
	p.*,
	o.order_date
FROM products AS p
INNER JOIN order_items AS oi ON oi.product_id = p.product_id
INNER JOIN orders AS o ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN CAST('2016-01-25' AS DATE) AND CAST('2016-01-30' AS DATE)
ORDER BY o.order_date 

--D13.
SELECT
	o.order_id,
	SUM((oi.price * oi.quantity))
FROM orders AS o
INNER JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY
	o.order_id
ORDER BY o.order_id




---test
ALTER PROCEDURE GetProducts
    @brand_id INT = NULL,
    @category_id INT = NULL,
    @product_name VARCHAR(255) = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1
AS
BEGIN
    BEGIN TRY
        DECLARE @TotalRecords INT;

        SELECT @TotalRecords = COUNT(*)
        FROM dbo.products
        WHERE (@brand_id IS NULL OR brand_id = @brand_id)
        AND (@category_id IS NULL OR category_id = @category_id)
        AND (@product_name IS NULL OR product_name LIKE '%' + @product_name + '%');

        SELECT *,
               @TotalRecords AS TotalRecords
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY product_id) AS RowNum, *
            FROM dbo.products
            WHERE (@brand_id IS NULL OR brand_id = @brand_id)
            AND (@category_id IS NULL OR category_id = @category_id)
            AND (@product_name IS NULL OR product_name LIKE '%' + @product_name + '%')
        ) AS RowConstrainedResult
        WHERE RowNum >= ((@PageNumber - 1) * @PageSize + 1)
        AND RowNum < (@PageNumber * @PageSize + 1)
        ORDER BY RowNum
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() as ErrorState,
            ERROR_PROCEDURE() as ErrorProcedure,
            ERROR_LINE() as ErrorLine,
            ERROR_MESSAGE() as ErrorMessage;
    END CATCH
END;

EXEC GetProducts
