SELECT
    date_1
    ,order_id
    ,customer_state
    ,product_category_name_english
    ,product_id
    ,payment_value
    ,seller_id
    ,review_score
FROM {{ ref('Times_series1_2') }}