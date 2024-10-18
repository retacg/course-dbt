WITH orders AS (
    SELECT * 
    FROM {{ ref(('stg_postgres__orders'))}}
)

SELECT
    order_id
    ,MIN(created_at_utc) AS first_order_at
    ,MAX(created_at_utc) AS last_order_at
    ,COUNT(DISTINCT order_id) AS total_orders
    ,SUM(order_total_cost) AS total_order_spend
    ,SUM(CASE WHEN promo_id IS NOT NULL then 1 else 0 end) AS total_orders_with_promo
FROM orders
GROUP BY 1    