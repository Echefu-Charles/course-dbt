{{
  config(
    materialized='table'
  )
}}


with 
addresses as (
    select 
        address_id, 
        address, 
        zipcode, 
        state, 
        country 
    from {{ source('postgres', 'addresses') }}
)

select * from addresses 