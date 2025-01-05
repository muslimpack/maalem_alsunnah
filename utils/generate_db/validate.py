import sqlite3
import re

# Define the database name
db_name = 'book.db'

# Connect to the database
conn = sqlite3.connect(db_name)
cursor = conn.cursor()

# Groups of characters to check
opening_group = ['[', '(', '«', '﴾']
closing_group = [']', ')', '»', '﴿']

# Query to fetch all text from the `text` column
cursor.execute("SELECT id, text FROM contents")
contentsRows = cursor.fetchall()

invalid_ids = []
# Extract and store unique special characters
for row in contentsRows:
    if row[0]:  # Ensure the text column is not None
        content_id, text = row

        # Count occurrences of each character in both groups
        opening_counts = {char: text.count(char) for char in opening_group}
        closing_counts = {char: text.count(char) for char in closing_group}

        # Check if the sum of counts for both groups matches
        if sum(opening_counts.values()) != sum(closing_counts.values()):
            invalid_ids.append(content_id)

print("Invalid content count: ", len(invalid_ids))
for id in invalid_ids:
    print(f"Invalid content ID: {id}")


print("\n---------------------------")
print("\n---------------------------\n")

# Query to fetch all text from the `text` column
cursor.execute("SELECT id, text FROM hadith")
hadithRows = cursor.fetchall()

hadith_invalid_ids = []
# Extract and store unique special characters
for row in hadithRows:
    if row[0]:  # Ensure the text column is not None
        content_id, text = row

        # Count occurrences of each character in both groups
        opening_counts = {char: text.count(char) for char in opening_group}
        closing_counts = {char: text.count(char) for char in closing_group}

        # Check if the sum of counts for both groups matches
        if sum(opening_counts.values()) != sum(closing_counts.values()):
            hadith_invalid_ids.append(content_id)


print("Invalid hadith count: ", len(hadith_invalid_ids))
for id in hadith_invalid_ids:
    print(f"Invalid hadith ID: {id}")

# Close the database connection
conn.close()
