use agridata;

# Q1. Year-wise Trend of Rice Production Across States (Top 3) 
# creating temperory table and rank
with rankstate as(
select year,state_name, round(sum(rice_production),2) as total_rice_production,
rank() over (partition by year order by round(sum(rice_production),2) desc) as rnk
from agri_data_table
group by year, state_name
)
select year,state_name,total_rice_production
from rankstate
where rnk <=3
order by year, rnk;




# Q2.Top 5 Districts by Wheat Yield Increase Over the Last 5 Years

with pastdata as (
	select year, dist_name, wheat_yield
    from agri_data_table
    where year = (select max(year) from agri_data_table) -5
),
recentdata as (
	select year, dist_name, wheat_yield
    from agri_data_table
    where year = (select max(year) from agri_data_table)
)
select
	p.dist_name,
    p.year as past_year,
    p.wheat_yield as past_wheat_yield,
    r.year as recent_year,
    r.wheat_yield as recent_wheat_yield,
    round((r.wheat_yield - p.wheat_yield),2) as yield_increase
from recentdata as r
join pastdata as p on r.dist_name = p.dist_name
order by yield_increase desc
limit 5;





# Q3.States with the Highest Growth in Oilseed Production (5-Year Growth Rate)

with past_production as(
	select state_name,round(sum(oilseeds_production),2) as past_oilseeds_production 
    from agri_data_table
    where year =(select max(year) from agri_data_table) - 5
    group by state_name
),
recent_production as (
	select state_name, round(sum(oilseeds_production),2) as recent_oilseeds_production
    from agri_data_table
    where year = (select max(year) from agri_data_table)
    group by state_name
)
select 
	r.state_name,
	p.past_oilseeds_production,
	r.recent_oilseeds_production,
	round(((r.recent_oilseeds_production - past_oilseeds_production)/ nullif(past_oilseeds_production,0))*100,2) as growth_rate
from recent_production as r
join past_production as p on r.state_name = p.state_name
order by growth_rate desc;






# Q4. District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)
# using formula
# SUM(X * Y) - (SUM(X) * SUM(Y) / COUNT(*)) ---→ Computes the numerator (covariance).
# SQRT(SUM(X²) - (SUM(X)² / COUNT(*))) --------→ Computes the denominator (standard deviation).

SELECT 
    dist_name,
    round((SUM(rice_area * rice_production) - SUM(rice_area) * SUM(rice_production) / COUNT(*)) / 
    (SQRT(SUM(rice_area * rice_area) - SUM(rice_area) * SUM(rice_area) / COUNT(*)) * 
     SQRT(SUM(rice_production * rice_production) - SUM(rice_production) * SUM(rice_production) / COUNT(*))),2) 
    AS rice_correlation,

    round((SUM(wheat_area * wheat_production) - SUM(wheat_area) * SUM(wheat_production) / COUNT(*)) / 
    (SQRT(SUM(wheat_area * wheat_area) - SUM(wheat_area) * SUM(wheat_area) / COUNT(*)) * 
     SQRT(SUM(wheat_production * wheat_production) - SUM(wheat_production) * SUM(wheat_production) / COUNT(*))),2) 
    AS wheat_correlation,

    round((SUM(maize_area * maize_production) - SUM(maize_area) * SUM(maize_production) / COUNT(*)) / 
    (SQRT(SUM(maize_area * maize_area) - SUM(maize_area) * SUM(maize_area) / COUNT(*)) * 
     SQRT(SUM(maize_production * maize_production) - SUM(maize_production) * SUM(maize_production) / COUNT(*))),2) 
    AS maize_correlation

FROM agri_data_table
GROUP BY dist_name
ORDER BY rice_correlation DESC;




select year, state_name, sum(cotton_production) as total_cotton_production
from agri_data_table
group by year, state_name
order by total_cotton_production desc;





# Q5.Yearly Production Growth of Cotton in Top 5 Cotton Producing States

WITH top_states AS (
    SELECT 
        year, 
        state_name, 
        SUM(cotton_production) AS total_cotton_production
    FROM agri_data_table
    GROUP BY year, state_name
),
ranked_states AS (
    SELECT 
        year, 
        state_name, 
        total_cotton_production,
        RANK() OVER (PARTITION BY year ORDER BY total_cotton_production DESC) AS rnk
    FROM top_states
)
SELECT year, state_name, round(total_cotton_production,2) as total_cotton_production 
FROM ranked_states
WHERE rnk <= 5
ORDER BY year, rnk;






# Q6. Districts with the Highest Groundnut Production in 2020
select year, dist_name, round(sum(groundnut_production),2) as total_groundnut_production
from agri_data_table
where year = (select max(year) from agri_data_table)
group by year,dist_name
order by total_groundnut_production desc;






# Q7. Annual Average Maize Yield Across All States
select year, state_name, avg(maize_yield) as average_of_maize_yield 
from agri_data_table
group by year, state_name;








# Q8.Total Area Cultivated for Oilseeds in Each State

select state_name, round(sum(oilseeds_area),2) as Total_Area
from agri_data_table
group by state_name;




# Q9. Districts with the Highest Rice Yield

select state_name, dist_name, round(sum(rice_yield),2) as Total_Rice_Yield
from agri_data_table
group by state_name,dist_name
order by Total_Rice_Yield desc;




# Q10. Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years

WITH last_10_years AS (
    SELECT * 
    FROM agri_data_table
    WHERE year >= (SELECT MAX(year) FROM agri_data_table) - 9
),
rice_top_5 AS (
    SELECT state_name AS rice_state, ROUND(SUM(rice_production),2) AS rice_production,
           ROW_NUMBER() OVER (ORDER BY SUM(rice_production) DESC) AS r_rank
    FROM last_10_years
    GROUP BY state_name
    ORDER BY rice_production DESC
    LIMIT 5
),
wheat_top_5 AS (
    SELECT state_name AS wheat_state, ROUND(SUM(wheat_production),2) AS wheat_production,
           ROW_NUMBER() OVER (ORDER BY SUM(wheat_production) DESC) AS w_rank
    FROM last_10_years
    GROUP BY state_name
    ORDER BY wheat_production DESC
    LIMIT 5
)
SELECT 
    r.rice_state, r.rice_production,
    w.wheat_state, w.wheat_production
FROM rice_top_5 AS r
JOIN wheat_top_5 AS w 
ON r.r_rank = w.w_rank
ORDER BY r.r_rank;
