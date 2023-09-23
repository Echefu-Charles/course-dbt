select * 
from {{ref('stg_orders')}}
where delivered_at < created_at