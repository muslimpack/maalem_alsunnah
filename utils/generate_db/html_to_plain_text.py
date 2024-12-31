import sqlite3
import html2text
import re
from tqdm import tqdm

def recreate_contents_table(cursor):
    cursor.execute( "DROP TABLE IF EXISTS contents" )
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS contents (
            id          INTEGER,
            titleId	    INTEGER,
            text	    TEXT,
            searchText	TEXT
        )
        """
    )

def render_html_as_text(html_content, html_converter):
    text = html_converter.handle(html_content).strip()
    text = text.replace("\\-", " -")
    text = re.sub(r'^\s*\n', '\n', text, flags=re.MULTILINE)
    unwanted_line = "الغاء التفضيلتفضيلاضف ملاحظاتكالحواشيشرح الحديثمشاركة"
    return "\n".join(line for line in text.splitlines() if line.strip() != unwanted_line)

def get_contents():    
    contentsConn = sqlite3.connect('assets\\original.db')
    contentsCursor = contentsConn.cursor()
    
    contentsCursor.execute("SELECT id, titleId, html FROM contents")
    rows = contentsCursor.fetchall()
    
    contentsConn.close()

    return rows

def process_html_to_plain_text(cursor):

    html_converter = html2text.HTML2Text()
    html_converter.ignore_links = True
    html_converter.ignore_images = True
    html_converter.body_width = 0
    html_converter.ignore_emphasis = True

    recreate_contents_table(cursor)

    rows = get_contents()

    for row in tqdm(rows, desc="BUILDING CONTENTS", unit="row"):
        record_id, titleId, html_content = row
        rendered_text = render_html_as_text(html_content, html_converter)
        cursor.execute("""
            INSERT INTO contents (id, titleId, text, searchText)
            VALUES (?, ?, ?, ?)
        """, (record_id, titleId, rendered_text, None))
    

