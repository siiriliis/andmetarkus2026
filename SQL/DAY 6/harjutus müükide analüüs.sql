-- 1. Leia müügisummad toodete kaupa – toote ID ja müügisumma

select product_id, round(sum(sale_sum),0) as total_sum -- ümarada sajalisteks -2
from sales_table
group by product_id;


--2.  Leia müügisummad klientide kaupa – kliendi ID ja müügisumma

SELECT customer_id, round(sum(sale_sum),0) as total_sum
from sales_table 
group BY customer_id;

-- 3. Leia müügisummad müügiesindajate kaupa – kliendiesindaja ID ja müügisumma

SELECT sales_rep_id , round(sum(sale_sum),0) as total_sum
from sales_table 
group BY sales_rep_id ;

-- 4. Leia müügisummad aastate kaupa – aasta ja müügisumma
SELECT 
    strftime('%Y', sale_date) AS sale_year,  
    ROUND(SUM(sale_sum), 0) AS total_sum
FROM sales_table
GROUP BY sale_year;


-- 5. Lisa müükidele müügisumma kategooriad
-- Large Sale > 500
-- Medium Sale <= 500 and >= 250
-- Small Sale < 250

SELECT *,
    CASE 
        WHEN sale_sum > 500 THEN 'Large Sale'
        WHEN sale_sum >= 250 THEN 'Medium Sale'
        ELSE 'Small Sale'
    END AS sale_category
FROM sales_table;

-- Lisa see tulp müügitabelisse
ALTER TABLE 
sales_table 
ADD column sale_category VARCHAR(50);

UPDATE sales_table SET sale_category =
 CASE 
        WHEN sale_sum > 500 THEN 'Large Sale'
        WHEN sale_sum >= 250 THEN 'Medium Sale'
        ELSE 'Small Sale' END;

select distinct sale_category from sales_table;

-- 6. Leia müükide arv ja müügisumma müügisumma kategooriate kaupa. Müügisumma kategooria, müükide arv, müügisumma

SELECT   sale_category, COUNT(*) AS nr_of_sales,ROUND(SUM(sale_sum), 0) AS total_sum
FROM sales_table
GROUP BY sale_category
ORDER BY total_sum DESC;    

-- alternatiivne lahendus ajutise päringu läbi

 
WITH sales_per_category AS (
    -- 1. SAMM: Sildistame iga rea (ei grupeeri veel!)
    SELECT 
        sale_id,
        sale_sum,
        CASE
            WHEN sale_sum > 500 THEN 'Large Sale'
            WHEN sale_sum >= 250 THEN 'Medium Sale'
            ELSE 'Small Sale'
        END AS sale_category
    FROM sales_table)
SELECT 
    sale_category,
    COUNT(sale_id) AS sales_count,
    SUM(sale_sum) AS total_sales_sum
FROM sales_per_category
GROUP BY sale_category
ORDER BY total_sales_sum DESC;

-- 7. Mida veel võiks leida?

-- 7.1. Allahindlus müügiesindajate lõikes võrreldes keskmise allahindlusega
SELECT sales_rep_id, AVG(discount) as avg_discount_per_sales_rep,
(SELECT AVG(discount) AS avg_discount_in_company FROM sales_table), 
AVG(discount) - (SELECT AVG(discount) AS avg_discount_in_company FROM sales_table) AS difference_from_company_average
FROM sales_table st 
GROUP BY sales_rep_id;
