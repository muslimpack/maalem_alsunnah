import sqlite3
from html_to_plain_text import process_html_to_plain_text
from remove_diacritics import process_remove_diacritics
from generate_hadith_table import process_generate_hadith_table

if __name__ == "__main__":
    conn = sqlite3.connect('book.db')
    cursor = conn.cursor()

    try:
        print("\n# Phase 1: Converting HTML to plain text...")
        process_html_to_plain_text(cursor)
        conn.commit()

        print("\n------------------------------")
        print("# Phase 2: Recreating Hadith table and processing Hadiths...")
        process_generate_hadith_table(cursor)
        conn.commit()

        print("\n------------------------------")
        print("# Phase 3: Removing diacritics...")
        process_remove_diacritics(cursor)
        conn.commit()
    finally:
        conn.close()

    print("\nProcessing complete!")
