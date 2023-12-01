select 
customer_id
,seller_id
,count(order_id) AS count_order
from {{ ref('int_customer_turnover') }}
GROUP BY 
customer_id
,seller_id
ORDER BY count_order desc