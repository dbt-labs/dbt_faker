{% macro is_truthy(value) %}
  {{ return((value | lower) == 'true') }}
{% endmacro %}

{% macro source(source_name, table_name) -%}

  {{ dbt_meta_testing.logger("dbt_faker has intercepted the source call! " ~ source_name ~ ", " ~ table_name) }}

  {# When faker_enabled is true, then route queries to the faked table #}
  {%- if is_truthy(var('faker_enabled', 'false')) -%}
    {{ dbt_meta_testing.logger("dbt_faker is enabled! " ~ source_name ~ ", " ~ table_name) }}

    {# Only on execution #}
    {% if execute %}
      {{ dbt_meta_testing.logger("dbt_faker: execute enabled! " ~ source_name ~ ", " ~ table_name) }}
      {% set is_source_enabled = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].source_meta.faker_enabled %}

      {% if is_truthy(is_source_enabled) %}
        {{ dbt_meta_testing.logger("dbt_faker: source is enabled! " ~ source_name ~ ", " ~ table_name) }}
        {% set is_source_table_enabled = graph.sources['source.fdbt.' ~ source_name ~ '.' ~ table_name].meta.faker_enabled %}

        {% if is_truthy(is_source_table_enabled) %}
          {{ dbt_meta_testing.logger("dbt_faker: source table is enabled! " ~ source_name ~ ", " ~ table_name) }}

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
            {{ dbt_meta_testing.logger("dbt_faker: fake table exists! " ~ source_name ~ ", " ~ table_name) }}
            {{ return(fully_qualified_fake_table_name) }}
          {% else %}
            {{ dbt_meta_testing.logger("Tried to use fake table " ~ fully_qualified_fake_table_name ~ ", but it doesn't exist! Defaulting to the actual source.") }}
          {% endif %}
        {% endif %}
      {% endif %}
    {% else %}
      {{ dbt_meta_testing.logger("dbt_faker: here! " ~ source_name ~ ", " ~ table_name) }}
    {%- endif -%}
  {% else %}
    {{ dbt_meta_testing.logger("dbt_faker: execute DISABLED! " ~ source_name ~ ", " ~ table_name) }}
  {%- endif -%}

  {{ return(builtins.source(source_name, table_name)) }}

{%- endmacro %}
