import faker
import pandas


def model(dbt, session):
    dbt.config(
        materialized="table",
        packages=["faker"],
    )

    fake = faker.Faker()

    # I want this model to generate 4 fake customers

    return pandas.DataFrame({
        'C_CUSTKEY': [fake.pyint(), fake.pyint(), fake.pyint(), fake.pyint()],          # increasing sequence
        'C_NAME': [fake.name(), fake.name(), fake.name(), fake.name()], 
        'C_ADDRESS': [fake.address(), fake.address(), fake.address(), fake.address()],     # random items :shrug:
        'C_NATIONKEY': [0, 1, 2, 0],     # random items :shrug:
        'C_PHONE': [fake.phone_number(), fake.phone_number(), fake.phone_number(), fake.phone_number()],     # random items :shrug:
        'C_ACCTBAL': [0, 1, 2, 0],
        'C_MKTSEGMENT': ['', '', '', ''],
        'C_COMMENT': [0, 1, 2, 0],     # random items :shrug:
    })


        # c_custkey as customer_key,
        # c_name as name,
        # c_address as address, 
        # c_nationkey as nation_key,
        # c_phone as phone_number,
        # c_acctbal as account_balance,
        # c_mktsegment as market_segment,
        # c_comment as comment


    # return pandas.DataFrame(
    #     [
    #         fake.first_name(),
    #         fake.first_name_female(),
    #         fake.name(),
    #     ],
    #     columns=['fake_name'],
    # )
