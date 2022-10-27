
def model(dbt, session):
    dbt.config(
        materialized = "table", 
    )


    df1 = session.create_dataframe([1, 2, 3, 4]).to_df("empanadas")


    return df