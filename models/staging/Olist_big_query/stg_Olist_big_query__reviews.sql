with 

source as (

    select * from {{ source('Olist_big_query', 'reviews') }}

),

renamed as (

    select
        order_id,
        review_score

    from source

)

select * from renamed
