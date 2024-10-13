SELECT
product_id
,name as product_name
,price as product_price
,inventory as product_inventory

FROM {{ source('postgres','products') }} 