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
from script.etl.transform import Transform
import pandas as pd
from pyspark.sql.functions import to_timestamp
from pyspark.sql.functions import to_date
from pyspark.sql.functions import *

#Extract from Data Source
people=extract_csv('../data/people.csv')
relationships=extract_csv('../data/relationships.csv')
table_names=["acquisition","company","funds","investments","ipos","funding_rounds"]
for name in table_names:
    globals()[f'{name}']=extract_db_src(name)

#Transform adn Load to Data Staging
step="Data Staging"
process="Load"
load_stg(people,"people")


relationships=relationships.withColumn("start_at",to_date( relationships['start_at'], "yyyy-mm-dd")) 
relationships=relationships.withColumn("end_at",to_date( relationships['end_at'], "yyyy-mm-dd")) 
relationships=relationships.withColumn("created_at",to_timestamp( relationships['created_at'], "yyyy-mm-dd HH:mm:ss")) 
relationships=relationships.withColumn("updated_at",to_timestamp( relationships['updated_at'], "yyyy-mm-dd HH:mm:ss")) 
load_stg(relationships,"relationships")
table_names=["acquisition","company","funds","investments","ipos","funding_rounds"]
for name in table_names:
    load_stg(globals()[f'{name}'],name)

#Extract from Data Staging
table_names=["people","relationships","acquisition","company","funds","investments","ipos","funding_rounds"]
for name in table_names:
    globals()[f'stg_{name}']=extract_db_stg(name)

#Transform and Load to DWH
trans=Transform()
dim_term_code=trans.dim_term_code()
load_dwh(dim_term_code,"dim_term_code")
dim_stock_symbol=trans.dim_stock_symbol()
load_dwh(dim_stock_symbol,"dim_stock_symbol")
dim_company=trans.dim_company()
load_dwh(dim_company,"dim_company")
dim_people=trans.dim_people()
load_dwh(dim_people,"dim_people")

fct_relationships=trans.fct_relationships()
load_dwh(fct_relationships,"fct_person_relationship")
fct_funding_rounds=trans.fct_funding_rounds()
load_dwh(fct_funding_rounds,"fct_funding_rounds")
fct_funds=trans.fct_funds()
load_dwh(fct_funds,"fct_funds")
fct_acquisition=trans.fct_acquisition()
load_dwh(fct_acquisition,"fct_acquisition")
fct_ipos=trans.fct_ipos()
load_dwh(fct_ipos,"fct_ipos")
fct_investments=trans.fct_investments()
load_dwh(fct_investments,"fct_investments")





