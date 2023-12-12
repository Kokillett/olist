WITH source AS (
    SELECT * FROM {{ source('Olist_big_query', 'order_items') }}
),
renamed AS (
    SELECT
        order_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    FROM source
)
SELECT
    order_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    COUNT(*) AS occurrence_count
/*freight_value is correct, price however needs to be multiplied by the occurence_count */
FROM renamed
GROUP BY
    order_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value

order by order_id
