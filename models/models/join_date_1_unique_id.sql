WITH CustomerData AS (
  SELECT
    c.date_1,
    c.customer_id,
    cu.customer_unique_id
  FROM {{ ref('CentralizedData') }} c
  INNER JOIN {{ ref('stg_Olist_big_query__customers') }} cu
    ON c.customer_id = cu.customer_id
)

SELECT
  cd.date_1,
  cd.customer_id,
  cd.customer_unique_id
FROM CustomerData cd
