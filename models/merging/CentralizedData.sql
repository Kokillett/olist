with calendar AS (
SELECT
    *
FROM
    UNNEST(
        GENERATE_DATE_ARRAY(
            '2017-01-01',
            '2018-08-31',
            INTERVAL 1 DAY)
    ) AS date_1),

int_1 AS 
(
/* have unique value : ,count(concat(oi.order_item_id, oi.order_id)) as test_unique*/
SELECT
  date_date
  ,time_time
  ,customer_id
  ,oi.order_id
  ,oi.product_id
  ,oi.seller_id
  ,ROUND(SUM(oi.price),2) AS item_price
  ,ROUND(SUM(oi.freight_value),2) AS shipping_revenue
  ,ROUND(SUM((oi.price * oi.occurrence_count)+oi.freight_value),2) AS turnover
  ,COUNT(DISTINCT oi.order_id) AS total_number_orders
/*in the table order_items, order_id column is not unique since it can have multiple items  */
/* here the unique identifier become  "(order_id || '-' || items_per_order)" */
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
ORDER BY date_date
),

int_2 AS
(
    /* primary key : items_per_order, order_id ,date_1*/
SELECT
   *
FROM int_1 as d
FULL OUTER JOIN calendar as f
on d.date_date = f.date_1
ORDER BY f.date_1
),

int_3 AS
(
    /*primary key : items_per_order, order_id ,date_1*/
SELECT 
*
FROM int_2
JOIN {{ ref('stg_Olist_big_query__product') }}
USING(product_id)
),

int_4 AS
(
    /* no primary key for turnover_map*/
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
    ,int_5.item_price
    ,int_5.shipping_revenue
    ,int_5.payment_type
    /*rename value of payment type*/
    , CASE int_5.payment_type
        WHEN 'credit_card' THEN 'Credit card'
        WHEN 'voucher' THEN 'Voucher'
        WHEN 'boleto' THEN 'Boleto'
        When 'debit_card' THEN 'Debit card'
        else payment_type
    END AS payment_type_rename

    ,int_5.payment_installments
    ,int_5.payment_value
    ,int_5.seller_id
    ,int_5.review_score
    ,int_5.turnover
    ,int_5.total_number_orders
     /*to calculate the NPS */
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
where date_1 is not NULL 


