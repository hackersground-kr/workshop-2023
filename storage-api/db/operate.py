import os
import uuid

from dotenv import load_dotenv
import pyodbc
from model.models import Info

# Load environment variables from .env
load_dotenv()

conn = pyodbc.connect(os.environ['SQLAZURECONNSTR_STORAGE'])
TABLE_NAME = "issues"

def delete_table():
    cursor = conn.cursor()
    cursor.execute(f"DROP TABLE {TABLE_NAME}")
    conn.commit()

def create_table():
    #create table with format from ../model/models.py Info class.
    cursor = conn.cursor()
    
    cursor.execute("""
        CREATE TABLE issues (
            id VARCHAR(255) NOT NULL PRIMARY KEY,
            [user] VARCHAR(255) NOT NULL,
            repository VARCHAR(255) NOT NULL,
            issueId INT,
            issueNumber INT,
            title VARCHAR(255),
            body VARCHAR(255),
            summary VARCHAR(255)
        )
        """)
    
    conn.commit()
    
def insert_issue(issue: Info):
    try:
        #insert issue to table
        cursor = conn.cursor()

        cursor.execute(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{TABLE_NAME}'")
        fetch_table = cursor.fetchone()
        
        #Create table if it doesn't exist
        if fetch_table is None:
            create_table()
        else:
            pass
        
        #Create random id for primary key
        new_id = uuid.uuid4()
        
        #Insert issue to table
        try:
            cursor.execute("""
            INSERT INTO issues (id, [user], repository, issueId, issueNumber, title, body, summary)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, new_id, issue.user, issue.repository, issue.issueId, issue.issueNumber, issue.title, issue.body, issue.summary)
            conn.commit()
            return True
        except Exception as e:
            return e
    
    except Exception as e:
        return e

