{{
  config(
    materialized='table'
  )
}}


with 
products as (
    select 
        product_id,
        name,
        price,
        inventory
        
    from {{ source('postgres', 'products') }}
)

select * from products 