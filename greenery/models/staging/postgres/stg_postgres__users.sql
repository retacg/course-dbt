SELECT
user_id
,first_name
,last_name
,email
,phone_number
,CONVERT_TIMEZONE('UTC',created_at) AS  created_at_utc
,CONVERT_TIMEZONE('UTC',updated_at) AS updated_at
,address_id

FROM {{ source('postgres','users') }}