select 
customer_id
,product_category_name_english
,count(order_id) AS count_order
from {{ ref('int_customer_turnover') }}
GROUP BY 
customer_id
,product_category_name_english
ORDER BY count_order DESC