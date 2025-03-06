{% snapshot mock_orders %}
    
    {% set new_schema = target.schema + '_snapshot' %}
    
    {{
        config(
            target_schema=new_schema,
            target_database='analytics',
            unique_key='order_id',
            
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from analytics.{{target.schema}}.mock_orders
 {% endsnapshot %}