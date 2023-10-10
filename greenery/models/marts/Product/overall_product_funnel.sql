{{
  config(
    materialized='view'
  )
}}

with 
int_events_ as (
    select * 
    from {{ref('int_events')}}
),

product_events as (
    select date(created_at) Event_Date, session_id, user_id, product_id, product_name, 
    case when event_type = 'page_view' then session_id else null end as page_view_sessions,
    case when event_type = 'add_to_cart' then session_id else null end as add_to_cart_sessions,
    case when event_type = 'checkout' then session_id else null end as checkout_sessions,
    case when event_type = 'package_shipped' then session_id else null end as package_shipped_sessions
    from int_events
),
final as (
    select 
    count(distinct page_view_sessions) Page_View, 
    count(distinct add_to_cart_sessions) Add_to_cart,
    count(distinct checkout_sessions) Checkout, 
    count(distinct package_shipped_sessions) Package_Shipped,
    round((Page_View/Page_View),2) *100 Page_view_rate,
    round((Add_to_cart/Page_View),2) *100 Add_to_cart_rate,
    round((Checkout/Page_View),2) *100 Purchase_rate,
    round((Package_Shipped/Page_View),2) * 100 Shipping_rate
    from product_events
)

select * from final