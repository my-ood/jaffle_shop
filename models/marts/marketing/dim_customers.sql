with customers as (
    select * from {{ ref('stg_jaffle_shop__customers')}}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders')}}    
),

fct_orders as (
    select * from {{ ref("fct_orders")}}
),

customer_orders as (
    select
        customer_id,

        min(order_placed_at) as first_order_date,
        max(order_placed_at) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders
    group by 1

),

customer_payments as (
    select 
        customer_id,
        coalesce(sum(amount), 0) AS lifetime_value  
    from fct_orders
    group by customer_id
)
,

final as (
    select  
        customers.customer_id,
        customers.customer_first_name,
        customers.customer_last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_payments.lifetime_value, 0) as lifetime_value
    
    from customers
    left join customer_orders using (customer_id)
    left join customer_payments using (customer_id)
)

select * from final