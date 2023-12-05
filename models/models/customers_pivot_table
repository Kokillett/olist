SELECT
    customer_id,
    {{ dbt_utils.pivot('date_1', dbt_utils.get_column_values(ref('customers_pivot'), 'date_1')) }}
FROM {{ ref('customers_pivot') }}
GROUP BY customer_id