{% macro test_assert_disabled_sources() %}

 {# "basic check that we're not generating disabled sources, aka faker_enabled: false" #}
 {% set python_model = dbt_faker.generate_faker_model() %}
 {{ dbt_unittest.assert_not_in(python_model, "disabled_") }}

{% endmacro %}
