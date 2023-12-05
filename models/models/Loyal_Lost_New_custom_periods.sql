WITH CustomerMonthsCTE AS (
  SELECT
    customer_unique_id,
    MAX(CASE WHEN DATE(date_1) BETWEEN '2018-03-01' AND '2018-05-31' THEN 1 ELSE 0 END) AS period_1,
    MAX(CASE WHEN DATE(date_1) BETWEEN '2018-06-01' AND '2018-08-31' THEN 1 ELSE 0 END) AS period_2
  FROM {{ ref('join_date_1_unique_id') }}
  WHERE DATE(date_1) BETWEEN '2018-03-01' AND '2018-08-31'
  GROUP BY customer_unique_id
)

SELECT
  COUNT(DISTINCT CASE WHEN period_1 = 1 AND period_2 = 1 THEN customer_unique_id END) AS loyal_count,
  COUNT(DISTINCT CASE WHEN period_1 = 1 AND period_2 = 0 THEN customer_unique_id END) AS lost_count,
  COUNT(DISTINCT CASE WHEN period_1 = 0 AND period_2 = 1 THEN customer_unique_id END) AS new_count,
  COUNT(DISTINCT CASE WHEN period_1 = 1 OR period_2 = 1 THEN customer_unique_id END) AS total_at_beginning,
  COUNT(DISTINCT CASE WHEN period_1 = 0 AND period_2 = 1 THEN customer_unique_id END) / COUNT(DISTINCT CASE WHEN period_1 = 1 OR period_2 = 1 THEN customer_unique_id END) * 100 AS churn_rate
FROM CustomerMonthsCTE
