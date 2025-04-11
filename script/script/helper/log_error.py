from datetime import datetime
from dotenv import load_dotenv
import pandas as pd
import os
from sqlalchemy import create_engine


load_dotenv()

def etl_log(log_msg: dict):
    """
    This function is used to save the log message to the database.
    """
    log_host="localhost"
    log_port=5432
    log_password="cobapassword"
    log_user = "postgres"
    log_database="etl_log"

    
    try:
        log_conn = f'postgresql://{log_user}:{log_password}@{log_host}:{log_port}/{log_database}'
        log_engine = create_engine(log_conn)
        
        # convert dictionary to dataframe
        df_log = pd.DataFrame([log_msg])

        #extract data log
        df_log.to_sql(name = "etl_log",  # Your log table
                        con = conn,
                        if_exists = "append",
                        index = False)
    except Exception as e:
        print("Can't save your log message. Cause: ", str(e))


def log_error(step,component, table_name, error_msg):
    log_msg = {
            "step" : step,
            "component" : component, 
            "status": "failed",
            "table_name": table_name,
            "etl_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),  # Current timestamp
            "error_msg": error_msg
        }
    etl_log(log_msg)





    

    
    

    