{% macro source(source_name, table_name) -%}
{#{% if var('fake', false) %}
{{ return(builtins.ref('fake__' ~ source_name ~ '__' ~ table_name))}}
{% else %}#}
{{ return(builtins.source(source_name, table_name)) }}
{#{% endif %}#}
{%- endmacro %}
