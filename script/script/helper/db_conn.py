from pyspark.sql import SparkSession
import logging

src_container = "source_startup_container"
src_database = "startup_investments"
src_host = "localhost"
src_user = "postgres"
src_password = "cobapassword"
src_container_port = 5432

stg_container = "target_db_container"
stg_database = "staging"
stg_host = "localhost"
stg_user = "postgres"
stg_password = "cobapassword"
stg_container_port = 5432


dwh_container = "target_db_container"
dwh_database = "warehouse"
dwh_host = "localhost"
dwh_user = "postgres"
dwh_password = "cobapassword"
dwh_container_port = 5432

log_container = "target_db_container"
log_database = "etl_log"
log_host = "localhost"
log_user = "postgres"
log_password = "cobapassword"
log_container_port = 5432


def logging_process():
    # Configure logging
    logging.basicConfig(
        filename="/home/jovyan/work/log/info.log",
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
    )

def db_connection():     
        #src_conn = f'postgresql://{src_user}:{src_password}@{src_host}:{src_port}/{src_database}'
        src_url = f'jdbc:postgresql://{src_container}:{src_container_port}/{src_database}'
        stg_url = f'jdbc:postgresql://{stg_container}:{stg_container_port}/{stg_database}'
        dwh_url = f'jdbc:postgresql://{dwh_container}:{dwh_container_port}/{dwh_database}'
        log_url = f'jdbc:postgresql://{log_container}:{log_container_port}/{log_database}'

        return src_url, stg_url, dwh_url, log_url


def connection_properties():
    cp_src={"user":src_user,"password":src_password,"driver":"org.postgresql.Driver"}
    cp_stg={"user":stg_user,"password":stg_password,"driver":"org.postgresql.Driver"}
    cp_dwh={"user":dwh_user,"password":dwh_password,"driver":"org.postgresql.Driver"}
    cp_log={"user":log_user,"password":log_password,"driver":"org.postgresql.Driver"}
    return cp_src,cp_stg,cp_dwh, cp_log