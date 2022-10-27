
def model(dbt, session):
    dbt.config(
        materialized = "table", 
    )

    df = session.create_dataframe([1, 2, 3, 4]).to_df("something")
    df.write.mode("overwrite").save_as_table(dbt.this.database + '.' +  dbt.this.schema+ '.' + "hack_this_1", create_temp_table=False)
    df.write.mode("overwrite").save_as_table(dbt.this.database + '.' +  dbt.this.schema+ '.' + "hack_this_2", create_temp_table=False)
    df.write.mode("overwrite").save_as_table(dbt.this.database + '.' +  dbt.this.schema+ '.' + "hack_this_3", create_temp_table=False)


    return df
