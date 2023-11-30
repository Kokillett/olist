select 
date_1
    ,sum(payment_value) as payment_value
    ,ROUND(sum(turnover),2) as turnover
    ,sum(total_orders) as total_orders
    ,sum(total_items) as total_items
    ,avg(avg_basket) as avg_basket
    ,avg(avg_unit_price) as avg_unit_price
from {{ ref('CentralizedData') }}
GROUP by 
date_1
ORDER BY date_1

