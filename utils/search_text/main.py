import sqlite3
import re

# Function to remove Arabic diacritics
def remove_diacritics(text):
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

# Connect to the database
conn = sqlite3.connect('book.db')

# Register the function
conn.create_function("REMOVE_DIACRITICS", 1, remove_diacritics)

# Update the search_text column
cursor = conn.cursor()
cursor.execute("""
    UPDATE titles
    SET search_text = REMOVE_DIACRITICS(name)
""")
cursor.execute("""
    UPDATE contents
    SET search_text = REMOVE_DIACRITICS(text)
""")
conn.commit()
conn.close()