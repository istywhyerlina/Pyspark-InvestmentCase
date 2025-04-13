import pyspark
from importlib import reload

from pyspark.sql import SparkSession
import os
import pandas as pd
import sys
sys.path.insert(0, '/home/jovyan/work')
from script.helper.db_conn import db_connection
from datetime import datetime
from datetime import timezone

from script.helper.conn_prop import connection_properties
from script.helper.init_spark import initiate_spark
import logging
import pandas as pd

def etl_log(log_msg: dict):
    """
    This function is used to save the log message to the database.
    """


    try:
        # create connection to database
        spark = initiate_spark()
        _,_,_,log_url = db_connection()
        _,_,_,cp_log=connection_properties()
        
        # convert dictionary to dataframe
        df_log = pd.DataFrame([log_msg])
        df_log=spark.createDataFrame(data=df_log)

        #extract data log
        df_log.write.jdbc(url=log_url,table="etl_log",mode="append",properties=cp_log)

    except Exception as e:
        print("Can't save your log message. Cause: ", str(e))


def log_success(step,process, source, table_name):
    log_msg = {
        "step" : step,
        "process" : process, 
        "status" : "success", 
        "source": source,
        "table_name": table_name,
        "etl_date": datetime.now(timezone.utc).astimezone()  # Current timestamp
        }
    etl_log(log_msg)








    

    
    

    