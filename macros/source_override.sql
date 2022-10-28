{% macro is_truthy(value) %}
  {{ return((value | lower) == 'true') }}
{% endmacro %}

{% macro source(source_name, table_name) -%}
  {% do log("dbt_faker has intercepted the source call! " ~ source_name ~ ", " ~ table_name, info=True) %}

  {# When faker_enabled is true, then route queries to the faked table #}
  {%- if is_truthy(var('faker_enabled', 'false')) -%}
    {% do log("dbt_faker is enabled! " ~ source_name ~ ", " ~ table_name, info=True) %}

    {# Only on execution #}
    {% if execute %}
      {% set is_source_enabled = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].source_meta.faker_enabled %}

      {% if is_truthy(is_source_enabled) %}
        {% do log("dbt_faker: source is enabled! " ~ source_name ~ ", " ~ table_name, info=True) %}

        {% set is_source_table_enabled = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].meta.faker_enabled %}

        {% if is_truthy(is_source_table_enabled) %}
          {% do log("dbt_faker: source table is enabled! " ~ source_name ~ ", " ~ table_name, info=True) %}

          {% set db_name = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].database %}
          {% set schema_name = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].schema %}
          {% set fake_table_name = 'fake__' ~ source_name ~ '__' ~ table_name %}
          {% set fully_qualified_fake_table_name = db_name ~ '.' ~ schema_name ~ '.' ~ fake_table_name %}

          {%- set source_relation = adapter.get_relation(
                database=db_name,
                schema=schema_name,
                identifier=fake_table_name,
          ) -%}

          {% set fake_table_exists = source_relation is not none %}

          {% if fake_table_exists %}
            {% do log("dbt_faker: fake table exists! " ~ source_name ~ ", " ~ table_name, info=True) %}
            {{ return(fully_qualified_fake_table_name) }}
          {% else %}

            {% do log("Tried to use fake table " ~ fully_qualified_fake_table_name ~ ", but it doesn't exist! Defaulting to the actual source.", info=True) %}
          {% endif %}
        {% endif %}
      {% endif %}
    {% else %}
      {% do log("dbt_faker: here! " ~ source_name ~ ", " ~ table_name, info=True) %}

    {%- endif -%}
  {% else %}
    {% do log("dbt_faker: execute DISABLED! " ~ source_name ~ ", " ~ table_name, info=True) %}

  {%- endif -%}

  {{ return(builtins.source(source_name, table_name)) }}

{%- endmacro %}
