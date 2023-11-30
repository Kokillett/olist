WITH intii AS
(
SELECT
    seller_id
    ,review_score
    ,COUNT(review_score) AS number_reviews
FROM {{ ref('sellers_table') }}
GROUP BY seller_id,review_score
ORDER BY seller_id
)

SELECT
    seller_id
    ,review_score
    ,number_reviews
    ,number_reviews / SUM(number_reviews) over(PARTITION by seller_id) as percentage_of_reviews
FROM intii