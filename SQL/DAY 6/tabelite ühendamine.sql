select *
from sales_table;

 -- Kui palju on toodete kaupa müüdud koguseid?
SELECT product_id, SUM(quantity) AS total_qty
FROM sales_table
GROUP BY product_id
order by product_id asc;

-- 10. TABELITE ÜHENDAMINE

-- 10.1. Kõik eelarveread eelarve tabelist ja nendega seotud müügiesindaja nimi müügiesindajate tabelist.

SELECT *
FROM budget_table AS bt 
LEFT JOIN sales_rep_table AS srt
ON bt.sales_rep_id = srt.sales_rep_id;

-- 10.3. Kõik müügiesindajad müügiesindajate tabelist ja nendega seotud eelarveread eelarve tabelist.

SELECT *
FROM sales_rep_table AS srt 
LEFT JOIN budget_table AS bt
ON srt.sales_rep_id = bt.sales_rep_id;

-- 10.4. Näita ainult ridu, millel on müügiesindaja nii eelarve tabelis kui ka väärtus müügiesindajate tabelis.

SELECT *
FROM sales_rep_table AS srt 
INNER JOIN budget_table AS bt
ON srt.sales_rep_id = bt.sales_rep_id;


-- 10.5. Näita kõiki ridu eelarve tabelist ja kõiki ridu müügiesindaja tabelist.
SELECT *
FROM budget_table AS bt 
FULL OUTER JOIN sales_rep_table AS srt
ON srt.sales_rep_id = bt.sales_rep_id;

-- 10.6. Näita ridu eelarve tabelist, millele pole müügiesindaja tabelis müügiesindajat kirjeldatud.

SELECT *
FROM budget_table AS bt
LEFT JOIN sales_rep_table AS srt
ON srt.sales_rep_id = bt.sales_rep_id
WHERE srt.sales_rep_id IS NULL;

-- 10.7. Näita ridu müügiesindaja tabelist, millele pole kirjeldatud ridu eelarve tabelis.

SELECT *
FROM sales_rep_table AS srt 
LEFT JOIN budget_table AS bt
ON srt.sales_rep_id = bt.sales_rep_id
WHERE bt.sales_rep_id IS NULL;

-- 10.8. Näita müügiesindajaid, kellel on puudu eelarve või müügiesindaja tabelist rida.

SELECT bt.sales_rep_id, srt.sales_rep_id 
FROM sales_rep_table AS srt 
FULL OUTER JOIN budget_table AS bt
ON srt.sales_rep_id = bt.sales_rep_id
WHERE bt.sales_rep_id IS NULL or srt.sales_rep_id IS NULL;

-- 10.9. Näita ridu müügitabelist, millel on olemas müügiesindaja info eelarve ja müügiesindaja tabelis.

SELECT *
FROM sales_table AS st 
JOIN budget_table AS bt -- JOIN vaikimisi on inner Join
ON st.sales_rep_id = bt.sales_rep_id
JOIN sales_rep_table AS srt 
ON st.sales_rep_id = srt.sales_rep_id

-- 10.9. alternatiivne lahendus

SELECT *
FROM sales_table AS st 
left JOIN budget_table AS bt 
ON st.sales_rep_id = bt.sales_rep_id
left JOIN sales_rep_table AS srt 
ON st.sales_rep_id = srt.sales_rep_id
where bt.sales_rep_id  is not null and srt.sales_rep_id  is not null;


/* Leia müügisummad toodete kaupa – toote ID ja müügisumma
‣Leia müügisummad klientide kaupa – kliendi ID ja müügisumma
‣Leia müügisummad müügiesindajate kaupa – kliendiesindaja ID ja müügisumma
‣Leia müügisummad aastate kaupa – aasta ja müügisumma
‣Lisa müükidele müügisumma kategooriad
1.Large Sale > 500
2.Medium Sale <= 500 and >= 250
3.Small Sale < 250
‣Leia müükide arv ja müügisumma müügisumma kategooriate kaupa
‣Müügisumma kategooria, müükide arv, müügisumma
‣Mida veel võiks leida?/*



