with 
source as (

    select * from {{ source('stripe', 'payment') }}

),

payments as (
    select 

        id as payment_id,
        orderid as order_id,
        status as payment_status, 
        round(amount/100, 2) as payment_amount
    
    from source
)

select * from payments