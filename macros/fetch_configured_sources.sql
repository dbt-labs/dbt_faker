{% macro fetch_configured_sources(sources=none) %}
	{{ return(adapter.dispatch("fetch_configured_sources", "dbt_meta_testing")( sources)) }}
{% endmacro %}

{% macro default__fetch_configured_sources( sources) %}
    
    {% set resource_type="source" %}
    {% set configured_sources = [] %}

    {{ dbt_meta_testing.logger("var `sources` is: " ~ sources) }}

    {% for node in graph.sources.values() | selectattr("resource_type", "equalto", resource_type) %}

        {# we could use this to point to all sources that would be fake-able #}
        {# {% if meta_config in node.config.keys() %} #}
            {% do configured_sources.append(node) %}

        {# {% endif %} #}

    {% endfor %}

    /* 
    If arg `sources` is provided, filter fetched sources to only those
    provided, either in space delimited string or via `dbt list -m <selection_syntax>`.

    See documentation here for more details: https://github.com/tnightengale/quality-assurance-dbt.
    */
    {% if sources is not none and resource_type == 'source' %}

        {% set filtered_sources_list = [] %}
        {% set final_sources_list = [] %}
        {% set sources_list = sources.split(" ") %}

        {{ dbt_meta_testing.logger("Building `filtered_sources_list`:") }}
        {% for m in sources_list %}

            /* 
            WE COULD USE THIS TO DELETE SOURCES.
            Assumes "." delimited string is output from `dbt list` and the last
            delimitee is the model name, eg. dbt_meta_testing.example.model_1
            */
            {# {% if "." in m %} {% set m = m.split(".")[-1] %} {% endif %} #}

            {% do filtered_sources_list.append(m) %}
            {{ dbt_meta_testing.logger("Appended to `filtered_sources_list`: " ~ m) }}

        {% endfor %}

        {{ dbt_meta_testing.logger("`filtered_sources_list` is: " ~ filtered_sources_list) }}
        {{ dbt_meta_testing.logger("`configured_sources` is: " ~ configured_sources) }}
        {% for m in configured_sources %}


            {{ dbt_meta_testing.logger("`filtered_sources_loop: " ~ loop.index ~ " " ~ m.name in filtered_sources_list)}}
            {% if m.unique_id in filtered_sources_list %}

                {% do final_sources_list.append(
                    {
                        'unique_id': m['unique_id'],
                        'columns': m.columns
                    }
                ) %}
                {{ dbt_meta_testing.logger("m is: " ~ m) }}
            
            {% endif %}

        {% endfor %}
    
    {% else %}

       /* {{ dbt_meta_testing.logger("else in fetch sources triggered, configured is: " ~ configured_sources) }} */
        {% set final_sources_list = configured_sources %}

    {% endif %}

    {{ dbt_meta_testing.logger("`final_sources_list` is: " ~ final_sources_list) }}
    {{ return(final_sources_list) }}

{% endmacro %}
