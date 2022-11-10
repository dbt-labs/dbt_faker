{% test row_count(model, column_name, equals) %}
    select row_count
    from (select count({{ column_name }}) as row_count from {{ model }})
    where row_count = {{ equals }}
{% endtest %}
