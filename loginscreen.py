"""
Syed Tanveer & Eileen
Team 7
CS61

loginscreen file (check README.md for description)
"""


from mysql.connector import MySQLConnection, Error, errorcode
import sys
from connect import connect
from author import author_options
from editor import editor_options
from reviewer import reviewer_options

def login():

    dbconfig = connect()
    # Connect to the database
    try:
        print('Connecting to MySQL database...')
        conn = MySQLConnection(**dbconfig)

        if conn.is_connected():
            print('connection established.')
            mycursor = conn.cursor(buffered=True)
        else:
            print('connection failed.')
            sys.exit(1)


    except Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
            sys.exit(1)


    user_login = input("Are you an Author, Editor, or Reviewer? ")


    if user_login == "Author" or user_login == "author":
        login_author(conn, mycursor)
    elif user_login == "Editor" or user_login == "editor":
        login_editor(conn, mycursor)
    elif user_login == "Reviewer" or user_login == "reviewer":
        login_reviewer(conn, mycursor)


def login_author(conn, mycursor):

    login_id = input("Please enter your unique login ID: ")
    idAuthor = None

    try:
        query = "SELECT idAuthor, Author_first_name, Author_last_name FROM Author WHERE Author_user_id = '{}'".format(login_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) == 0:
            print("this user does not exist!")
            return

        idAuthor = res[0][0]
        print("Welcome {} {}!".format(res[0][1], res[0][2]))
        author_options(idAuthor, conn, mycursor)

def login_editor(conn, mycursor):

    login_id = input("Please enter your unique login ID: ")
    res = None

    try:
        query = "SELECT idEditor, Editor_first_name, Editor_last_name FROM Editor WHERE Editor_user_id = '{}'".format(login_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) == 0:
            print("this user does not exist!")
            return
        idEditor = res[0][0]
        print("Welcome {} {}!".format(res[0][1], res[0][2]))
        editor_options(idEditor, conn, mycursor)

def login_reviewer(conn, mycursor):

    login_id = input("Please enter your unique login ID: ")

    try:
        query = "SELECT idReviewer, Reviewer_first_name, Reviewer_last_name FROM Reviewer WHERE Reviewer_user_id = '{}';".format(login_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
        reviewer_id = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) == 0:
            print("this user does not exist!")
            return
        print("Welcome {} {}!".format(res[0][1], res[0][2]))
    reviewer_options(reviewer_id, conn, mycursor)