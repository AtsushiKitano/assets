from google.cloud import bigquery
import os

pj_name = os.environ["GCP_PROJECT"]
sql_file = "./files/github_sample.sql"
dataset_name = "github_source_data"
table_name = "git_sample"

table_id = pj_name + "." + dataset_name + "." + table_name

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(destination=table_id)

with open(sql_file) as f:
    sql = f.read()

job=client.query(sql,job_config=job_config,location="US")
job.result()



