SELECT *,
DATE(EXTRACT(YEAR FROM order_purchase_timestamp), EXTRACT(MONTH FROM order_purchase_timestamp), EXTRACT(DAY FROM order_purchase_timestamp)) AS date_date,
EXTRACT(HOUR FROM order_purchase_timestamp) as time_time,

FROM {{ ref('stg_Olist_big_query__orders') }}
