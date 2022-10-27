import faker
import pandas


def model(dbt, session):
    dbt.config(
        materialized="table",
        packages=["faker"],
    )

    fake = faker.Faker()

    return pandas.DataFrame(
        [
            fake.first_name(),
            fake.first_name_female(),
            fake.name(),
        ],
        columns=['fake_name'],
    )
