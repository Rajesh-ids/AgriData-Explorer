use agridata;

-- Q1)
select state_name, round(sum(rice_production),2) as rice_production
from agri_data_table
group by state_name
order by rice_production desc
limit 7;

-- Q2)
select state_name, round(sum(wheat_production),2) as wheat_production
from agri_data_table
group by state_name
order by wheat_production desc
limit 5;

-- Q3)
select state_name, round(sum(oilseeds_production),2) as oilseeds_production
from agri_data_table
group by state_name
order by oilseeds_production desc
limit 5;


-- Q4)
select state_name, round(sum(sunflower_production),2) as sunflower_production
from agri_data_table
group by state_name
order by sunflower_production desc
limit 7;


-- Q5)
select year, round(sum(sugarcane_production),2) as sugarcane_production
from agri_data_table
group by year
order by year desc
limit 50;

-- Q6)
select year, round(sum(rice_production),2) as rice_production,
round(sum(wheat_production),2) as wheat_production
from agri_data_table
group by year
order by year desc
limit 50;

-- Q7)
select state_name,dist_name, round(sum(rice_production),2) as rice_production
from agri_data_table
where state_name = 'West Bengal'
group by state_name,dist_name
order by rice_production desc;

-- Q8)
select year,state_name, round(sum(wheat_production),2) as wheat_production
from agri_data_table
where state_name = 'Uttar Pradesh'
group by year, state_name
order by wheat_production desc
limit 10;

-- Q9)
select year, round(sum(pearl_millet_production),2) as pearl_millet_production,
round(sum(finger_millet_production),2) as finger_millet_production
from agri_data_table
group by year
order by year desc
limit 50;

-- Q10)

select state_name, round(sum(kharif_sorghum_production),2) as kharif_sorghum_production , round(sum(rabi_sorghum_production),2) as rabi_sorghum_production
from agri_data_table
group by state_name;





-- Q11)
select state_name, round(sum(groundnut_production),2) as groundnut_production
from agri_data_table
group by state_name
order by groundnut_production desc
limit 7;

-- Q12)

select state_name , round(sum(soyabean_production),2) as soyabean_production
from agri_data_table
group by state_name
order by soyabean_production desc
limit 5;

select state_name , round(sum(soyabean_yield),2) as soyabean_yield
from agri_data_table
group by state_name
order by soyabean_yield desc
limit 5;


-- Q13)
select state_name, round(sum(oilseeds_production),2) as oilseeds_production
from agri_data_table
group by state_name
order by oilseeds_production desc
limit 5;

-- Q14)
select rice_area, rice_production,
	wheat_area, wheat_production,
    maize_area,maize_production
from agri_data_table;

-- Q15)
select state_name , round(sum(rice_yield),2) as rice_yield,
	round(sum(wheat_yield),2)
from agri_data_table
group by state_name;

