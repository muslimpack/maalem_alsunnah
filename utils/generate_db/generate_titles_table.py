import sqlite3
import html2text
import re
from tqdm import tqdm

def recreate_titles_table(cursor):
    cursor.execute( "DROP TABLE IF EXISTS titles" )
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS titles (
            id          INTEGER,
            name	      TEXT,
            searchText	TEXT,
            parentId	  INTEGER
        )
        """
    )

def get_titles():    
    conn = sqlite3.connect('assets\\original.db')
    cursor = conn.cursor()
    
    cursor.execute("SELECT id, parentId, name FROM titles")
    rows = cursor.fetchall()
    
    conn.close()

    return rows

def process_generate_titles_table(cursor):

    recreate_titles_table(cursor)

    rows = get_titles()

    for row in tqdm(rows, desc="BUILDING TITLES", unit="row"):
        record_id, parentId, name = row
        cursor.execute("""
            INSERT INTO titles (id, name, searchText, parentId)
            VALUES (?, ?, ?, ?)
        """, (record_id, name, None, parentId))
    

