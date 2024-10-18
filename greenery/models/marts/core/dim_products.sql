WITH order_items AS (
    SELECT
    product_id
    ,COUNT(DISTINCT order_id) as product_orders
    ,SUM(order_items_quantity) as product_quantity_ordered
    FROM {{ ref('stg_postgres__order_items') }}
    GROUP BY 1
)

SELECT product_id
,product_name
,product_price
,product_inventory
,order_items.product_orders
,order_items.product_quantity_ordered

FROM {{ ref('stg_postgres__products') }} AS products
LEFT JOIN order_items USING (product_id)
