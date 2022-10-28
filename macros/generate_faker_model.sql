{% macro generate_faker_model() %}

{% set final_list=fetch_configured_sources() %}

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

    {% for source_table in final_list %}

        {%- set columns = source_table.columns -%}
        {% set column_names=columns %}

        create_rows(
        dbt,
        session,
        table_name={{ source_table['unique_id'] }},
        num=5000,
        {%- for column in column_names  %}
        {%- set def_fake_provider=column_names[column]['meta'].fake_provider %}
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

    {{ log(fake_model_py, info=True) }}
    {% do return(fake_model_py) %}

    {% endif %}

{% endmacro %}
