WITH create_cohort AS
(
SELECT
    customer_id
    ,MIN(date_1) AS first_purchase_date
    ,MIN(CAST(CONCAT(EXTRACT(year FROM date_1),"-", EXTRACT(month FROM date_1),"-", 1) AS DATE)) AS cohort_date
FROM {{ ref('CentralizedData') }}
GROUP BY customer_id
)

SELECT
    c.customer_id
    ,c.cohort_date
    ,CAST(CONCAT(EXTRACT(year FROM date_1),"-", EXTRACT(month FROM date_1),"-", 1) AS DATE) AS order_date
    ,CAST(EXTRACT((year from date_1) as DATE)) as order_year
    ,CAST(EXTRACT((month from date_1) as DATE)) as order_month
    ,CAST(EXTRACT((year from cohort_date) as DATE)) as cohort_year
    ,CAST(EXTRACT((month from cohort_date) as DATE)) as cohort_month
FROM {{ ref('CentralizedData') }} as o
JOIN create_cohort as c
ON o.customer_id = c.customer_id