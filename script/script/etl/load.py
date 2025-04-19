import pyspark
from importlib import reload
import pyspark
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
from script.helper.log_success import log_success
from script.helper.log_error import log_error
from script.etl.extract import *
import pandas as pd


# Inisialisasi SparkSession
spark = initiate_spark()

# handle legacy time parser
spark.conf.set("spark.sql.legacy.timeParserPolicy", "LEGACY")

def load_stg(data,table_name:str,step="Data Staging",process="Load",spark=spark,source=""):
    try:

        print(f"===== Get only new data =====")
        primary_key={"people":"people_id",'relationships':'relationship_id','acquisition':'acquisition_id','company':'office_id','funds':'fund_id','investments':'investment_id','ipos':'ipo_id','funding_rounds':'funding_round_id'}
        process="Check New Data"
        data_in_stg=extract_db_stg(table_name,step,process)
        #data_in_stg.show()
        #data.show()
        
        new_data=data.join(data_in_stg, primary_key[table_name],"leftanti")
        
        
        #new_data.show()
        
        print(f"===== Already got only New Data  =====")

        print(f"===== Start Loading {table_name} new data =====")
        _,cp_stg,_,_=connection_properties()
        _,stg_url,_,_ = db_connection()
        
        new_data.write.jdbc(url=stg_url,table=table_name,mode="append",properties=cp_stg)
        process="Load"
        log_success(step,process,source,table_name)
        print(f"===== Success Loading {table_name} new data =====")
    except Exception as e:
        print(f"====== Failed to Load Data {table_name} ====== \n {e}")
        log_error(step,process,source,table_name,str(e))


def load_dwh(data,table_name:str,step="Data Warehouse",process="Load",spark=spark,source=""):
    try:
        _,_,cp_stg,_=connection_properties()
        _,_,stg_url,_= db_connection()

        # Truncate the target table (ensure data integrity by removing old records before loading new data)
        truncate_sql = f"TRUNCATE TABLE {table_name} CASCADE"
        pyspark.pandas.read_sql(truncate_sql,stg_url)
        # Use the jdbc connection to execute the SQL truncate statement
        truncate_df = pyspark.sql.SparkSession.builder.getOrCreate().read \
            .format("jdbc") \
            .option("url", stg_url) \
            .option("dbtable", f"({truncate_sql}) AS trunc_query") \
            .option("user", "postgres") \
            .option("password", "cobapassword") \
            .load()

        log_success(f"===== Truncated table {table_name} successfully =====")      

        print(f"===== Start Loading {table_name} new data =====")
 
        
        new_data.write.jdbc(url=stg_url,table=table_name,mode="append",properties=cp_stg)
        process="Load"
        log_success(step,process,source,table_name)
        print(f"===== Success Loading {table_name} new data =====")
    except Exception as e:
        print(f"====== Failed to Load Data {table_name} ====== \n {e}")
        log_error(step,process,source,table_name,str(e))


