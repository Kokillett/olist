with 

source as (

    select * from {{ source('Olist_big_query', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date

    from source

),
renamed_2 as (
select renamed.*
,customer_unique_id,
from renamed
join {{ ref('stg_Olist_big_query__customers') }}
using(customer_id)
)

select order_id,
order_status,
order_purchase_timestamp,
order_approved_at,
order_delivered_carrier_date,
order_delivered_customer_date,
order_estimated_delivery_date,
customer_unique_id as customer_id
from renamed_2