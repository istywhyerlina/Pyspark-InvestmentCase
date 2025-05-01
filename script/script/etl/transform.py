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

class Transform():
    def __init__:
        self.stg_people=extract_db_stg("people")
        self.stg_relationships=extract_db_stg("relationships")
        self.stg_acquisition=extract_db_stg("acquisition")
        self.stg_company=extract_db_stg("company")
        self.stg_fundse=extract_db_stg("funds")
        self.stg_investments=extract_db_stg("investments")
        self.stg_ipos=extract_db_stg("ipos")
        self.stg_funding_rounds=extract_db_stg("funding_rounds")
        
    def dim_table():
        self.dim_term_code=self.stg_acquisition.select(self.stg_acquisition['term_code']).distinct()
        self.stock_symbol=self.stg_ipos.select(self.stg_ipos['stock_symbol']).distinct()

