{% macro fetch_configured_sources() %}
	{{ return(adapter.dispatch("fetch_configured_sources", "dbt_faker")()) }}
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

          {# if the model has no columns then nothing to fake --> skip #}
          {% if node.columns != {} %}
          
            {% do configured_sources.append(
                        {
                            'unique_id': node['unique_id'],
                            'columns': node.columns
                        }
                    ) %}
                {% do log("Appended to `configured_sources`: " ~ node, info=True) %}

        {% endif %}

        {% endif %}

    {% endfor %}


    {% do log("`final_sources_list` is: " ~ configured_sources, info=True) %}
    {{ return(configured_sources) }}

{% endmacro %}
