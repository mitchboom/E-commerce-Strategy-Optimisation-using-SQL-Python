import mysql.connector
import pandas as pd

# Load the cleaned CSV
dfSQL = pd.read_csv("data/gms_cleaned.csv")

# Ask user for credentials
user = input("Enter MySQL username: ")
password = input("Enter MySQL password: ")

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user=user,
    password=password
)
cursor = conn.cursor()

# Create the database if it doesn't exist
cursor.execute("CREATE DATABASE IF NOT EXISTS gms_project")
print("✅ Database 'gms_project' ensured.")

# Switch to that database
cursor.execute("USE gms_project")

# Drop the table if it already exists (optional)
cursor.execute("DROP TABLE IF EXISTS gms_sessions")

# Create the table
cursor.execute("""
CREATE TABLE gms_sessions (
    session_id VARCHAR(255) PRIMARY KEY,
    fullVisitorId VARCHAR(25),
    visitId VARCHAR(25),
    visitNumber INT,
    visitStartTime DATETIME,
    date DATE,
    channelGrouping VARCHAR(100),
    deviceCategory VARCHAR(50),
    continent VARCHAR(50),
    country VARCHAR(100),
    source VARCHAR(100),
    medium VARCHAR(100),
    visits INT,
    pageviews FLOAT,
    timeOnSite FLOAT,
    bounces FLOAT,
    transactions FLOAT,
    transactionRevenue FLOAT,
    newVisits FLOAT
)
""")
print("✅ Table 'gms_sessions' created.")

# Insert data row by row
for _, row in dfSQL.iterrows():
    cursor.execute("""
        INSERT INTO gms_sessions VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, tuple(row))

# Commit and close
conn.commit()
cursor.close()
conn.close()

print("✅ Data successfully loaded into MySQL!")
