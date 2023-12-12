WITH intii AS
(
SELECT
    seller_id
    ,customer_state
    ,COUNT(customer_state) AS number_customer_state
FROM {{ ref('sellers_table') }}
GROUP BY seller_id, customer_state
ORDER BY seller_id
)

SELECT
    seller_id
    ,customer_state
    ,number_customer_state
    ,number_customer_state / SUM(number_customer_state) over(PARTITION by seller_id) as percentage_of_customer_state
FROM intii