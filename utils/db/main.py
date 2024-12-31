import sqlite3
import html2text
import re
from tqdm import tqdm

# Function to remove Arabic diacritics
def remove_diacritics(text):
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

# Function to render HTML as plain text and remove unwanted lines
def render_html_as_text(html_content):
    # Convert HTML to text
    text = html_converter.handle(html_content).strip()
    # Replace "\\-" with a new line
    text = text.replace("\\-", " -")
    # Replace multiple new lines with a new line
    text = re.sub(r'^\s*\n', '\n', text, flags=re.MULTILINE)
    # Remove the specific unwanted line
    unwanted_line = "الغاء التفضيلتفضيلاضف ملاحظاتكالحواشيشرح الحديثمشاركة"
    return "\n".join(line for line in text.splitlines() if line.strip() != unwanted_line)

# Combine both scripts
if __name__ == "__main__":
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

    conn.commit()

    # Phase 3: Recreate hadith table and process hadiths
    print("Phase 3: Recreating Hadith table and processing Hadiths...")

    def recreate_hadith_table(cursor):
        cursor.execute("DROP TABLE IF EXISTS hadith;")
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS hadith (
                id INTEGER,
                titleId INTEGER,
                contentId INTEGER,
                orderId INTEGER,
                count INTEGER,
                text TEXT,
                searchText TEXT
            )
            """
        )

    def process_contents(rows, cursor):
        hadith_start_regex = re.compile(r"^\s*(\d+)\s*-\s*", re.MULTILINE)

        for content_id, title_id, text_content in tqdm(rows, desc="Processing Hadiths", unit="row"):
            if title_id < 7:
                continue

            text_content = text_content.replace("\u2013", "-")
            matches = list(hadith_start_regex.finditer(text_content))

            if matches:
                first_match_start = matches[0].start()
                header = text_content[:first_match_start].strip()
                body = text_content[first_match_start:].strip()
                hadith_splits = hadith_start_regex.split(body)
                hadith_count = (len(hadith_splits) - 1) // 2
                if header:
                    insert_single(header, content_id, title_id, hadith_count + 1, cursor)

                if len(hadith_splits) > 1:
                    insert_hadiths(hadith_splits, content_id, title_id, header, cursor)
                else:
                    insert_single(body, content_id, title_id, None, cursor)
            else:
                insert_single(text_content.strip(), content_id, title_id, None, cursor)

    def insert_hadiths(hadith_splits, content_id, title_id, haveHeader, cursor):
        order_id = 0
        hadith_count = (len(hadith_splits) - 1) // 2

        for i in range(1, len(hadith_splits), 2):
            order_id += 1

            hadith_id = int(hadith_splits[i]) if not hadith_splits[i + 1].startswith("\u0628\u0627\u0628") else None
            hadith_text = hadith_splits[i + 1].strip()
            search_text = remove_diacritics(hadith_text)

            cursor.execute(
                """
                INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (hadith_id, title_id, content_id, order_id, hadith_count if order_id == 1 and not haveHeader else None, hadith_text, search_text)
            )

    def insert_single(hadith_text, content_id, title_id, count, cursor):
        search_text = remove_diacritics(hadith_text)
        cursor.execute(
            """
            INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (None, title_id, content_id, 1, count if count else 1, hadith_text, search_text)
        )

    recreate_hadith_table(cursor)
    cursor.execute("SELECT id, titleId, text FROM contents")
    rows = cursor.fetchall()
    process_contents(rows, cursor)

    conn.commit()
    conn.close()

    print("Processing complete!")
