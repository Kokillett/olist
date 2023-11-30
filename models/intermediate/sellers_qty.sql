SELECT
    seller_id
    ,COUNT(order_id) as number_of_orders
    ,COUNT(product_id) as number_of_products
    ,SUM(payment_value) as seller_total_value
FROM {{ ref('best_sellers_int') }}
GROUP BY seller_id