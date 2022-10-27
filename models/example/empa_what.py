import faker
import pandas


def create_rows(table_name, num=1, **kwargs):
    fake = faker.Faker()

    df = pandas.DataFrame([
        {
            key: getattr(fake, value)()
            for key, value in kwargs.items()
        } for x in range(num)
    ])

    df.write.mode("overwrite").save_as_table(
        dbt.this.database + '.' + dbt.this.schema + '.' + table_name,
        create_temp_table=False,
    )



def model(dbt, session):
    dbt.config(
        materialized="table", 
        packages=["faker", "pandas"],
    )

    create_rows(
        table_name='regions',
        num=5000,
        N_NATIONKEY='country',
        R_REGIONKEY='country',
        R_NAME='name',
        R_COMMENT='paragraph',
    )

    create_rows(
        table_name='customers',
        num=5000,
        C_CUSTKEY='pyint',
        C_NAME='name',
        C_ADDRESS='address',
        C_NATIONKEY='pyint',
        C_PHONE='phone_number',
        C_ACCTBAL='pyint',
        C_MKTSEGMENT='pystr',
        C_COMMENT='paragraph',
    )

    create_rows(
        table_name='nations',
        num=5000,
        N_NAME='country',
        N_REGIONKEY='country',
        N_COMMENT='paragraph',
    )

    df = session.create_dataframe(['yes']).to_df("are_we_faking")

    return df
