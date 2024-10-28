WITH session_products AS (
    SELECT * 
    FROM {{'int_session_products'}}
)
select product_name
,count(distinct session_id) as sessions
,count(distinct case when purchase_events is not null then session_id else null end) as purchase_sessions
from session_products
where product_name is not null
group by 1