SELECT
    seller_id
    ,product_category_name_english
    ,SUM(payment_value) as seller_total_value
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english
ORDER BY SUM(payment_value) DESC
LIMIT 10