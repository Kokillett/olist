with calendar AS (
SELECT
    *
FROM
    UNNEST(
        GENERATE_DATE_ARRAY(
            '2016-09-04',
            '2018-09-03',
            INTERVAL 1 DAY)
    ) AS date_1),

int AS 
(
SELECT
  date_date
  ,time_time
  ,oi.order_id
  ,oi.product_id
  ,oi.seller_id
  ,SUM(oi.price + oi.freight_value) AS turnover
  ,COUNT(DISTINCT oi.order_id) AS total_orders
  ,COUNT(oi.order_item_id) AS total_items
 FROM {{ ref('Create_date_date_and_time_time') }} AS o
JOIN {{ ref('stg_Olist_big_query__order_items') }} AS oi
ON
  o.order_id = oi.order_id
GROUP BY 
date_date
,time_time
,oi.order_id
,oi.product_id
,oi.seller_id
),

int_2 AS
(
SELECT
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
FROM int as d
FULL OUTER JOIN calendar as f
on d.date_date = f.date_1
ORDER BY f.date_1
),

int_3 AS
(
SELECT *
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
    ,int_5.order_id
    ,int_5.customer_state
    ,int_5.product_category_name_english
    ,int_5.product_id
    ,int_5.payment_type
    ,int_5.payment_installments
    ,int_5.payment_value
    ,int_5.seller_id
    ,int_5.review_score
    ,int_5.turnover
    ,int_5.total_orders
    ,int_5.total_items
    ,int_5.avg_basket
    ,int_5.avg_unit_price
    /* to calculate the NPS */
    ,CASE int_5.review_score
    WHEN '5' THEN 1
    WHEN '4' THEN 0
    WHEN '3' THEN 0
    WHEN '2' THEN 0
    WHEN '1' THEN 0
END AS promoters_1,

CASE int_5.review_score
    WHEN '5' THEN 0
    WHEN '4' THEN 1
    WHEN '3' THEN 0
    WHEN '2' THEN 0
    WHEN '1' THEN 0
END AS passive,

CASE int_5.review_score
    WHEN '5' THEN 0
    WHEN '4' THEN 0
    WHEN '3' THEN 1
    WHEN '2' THEN 1
    WHEN '1' THEN 1
END AS detractors
FROM int_5
