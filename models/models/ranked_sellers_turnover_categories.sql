SELECT
    seller_id
    ,product_category_name_english
    ,COUNT(order_id) as number_of_orders
    ,COUNT(product_id) as number_of_products
    ,SUM(payment_value) as seller_total_value
    ,review_score
    ,RANK() OVER (PARTITION BY product_category_name_english ORDER BY SUM(payment_value) DESC) AS TOP_10
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english, review_score
ORDER BY product_category_name_english,RANK() OVER (PARTITION BY product_category_name_english ORDER BY SUM(payment_value) DESC)