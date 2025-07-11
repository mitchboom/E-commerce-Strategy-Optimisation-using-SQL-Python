## ======================================================|
## FIRST FOLLOW THE INSTRUCTIONS GIVEN IN README.md      |
## ======================================================|
import os
from google.cloud import bigquery
from google.oauth2 import service_account
import pandas as pd

# Path to your credentials file
key_path = "credentials/gcp_bigquery_key.json"

# Authenticate and connect to BigQuery
credentials = service_account.Credentials.from_service_account_file(key_path)
client = bigquery.Client(credentials=credentials, project=credentials.project_id)

# Define SQL query (Oct to Dec 2016)
query = """
SELECT
  fullVisitorId,
  visitId,
  visitNumber,
  visitStartTime,
  date,
  totals.visits,
  totals.pageviews,
  totals.timeOnSite,
  totals.bounces,
  totals.transactions,
  totals.transactionRevenue,
  totals.newVisits,
  channelGrouping,
  device.deviceCategory,
  geoNetwork.continent,
  geoNetwork.country,
  geoNetwork.region,
  trafficSource.source,
  trafficSource.medium
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20161001' AND '20161231' AND geoNetwork.country = 'United States'
"""

# Run query and convert to DataFrame
df = client.query(query).to_dataframe()
print(f"✅ Query successful — {len(df)} rows retrieved.")

# Save result to CSV
output_path = "data/gms_oct_dec_2016.csv"
os.makedirs("data", exist_ok=True)  # ✅ Creates folder if it doesn't exist
df.to_csv(output_path, index=False)
print(f"✅ CSV saved to {output_path}")