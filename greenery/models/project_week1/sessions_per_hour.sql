{{
  config(
    materialized='view'
  )
}}

with 
events as (
    select * 
    from {{ref('stg_events')}}
)

select avg(sessions) sessions_per_hour 
from (
    select extract(hour from created_at) hour_of_day, 
    count(distinct session_id) as sessions 
    from events
    group by 1
)