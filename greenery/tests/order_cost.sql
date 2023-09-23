select * from {{ref('fct_orders')}}
where order_cost < 0