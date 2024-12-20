import sqlite3
from bs4 import BeautifulSoup

# Connect to SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

# Function to extract plain text from HTML
def extract_plain_text(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    return soup.get_text()

# Fetch all rows with HTML content
cursor.execute("SELECT id, text FROM contents")
rows = cursor.fetchall()

# Update shareable_text with plain text
for row in rows:
    record_id, html_content = row
    plain_text = extract_plain_text(html_content)
    cursor.execute("""
        UPDATE contents
        SET shareable_text = ?
        WHERE id = ?
    """, (plain_text, record_id))

# Commit changes and close connection
conn.commit()
conn.close()
