import sqlite3
import os
from generate_titles_table import process_generate_titles_table
from html_to_plain_text import process_html_to_plain_text
from generate_hadith_table import process_generate_hadith_table
from remove_diacritics import process_remove_diacritics

db_name = 'book.db'

if __name__ == "__main__":
    if os.path.exists(db_name):
        os.remove(db_name)
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()

    try:
        print("\n------------------------------")
        print("# Phase 1: Building 'titles' table...")
        print("------------------------------\n")
        process_generate_titles_table(cursor)
        conn.commit()

        print("\n------------------------------")
        print("# Phase 2: Building 'contents' table | Converting HTML to plain text...")
        print("------------------------------\n")
        process_html_to_plain_text(cursor)
        conn.commit()

        print("\n------------------------------")
        print("# Phase 3: Recreating Hadith table and processing Hadiths...")
        print("------------------------------\n")
        process_generate_hadith_table(cursor)
        conn.commit()

        print("\n------------------------------")
        print("# Phase 4: Removing diacritics...")
        print("------------------------------\n")
        process_remove_diacritics(cursor)
        conn.commit()
    finally:
        conn.close()

    print("\nProcessing complete!")
