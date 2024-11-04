## Part 1. dbt Snapshots
2. Philodendron, String of pearls, pothos, monstera, bamboo, and zz plant all had inventory changes
```
with new_inventory as (select name
,inventory as new_inventory_count
from product_inventory_snapshot
where cast(dbt_updated_at AS DATE)='2024-11-04'
and dbt_valid_to is null
)

,old_inventory as (
SELECT distinct name
,inventory as old_inventory_count
from product_inventory_snapshot
where cast(dbt_valid_to AS DATE)='2024-11-04'
)
select  n.name
,new_inventory_count-old_inventory_count as inventory_diff
from new_inventory n
LEFT JOIN old_inventory i using (name)
```
3. String of pearls, ZZ plant, Monstera had the biggest changes in inventory from the first week until now 
```
with first_inventory as (select name
,inventory as first_inventory
from product_inventory_snapshot
where cast(dbt_valid_from AS DATE)='2024-10-13'
--and dbt_valid_to is null
)

,final_inventory as (
SELECT distinct name
,inventory as final_inventory
from product_inventory_snapshot
where dbt_valid_to is null
)
select  n.name
,first_inventory-final_inventory as inventory_diff
from first_inventory n
LEFT JOIN final_inventory i using (name)
order by 2 DESC
```
String of pearls and pothos had 0 inventory at one point from 10/28 - 11/04
```select * from product_inventory_snapshot
where inventory=0
```

## Part 2 
I work in elections and did not have time to do this part of the project this week I will come back in my own time and work on it
