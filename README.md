# dbt faker 
Generate fake/test/demo/sample data directly from dbt. dbt_faker is a python model generator for generating data within a [dbt](https://docs.getdbt.com/docs/introduction) project using the Python [Faker](https://faker.readthedocs.io/en/master/) project. 

![Welcome to the dbt faker project!](https://i.imgflip.com/4cfh9t.jpg)

## Install
Include in `packages.yml`:

```yaml
packages:
  - git: "https://github.com/dbt-labs/dbt_faker.git"
    revision: main 
```

### Requirements 
- dbt version >= 1.3

## How to use it 
### 1. Add a source override macro in your project 
Create the file `macro/dbt_faker_source_override.sql` that looks like this:
```
{% macro source(source_name, table_name) %}
{{ return(dbt_faker.dbt_faker_source(source_name, table_name)) }}
{% endmacro %}
```
Activate the faker_enabled variable in your project.yml 
```
vars: 
  faker_enabled: true
```
### 2. Declare your sources.yml
including columns and [faker_providers](#providers), and add the meta config `faker_enabled:true` 

```yaml
sources:
  - name: tpch
    meta:
      faker_enabled: true
  - name: fake_tpch
    tables:
      - name: orders
        meta:
          faker_enabled: true
          faker_rows: 250
        columns:
          - name: o_orderkey
            meta:
            faker_provider: pyint

          - name: o_order_date
            meta:
              faker_provider: date
```


### 3. Generate your python model 
Execute the command `dbt run-operation generate_faker_model`

### 4. Copy the output of your terminal and create a python model 
Create a file (e.g. dbt_faker.py) with the code generated from step #2

### 5. Execute your newly created python model
For example `dbt run -m dbt_faker.py`. This will create a table called fake__source_table for each source you have defined as fake-able

### 6. Use your fake data! 
Run the models depending on the fake sources and be amazed 

## Providers
dbt_faker relies on [Faker's](https://faker.readthedocs.io/en/master/) robust data providers. In order to use them, simply include the name of the provider in the `faker_provider` meta tag. A full list of providers is [here]([url](https://faker.readthedocs.io/en/master/providers.html)). Some examples you can use:

- [faker_provider.address](https://faker.readthedocs.io/en/master/providers/faker.providers.address.html) (48764 Howard Forge Apt. 421 Vanessaside, PA 19763)
- [faker_provider.name](https://faker.readthedocs.io/en/master/providers/faker.providers.person.html) ( Diego Maradona)
- [faker_provider.pyint](https://faker.readthedocs.io/en/master/providers/faker.providers.python.html) (1234)



## FAQ

### `generate_faker_model` is skipping my sources   
    You should check that your sources have: 
        - Columns defined in the sources.yml
        - the meta field faker_enabled: true either at the source name level or source table name level
        - the meta field faker_enabled:false not defined at the source table level 

### `dbt run -m dbt_faker.py` gives me a warning that the selector haven't found the model
    You may not be running dbt 1.3, needed to be able to execute dbt python models
