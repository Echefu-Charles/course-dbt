{{
  config(
    materialized='view'
  )
}}

with users as (
    select * 
    from {{ref('stg_users')}}
),

addresses as (
    select * 
    from {{ref('stg_addresses')}}
)

select users.user_id, users.first_name, users.last_name, users.email, users.phone_number,
addresses.state, addresses.country
from users 
join addresses on users.address_id = addresses.address_id