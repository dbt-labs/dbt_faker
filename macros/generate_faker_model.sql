{% macro generate_faker_model(source_name, table_name, case_sensitive_cols=False) %}


{# here we would need to read from yml instead?? #}
{# This relation is not being used atm #}
{%- set source_relation = source(source_name, table_name) -%}

{%- set columns = adapter.get_columns_in_relation(source_relation) -%}
{% set column_names=columns | map(attribute='name') %}
{% set fake_model_py %}

import pandas as pd
import faker

def model( dbt, session ):
    
    dbt.config(
        materialized="table",
        packages=['pandas','faker'] 
    )

    {# fake code alert #}
    data = {'Name':['Tom', 'Brad', 'Kyle', 'Jerry'],
        'Age':[20, 21, 19, 18],
        'Height' : [6.1, 5.9, 6.0, 6.1]
        }

    df = pd.DataFrame(data) 
    df.columns = df.columns.str.lower()
    
    return df

{% endset %}

{% if execute %}

{{ log(fake_model_py, info=True) }}
{% do return(fake_model_py) %}

{% endif %}
{% endmacro %}
