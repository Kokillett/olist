with 

source as (

    select * from {{ source('Olist_big_query', 'sellers') }}

),

renamed as (

    select
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state

    from source

)

select * from renamed
