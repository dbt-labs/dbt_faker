import faker
import pandas
import random


def create_rows(num=1, **kwargs):
    fake = faker.Faker()

    return [
        {
            key: getattr(fake, value)()
            for key, value in kwargs.items()
        } for x in range(num)
    ]


def model(dbt, session):
    dbt.config(
        materialized="table",
        packages=["faker"],
    )


    return pandas.DataFrame(
        create_rows(
            num=5000,
            N_NATIONKEY='country',
            R_REGIONKEY='country',
            R_NAME='name',
            R_COMMENT='paragraph',
        )
    )
