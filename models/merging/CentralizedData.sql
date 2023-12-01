with calendar AS (
SELECT
    *
FROM
    UNNEST(
        GENERATE_DATE_ARRAY(
            '2016-09-04',
            '2018-08-31',
            INTERVAL 1 DAY)
    ) AS date_1),

int AS 
(
SELECT
  date_date
  ,time_time
  ,customer_id
  ,oi.order_id
  ,oi.product_id
  ,oi.seller_id
  ,oi.order_item_id AS items_per_order
  ,ROUND(SUM(oi.price),2) AS item_price
  ,ROUND(SUM(oi.freight_value),2) AS shipping_revenue
  ,ROUND(SUM(oi.price + oi.freight_value),2) AS turnover
  ,COUNT(DISTINCT oi.order_id) AS total_number_orders
  ,COUNT(oi.order_item_id) AS total_number_items
 FROM {{ ref('Create_date_date_and_time_time') }} AS o
JOIN {{ ref('stg_Olist_big_query__order_items') }} AS oi
ON
  o.order_id = oi.order_id
GROUP BY 
date_date
,customer_id
,time_time
,oi.order_id
,oi.product_id
,oi.seller_id
,order_item_id
),

int_2 AS
(
SELECT
   *
FROM int as d
FULL OUTER JOIN calendar as f
on d.date_date = f.date_1
ORDER BY f.date_1
),

int_3 AS
(
SELECT 
*
FROM int_2
JOIN {{ ref('stg_Olist_big_query__product') }}
USING(product_id)
),

int_4 AS
(
SELECT 
int_3.*
,customer_state
,payment_type
,payment_installments
,payment_value
FROM int_3
JOIN {{ ref('stg_Olist_big_query__turnover_map') }} as tmap 
USING(order_id)
),

int_5 AS
(
SELECT
    *
FROM int_4
JOIN {{ ref('stg_Olist_big_query__reviews') }}
USING(order_id)
)

SELECT
    int_5.date_1
    ,int_5.time_time
    ,int_5.customer_id
    ,int_5.order_id
    ,int_5.customer_state
    ,int_5.product_category_name_english
    ,int_5.product_id
    ,int_5.items_per_order
    ,int_5.item_price
    ,int_5.shipping_revenue
    ,int_5.payment_type
    ,int_5.payment_installments
    ,int_5.payment_value
    ,int_5.seller_id
    ,int_5.review_score
    ,int_5.turnover
    ,int_5.total_number_orders
    ,int_5.total_number_items
    /* to calculate the NPS */
,if(int_5.review_score = '5',1,0) as promoters_1 

,if(int_5.review_score = '4',1,0) as passive 

,CASE int_5.review_score
   
    WHEN '3' THEN 1
    WHEN '2' THEN 1
    WHEN '1' THEN 1
    else 0
END AS detractors
,CASE int_5.review_score
    WHEN '5' then 'Promoters'
    WHEN '4' then 'Passive'
    WHEN '3' THEN 'Detractors'
    WHEN '2' THEN 'Detractors'
    WHEN '1' THEN 'Detractors'
    else ''
END AS Repartition_review
FROM int_5


