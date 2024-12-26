import sqlite3
import html2text
import re
from tqdm import tqdm  # For progress bar

# Function to remove Arabic diacritics
def remove_diacritics(text):
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

# Function to render HTML as plain text and remove unwanted lines
def render_html_as_text(html_content):
    # Convert HTML to text
    text = html_converter.handle(html_content).strip()
    # Replace "\-" with a new line
    text = text.replace("\\-", " -")
    # Replace multiple new lines with a new line
    text = re.sub(r'^\s*\n', '\n', text, flags=re.MULTILINE)
    # Remove the specific unwanted line
    unwanted_line = "الغاء التفضيلتفضيلاضف ملاحظاتكالحواشيشرح الحديثمشاركة"
    return "\n".join(line for line in text.splitlines() if line.strip() != unwanted_line)

# Connect to SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

# Initialize html2text converter
html_converter = html2text.HTML2Text()
html_converter.ignore_links = True  # Ignore links in the HTML
html_converter.ignore_images = True  # Ignore images in the HTML
html_converter.body_width = 0  # Prevent word wrapping for cleaner output
html_converter.ignore_emphasis = True  # Ignore formatting like bold, italic, etc.

# Phase 1: Convert HTML to plain text
print("Phase 1: Converting HTML to plain text...")
cursor.execute("SELECT id, html FROM contents")
rows = cursor.fetchall()

for row in tqdm(rows, desc="Processing HTML", unit="row"):
    record_id, html_content = row
    rendered_text = render_html_as_text(html_content)
    cursor.execute("""
        UPDATE contents
        SET text = ?
        WHERE id = ?
    """, (rendered_text, record_id))

conn.commit()

# Phase 2: Remove diacritics
print("Phase 2: Removing diacritics...")
conn.create_function("REMOVE_DIACRITICS", 1, remove_diacritics)

# Update titles table
cursor.execute("SELECT COUNT(*) FROM titles")
title_count = cursor.fetchone()[0]
cursor.execute("SELECT COUNT(*) FROM contents")
content_count = cursor.fetchone()[0]

print("Processing titles...")
cursor.execute("SELECT id, name FROM titles")
titles = cursor.fetchall()
for row in tqdm(titles, desc="Processing Titles", unit="row", total=title_count):
    record_id, name = row
    processed_name = remove_diacritics(name)
    cursor.execute("""
        UPDATE titles
        SET searchText = ?
        WHERE id = ?
    """, (processed_name, record_id))

print("Processing contents...")
cursor.execute("SELECT id, text FROM contents")
contents = cursor.fetchall()
for row in tqdm(contents, desc="Processing Contents", unit="row", total=content_count):
    record_id, text = row
    processed_text = remove_diacritics(text)
    cursor.execute("""
        UPDATE contents
        SET searchText = ?
        WHERE id = ?
    """, (processed_text, record_id))

# Commit changes and close connection
conn.commit()
conn.close()

print("Processing complete!")
