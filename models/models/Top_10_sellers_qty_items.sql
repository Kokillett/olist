SELECT
    seller_id
    ,product_category_name_english
    ,COUNT(product_id) as number_of_products
    ,review_score
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english, review_score
ORDER BY COUNT(product_id) DESC
LIMIT 10