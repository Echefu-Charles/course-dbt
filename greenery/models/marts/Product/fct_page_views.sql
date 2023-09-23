{{
  config(
    materialized='view'
  )
}}

with int_events as (
    select * 
    from {{ref('int_events')}}
),

users as (
    select * from {{ref('dim_users')}}
)

select users.first_name, users.last_name, users.email, users.phone_number, users.state, users.country,
int_events.created_at, int_events.session_id, int_events.event_type, int_events.order_id, int_events.product_name
from int_events 
join users on int_events.user_id = users.user_id
where int_events.event_type = 'page_view'