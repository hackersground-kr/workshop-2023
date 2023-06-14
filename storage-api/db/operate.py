import os
from dotenv import load_dotenv
import pyodbc
from model.models import Info

# Load environment variables from .env
load_dotenv()

conn = pyodbc.connect(os.environ['SQLAZURECONNSTR_STORAGE'])

def create_table():
    #create table with format from ../model/models.py Info class.
    cursor = conn.cursor()
    
    cursor.execute("""
        CREATE TABLE issues (
            id VARCHAR(255) PRIMARY KEY NOT NULL,
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
    #insert issue to table
    cursor = conn.cursor()
    
    table_name = "issues"
    cursor.execute(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{table_name}'")
    fetch_table = cursor.fetchone()
    
    #Create table if it doesn't exist
    if fetch_table is None:
        create_table()
    else:
        pass
    
    #Insert issue to table
    result = cursor.execute("""
        INSERT INTO issues (id, [user], repository, issueId, issueNumber, title, body, summary)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, issue.id, issue.user, issue.repository, issue.issueId, issue.issueNumber, issue.title, issue.body, issue.summary)
    conn.commit()
    
    return result

