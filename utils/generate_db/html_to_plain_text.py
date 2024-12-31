import sqlite3
import html2text
import re
from tqdm import tqdm

def render_html_as_text(html_content, html_converter):
    text = html_converter.handle(html_content).strip()
    text = text.replace("\\-", " -")
    text = re.sub(r'^\s*\n', '\n', text, flags=re.MULTILINE)
    unwanted_line = "الغاء التفضيلتفضيلاضف ملاحظاتكالحواشيشرح الحديثمشاركة"
    return "\n".join(line for line in text.splitlines() if line.strip() != unwanted_line)

def process_html_to_plain_text(cursor):
    html_converter = html2text.HTML2Text()
    html_converter.ignore_links = True
    html_converter.ignore_images = True
    html_converter.body_width = 0
    html_converter.ignore_emphasis = True

    cursor.execute("SELECT id, html FROM contents")
    rows = cursor.fetchall()

    for row in tqdm(rows, desc="Processing HTML", unit="row"):
        record_id, html_content = row
        rendered_text = render_html_as_text(html_content, html_converter)
        cursor.execute("""
            UPDATE contents
            SET text = ?
            WHERE id = ?
        """, (rendered_text, record_id))
