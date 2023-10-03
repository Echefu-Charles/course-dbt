{{
  config(
    materialized='view'
  )
}}

with int_events as (
    select * 
    from {{ref('int_events')}}
),

purchase_sesions as (
    select *, 
    case when session_step in (3, 4) then session_id else null end as purchase_session_id
    from int_events
)

select count(distinct purchase_session_id)/ count(distinct session_id) as conversion_rate
from purchase_sesions