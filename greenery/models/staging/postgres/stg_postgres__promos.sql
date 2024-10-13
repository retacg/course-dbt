SELECT
promo_id
,discount as promo_discount
,status as promo_status

FROM {{ source('postgres','promos') }}