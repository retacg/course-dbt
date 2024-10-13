SELECT
event_id
,session_id
,user_id
,event_type
,page_url as event_page_url
,CONVERT_TIMEZONE('UTC',created_at) as created_at_utc
,order_id
,product_id

FROM {{ source('postgres','events') }}