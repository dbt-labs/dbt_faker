{% macro source(source_name, table_name) %}
{{ return(dbt_faker.dbt_faker_source(source_name, table_name)) }}
{% endmacro %}
