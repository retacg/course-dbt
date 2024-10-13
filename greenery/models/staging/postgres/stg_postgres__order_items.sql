SELECT
order_id
,product_id
,quantity as order_items_quantity
FROM {{ source('postgres','order_items') }}