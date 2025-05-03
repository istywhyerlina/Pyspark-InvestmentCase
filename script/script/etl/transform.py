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
        self.stg_funds=extract_db_stg("funds")
        self.stg_investments=extract_db_stg("investments")
        self.stg_ipos=extract_db_stg("ipos")
        self.stg_funding_rounds=extract_db_stg("funding_rounds")
        
    def dim_term_code(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for dim_term_code =====")
            self.dim_term_code=self.stg_acquisition.select(self.stg_acquisition['term_code']).distinct()
            log_success(step,process,"Acquisition","dim_term_code")
            print(f"===== Finish Tranformation for dim_term_code =====")
            return self.dim_term_code
        except Exception as e:
            print(f"===== Found Error during Tranformation for dim_term_code: =====\n {e}")
            log_error(step,process,"Acquisition","dim_term_code",str(e))

    def dim_stock_symbol(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for dim_stock_symbol =====")
            self.dim_stock_symbol=self.stg_ipos.select(self.stg_ipos['stock_symbol']).distinct()
            log_success(step,process,"Ipos","dim_stock_symbol")
            print(f"===== Finish Tranformation for dim_stock_symbol =====")
            return self.dim_stock_symbol
        except Exception as e:
            print(f"===== Found Error during Tranformation for dim_stock_symbol: =====\n {e}")
            log_error(step,process,"Ipos","dim_stock_symbol",str(e))
    
    def dim_company(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for dim_company =====")
            RENAME_COLS = {"office_id": "company_nk_id"}
            self.dim_company = self.stg_company.withColumnsRenamed(colsMap = RENAME_COLS)
            columns_to_drop = ['created_at', 'updated_at']
            self.dim_company = self.dim_company.drop(*columns_to_drop)
            log_success(step,process,"Company","dim_company")
            print(f"===== Finish Tranformation for dim_company =====")
            return self.dim_company
        except Exception as e:
            print(f"===== Found Error during Tranformation for dim_company: =====\n {e}")
            log_error(step,process,"Company","dim_company",str(e))
    
    def dim_people(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for dim_people =====")
            
            RENAME_COLS = {"people_id": "people_nk_id"}
            self.dim_people = self.stg_people.withColumnsRenamed(colsMap = RENAME_COLS)
            columns_to_drop = ['created_at', 'updated_at']
            self.dim_people = self.dim_people.drop(*columns_to_drop)
            self.dim_people=self.dim_people.withColumn("people_nk_id",self.dim_people ["people_nk_id"].cast("int"))
            log_success(step,process,"People","dim_people")
            print(f"===== Finish Tranformation for dim_people =====")
            
            return self.dim_people
        except Exception as e:
            print(f"===== Found Error during Tranformation for dim_people: =====\n {e}")
            
            log_error(step,process,"People","dim_people",str(e))

    def extract_dim(self):
        self.dim_time=extract_db_dwh("dim_time",step="Transform",process="Extract DWH for joining")
        self.dim_people=extract_db_dwh("dim_people",step="Transform",process="Extract DWH for joining")
        self.dim_company=extract_db_dwh("dim_company",step="Transform",process="Extract DWH for joining")
        self.dim_date=extract_db_dwh("dim_date",step="Transform",process="Extract DWH for joining")
        self.dim_term_code=extract_db_dwh("dim_term_code",step="Transform",process="Extract DWH for joining")
        self.dim_stock_symbol=extract_db_dwh("dim_stock_symbol",step="Transform",process="Extract DWH for joining")
        self.dim_date=self.dim_date.select(['date_id','date_actual'])
        self.dim_company=self.dim_company.select(['company_id','object_id'])
        self.dim_people=self.dim_people.select(['people_id','object_id'])
        return self.dim_time, self.dim_date, self.dim_people, self.dim_company, self.dim_term_code, self.dim_stock_symbol

    def fct_relationships(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for fct_relationships =====")
            
            self.extract_dim()
            self.relationships=self.stg_relationships.join(self.dim_date, self.stg_relationships.start_at == self.dim_date.date_actual, 'left')
            self.relationships = self.relationships.drop('created_at', 'updated_at','date_actual','start_at')
            RENAME_COLS = {
                            "date_id": "start_at"}
            self.relationships = self.relationships.withColumnsRenamed(colsMap = RENAME_COLS)
            self.relationships=self.relationships.join(self.dim_date, self.relationships.end_at == self.dim_date.date_actual, 'left')
            self.relationships = self.relationships.drop('date_actual','end_at')
            RENAME_COLS = {
                            "date_id": "end_at"}
            self.relationships = self.relationships.withColumnsRenamed(colsMap = RENAME_COLS)
            self.relationships=self.relationships.join(self.dim_company, self.relationships.relationship_object_id == self.dim_company.object_id, 'left')
            self.relationships = self.relationships.drop('relationship_object_id','object_id')
            RENAME_COLS = {
                            "company_id": "relationship_object_id"}
            self.relationships = self.relationships.withColumnsRenamed(colsMap = RENAME_COLS)
            self.relationships=self.relationships.join(self.dim_people, self.relationships.person_object_id == self.dim_people.object_id, 'left')
            self.relationships = self.relationships.drop('object_id','person_object_id')
            
            RENAME_COLS = {
                            "relationship_id": "relationship_nk_id"}
            self.relationships = self.relationships.withColumnsRenamed(colsMap = RENAME_COLS)
            self.relationships=self.relationships.withColumn("relationship_nk_id",self.relationships ["relationship_nk_id"].cast("int"))
            self.relationships=self.relationships.withColumn("is_past",when(self.relationships.is_past == "true", True)
                                               .when(self.relationships.is_past == "false", False))
            log_success(step,process,"stg_relationships","fct_relationships")
            print(f"===== Finish Tranformation for fct_relationships =====")
            
            return self.relationships
        except Exception as e:
            log_error(step,process,"stg_relationships","fct_relationships",str(e))

    
    def fct_funding_rounds(self):
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for fct_funding_rounds =====")
            
            self.extract_dim()
            self.funding_rounds=self.stg_funding_rounds.join(self.dim_date, self.stg_funding_rounds.funded_at == self.dim_date.date_actual, 'left')
            self.funding_rounds = self.funding_rounds.drop('created_at', 'updated_at','date_actual','funded_at')
            RENAME_COLS = {
                            "date_id": "funded_at"}
            self.funding_rounds = self.funding_rounds.withColumnsRenamed(colsMap = RENAME_COLS)
            self.funding_rounds=self.funding_rounds.join(self.dim_company, self.funding_rounds.object_id == self.dim_company.object_id, 'left')
            self.funding_rounds = self.funding_rounds.drop('object_id','object_id')
            RENAME_COLS = {
                            "company_id": "object_id","funding_round_id":"funding_round_nk_id" }
            self.funding_rounds = self.funding_rounds.withColumnsRenamed(colsMap = RENAME_COLS)
            self.funding_rounds=self.funding_rounds.withColumn("is_first_round",when(self.funding_rounds.is_first_round == "true", True)
                                               .when(self.funding_rounds.is_first_round == "false", False))
            
            log_success(step,process,"stg_funding_rounds","fct_funding_rounds")
            print(f"===== Finish Tranformation for fct_funding_rounds =====")
            
            return self.funding_rounds
        except Exception as e:
            log_error(step,process,"stg_funding_rounds","fct_funding_rounds",str(e))


    def fct_funds(self):
        self.extract_dim()
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for fct_funds =====")
            
            self.funds=self.stg_funds.join(self.dim_date, self.stg_funds.funded_at == self.dim_date.date_actual, 'left')
            columns_to_drop = ['created_at', 'updated_at','date_actual','funded_at']
            self.funds = self.funds.drop(*columns_to_drop)
            RENAME_COLS = {
                            "date_id": "funded_at", "fund_id":"fund_nk_id" }
            self.funds = self.funds.withColumnsRenamed(colsMap = RENAME_COLS)
            self.funds=self.funds.join(self.dim_company, self.funds.object_id == self.dim_company.object_id, 'left')
            columns_to_drop = ['object_id','object_id']
            self.funds = self.funds.drop(*columns_to_drop)
            RENAME_COLS = {
                            "company_id": "object_id" }
            self.funds = self.funds.withColumnsRenamed(colsMap = RENAME_COLS)
            log_success(step,process,"stg_funds","fct_funds")
            print(f"===== Finish Tranformation for fct_funds =====")
            
            return self.funds
        except Exception as e:
            log_error(step,process,"stg_funds","fct_funds",str(e))

    def fct_acquisition(self):
        self.extract_dim()
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for fct_acquisition =====")
            
            self.acquisition=self.stg_acquisition.join(self.dim_company, self.stg_acquisition.acquiring_object_id == self.dim_company.object_id, 'left')
            columns_to_drop = ['acquiring_object_id','object_id','created_at','updated_at']
            self.acquisition = self.acquisition.drop(*columns_to_drop)
            RENAME_COLS = {
                            "company_id": "acquiring_object_id","acquisition_id":"acquisition_nk_id" }
            self.acquisition = self.acquisition.withColumnsRenamed(colsMap = RENAME_COLS)
            self.acquisition=self.acquisition.join(self.dim_company, self.acquisition.acquired_object_id == self.dim_company.object_id, 'left')
            columns_to_drop = ['acquired_object_id','object_id']
            self.acquisition = self.acquisition.drop(*columns_to_drop)
            RENAME_COLS = {
                            "company_id": "acquired_object_id" }
            self.acquisition = self.acquisition.withColumnsRenamed(colsMap = RENAME_COLS)
            self.acquisition=self.acquisition.join(self.dim_term_code, self.acquisition.term_code == self.dim_term_code.term_code, 'left')
            columns_to_drop = ['term_code','term_code']
            self.acquisition = self.acquisition.drop(*columns_to_drop)
            self.acquisition=self.acquisition.withColumn('acquired_at', to_date( self.acquisition['acquired_at'], "yyyy-MM-dd"))
            self.acquisition=self.acquisition.join(self.dim_date, self.acquisition.acquired_at == self.dim_date.date_actual, 'left')
            columns_to_drop = ['date_actual','acquired_at']
            self.acquisition = self.acquisition.drop(*columns_to_drop)
            RENAME_COLS = {
                            "date_id": "acquired_at"}
            self.acquisition = self.acquisition.withColumnsRenamed(colsMap = RENAME_COLS)
            log_success(step,process,"stg_acquisition","fct_acquisition")
            print(f"===== Finish Tranformation for fct_acquisition =====")
            
            return self.acquisition
        except Exception as e:
            log_error(step,process,"stg_acquisition","fct_acquisition",str(e))

    def fct_ipos(self):
        self.extract_dim()
        step="Data Warehouse"
        process="Transform"
        try:
            print(f"===== Start Tranformation for fct_ipos =====")
            
            self.ipos=self.stg_ipos.join(self.dim_company, self.stg_ipos.object_id == self.dim_company.object_id, 'left')
            columns_to_drop = ['object_id','object_id','created_at','updated_at']
            self.ipos = self.ipos.drop(*columns_to_drop)
            RENAME_COLS = {
                            "company_id": "object_id", "ipo_id": "ipo_nk_id" }
            self.ipos = self.ipos.withColumnsRenamed(colsMap = RENAME_COLS)
            self.ipos=self.ipos.withColumn('public_at', to_date( self.ipos['public_at'], "yyyy-MM-dd"))
            self.ipos=self.ipos.join(self.dim_date, self.ipos.public_at == self.dim_date.date_actual, 'left')
            columns_to_drop = ['date_actual','public_at']
            self.ipos = self.ipos.drop(*columns_to_drop)
            RENAME_COLS = {
                            "date_id": "public_at"}
            self.ipos = self.ipos.withColumnsRenamed(colsMap = RENAME_COLS)
            self.ipos=self.ipos.join(self.dim_stock_symbol, self.ipos.stock_symbol == self.dim_stock_symbol.stock_symbol, 'left')
            columns_to_drop = ['stock_symbol','stock_symbol']
            self.ipos = self.ipos.drop(*columns_to_drop)
            RENAME_COLS = {
                            "stock_symbol_id": "stock_symbol"}
            self.ipos = self.ipos.withColumnsRenamed(colsMap = RENAME_COLS)
            
            log_success(step,process,"stg_ipos","fct_ipos")
            print(f"===== Finish Tranformation for fct_ipos =====")
            
            return self.ipos
        except Exception as e:
            log_error(step,process,"stg_ipos","fct_ipos",str(e))


    def fct_investments(self):
            self.extract_dim()
            step="Data Warehouse"
            process="Transform"
            try:
                print(f"===== Start Tranformation for fct_investments =====")
                
                fct_funding_rounds=extract_db_dwh("fct_funding_rounds",step="Transform",process="Extract DWH for joining")
                fct_funding_rounds=fct_funding_rounds.select(['funding_round_id','funding_round_nk_id'])
                RENAME_COLS = {
                                "funding_round_id": "id"}
                fct_funding_rounds = fct_funding_rounds.withColumnsRenamed(colsMap = RENAME_COLS)
                self.investments=self.stg_investments.join(self.dim_company, self.stg_investments.funded_object_id == self.dim_company.object_id, 'left')
                columns_to_drop = ['funded_object_id','object_id','created_at','updated_at']
                self.investments = self.investments.drop(*columns_to_drop)
                RENAME_COLS = {
                                "company_id": "funded_object_id", "investment_id": "investment_nk_id" }
                self.investments = self.investments.withColumnsRenamed(colsMap = RENAME_COLS)
                self.investments=self.investments.join(self.dim_company, self.investments.investor_object_id == self.dim_company.object_id, 'left')
                columns_to_drop = ['investor_object_id','object_id']
                self.investments = self.investments.drop(*columns_to_drop)
                RENAME_COLS = {
                                "company_id": "investor_object_id"}
                self.investments = self.investments.withColumnsRenamed(colsMap = RENAME_COLS)
                self.investments=self.investments.join(fct_funding_rounds, self.investments.funding_round_id == fct_funding_rounds.funding_round_nk_id, 'left')
                columns_to_drop = ['funding_round_nk_id','funding_round_id']
                self.investments = self.investments.drop(*columns_to_drop)
                RENAME_COLS = {
                                "id": "funding_round_id"}
                self.investments = self.investments.withColumnsRenamed(colsMap = RENAME_COLS)
                log_success(step,process,"stg_investments","fct_investments")
                print(f"===== Finish Tranformation for fct_investments =====")
        
                return self.investments
            except Exception as e:
                log_error(step,process,"stg_investments","fct_investments",str(e))


        


