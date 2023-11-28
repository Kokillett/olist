with int as 
(
  select 
  date_date,
  SUM(oi.price + oi.freight_value) AS turnover,
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(oi.order_item_id) AS total_items,
  FROM
  {{ ref('Create_date_date_and_time_time') }} AS o
JOIN
  {{ ref('stg_Olist_big_query__order_items') }} AS oi
ON
  o.order_id = oi.order_id
group by date_date
)

SELECT
  date_date,
  ROUND(turnover,2)as turnover,
  total_orders,
  total_items,
  ROUND((turnover / total_orders),2) AS avg_basket,
  ROUND((turnover / total_items),2) AS avg_ticket,
 ROUND((((turnover - LAG(turnover) OVER(ORDER BY date_date ASC)) / LAG(turnover) OVER(ORDER BY date_date ASC))*100),2) AS turnover_growth_percent
FROM
  int
ORDER BY date_date