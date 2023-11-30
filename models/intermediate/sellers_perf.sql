SELECT
    seller_id
    ,product_category_name_english
    ,COUNT(order_id) as number_of_orders
    ,COUNT(product_id) as number_of_products
    ,SUM(payment_value) as seller_total_value
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, product_category_name_english