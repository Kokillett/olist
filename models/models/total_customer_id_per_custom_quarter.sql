WITH CustomerMonthsCTE AS (
  SELECT
    customer_id,
    MAX(CASE WHEN DATE(date_1) BETWEEN '2018-03-01' AND '2018-05-31' THEN 1 ELSE 0 END) AS period_1,
    MAX(CASE WHEN DATE(date_1) BETWEEN '2018-06-01' AND '2018-08-31' THEN 1 ELSE 0 END) AS period_2
  FROM {{ ref('CentralizedData') }}
  WHERE DATE(date_1) BETWEEN '2018-03-01' AND '2018-08-31'
  GROUP BY customer_id
)

SELECT
  SUM(CASE WHEN period_1 = 1 AND period_2 = 0 THEN 1 ELSE 0 END) AS total_in_period_1,
  SUM(CASE WHEN period_1 = 0 AND period_2 = 1 THEN 1 ELSE 0 END) AS total_in_period_2,
FROM CustomerMonthsCTE

