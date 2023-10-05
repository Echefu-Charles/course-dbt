## Question 1:What is our overall conversion rate?
### Script: 
    with int_events as (
    select * 
    from {{ref('int_events')}}
    ),
    
    purchase_sesions as (
        select *, 
        case when session_step in (3, 4) then session_id else null end as purchase_session_id
        from int_events
    )
    
    select count(distinct purchase_session_id)/ count(distinct session_id) as conversion_rate
    from purchase_sesions
#### Answer: 62.45%



## Question 2:What is our conversion_rate by Product?
### Script: 
    
    with 
    events as (
    select * 
    from {{ref('int_events') }}
    
    ),
    product_sesions as (
        select *, 
        case when session_step in (3, 4) then session_id else null end as purchase_session_id,
        case when session_step = 1 then session_id else null end as viewed_session_id
        from events
    )
    
    select product_name, count(distinct purchase_session_id) num_purchase_sessions, count(distinct viewed_session_id) num_view_sessions, 
    div0null(count(distinct purchase_session_id), count(distinct viewed_session_id)) as conversion_rate
    from product_sesions
    group by 1
    order by 1
#### Answer: 
    PRODUCT_NAME	NUM_PURCHASE_SESSIONS	NUM_VIEW_SESSIONS	CONVERSION_RATE
    Alocasia Polly	21	51	0.411764
    Aloe Vera	32	65	0.492307
    Angel Wings Begonia	24	61	0.393442
    Arrow Head	35	63	0.555555
    Bamboo	36	67	0.537313
    Bird of Paradise	27	60	0.45
    Birds Nest Fern	33	78	0.423076
    Boston Fern	26	63	0.412698
    Cactus	30	55	0.545454
    Calathea Makoyana	27	53	0.509433
    Devil's Ivy	22	45	0.488888
    Dragon Tree	29	62	0.467741
    Ficus	29	68	0.42647
    Fiddle Leaf Fig	28	56	0.5
    Jade Plant	22	46	0.47826
    Majesty Palm	33	67	0.492537
    Money Tree	26	56	0.464285
    Monstera	25	49	0.510204
    Orchid	34	75	0.453333
    Peace Lily	27	66	0.40909
    Philodendron	30	62	0.48387
    Pilea Peperomioides	28	59	0.474576
    Pink Anthurium	31	74	0.418918
    Ponytail Palm	28	70	0.4
    Pothos	21	61	0.344262
    Rubber Plant	28	54	0.518518
    Snake Plant	29	73	0.39726
    Spider Plant	28	59	0.474576
    String of pearls	39	64	0.609375
    ZZ Plant	34	63	0.539682

## Question 3:Which products had their inventory change from week 2 to week 3?
#### Answer:
    select product_id, name, price, inventory, dbt_valid_to
    from product_snapshot 
    where product_id in (
        select product_id from product_snapshot
        where dbt_valid_to is not null)
    order by product_id
from the output ot the query, the products that changed between week 2 and 3 are 
Pothos, Philodendron, Monstera, String of pearls, ZZ Plant and Bamboo
