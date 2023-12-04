select 
moc.*
,payment_type
,payment_installments
,payment_value
from {{ ref('int_merging_orders_customers') }} as moc
JOIN {{ ref('stg_Olist_big_query__payments') }} p
using(order_id)
