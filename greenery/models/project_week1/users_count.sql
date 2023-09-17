{{
  config(
    materialized='view'
  )
}}

with 
users as (
    select * 
    from {{ref('stg_users')}}
)

select count(distinct user_id) as number_of_users
from users 