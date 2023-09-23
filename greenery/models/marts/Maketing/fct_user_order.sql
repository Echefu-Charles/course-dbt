{{
  config(
    materialized='view'
  )
}}

with dim_users as (
    select * from {{ref('dim_users')}}
),

fct_orders as (
    select * from {{ref('fct_orders')}}
)

select fct_orders.order_id, dim_users.first_name, dim_users.last_name, dim_users.email, dim_users.phone_number, dim_users.state, dim_users.country,
fct_orders.created_at, fct_orders.product_name, fct_orders.price, fct_orders.quantity, fct_orders.order_cost, 
fct_orders.shipping_cost, fct_orders.order_total, fct_orders.status, fct_orders.delivered_at, fct_orders.time_to_delivery
from fct_orders
join dim_users on fct_orders.user_id = dim_users.user_id