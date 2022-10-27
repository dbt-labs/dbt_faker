import faker
import pandas




# File name needs to match the schema "fake__order_items.py" <-- queries get routed

def model(dbt, session):  # <--- THIS IS ACTUALLY A SOURCE. BLACK MAGIC MAKE THIS THE SOURCE
    dbt.config(
        materialized="table",
        packages=["faker"],
    )

    fake = faker.Faker()

    # I want this model to generate 3 fake order line items

    return pandas.DataFrame({
        'ORDER_ITEM_ID': [0, 1, 2, 3],          # increasing sequence
        'ORDER_ID': [0, 1, 2, 2], 
        'ITEM_ID': [0, 1, 2, 0],     # random items :shrug:
    })


    # return pandas.DataFrame(
    #     [
    #         fake.first_name(),
    #         fake.first_name_female(),
    #         fake.name(),
    #     ],
    #     columns=['fake_name'],
    # )
