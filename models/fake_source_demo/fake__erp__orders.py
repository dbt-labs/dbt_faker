import faker
import pandas




# File name needs to match the schema "fake__order_items.py" <-- queries get routed

def model(dbt, session):  # <--- THIS IS ACTUALLY A SOURCE. BLACK MAGIC MAKE THIS THE SOURCE
    dbt.config(
        materialized="table",
        packages=["faker"],
    )

    fake = faker.Faker()

    # I want this model to generate 3 fake orders

    return pandas.DataFrame({
        'ORDER_ID': [0, 1, 2], 
        'ORDERED_AT': ['2022-01-01T00:00:00', '2022-01-01T01:00:00', '2022-01-01T02:00:00'],   # datetime between two dates
        'CUSTOMER_ID': [0, 1, 2]  # random IDs
    })
