
ALTER TABLE 
sales_table 
ADD column sale_sum NUMERIC;

SELECT *FROM sales_table;

update sales_table SET sale_sum = quantity * unit_price *(1-discount );
