SELECT 
 order_id
, user_id
, promo_id
, address_id
, CONVERT_TIMEZONE('UTC',created_at)  AS created_at_utc
, order_cost
, shipping_cost as order_shipping_cost
, order_total as order_total_cost
, tracking_id as order_tracking_id
, shipping_service as order_shipping_service
, CONVERT_TIMEZONE('UTC',estimated_delivery_at) AS estimated_delivery_at_utc
, CONVERT_TIMEZONE('UTC',delivered_at) AS delivered_at_utc
, status as order_status
FROM {{ source('postgres','orders') }}