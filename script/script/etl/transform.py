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
from script.etl.extract import *
from script.etl.load import *
import pandas as pd
from pyspark.sql.functions import to_timestamp
from pyspark.sql.functions import to_date
from pyspark.sql.functions import *
from script.helper.log_success import log_success
from script.helper.log_error import log_error

class Transform():
    def __init__(self):
        self.stg_people=extract_db_stg("people")
        self.stg_relationships=extract_db_stg("relationships")
        self.stg_acquisition=extract_db_stg("acquisition")
        self.stg_company=extract_db_stg("company")
        self.stg_fundse=extract_db_stg("funds")
        self.stg_investments=extract_db_stg("investments")
        self.stg_ipos=extract_db_stg("ipos")
        self.stg_funding_rounds=extract_db_stg("funding_rounds")
        
    def dim_term_code(self):
        step="Data Warehouse"
        process="Transform"
        try:
            self.dim_term_code=self.stg_acquisition.select(self.stg_acquisition['term_code']).distinct()
            log_success(step,process,"Acquisition","dim_term_code")
            return self.dim_term_code
        except Exception as e:
            log_error(step,process,"Acquisition","dim_term_code",str(e))

    def dim_stock_symbol(self):
        step="Data Warehouse"
        process="Transform"
        try:
            self.dim_stock_symbol=self.stg_ipos.select(self.stg_ipos['stock_symbol']).distinct()
            log_success(step,process,"Ipos","dim_stock_symbol")
            return self.dim_stock_symbol
        except Exception as e:
            log_error(step,process,"Ipos","dim_stock_symbol",str(e))
    
    def dim_company(self):
        step="Data Warehouse"
        process="Transform"
        try:
            RENAME_COLS = {"office_id": "company_nk_id"}
            self.dim_company = self.stg_company.withColumnsRenamed(colsMap = RENAME_COLS)
            columns_to_drop = ['created_at', 'updated_at']
            self.dim_company = self.dim_company.drop(*columns_to_drop)
            log_success(step,process,"Company","dim_company")
            return self.dim_company
        except Exception as e:
            log_error(step,process,"Company","dim_company",str(e))
    
    def dim_people(self):
        step="Data Warehouse"
        process="Transform"
        try:
            RENAME_COLS = {"people_id": "people_nk_id"}
            self.dim_people = self.stg_people.withColumnsRenamed(colsMap = RENAME_COLS)
            columns_to_drop = ['created_at', 'updated_at']
            self.dim_people = self.dim_people.drop(*columns_to_drop)
            self.dim_people=self.dim_people.withColumn("people_nk_id",dim_people ["people_nk_id"].cast("int"))
            log_success(step,process,"People","dim_people")
            return self.dim_people
        except Exception as e:
            log_error(step,process,"People","dim_people",str(e))


