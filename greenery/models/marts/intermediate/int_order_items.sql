WITH order_items as (
    SELECT * 
    FROM {{ ref('stg_postgres__order_items') }}
),

products AS (
    SELECT *
    FROM {{ ref('stg_postgres__products') }}
)

SELECT DISTINCT order_items.order_id
,order_items.product_id
,products.product_name
,products.product_price
,order_items.order_items_quantity
FROM order_items
LEFT JOIN products 
    ON products.product_id=order_items.product_id