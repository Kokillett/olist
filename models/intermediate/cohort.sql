SELECT
    customer_id
    ,MIN(date_1) AS first_purchase_date
    ,MIN(CAST(CONCAT(EXTRACT(year FROM date_1),"-", EXTRACT(month FROM date_1),"-", 1) AS DATE)) AS cohort_date
FROM {{ ref('CentralizedData') }}
GROUP BY customer_id