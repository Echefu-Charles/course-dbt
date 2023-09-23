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

order_items as (
    select * 
    from {{ref('stg_order_items')}}
),

products as (
    select * 
    from {{ref('stg_products')}}
)

select events.user_id,events.created_at, events.session_id, events.event_type,
case when events.event_type = 'page_view' then 1
     when events.event_type = 'add_to_cart' then 2
     when events.event_type = 'checkout' then 3
     when events.event_type = 'package_shipped' then 4
    else null end as session_step,
    events.order_id, products.name as product_name
from events
left join order_items on events.order_id = order_items.order_id
left join products on order_items.product_id = products.product_id

order by events.user_id, events.created_at