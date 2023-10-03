{{
  config(
    materialized='view'
  )
}}

with 
events as (
    select * 
    from {{ref('stg_events')}}
),

final as (
    select session_id, created_at, user_id 
    {{ event_types('stg_events', 'event_type') }}
    from events
    group by 1, 2, 3
)

select * from final 