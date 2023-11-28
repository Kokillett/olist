with 

source as (

    select * from {{ source('Olist_big_query', 'geolocation') }}

),

renamed as (

    select
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state

    from source

)

select * from renamed
