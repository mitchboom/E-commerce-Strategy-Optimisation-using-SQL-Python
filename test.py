import pandas as pd
import matplotlib.pyplot as plt

# Load the dataset
df = pd.read_csv("data/gms_oct_dec_2016.csv")

# Filter rows where 'source' contains 'youtube' (case-insensitive)
youtube_df = df[df['source'].str.contains('youtube', case=False, na=False)]

# Keep only rows where 'transactions' is not null
youtube_transactions = youtube_df[youtube_df['transactions'].notnull()]

print("YouTube Traffic - Transaction Statistics")
print(f"Number of sessions with transactions: {len(youtube_transactions)}\n")

# Summary stats
print("Summary statistics for 'transactions':")
print(youtube_transactions['transactions'].describe())

# Optional: Also look at transactionRevenue
print("\nSummary statistics for 'transactionRevenue':")
print(youtube_transactions['transactionRevenue'].describe())

