{{
  config(
    materialized='view'
  )
}}

with orders as (
    select * 
    from {{ref('stg_orders')}}
),

order_items as (
    select * 
    from {{ref('stg_order_items')}}
),

products as (
    select * from {{ref('stg_products')}}
)


select orders.order_id, orders.user_id, orders.created_at, products.name as product_name, products.price, order_items.quantity,
orders.order_cost, orders.shipping_cost, orders.order_total, orders.status, orders.delivered_at,
datediff(day,orders.created_at, orders.delivered_at) time_to_delivery

from orders
join order_items on orders.order_id = order_items.order_id
join products on order_items.product_id = products.product_id