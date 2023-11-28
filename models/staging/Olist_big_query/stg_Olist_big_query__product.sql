with 

source as (

    select * from {{ source('Olist_big_query', 'product') }}

),

renamed as (

    select
        product_id,
        product_category_name_english

    from source

)

select * from renamed
