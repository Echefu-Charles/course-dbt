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
),

merged as (
    select events.user_id,events.created_at, events.session_id, events.event_type,
case when events.event_type = 'page_view' then 1
     when events.event_type = 'add_to_cart' then 2
     when events.event_type = 'checkout' then 3
     when events.event_type = 'package_shipped' then 4
    else null end as session_step,
    events.order_id, events.product_id product_viewed, products.product_id product_ordered, 
    coalesce(product_viewed, product_ordered) product_id
from events
left join order_items on events.order_id = order_items.order_id
left join products on order_items.product_id = products.product_id
),

final as (
SELECT merged.user_id, merged.created_at, merged.session_id, merged.event_type, merged.session_step, merged.order_id, merged.product_id, products.name as product_name
from merged 
join products on merged.product_id = products.product_id
)

select * 
from final
order by user_id, created_at

