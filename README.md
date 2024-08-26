# Project Name: Startup Investment Pipeline
#

## Installation
1. Clone the repository: `git clone https://github.com/Kurikulum-Sekolah-Pacmann/project_data_pipeline.git`
  - Build: docker compose up --build --detach
  - Copy Driver: docker cp driver/postgresql-42.6.0.jar pyspark_project_container:/usr/local/spark/jars/postgresql-42.6.0.jar
2. Data from  **Startup CSV**: access directory /script/data

## Usage
1. Access the terminal of the container: `docker exec -it pyspark_container2 /bin/bash `
2. Navigate to the project directory: `/home/jovyan/work`
3. Run the pipeline script:
   - if you use pandas: `pyton your_script.py`
    - if you use pyspark `spark-submit your_script.py`

alternative:
1. Access the Jupyter Notebook server at:: [localhost:8888](http://localhost:8888/) (if you use pyspark)
2. Run your_notebook.ipynb
