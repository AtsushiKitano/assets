from google.cloud import bigquery_storage_v1

client = bigquery_storage_v1.BigQueryReadClient()

table = "projects/{}/datasets/{}/tables/{}".format(
    "bigquery-public-data", "usa_names", "usa_1910_current"
)

requested_session = bigquery_storage_v1.types.ReadSession()
requested_session.table = table
requested_session.data_format = bigquery_storage_v1.enums.DataFormat.AVRO

requested_session.read_options.selected_fields.append("name")
requested_session.read_options.selected_fields.append("number")
requested_session.read_options.selected_fields.append("state")
requested_session.read_options.row_restriction = 'state="WA"'

