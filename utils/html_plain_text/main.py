import sqlite3
import html2text

# Connect to SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

# Initialize html2text converter
html_converter = html2text.HTML2Text()
html_converter.ignore_links = True  # Ignore links in the HTML
html_converter.ignore_images = True  # Ignore images in the HTML
html_converter.body_width = 0  # Prevent word wrapping for cleaner output
html_converter.ignore_emphasis = True  # Ignore formatting like bold, italic, etc.

# Function to render HTML as plain text and remove unwanted lines
def render_html_as_text(html_content):
    # Convert HTML to text
    text = html_converter.handle(html_content).strip()
    # Remove the specific unwanted line
    unwanted_line = "الغاء التفضيلتفضيلاضف ملاحظاتكالحواشيشرح الحديثمشاركة"
    return "\n".join(line for line in text.splitlines() if line.strip() != unwanted_line)

# Fetch all rows with HTML content
cursor.execute("SELECT id, html FROM contents")
rows = cursor.fetchall()

# Update shareable_text with processed text
for row in rows:
    record_id, html_content = row
    rendered_text = render_html_as_text(html_content)
    cursor.execute("""
        UPDATE contents
        SET text = ?
        WHERE id = ?
    """, (rendered_text, record_id))

# Commit changes and close connection
conn.commit()
conn.close()
