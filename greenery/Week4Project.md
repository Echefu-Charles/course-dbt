## Part 1
### Which products had their inventory change from week 3 to week 4? 
#### Answer: 
    The products whose inventory changed from week3 to week4 are : Pothos, Philodendron, Bamboo, ZZ Plant, Monstera, String of pearls

### Which products had the most fluctuations in inventory? 
#### Answer: 
    The products with the most fluctuations are: Monstera, Pothos,Philodendron, String of pearls 

### Did we have any items go out of stock in the last 3 weeks?
#### Answer: 
    We had two items go out of stock: Pothos and String of pearls

## Part 2
### How are our users moving through the product funnel?
#### Answer:
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
  578 users viewed the product page, 467 users added products to their carts, 
  361 users checked out different products and 335 users shipped their orders.

### Which steps in the funnel have largest drop off points?
#### Answer:
  The largest dropoff points are page_view --> add_to_carts with a drop from 100% of users to 81%
  and also from add_to_carts --> checkout with a drop from 81% of users to 62% of users

### Addition: 
    In order to track these metrics on an ongoing basics, I created a model 'product_funnel_by_date' to group the event metrics by date. 
    This is to show how these metrics change over different time periods.
#### Script:
   
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
        select event_date,
        count(distinct page_view_sessions) Page_View, 
        count(distinct add_to_cart_sessions) Add_to_cart,
        count(distinct checkout_sessions) Checkout, 
        count(distinct package_shipped_sessions) Package_Shipped,
        round((Page_View/Page_View),2) *100 Page_view_rate,
        round((Add_to_cart/Page_View),2) *100 Add_to_cart_rate,
        round((Checkout/Page_View),2) *100 Purchase_rate,
        round((Package_Shipped/Page_View),2) * 100 Shipping_rate
        from product_events
        group by 1
        order by 1
    )
    
    select * from final

## Part 3:
My company is using Dbt and I have already recommended using snapshots to track changes in products. 
Also, I will recommend using more of macros within our project to remove redundant code blocks and repeated models.

## Part 3B:
We already have a scheduled run for dbt on production but it does not use hooks or operations. 
I will speak to my manager about adding them to improve the job runs.
Our current job runs on a 6-hours interval.

We are not using any ochestration tool at the moment, but we are having discussions about including airflow to the current data architecture.
