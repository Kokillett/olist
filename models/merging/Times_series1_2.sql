with calendar as (
    SELECT
    *
FROM
    UNNEST(
        GENERATE_DATE_ARRAY(
            '2016-09-04',
            '2018-09-03',
            INTERVAL 1 DAY)
    ) AS date_1) ,


int as 
(
  select 
  date_date
  ,time_time
  ,oi.order_id
  ,oi.product_id
  ,oi.seller_id
  ,SUM(oi.price + oi.freight_value) AS turnover
  ,COUNT(DISTINCT oi.order_id) AS total_orders
  ,COUNT(oi.order_item_id) AS total_items
  FROM
  {{ ref('Create_date_date_and_time_time') }} AS o
JOIN
  {{ ref('stg_Olist_big_query__order_items') }} AS oi
ON
  o.order_id = oi.order_id
group by 
date_date
,time_time
,oi.order_id
,oi.product_id
,oi.seller_id
),

int_2 as( SELECT
f.date_1
,time_time
,order_id
,product_id
,seller_id
,ROUND(turnover,2) as turnover
,total_orders
,total_items
,ROUND((turnover / total_orders),2) AS avg_basket
,ROUND((turnover / total_items),2) AS avg_unit_price
,ROUND((((turnover - LAG(turnover) OVER(ORDER BY date_date ASC)) / LAG(turnover) OVER(ORDER BY date_date ASC))*100),2) AS turnover_growth_percent
,ROUND((((total_orders - LAG(total_orders) OVER (ORDER BY date_date ASC)) / LAG(total_orders) OVER (ORDER BY date_date ASC)) * 100), 2) AS orders_growth_percent
FROM
  int as d
FULL OUTER JOIN calendar as f
on d.date_date = f.date_1
ORDER BY f.date_1),

int_3 as (
SELECT *
FROM int_2
JOIN {{ ref('stg_Olist_big_query__product') }} AS cat
using(product_id)
)

SELECT 
int_3.*
,customer_state
,payment_type
,payment_installments
,payment_value
FROM int_3
JOIN {{ ref('stg_Olist_big_query__turnover_map') }} as tmap 
using (order_id)