{% macro fetch_configured_sources() %}
	{{ return(adapter.dispatch("fetch_configured_sources", "dbt_meta_testing")()) }}
{% endmacro %}

{% macro default__fetch_configured_sources() %}

    {% set resource_type="source" %}
    {% set configured_sources = [] %}

    {% for node in graph.sources.values() | selectattr("resource_type", "equalto", resource_type) %}

        {# Retrieve sources whose meta faker is:
            - enabled the source level 
            - not disabled at the table level 
        #}
         {% if (node.source_meta.faker_enabled == True and node.meta.faker_enabled != False ) %} 
          {% do configured_sources.append(
                    {
                        'unique_id': node['unique_id'],
                        'columns': node.columns
                    }
                ) %}
            
            {{ dbt_meta_testing.logger("Appended to `configured_sources`: " ~ node) }}


        {% endif %}

    {% endfor %}

   
    {{ dbt_meta_testing.logger("`final_sources_list` is: " ~ configured_sources) }}
    {{ return(configured_sources) }}

{% endmacro %}
