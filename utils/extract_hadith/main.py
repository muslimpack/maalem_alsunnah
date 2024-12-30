import sqlite3
import re

# Connect to the SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

# Create the hadith table if it doesn't exist
cursor.execute("""
CREATE TABLE IF NOT EXISTS hadith (
    id INTEGER,
    titleId INTEGER,
    html TEXT,
    text TEXT,
    searchText TEXT
)
""")
conn.commit()

cursor.execute("Delete from hadith")
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
    hadith_splits = hadith_start_regex.split(text_content)
    if len(hadith_splits) > 1:
        # Skip the first split, process subsequent Hadiths
        for i in range(1, len(hadith_splits), 2):
            hadith_id = int(hadith_splits[i])  # The number is the ID
            hadith_text = hadith_splits[i + 1].strip()  # Hadith text

            # Normalize the text for searching
            search_text = ' '.join(hadith_text.split())

            # Insert the Hadith into the hadith table
            cursor.execute("""
            INSERT INTO hadith (id, titleId, html, text, searchText)
            VALUES (?, ?, ?, ?, ?)
            """, (hadith_id, title_id, None, hadith_text, search_text))

# Commit the changes and close the connection
conn.commit()
conn.close()
