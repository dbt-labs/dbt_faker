# dbt faker 
This [dbt](https://docs.getdbt.com/docs/introduction) package contains macros to create a python model that will generate fake data to use as sources

![Welcome to the dbt faker project!](https://i.imgflip.com/4cfh9t.jpg)

## Install
Include in `packages.yml`:

```yaml
packages:
  - package: 
    version: 
```

### Requirements 
- dbt version >= 1.3

## How to use it 
### 1. Declare your sources.yml, including columns, and add the meta config `faker_enabled:true` 
```yaml
sources:
  - name: tpch
    description: Welcome to the dbt Labs demo dbt project! 
    meta:
      faker_enabled: true
  - name: fake_tpch
    tables:
      - name: orders
        description: main order tracking table

        meta:
          faker_enabled: false
        columns:
          - name: o_orderkey
            description: SF*1,500,000 are sparsely populated
            tests: 
              - unique
              - not_null

          - name: o_custkey
            description: Foreign Key to C_CUSTKEY
```

### 2. Generate your python model by executing the command `dbt run-operation generate_faker_model`

### 3. Copy the output of your terminal and create a python model with the code generate_faker_model

### 4. Add a macro in your project at `macro/dbt_faker_source_override.sql` that looks like this:

```
{% macro source(source_name, table_name) %}
{{ return(dbt_faker_source(source_name, table_name)) }}
{% endmacro %}
```

### 5. Execute your newly created python model `dbt run -m dbt_faker.py`

## FAQ

### `generate_faker_model` is skipping my sources   
    You should check that your sources have: 
        - Columns defined in the sources.yml
        - the meta field faker_enabled: true either at the source name level or source table name level
        - the meta field faker_enabled:false not defined at the source table level 

### `dbt run -m dbt_faker.py` gives me a warning that the selector haven't found the model
    You may not be running dbt 1.3, needed to be able to execute dbt python models
