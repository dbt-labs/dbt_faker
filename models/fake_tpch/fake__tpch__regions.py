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
        output = [{
            "N_NATIONKEY":fake.country(),
            "R_REGIONKEY":fake.country(),
            "R_NAME":fake.country(),
            "R_COMMENT":fake.paragraph(nb_sentences=5) 
            } for x in range(num)]
        return output
    return pandas.DataFrame(create_rows(5000))

