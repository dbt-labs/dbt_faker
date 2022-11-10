{% macro generate_faker_model() %}

{% set final_list=dbt_faker.fetch_configured_sources() %}

    {% set fake_model_py %}

    import faker
    import pandas
    from snowflake.snowpark import Row


    def create_rows(dbt, session, source_name, table_name, num=1, **kwargs):
        fake = faker.Faker()

        df = session.create_dataframe([
            Row(**{
                key: getattr(fake, value)()
                for key, value in kwargs.items()
            }) for x in range(num)
        ])

        df.write.mode("overwrite").save_as_table(
            f"{dbt.this.database}.{dbt.this.schema}.fake__{source_name}__{table_name}",
            create_temp_table=False,
        )

    def model(dbt, session):
        dbt.config(
        materialized="table", 
        packages=["faker", "pandas"],
        )

    {%- for source_table in final_list -%}
        {%- set columns = source_table.columns -%}
        {% set column_names=columns %}
        {% set unique_id=source_table['unique_id'] %}

        create_rows(
        dbt,
        session,
        {%- if source_table['meta'].faker_rows -%}
            {%- set def_fake_rows=source_table['meta'].faker_rows -%}
        {%- else -%}
            {%- set def_fake_rows=100 -%}
        {%- endif %}        
        num={{ def_fake_rows }},
        source_name='{{ unique_id.split(".")[-2]  }}',
        table_name='{{ unique_id.split(".")[-1]  }}',

        {%- for column in column_names  %}
        {%- set def_fake_provider=column_names[column]['meta'].faker_provider %}
        {%- if (def_fake_provider|length) == 0 %}
            {%- set def_fake_provider='pystr' %}
        {%- endif %}
        {{ column_names[column]['name'] | upper }}{{ "='" ~ def_fake_provider ~ "'" }}{{"," if not loop.last}}
        {%- endfor %}
        )

    {% endfor %}
    
        df = session.create_dataframe(['yes']).to_df("are_we_faking")

        return df

    {% endset %}

    {% if execute %}

    {{ print(fake_model_py) }}
    {% do return(fake_model_py) %}

    {% endif %}

{% endmacro %}
