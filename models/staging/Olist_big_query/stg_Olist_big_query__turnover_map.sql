with 

source as (

    select * from {{ source('Olist_big_query', 'turnover_map') }}

),

renamed as (

    select
        order_id,
        customer_id,
        customer_state,
        payment_type,
        payment_installments,
        payment_value,
        freight_value,
        turnover

    from source

)

select * from renamed
