import re
from tqdm import tqdm

def remove_diacritics(text):
    arabic_diacritics = re.compile(r'[\u0610-\u061A\u064B-\u065F\u0670]')
    return arabic_diacritics.sub('', text)

def process_remove_diacritics(cursor):
    cursor.execute("SELECT COUNT(*) FROM titles")
    title_count = cursor.fetchone()[0]
    cursor.execute("SELECT COUNT(*) FROM contents")
    content_count = cursor.fetchone()[0]
    cursor.execute("SELECT COUNT(*) FROM hadith")
    hadith_count = cursor.fetchone()[0]

    print("- Processing titles...")
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

    print("- Processing contents...")
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

    print("- Processing hadith...")
    cursor.execute("SELECT id, text FROM hadith")
    hadiths = cursor.fetchall()
    for row in tqdm(hadiths, desc="Processing Hadith", unit="row", total=hadith_count):
        record_id, text = row
        processed_text = remove_diacritics(text)
        cursor.execute("""
            UPDATE hadith
            SET searchText = ?
            WHERE text = ?
        """, (processed_text, text))
