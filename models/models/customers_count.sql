-- models/customer_segments.sql

-- Create a table with a single column named 'customer_segment'
WITH customer_data AS (
  SELECT 'lost' AS customer_segment
  FROM UNNEST(GENERATE_ARRAY(1, 20357)) AS series
  UNION ALL
  SELECT 'new' AS customer_segment
  FROM UNNEST(GENERATE_ARRAY(1, 18408)) AS series
  UNION ALL
  SELECT 'loyal' AS customer_segment
  FROM UNNEST(GENERATE_ARRAY(1, 161)) AS series
)

-- Select the data from the temporary table
SELECT
  *
FROM
  customer_data