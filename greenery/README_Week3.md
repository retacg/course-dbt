# Part 1
## What is our overall conversion rate?
62.5%
```
select count(distinct CASE WHEN purchase_events is not null then session_id else NULL end)/count(distinct session_id) from int_session_products
```
## What is our conversion rate by product?
String of pearls has the highest conversion rate
```
SELECT *
,purchase_sessions/sessions

from fact_product_sessions
```
# Part 2
## Macros
I created a macro to help with the case statements for the aggregation columns by event type. I also saw a grant macro in someone elses project that I borrowed here since I thought it was clever!

# Part 4
## Packages
I installed dbt expectations and added the test `expect_column_distinct_count_to_equal_other_table` in a few places to ensure my transformations were not messing up unique id columns. 

# Part 5
## DAG
![alt text](<Screenshot 2024-10-28 at 11.07.51 AM.png>)
# Part 6
## Snapshot
The following products all had their inventories change (took snapshot on 10/28 so I might be capturing week 4 changes, not sure when the new numbers drop)
Bamboo
ZZ Plant
Pothos
Philodendron
Monstera
String of pearls

```
with new_inventory as (select name
,inventory as new_inventory_count
from product_inventory_snapshot
where cast(dbt_updated_at AS DATE)='2024-10-28'
and dbt_valid_to is null
)

,old_inventory as (
SELECT distinct name
,inventory as old_inventory_count
from product_inventory_snapshot
where cast(dbt_valid_to AS DATE)='2024-10-28'
)

select  n.name
,new_inventory_count-old_inventory_count as inventory_diff
from new_inventory n
LEFT JOIN old_inventory i using (name)
```