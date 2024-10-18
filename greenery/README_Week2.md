# Part 1: Models
## What is our user repeat rate?
79.8%
```
--select * from public.events;
with base as (
select user_id
,count(distinct order_id) as order_numbers

from DBT_RETACGGMAILCOM.STG_POSTGRES__ORDERS
group by 1
order by 2 desc
)
,user_orders as (select CASE WHEN order_numbers=1 then '1_order'
WHEN order_numbers>=2 then '2_orders'
 else null end as order_numbers
,count(distinct user_id) as users
from base
group by 1
)

select sum(case when order_numbers='2_orders' then users else null end)/sum(users) 
as repeat_rate
from user_orders
```
## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
To approach this question I would look at user behavior on the site. Some things I would look at are: the time a user spends on site, how many times they revisit the site, how long they have been coming to our site. 

If I had more data, I might look at some kind of demographic information or model data. Could I look at household income? Could I look at whether or not they are a likely homeowner or a renter? 
## Explain the product mart models you added. Why did you organize the models in the way you did?
I presume the product team is going to want to view information over time about sessions (fact_page_views) and also be able to easily access information summarized at the page level. The page level summary may help them make optimizations to the site by answering questions like - which pages are leading to the most completed orders and which pages folks are spending the most amount of time on. 

I tried to organize fact and event data separately so its easy to join fact tables to event tables to answer key business questions. I think I could probably break up the `dim_product_pages` model a bit more so its pulling from intermediate models. 
![Image from my DAG](<Screenshot 2024-10-18 at 2.43.45 PM.png>)


# Part 2: Tests
## What assumptions are you making about each model? (i.e. why are you adding each test?)
I am assuing that for each model, the grain of the data should be unique at the level of the modeled raw data. EG the orders data should have one row per order. 

## Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
I noticed that not all the zip codes were clean and it looked like some were missing leading zeroes! To clean the data I cast the zip code as a string and padded the data that was not 5 characters with a leading zero. 

# Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
I might set up slack alerts such that failing tests populated into a slack channel. We would then have either assigned tables OR an assigned person monitoring the channel and taking charge of investigating failures. Beacuse a failed test mean downstream models don't run, the first thing the team member investigating would do is report that data might be outdated while we investigate a failed test and that once we investigate we can have an estimated time to fix. 

Once we investigate we determine if its a data quality issue, if our assumptions about the data are wrong, or something else and we provide the proper update to the end users about when they can expect refreshed data and what the fix to the error was. 

# Part 3: Snapshots
The products that had their inventory change from week 1 to week 2 are: Pothos, Philodendron, Monstera, String of Pearls
![Inventory Diff](<Screenshot 2024-10-18 at 3.26.00 PM.png>)

```
with new_inventory as (select name
,inventory as new_inventory_count
from product_inventory_snapshot
where cast(dbt_updated_at AS DATE)='2024-10-18'
and dbt_valid_to is null
)

,old_inventory as (
SELECT distinct name
,inventory as old_inventory_count
from product_inventory_snapshot
where cast(dbt_valid_to AS DATE)='2024-10-18'
)

select  n.name
,new_inventory_count-old_inventory_count as inventory_diff
from new_inventory n
LEFT JOIN old_inventory i using (name)
```