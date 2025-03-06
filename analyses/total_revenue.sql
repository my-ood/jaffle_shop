-- using the stg_payments model to sum the amount of successful payments

with 

payments as (
    select * from {{ ref('stg_stripe__payments') }}
)

select 
    sum(payment_amount) as total_successful_payments
from payments
where payment_status = 'success'