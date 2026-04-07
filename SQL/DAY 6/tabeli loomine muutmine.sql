-- Saime juhatuselt uue eelarve numbrid ja loeme uue eelarve tabeli nende numbritega
--DROP TABLE budget_table_new; 
CREATE Table budget_table_new(
budget_id INTEGER PRIMARY KEY AUTOINCREMENT,
--budget_id serial not null Primary KEY, --serial, loob seeria numbreid 1,2,3...
budget_date DATE,
sales_rep_name VARCHAR(50),
budget_sum NUMERIC(50,2));


select * from budget_table_new;

insert into budget_table_new(
budget_date,
sales_rep_name,
budget_sum)
values('2026-01-31', 'Jane Smith', 20000 ),
('2026-01-31', 'John Doe', 20000);

-- Lisa müügiesindaja ID tulp

alter table budget_table_new
add column sales_rep_id VARCHAR(50);

-- Lisa ID 'SR001' Jane Smithile

update budget_table_new
set sales_rep_id = 'SR001'
where sales_rep_name = 'Jane Smith';

-- Lisa ID 'SR002' Jon Doele

update budget_table_new
set sales_rep_id = 'SR002'
where sales_rep_name = 'John Doe';

-- eemalda müügiesindaja nimetulba
alter table budget_table_new
drop column sales_rep_name;

--kustutame tabeli
drop table budget_table_new;
