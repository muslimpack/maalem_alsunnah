import sqlite3

from bs4 import BeautifulSoup

# Connect to SQLite database
conn = sqlite3.connect('book.db')
cursor = conn.cursor()

# Function to render HTML as text, considering <p> and <span> with classes
def render_html_with_p_and_span(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Prepare a list to collect the final text
    result_lines = []

    # Process <p> tags (treat as block elements)
    for p in soup.find_all("p"):
        paragraph_text = []
        for span in p.find_all("span"):  # Process spans within <p>
            paragraph_text.append(span.get_text(strip=True))
        result_lines.append(" ".join(paragraph_text))  # Join spans within the paragraph

    # Combine all paragraphs, separating by newlines
    return "\n\n".join(result_lines).strip()

# Fetch all rows with HTML content
cursor.execute("SELECT id, html FROM contents")
rows = cursor.fetchall()

# Update shareable_text with processed text
for row in rows:
    record_id, html_content = row
    rendered_text = render_html_with_p_and_span(html_content)
    cursor.execute("""
        UPDATE contents
        SET shareable_text = ?
        WHERE id = ?
    """, (rendered_text, record_id))

# Commit changes and close connection
conn.commit()
conn.close()
