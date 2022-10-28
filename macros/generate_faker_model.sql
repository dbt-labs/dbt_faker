{% macro generate_faker_model(source_name, table_name) %}

{% set final_sources_list=fetch_configured_sources('source.fdbt.tpch.orders') %}

{# here we would need to read from yml instead?? #}
{# This relation is not being used atm #}
--{%- set source_relation = source(source_name, table_name) -%}

{% for source_table in final_sources_list %}

    {%- set columns = source_table.columns -%}
    {% set column_names=columns %}

    {% set fake_model_py %}

    import pandas as pd
    import faker

    def model( dbt, session ):
        
        dbt.config(
            materialized="table",
            packages=['pandas','faker'] 
        )

        create_rows(
        dbt,
        session,
        table_name=source_table['unique_id'],
        num=100
        
        --{%- for column in column_names %}
        --    {{ column.name | upper }}{{ "='" ~ column.meta.provider ~ "'" }}{{"," if not loop.last}}
        --{%- endfor -%}
        
        )

        df = pd.DataFrame(data) 
        df.columns = df.columns.str.lower()
        
        return df

    {% endset %}

    {% if execute %}

    {{ log(fake_model_py, info=True) }}
    {% do return(fake_model_py) %}

    {% endif %}

{% endfor %}

{% endmacro %}
