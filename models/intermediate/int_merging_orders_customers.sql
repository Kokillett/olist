Select 

o.order_id
,o.customer_id
, c.customer_state
from {{ ref('stg_Olist_big_query__orders') }} as o
join {{ ref('stg_Olist_big_query__customers') }} as c
using(customer_id)



