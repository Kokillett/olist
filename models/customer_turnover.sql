SELECT 
cust.customer_id
,CD.order_id
,CD.product_id
,CD.seller_id
,CD.customer_state
,CD.product_category_name_english
,CD.turnover
,CD.total_orders

FROM {{ ref('CentralizedData') }} AS CD
JOIN {{ ref('stg_Olist_big_query__customers') }} cust
using(customer_state)