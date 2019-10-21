"""
Syed Tanveer & Eileen
Team 7
CS61

Author file (check README.md for description)
"""

from mysql.connector import Error
import sys
from random import randint

def read_file(filename):
    with open(filename, 'rb') as f:
        file = f.read()
    return file

def author_options(author_id, conn, mycursor):
    option = False
    author_status(author_id, mycursor)
    while option == False:
        author_select = input("What would you like to do?\n"
                              "type 'submit' to submit a Manuscript\n"
                              "type 'status' for all your submitted Manusripts statuses\n"
                              ": ")
        if author_select == 'submit' or author_select == 'Select':
            option = True
            author_submit(author_id, conn, mycursor)

        elif author_select == 'status' or author_select == 'Status':
            option = True
            author_status(author_id, mycursor)
        elif author_select == 'exit' or author_select == 'Exit':
            conn.close()
            mycursor.close()
            return
        else:
            print("this is not an option")

def author_submit(author_id,conn, mycursor):
    author_id = author_id
    Manuscript_title = input("Enter your Manuscripts title: ")
    Manuscript_data = input("Enter your the location of the Manuscripts file: ")
    Manuscript_status = 'accepted'
    Manuscript_affiliation = input("Enter the affiliation of the Manuscript: ")
    Manuscript_RI_code = input("Enter the RI code of your Manuscript (if you do not know RI-Codes, type 'showcode'):  ")
    Manuscript_data = read_file(Manuscript_data)
    idEditor = None

    try:
        query = "SELECT idManuscript FROM `Manuscript` WHERE Manuscript_title = '{}'"
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    if len(res)!= 0:
        print("Manuscript with this title already exists!")

    if int(Manuscript_RI_code) < 0:
        print("Not a valid RI-code")
        return
    elif int(Manuscript_RI_code) < 10 and int(Manuscript_RI_code) >= 0:
        idEditor = randint(1,7)
    elif int(Manuscript_RI_code) < 20 and int(Manuscript_RI_code) >= 10:
        idEditor = randint(8,14)
    elif int(Manuscript_RI_code) < 30 and int(Manuscript_RI_code) >= 20:
        idEditor = randint(15,21)
    elif int(Manuscript_RI_code) < 40 and int(Manuscript_RI_code) >= 30:
        idEditor = randint(22,29)
    elif int(Manuscript_RI_code) >= 40:
        idEditor = randint(30,40)


    try:
        query = "SELECT idManuscript FROM `Manuscript` WHERE Manuscript_title = '{}'".format(Manuscript_title)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) != 0:
            print("there already exists a Manuscript with this title!")
            return
    try:
        query = "INSERT INTO `Manuscript`(`Manuscript_title`, `Manuscript_data`, `Manuscript_status`, `Manuscript_affiliation`, `Manuscript_RI_Code`, `Editor_idEditor`) VALUES (%s, %s, %s, %s, %s, %s);"
        values = (Manuscript_title, Manuscript_data, Manuscript_status, Manuscript_affiliation, Manuscript_RI_code, idEditor)
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(21)

    try:
        query = "SELECT idManuscript FROM `Manuscript` WHERE Manuscript_title = '{}'".format(Manuscript_title)
        mycursor.execute(query)
        res = mycursor.fetchall()
        Manuscript_id = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES(%s,%s,%s);"
        values = (author_id, Manuscript_id, '0')
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:

        co_author = input("Would you like to add a co-author?: (y/n) ")

        if co_author == 'y' or co_author == 'Y':
            num_co_author = int(input("How many co-authors would you like to add: "))
            for x in range(num_co_author):
                author_fname = input("What is the co-authors first name?: ")
                author_lname = input("What is the co-authors last name?: ")
                try:
                    query = "INSERT INTO `Author` (`Author_first_name`,`Author_last_name`) VALUES(%s,%s);"
                    values = (author_fname, author_lname)
                    mycursor.execute(query, values)
                    conn.commit()
                except Error as err:
                    print(err.msg)
                    sys.exit(21)
                try:
                    query = "SELECT idAuthor FROM `Author` WHERE Author_first_name = '{}' AND Author_last_name = '{}'".format(author_fname, author_lname)
                    mycursor.execute(query)
                    res = mycursor.fetchall()
                    coauthor_id = res[0][0]
                except Error as err:
                    print(err.msg)
                    sys.exit(21)
                try:
                    query = "INSERT INTO `Author_has_Manuscript` (`Author_idAuthor`,`Manuscript_idManuscript`,`Author_order`) VALUES(%s,%s,%s);"
                    values = (coauthor_id, Manuscript_id, x+1)
                    mycursor.execute(query, values)
                    conn.commit()
                except Error as err:
                    print(err.msg)
                    sys.exit(21)
                else:
                    print("added {} {} to the Manuscript as a co-Author!".format(author_fname, author_lname))

        print("{} has been submitted!".format(Manuscript_title))
        submit_another = input("would you like to submit another? (y/n): ")

        if submit_another == 'y' or submit_another == 'Y':
            author_submit(author_id, conn, mycursor)
        else:
            author_options(author_id, conn, mycursor)

def author_status(author_id, mycursor):

    try:
        query = "SELECT idManuscript, Manuscript_status, Manuscript_timestamp Manuscript FROM `LeadAuthorManuscripts` WHERE idAuthor = {}".format(author_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) == 0:
            print("You have no submitted Manuscripts\n")
        for manuscript in res:
            print(manuscript)
