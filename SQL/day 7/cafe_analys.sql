-- Analyze cafe sales and compare them to budget 

-- 1.1. Cafe sales by Year-Month 

SELECT 
    TO_CHAR(transaction_date, 'YYYY-MM') AS year_month, 
    SUM(total_spent_calc) AS total_sales
FROM cafe_sales_cleaned
GROUP BY year_month 
ORDER BY year_month;

-- 1.2. Monthly sales vs monthly budget 

WITH monthly_sales as (
    SELECT 
        TO_CHAR(transaction_date, 'YYYY-MM') AS year_month, 
        SUM(total_spent_calc) AS total_sales
    FROM cafe_sales_cleaned
    GROUP BY year_month 
)
SELECT 
cb.year_month, 
cb.budget_sum, 
ms.total_sales,
(ms.total_sales - cb.budget_sum) AS difference
FROM cafe_budget  as cb
FULL OUTER JOIN monthly_sales as ms
    ON cb.year_month = ms.year_month
ORDER BY cb.year_month;

--alternatiivne lahendus, eelarve tabelis kõik read olemas

WITH monthly_sales as (
    SELECT 
        TO_CHAR(transaction_date, 'YYYY-MM') AS year_month, 
        SUM(total_spent_calc) AS total_sales
    FROM cafe_sales_cleaned
    GROUP BY year_month 
)
SELECT 
cb.year_month, 
cb.budget_sum, 
ms.total_sales,
(ms.total_sales - cb.budget_sum) AS difference
FROM cafe_budget  as cb
left JOIN monthly_sales as ms
    ON cb.year_month = ms.year_month
ORDER BY cb.year_month;

-- alternatiivne lahendus 2

SELECT 
    b.year_month, SUM(c.total_spent_calc) AS actual_sales,
    b.budget_sum
FROM cafe_sales_cleaned c
LEFT JOIN cafe_budget b
    ON TO_CHAR(c.transaction_date, 'YYYY-MM') = b.year_month
GROUP BY b.year_month,b.budget_sum
ORDER BY b.year_month;

-- alternatiivne lahendus 3

select
	cb.year_month 
	,cb.budget_sum
	,csc2.sale_sum
from cafe_budget cb
	left join (
		select sum(csc.total_spent_calc) as sale_sum, to_char(csc.transaction_date, 'YYYY-MM') as year_month
		from cafe_sales_cleaned csc 
		group by year_month
	) csc2 on cb.year_month = csc2.year_month;


--alternatiivne lahendus 4:

select
	cb.year_month 
	,(
		select sum(csc.total_spent_calc) as sale_sum
		from cafe_sales_cleaned csc 
		where to_char(csc.transaction_date, 'YYYY-MM') = cb.year_month 
		group by to_char(csc.transaction_date, 'YYYY-MM')
	)
	,cb.budget_sum 
from cafe_budget cb

-- 1.3. Cafe sales by item 
SELECT 
    item_cleaned,                        -- 1. Vali toode
    SUM(total_spent_calc) AS item_sales  -- 2. Liida selle toote müük || '€' saaks lisada euro märgi aga siis muutub tekstiks
FROM cafe_sales_cleaned                  -- 3. Tabelist
GROUP BY item_cleaned                    -- 4. Grupeeri toote nime järgi
ORDER BY item_sales DESC;                -- 5. Sorteeri suurem müük ettepoole

-- 1.4. Compare average sale sum per item to average sale sum for all items 

SELECT 
    item_cleaned, 
    round(AVG(total_spent_calc),2) AS item_avg,
    -- See järgmine rida arvutab ÜLDISE keskmise üle kõigi ridade
    (SELECT round(AVG(total_spent_calc),2) FROM cafe_sales_cleaned) AS cafe_avg,
    -- Arvutame vahe: toote keskmine MIINUS üldine keskmine
    round(AVG(total_spent_calc),2) - (SELECT round(AVG(total_spent_calc),2) FROM cafe_sales_cleaned) AS difference
FROM cafe_sales_cleaned
GROUP BY item_cleaned
order by difference desc;

-- 1.5. Filter out only items where sales were more than 10 000
select item_cleaned, SUM(total_spent_calc) as total
from cafe_sales_cleaned csc 
group by item_cleaned
having  SUM(total_spent_calc) > 10000;


-- 1.6. What were sales by payment method?

SELECT 
    payment_method_cleaned,                        
    SUM(total_spent_calc) AS sales_sum 
FROM cafe_sales_cleaned                  
GROUP BY payment_method_cleaned                    
union all              -- paneb üksteise alla ridasid union näitab unikaalseid ridu, union all näitab kõiki ridu
select 'Total', sum (total_spent_calc) as Total
from cafe_sales_cleaned;

-- 1.7. Compare average sale sum by location to average sale sum

SELECT 
   location_cleaned, 
    round(AVG(total_spent_calc),2) AS loc_avg,
    -- See järgmine rida arvutab ÜLDISE keskmise üle kõigi ridade
    (SELECT round(AVG(total_spent_calc),2) FROM cafe_sales_cleaned) AS cafe_avg,
    -- Arvutame vahe: toote keskmine MIINUS üldine keskmine
    round(AVG(total_spent_calc),2) - (SELECT round(AVG(total_spent_calc),2) FROM cafe_sales_cleaned) AS difference
FROM cafe_sales_cleaned
GROUP BY location_cleaned
order by difference desc;

-- 1.8. What were sales by location?

SELECT 
    location_cleaned,                        
    SUM(total_spent_calc) AS sales_sum 
FROM cafe_sales_cleaned                  
GROUP BY location_cleaned                    
union all              -- paneb üksteise alla ridasid union näitab unikaalseid ridu, union all näitab kõiki ridu
select 'Total', sum (total_spent_calc) as Total
from cafe_sales_cleaned;

-- 1.9. How many units per item were sold?

select item_cleaned, sum(quantity)
from cafe_sales_cleaned csc 
group by csc.item_cleaned ;

-- 1.10. Filter out only items where more than 3000 units were sold

select item_cleaned, sum(quantity) as units_sold
from cafe_sales_cleaned csc 
group by csc.item_cleaned 
having sum(quantity) > 3000;