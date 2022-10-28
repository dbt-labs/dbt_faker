{% macro fetch_configured_sources() %}
	{{ return(adapter.dispatch("fetch_configured_sources")()) }}
{% endmacro %}

{% macro default__fetch_configured_sources() %}

    {% set resource_type="source" %}
    {% set configured_sources = [] %}

    {% for node in graph.sources.values() | selectattr("resource_type", "equalto", resource_type) %}

        {# Retrieve sources whose meta faker is:
            - enabled the source level 
            - not disabled at the table level 
           or
           - enabled the source table level 
        #}
         {% if (node.source_meta.faker_enabled == True and node.meta.faker_enabled != False) or node.meta.faker_enabled == True  %} 

          {# if the model has no columns then nothing to fake --> skip #}
          {% if node.columns != {} %}
          
            {% do configured_sources.append(
                        {
                            'unique_id': node['unique_id'],
                            'meta': node.meta,
                            'columns': node.columns
                        }
                    ) %}
                {% do log("dbt_faker appended to `configured_sources`: " ~ node['unique_id'], info=True) %}

        {% endif %}

        {% endif %}

    {% endfor %}


    {% do log("dbt_faker has some sources to fake!", info=True) %}
    {{ return(configured_sources) }}

{% endmacro %}
