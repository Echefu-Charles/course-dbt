{{
  config(
    materialized='view'
  )
}}

with 
orders as (
    select * 
    from {{ref('stg_orders')}}
)


select avg(delivery_time) average_delivery_time 
from (
    select order_id, 
    datediff(day,created_at, delivered_at) as delivery_time 
    from orders
    where status = 'delivered'
)