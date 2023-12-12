SELECT
    seller_id
    ,product_category_name_english
    ,SUM(payment_value) as seller_total_value
    ,review_score
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english, review_score
ORDER BY SUM(payment_value) DESC
LIMIT 10