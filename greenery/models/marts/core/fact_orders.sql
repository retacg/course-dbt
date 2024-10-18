WITH orders AS (
    SELECT 
        *
    FROM {{ ref(('stg_postgres__orders'))}}
),

addresses AS (
    SELECT
        *
    FROM {{ ref(('stg_postgres__addresses'))}}
),

products_in_order AS (
    SELECT 
        order_id
        ,count(product_id) as products_in_order
    FROM {{ ref(('stg_postgres__order_items'))}}
    GROUP BY 1
)

SELECT 
    orders.order_id
    ,orders.user_id
    ,orders.promo_id
    ,orders.address_id
    ,addresses.state
    ,addresses.country
    ,orders.created_at_utc
    ,orders.estimated_delivery_at_utc
    ,orders.delivered_at_utc
    ,orders.order_cost
    ,orders.order_shipping_cost
    ,orders.order_total_cost
    ,orders.order_tracking_id
    ,orders.order_shipping_service
    ,orders.order_status
    ,products_in_order.products_in_order


FROM orders
LEFT JOIN addresses
    ON addresses.address_id=orders.address_id
LEFT JOIN products_in_order
    ON products_in_order.order_id=orders.order_id
