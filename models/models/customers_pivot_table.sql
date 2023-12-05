-- Time-Based Customers Cohorts: we create a pivot table based on a time segmentation starting with the date of first purchase

SELECT
    cohort_date,
    {{ dbt_utils.pivot('order_date', dbt_utils.get_column_values(ref('pivot_int'), 'order_date')) }}
FROM {{ ref('pivot_int') }}
GROUP BY cohort_date
ORDER BY cohort_date ASC