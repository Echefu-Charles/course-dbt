## Question 1:How many users do we have?
### Script: 
    with 
    users as (
        select * 
        from {{ref('stg_users')}}
    )
    
    select count(distinct user_id) as number_of_users
    from users 
#### Answer: 130 users



## Question 2:On average, how many orders do we receive per hour?
### Script: 
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
#### Answer: 15.042 (Approximately 15 orders per hour)



## Question 3:On average, how long does an order take from being placed to being delivered?
#### Note: This computation was done using days as the unit
### Script: 
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
#### Answer: 3.892 days (Approximately 4 days)



## Question 4:How many users have only made one purchase? Two purchases? Three+ purchases?
### Script: 
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
    )nct user_id) as number_of_users
        from users 
#### Answer: 
    - One Purchase: 25 users
    - Two Purchases: 28 users
    - Three+ Purchases: 71 users
        


## Question 5:On average, how many unique sessions do we have per hour?
### Script: 
    with 
    events as (
        select * 
        from {{ref('stg_events')}}
    )
    
    select avg(sessions) sessions_per_hour 
    from (
        select extract(hour from created_at) hour_of_day, 
        count(distinct session_id) as sessions 
        from events
        group by 1
    )
#### Answer: 39.45 (Approximately 39 sessions per hour)
