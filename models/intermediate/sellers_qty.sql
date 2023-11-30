SELECT
    seller_id
    ,COUNT(order_id) as number_of_orders
FROM {{ ref('best_sellers_int') }}
GROUP BY seller_id