{% macro test_assert_python_model_length() %}

 {# "super basic check that we're generating something" #}
 {% set python_model = dbt_faker.generate_faker_model() %}
 {{ dbt_unittest.assert_true(python_model | length > 5000) }}

{% endmacro %}
