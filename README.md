# dbt faker 
Generate fake/test/demo/sample data directly from dbt. dbt_faker is a python model generator for generating data within a [dbt](https://docs.getdbt.com/docs/introduction) project using the Python [Faker](https://faker.readthedocs.io/en/master/) project. 

![Welcome to the dbt faker project!](https://i.imgflip.com/4cfh9t.jpg)

## Install
Include in `packages.yml`:

```yaml
packages:
  - git: "https://github.com/dbt-labs/dbt_faker.git" # git URL
    revision: main 
```

### Requirements 
- dbt version >= 1.3

## How to use it 
### 1. Declare your sources.yml, including columns, and add the meta config `faker_enabled:true` 
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
        columns:
          - name: o_orderkey
            meta:
            faker_provider: pyint

          - name: o_order_date
            meta:
              faker_provider: date
```

### 2. Generate your python model by executing the command `dbt run-operation generate_faker_model`

### 3. Copy the output of your terminal and create a python model (e.g. dbt_faker.py) with the code generated from step #1

### 4. Execute your newly created python model `dbt run -m dbt_faker.py`

## FAQ

### `generate_faker_model` is skipping my sources   
    You should check that your sources have: 
        - Columns defined in the sources.yml
        - the meta field faker_enabled: true either at the source name level or source table name level
        - the meta field faker_enabled:false not defined at the source table level 

### `dbt run -m dbt_faker.py` gives me a warning that the selector haven't found the model
    You may not be running dbt 1.3, needed to be able to execute dbt python models
