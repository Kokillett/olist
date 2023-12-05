WITH customers_data AS (
  SELECT
    38926 AS customers_count
    UNION ALL
  SELECT
    20357 AS customers_count
    UNION ALL
  SELECT
    18408 AS customers_count
    UNION ALL
  SELECT
    161 AS customers_count
)

SELECT
  *
FROM
  customers_data