WITH events as (
    SELECT * 
    FROM {{ ref('stg_postgres__events') }}
),

products as ( 
    SELECT * 
    FROM 
    {{ ref('stg_postgres__products') }}

),

order_items as ( 
    SELECT * 
    FROM 
    {{ ref('stg_postgres__order_items') }}

),

session_events_agg AS (
    SELECT 
        *
    FROM {{ ref('int_session_events_agg') }}
)

SELECT DISTINCT
events.session_id 
,events.user_id
,events.product_id
,products.product_name
,session_events_agg.session_started_at
,session_events_agg.session_ended_at
,session_events_agg.page_views
,session_events_agg.add_to_carts
,session_events_agg.checkouts
,session_events_agg.packages_shipped
,session_events_agg.orders
,DATEDIFF('minute',session_started_at,session_ended_at) AS session_length_minutes

FROM  events
LEFT JOIN  products
    ON products.product_id=events.product_id
LEFT JOIN order_items
    ON order_items.order_id=events.order_id
LEFT JOIN session_events_agg
    ON session_events_agg.session_id=events.session_id
GROUP BY ALL
