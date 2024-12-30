import sqlite3
import re

# Connect to the SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

cursor.execute("DROP TABLE if EXISTS hadith;")
conn.commit()

# Function to remove Arabic diacritics
def remove_diacritics(text):
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

# Create the hadith table if it doesn't exist
cursor.execute("""
CREATE TABLE IF NOT EXISTS hadith (
    id INTEGER,
    titleId INTEGER,
    contentId INTEGER,
    orderId INTEGER,
    count INTEGER,
    text TEXT,
    searchText TEXT
)
""")
conn.commit()

# Fetch all rows from the contents table
cursor.execute("SELECT id, titleId, text FROM contents")
rows = cursor.fetchall()

# Regular expression to identify Hadith starting lines
hadith_start_regex = re.compile(r"^\s*(\d+)\s*-\s*", re.MULTILINE)

# Process each row to extract Hadiths
for row in rows:
    content_id, title_id, text_content = row

    # Skip introduction titles
    if title_id < 7:
        continue

    # Find all Hadith start positions
    text_content = text_content.replace("–", "-")
    hadith_splits = hadith_start_regex.split(text_content)
    if len(hadith_splits) > 1:
        # Skip the first split, process subsequent Hadiths
        orderId = 0
        for i in range(1, len(hadith_splits), 2):
            orderId += 1

            # Extract the length of the Hadith in each title
            count = None
            # Only set count to first record in each title
            if i == 1:
                count = ((len(hadith_splits) + 1 )/2)-1

            hadith_text = hadith_splits[i + 1].strip()  # Hadith text

            hadith_id = int(hadith_splits[i])  # The number is the ID
            if hadith_text.startswith("باب"):
              hadith_id = None

            # Normalize the text for searching
            search_text = remove_diacritics(hadith_text)

            # Insert the Hadith into the hadith table
            cursor.execute("""
            INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (hadith_id, title_id, content_id, orderId, count, hadith_text, search_text))
        # Skip the first split, process subsequent Hadiths
        orderId = 0

# Commit the changes and close the connection
conn.commit()
conn.close()
