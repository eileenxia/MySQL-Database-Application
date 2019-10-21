"""
Syed Tanveer & Eileen
Team 7
CS61

registerscreen file (check README.md for description)
"""

from mysql.connector import MySQLConnection, Error, errorcode
import sys
from connect import connect

def register():

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


    registered = False

    register = input("Welcome new user! Are you an Author, Editor, or Reviewer? ")

    while registered == False:

        if register == "Author" or register == "author":
            print("Welcome new author!")
            register_author(conn, mycursor)
            registered = True
        elif register == "Editor" or register == "editor":
            print("Welcome new editor!")
            register_editor(conn, mycursor)
            registered = True
        elif register == "Reviewer" or register == "reviewer":
            print("Welcome new reviewer!")
            register_reviewer(conn, mycursor)
            registered = True
        else:
            register = input("That is not an option. Try again: ")


def register_author(conn, mycursor):
    #register author < fname > < lname > < email > < affiliation >
    fname = input("Enter first name: ")
    lname = input("Enter last name: ")
    address = input("Enter address: ")
    email = input("Enter email: ")
    affiliation = input("Enter company or school affiliation: ")
    user_id = input("Enter a user ID to login with: ")

    try:
        query = "SELECT Author_first_name, Author_last_name, Author_user_id FROM Author WHERE Author_user_id = '{}'".format(user_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) != 0 :
            print("invalid user ID or the user already exists! please try again")
            register_author(conn, mycursor)
    try:
        query = "INSERT INTO `Author` (`Author_first_name`,`Author_last_name`,`Author_address`,`Author_email`,`Author_affiliation`, `Author_user_id`) VALUES (%s,%s,%s,%s,%s,%s);"
        values = (fname,lname,address,email,affiliation, user_id)
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(2)
    else:
        print("Successfully registered! Welcome " + fname)
        conn.close()
        mycursor.close()


def register_editor(conn, mycursor):
    #register editor <fname> <lname>
    fname = input("Enter first name: ")
    lname = input("Enter last name: ")
    user_id = input("Enter a user ID to login with: ")

    try:
        query = "SELECT Editor_first_name, Editor_last_name, Editor_user_id FROM Editor WHERE Editor_user_id = '{}'".format(user_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) != 0 :
            print("invalid user ID or the user already exists! please try again")
            register_editor(conn, mycursor)
    try:
        query = "INSERT INTO `Editor` (`Editor_first_name`,`Editor_last_name`, `Editor_user_id`) VALUES (%s,%s,%s);"
        values = (fname, lname, user_id)
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(2)
    else:
        print("Successfully registered! Welcome " + fname)
        conn.close()
        mycursor.close()

def register_reviewer(conn, mycursor):
    #register reviewer <fname> <lname> <ICode 1> <ICode 2> <ICode 3>
    fname = input("Enter first name: ")
    lname = input("Enter last name: ")
    email = input("Enter email: ")
    affiliation = input("Enter company or school affiliation: ")
    user_id = input("Enter a user ID to login with: ")
    ICode2=None
    ICode3=None

    try:
        name_exception = "SELECT idReviewer FROM `Reviewer` WHERE Reviewer_first_name='{}' AND Reviewer_last_name='{}' AND Reviewer_user_id = '{}'".format(fname, lname, user_id)
        mycursor.execute(name_exception)
        res = mycursor.fetchall()
        if len(res) != 0:
            print("This name pair already exists.")
            register_reviewer(conn, mycursor)

        query = "INSERT INTO `Reviewer` (`Reviewer_first_name`,`Reviewer_last_name`,`Reviewer_email`,`Reviewer_affiliation`, `Reviewer_user_id`) VALUES (%s,%s,%s,%s, %s);"
        values = (fname, lname,email,affiliation, user_id)
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(2)
    else:
        print("Welcome " + fname + "!")

    ICode = input("Enter interest code: ")
    if ICode == "":
        raise Exception('You must enter an interest code.')
    multiple = input("Do you wish to add another interest code? y/n ")
    if multiple == "y":
        ICode2 = input("Enter second interest code: ")
        multiple = input("Do you wish to add another interest code? y/n ")
        if multiple == "y":
            ICode3 = input("Enter third interest code: ")
            print("Done!")
        print("Done!")
    elif multiple == "n":
        print("Done!")

    try:
        reviewer_id = mycursor.lastrowid
        # id = "SELECT idReviewer FROM `Reviewer` WHERE Reviewer_first_name=%s and Reviewer_last_name=%s"
        # values = (fname,lname)
        # reviewer_id=mycursor.execute(id,values)

        query = "INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (%s,%s);"
        values = (reviewer_id,ICode)
        mycursor.execute(query, values)
        conn.commit()
        if ICode2 != None:
            query = "INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (%s,%s);"
            values = (reviewer_id, ICode2)
            mycursor.execute(query, values)
            conn.commit()
        if ICode3 != None:
            query = "INSERT INTO `Reviewer_has_Interest_area` (`Reviewer_idReviewer`,`Interest_area_RI_code`) VALUES (%s,%s);"
            values = (reviewer_id, ICode3)
            mycursor.execute(query, values)
            conn.commit()

    except Error as err:
        print(err.msg)
        sys.exit(2)
    else:
        print("Successfully registered! Welcome " + fname)
        conn.close()
        mycursor.close()