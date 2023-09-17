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


select 
sum(case when orders = 1 then 1 else 0 end) as One_Purchase, 
sum(case when orders = 2 then 1 else 0 end) as Two_Purchases,
sum(case when orders >= 3 then 1 else 0 end) as Three_or_more_Purchases 
from (
    select user_id, 
    count(order_id) orders
    from orders
    group by user_id
)