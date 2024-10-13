SELECT
address_id
,address
,LPAD(CAST(zipcode AS STRING),5,0) as zip_code
,state
,country

FROM {{ source('postgres','addresses') }}