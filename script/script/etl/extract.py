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
from script.helper.log_success import log_success
from script.helper.log_error import log_error
import pandas as pd



# Inisialisasi SparkSession
spark = initiate_spark()

# handle legacy time parser
spark.conf.set("spark.sql.legacy.timeParserPolicy", "LEGACY")



def extract_csv(filename,step="Data Source",process="Extract",spark=spark):
    try: 
        print(f"===== Start Extracting {filename} data =====")
        source=filename.split('/')[-1]
        table_name=source.split('.')[0]
        
        df=spark.read.csv(filename,header=True)
        log_success(step,process,source,table_name)
        
        print(f"===== Success Extracting {filename} data =====")
        return df
    except Exception as e:
        source=filename.split('/')[-1]
        table_name=source.split('.')[0]
        log_error(step,process,source,table_name,str(e))
        print(f"====== Failed to Extract Data {filename} ======,\n {e}")



def extract_db_src(table_name,step="Data Source",process="Extract",spark=spark):
    try:
        print(f"===== Start Extracting {table_name} data =====")
        cp_src,_,_,_=connection_properties()
        src_url,_,_,_ = db_connection()
        df_metadata=spark.read.jdbc(src_url, table=table_name, properties=cp_src)
        log_success(step,process,table_name,table_name)
        print(f"===== Success Extracting {table_name} data =====")
        return df_metadata
    except Exception as e:
        print(f"====== Failed to Extract Data {table_name} ======,\n {e}")
        log_error(step,process,table_name,table_name,str(e))




def extract_db_stg(table_name,step="Data Staging",process="Extract",spark=spark):
    try:
        print(f"===== Start Extracting {table_name} data =====")
        _,cp_stg,_,_=connection_properties()
        _,stg_url,_,_ = db_connection()
        df_metadata=spark.read.jdbc(stg_url, table=table_name, properties=cp_stg)
        log_success(step,process,table_name,table_name)
        print(f"===== Success Extracting {table_name} data =====")
        return df_metadata
    except Exception as e:
        print(f"====== Failed to Extract Data {table_name} ======,\n {e}")
        log_error(step,process,table_name,table_name,str(e))



def extract_db_dwh(table_name,step="Data Warehouse",process="Extract",spark=spark):
    try:
        print(f"===== Start Extracting {table_name} data =====")
        _,_,cp_dwh,_=connection_properties()
        _,_,dwh_url,_ = db_connection()
        df_metadata=spark.read.jdbc(dwh_url, table=table_name, properties=cp_dwh)
        log_success(step,process,table_name,table_name)
        print(f"===== Success Extracting {table_name} data =====")
        return df_metadata
    except Exception as e:
        print(f"====== Failed to Extract Data {table_name} ======,\n {e}")
        log_error(step,process,table_name,table_name,str(e))
