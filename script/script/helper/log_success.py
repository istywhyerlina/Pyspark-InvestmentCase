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
    log_database = os.getenv("LOG_POSTGRES_DB")
    log_host = "localhost"
    log_user = os.getenv("LOG_POSTGRES_USER")
    log_password = os.getenv("LOG_POSTGRES_PASSWORD")
    log_port = os.getenv("LOG_POSTGRES_PORT")
    
    try:
        # create connection to database
        conn = create_engine(f"postgresql://{log_user}:{log_password}@{log_host}:{log_port}/{log_database}")
        
        # convert dictionary to dataframe
        df_log = pd.DataFrame([log_msg])

        #extract data log
        df_log.to_sql(name = "etl_log",  # Your log table
                        con = conn,
                        if_exists = "append",
                        index = False)
    except Exception as e:
        print("Can't save your log message. Cause: ", str(e))


def log_success(step,component, table_name):
    log_msg = {
            "step" : step,
            "component" : component, 
            "status": "success",
            "table_name": table_name,
            "etl_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),  # Current timestamp
        }
    etl_log(log_msg)




    

    
    

    