
WITH 
    events as (
        SELECT
        * 
        FROM {{ ref('stg_postgres__events') }} 
    ),
        purchase_events as (
        SELECT
        * 
        FROM {{ ref('stg_postgres__events') }}
        where event_type='checkout'
    ),
    products as ( 
        SELECT * 
        FROM 
        {{ ref('stg_postgres__products') }}

    )

SELECT 
 events.session_id
,purchase_events.product_id 
,products.product_name
,SUM(CASE WHEN purchase_events.session_id is not null then 1 else NULL end) as purchase_events


FROM events
LEFT JOIN purchase_events 
    ON purchase_events.session_id=events.session_id
LEFT JOIN products
    ON events.product_id=products.product_id
GROUP BY 1,2,3
