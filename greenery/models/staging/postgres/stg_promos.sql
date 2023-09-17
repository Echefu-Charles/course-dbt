{{
  config(
    materialized='table'
  )
}}


with 
promos as (
    select 
        promo_id,
        discount,
        status
        
    from {{ source('postgres', 'promos') }}
)

select * from promos 