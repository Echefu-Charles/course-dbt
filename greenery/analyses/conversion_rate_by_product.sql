{{
  config(
    materialized='view'
  )
}}

with 
events as (
select * 
from {{ref('int_events') }}

),
product_sesions as (
    select *, 
    case when session_step in (3, 4) then session_id else null end as purchase_session_id,
    case when session_step = 1 then session_id else null end as viewed_session_id
    from events
)

select product_name, count(distinct purchase_session_id) num_purchase_sessions, count(distinct viewed_session_id) num_view_sessions, 
div0null(count(distinct purchase_session_id), count(distinct viewed_session_id)) as conversion_rate
from product_sesions
group by 1
order by 1