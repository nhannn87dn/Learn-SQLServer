--GROUPING SETS

SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

-- Group by brand, category

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    category
ORDER BY
    brand,
    category;

-- Group by brand

SELECT
    brand,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand
ORDER BY
    brand;

-- Group by category


SELECT
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    category
ORDER BY
    category;


SELECT
    SUM (sales) sales
FROM
    sales.sales_summary;

-- MERGE results

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    category
UNION ALL
SELECT
    brand,
    NULL,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand
UNION ALL
SELECT
    NULL,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    category
UNION ALL
SELECT
    NULL,
    NULL,
    SUM (sales)
FROM
    sales.sales_summary
ORDER BY brand, category;



--Thay vì thế chúng ta gom lại chỉ với 1 câu truy vấn


SELECT
	brand,
	category,
	SUM (sales) sales
FROM
	sales.sales_summary
GROUP BY
    -- Phân theo từng nhóm, trong 1 câu truy vấn
	GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
	)
ORDER BY
	brand,
	category;