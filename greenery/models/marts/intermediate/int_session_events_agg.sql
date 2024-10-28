
WITH events as (
    SELECT
    * 
    FROM {{ ref('stg_postgres__events') }} 
)


SELECT
    session_id
    {{event_types('stg_postgres__events',' event_type')}}
    ,SUM(CASE WHEN events.order_id is not null then 1 else 0 END) AS orders
    ,MIN(created_at_utc) as session_started_at
    ,MAX(created_at_utc) as session_ended_at

FROM events
GROUP BY 1
