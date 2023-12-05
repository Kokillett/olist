SELECT
    c.customer_id
    ,c.first_purchase_date
    ,c.cohort_date
    ,CAST(CONCAT(EXTRACT(year FROM date_1),"-", EXTRACT(month FROM date_1),"-", 1) AS DATE) AS order_date
FROM {{ ref('CentralizedData') }} as o
JOIN {{ ref('cohort') }} as c
ON o.customer_id = c.customer_id