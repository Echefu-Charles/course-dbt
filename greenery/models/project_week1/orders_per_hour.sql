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


select avg(orders) avg_orders
from (
    select 
    extract(hour from created_at) hour_of_day, 
    count(*) as orders 
    from stg_orders
    group by 1
)