SELECT
    seller_id
    ,product_category_name_english
    ,COUNT(product_id) as number_of_products
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english
ORDER BY COUNT(product_id) DESC
LIMIT 10