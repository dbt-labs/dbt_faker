select 
    customer_id,
    count(*) as customer_item_count
from {{ source('erp', 'order_items') }} as order_items
left join {{ source('erp', 'orders') }} as orders
    on orders.order_id = order_items.order_id
group by 1
