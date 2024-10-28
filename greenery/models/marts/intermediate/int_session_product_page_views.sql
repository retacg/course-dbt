WITH events as (
    SELECT
    * 
    FROM {{ ref('stg_postgres__events') }} 
)

SELECT session_id
,user_id
,product_id

FROM events
where event_type in ('add_to_cart','page_view')