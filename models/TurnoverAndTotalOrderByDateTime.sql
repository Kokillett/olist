select 
date_1
    ,time_time
    ,customer_state
    ,product_category_name_english
    ,sum(payment_value) as payment_value
    
    ,sum(turnover) as turnover
    ,sum(total_orders) as total_orders
    ,sum(total_items) as total_items
    ,avg(avg_basket) as avg_basket
    ,avg(avg_unit_price) as avg_unit_price
from {{ ref('CentralizedData') }}
GROUP by 
date_1
, time_time
,product_category_name_english
,customer_state
ORDER BY date_1

