import re
from tqdm import tqdm

#exclude these hadith ids when its count is not nll
#as its not a hadith
excluded_titles = [16,19,29,35,39]

def recreate_hadith_table(cursor):
    cursor.execute( "DROP TABLE IF EXISTS hadith" )
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS hadith (
            id TEXT,
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
    seen_hadith_ids = {}  # Dictionary to track occurrences of hadith_id

    for i in range(1, len(hadith_splits), 2):
        order_id += 1
        hadith_id = int(hadith_splits[i]) if not hadith_splits[i + 1].startswith("\u0628\u0627\u0628") else None
        hadith_text = hadith_splits[i].strip() + " - " + hadith_splits[i + 1].strip()

        hadith_count = hadith_count if order_id == 1 and not haveHeader else None
        hadith_id = None if (hadith_id in excluded_titles and hadith_count is not None) else hadith_id

        # Handle duplicated hadith_id by appending "م" to duplicates
        if hadith_id is not None:
            if hadith_id in seen_hadith_ids:
                seen_hadith_ids[hadith_id] += 1
                hadith_id = f"{hadith_id}م"  # Append "م" for duplicates
            else:
                seen_hadith_ids[hadith_id] = 1

        cursor.execute(
            """
            INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (hadith_id, title_id, content_id, order_id, hadith_count, hadith_text, None)
        )

def insert_single(hadith_text, content_id, title_id, count, cursor):
    cursor.execute(
        """
        INSERT INTO hadith (id, titleId, contentId, orderId, count, text, searchText)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (None, title_id, content_id, 1, count if count else 1, hadith_text, None)
    )

def process_generate_hadith_table(cursor):
    recreate_hadith_table(cursor)
    cursor.execute("SELECT id, titleId, text FROM contents")
    rows = cursor.fetchall()
    process_contents(rows, cursor)
