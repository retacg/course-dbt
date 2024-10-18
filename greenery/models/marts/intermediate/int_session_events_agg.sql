WITH events as (
    SELECT
    * 
    FROM {{ ref('stg_postgres__events') }} 
)


SELECT
    session_id
    ,SUM(CASE WHEN events.event_type='page_view' then 1 else 0 END) as page_views
    ,SUM(CASE WHEN events.event_type='add_to_cart' then 1 else 0 END) as add_to_carts
    ,SUM(CASE WHEN events.event_type='checkout' then 1 else 0 END) as checkouts
    ,SUM(CASE WHEN events.event_type='package_shipped' then 1 else 0 END) as packages_shipped
    ,SUM(CASE WHEN events.order_id is not null then 1 else 0 END) AS orders
    ,MIN(created_at_utc) as session_started_at
    ,MAX(created_at_utc) as session_ended_at

FROM events
GROUP BY 1