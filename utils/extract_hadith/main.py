import sqlite3
import re

def main():
    # Connect to the SQLite database
    conn = sqlite3.connect('book.db')
    cursor = conn.cursor()

    try:
        # Recreate the hadith table
        recreate_hadith_table(cursor)

        # Fetch all rows from the contents table
        cursor.execute("SELECT id, titleId, text FROM contents")
        rows = cursor.fetchall()

        # Process each row to extract and insert Hadiths
        process_contents(rows, cursor)

        # Commit changes
        conn.commit()
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Close the connection
        conn.close()

def recreate_hadith_table(cursor):
    """Drop and recreate the hadith table."""
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

def remove_diacritics(text):
    """Remove Arabic diacritics from text."""
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

import re

def process_contents(rows, cursor):
    """Process rows from the contents table and insert Hadiths into the hadith table."""
    hadith_start_regex = re.compile(r"^\s*(\d+)\s*-\s*", re.MULTILINE)

    for content_id, title_id, text_content in rows:
        # Skip introduction titles
        if title_id < 7:
            continue

        # Normalize text for processing
        text_content = text_content.replace("\u2013", "-")  # Replace en dash with hyphen

        # Find Hadith starting lines and split the text
        matches = list(hadith_start_regex.finditer(text_content))
        
        if matches:
            # Process the text before the first Hadith as the header
            first_match_start = matches[0].start()
            header = text_content[:first_match_start].strip()
            body = text_content[first_match_start:].strip()

            # Process the remaining Hadiths
            hadith_splits = hadith_start_regex.split(body)
            hadith_count = (len(hadith_splits) - 1) // 2
            if header:
                insert_single(header, content_id, title_id, hadith_count + 1, cursor)

            if len(hadith_splits) > 1:
                insert_hadiths(hadith_splits, content_id, title_id, header, cursor)
            else:
                insert_single(body, content_id, title_id,None, cursor)
        else:
            # If no Hadith starting lines are found, insert the entire text as a single entry
            insert_single(text_content.strip(), content_id, title_id, None, cursor)


def insert_hadiths(hadith_splits, content_id, title_id, haveHeader, cursor):
    """Insert Hadiths into the database based on split text."""
    order_id = 0
    hadith_count = (len(hadith_splits) - 1) // 2  # Calculate the count of Hadiths

    for i in range(1, len(hadith_splits), 2):
        order_id += 1

        # Parse Hadith ID and text
        hadith_id = int(hadith_splits[i]) if not hadith_splits[i + 1].startswith("\u0628\u0627\u0628") else None
        hadith_text = hadith_splits[i + 1].strip()

        # Normalize the text for searching
        search_text = remove_diacritics(hadith_text)

        # Insert into the hadith table
        cursor.execute(
            """
            INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (hadith_id, title_id, content_id, order_id,  hadith_count if order_id == 1 and not haveHeader else None, hadith_text, search_text)
        )

def insert_single(hadith_text, content_id, title_id, count, cursor):
    """Insert titles which not satisfy regex."""

    # Normalize the text for searching
    search_text = remove_diacritics(hadith_text)

    # Insert into the hadith table
    cursor.execute(
        """
        INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (None, title_id, content_id, 1,count if count else 1, hadith_text, search_text)
    )

if __name__ == "__main__":
    main()
