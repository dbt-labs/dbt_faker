import faker
import pandas
import random


def model(dbt, session):
    dbt.config(
        materialized="table",
        packages=["faker"],
    )

    fake = faker.Faker()

    def create_rows(num=1):
        output = [{"N_NATIONKEY":fake.country(),
            "N_NAME":fake.country(),
            "N_REGIONKEY":fake.country(),
            "N_COMMENT":fake.paragraph(nb_sentences=5)}]
        return output
    return pandas.DataFrame(create_rows(5000))



