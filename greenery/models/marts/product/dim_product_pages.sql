WITH order_promos AS (
    SELECT DISTINCT
    order_id
    ,orders.promo_id
    ,promos.promo_discount
    ,orders.order_cost
    FROM {{ ref('stg_postgres__orders') }} orders 
    LEFT JOIN {{ ref('stg_postgres__promos') }} promos 
        on orders.promo_id=promos.promo_id 
),
products AS (
    SELECT * 
    FROM {{ ref('stg_postgres__products') }} 
),
--We want to summarize key time-based session information at the page level
    user_session_time AS (
        SELECT
        event_page_url
        ,product_id
        ,user_id
        ,MIN(created_at_utc) AS first_viewed
        ,MAX(created_at_utc) AS last_viewed
        FROM {{ ref('stg_postgres__events') }}
        GROUP BY 1,2,3
    ),

    page_session_time AS (
        SELECT
        event_page_url
        ,product_id
        ,TIMEDIFF('seconds',first_viewed,last_viewed) AS page_view_time
        FROM user_session_time
    ),

    page_session_time_summary as (
        SELECT event_page_url
        ,product_id
        ,AVG(page_view_time) as average_page_view_seconds
        ,MIN(page_view_time) as min_page_view_seconds
        ,MAX(page_view_time) as max_page_view_seconds
        ,MEDIAN(page_view_time) as median_page_view_seconds
        FROM page_session_time
        GROUP BY 1,2
    ),
    --Checkout pages are different than product pages and their information doesn't summarize nicely
    checkout_sessions AS (
        SELECT session_id
        ,event_type
        ,order_id
        from {{ ref('stg_postgres__events') }} 
        where event_type in ('package_shipped','checkout')
    ),
    events as (
        SELECT 
        *  
        FROM {{ ref('stg_postgres__events') }} 
        WHERE event_type not in ('package_shipped','checkout')
    )

SELECT events.event_page_url
,events.product_id
,products.product_name
,COUNT(DISTINCT events.session_id) as sessions
,COUNT(DISTINCT events.user_id) as users
,SUM(CASE WHEN events.event_type='page_view' then 1 else 0 END) as page_views
,SUM(CASE WHEN events.event_type='add_to_cart' then 1 else 0 END) as add_to_carts
,SUM(CASE WHEN checkout_sessions.event_type='checkout' then 1 else 0 END) as checkouts
,SUM(CASE WHEN checkout_sessions.event_type='package_shipped' then 1 else 0 END) as package_shippeds
,SUM(CASE WHEN checkout_sessions.order_id is not null then 1 else 0 END) AS orders
,SUM(order_promos.order_cost) as order_cost
,order_promos.promo_discount as order_promo_discount
,page_session_time_summary.average_page_view_seconds
,page_session_time_summary.min_page_view_seconds
,page_session_time_summary.max_page_view_seconds
,page_session_time_summary.median_page_view_seconds

FROM events
LEFT JOIN products 
    ON events.product_id=products.product_id
LEFT JOIN order_promos 
    ON events.order_id=order_promos.order_id
LEFT JOIN page_session_time_summary 
    ON events.product_id=page_session_time_summary.product_id
    AND events.event_page_url=page_session_time_summary.event_page_url
LEFT JOIN checkout_sessions 
    ON events.session_id=checkout_sessions.session_id
GROUP BY 1,2,3,order_promo_discount,average_page_view_seconds, min_page_view_seconds, max_page_view_seconds,median_page_view_seconds
