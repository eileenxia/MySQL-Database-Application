"""
Syed Tanveer & Eileen
Team 7
CS61

Editor file (check README.md for description)
"""

from mysql.connector import Error
import sys
import time
import datetime
from random import randint

def editor_options(editor_id, conn, mycursor):

    editor_action = input(" -- Please enter what you would like to do -- \n"
                          "get status (type status)\n"
                          "assign a Manuscript to a reviewer (type assign)\n"
                          "reject a Manuscript (type reject)\n"
                          "accept an existing Manuscript (type accept)\n"
                          "schedule a Manuscript into an issue (type schedule)\n"
                          "publish an issue (type publish)\n"
                          "or exit (type exit): \n")

    if editor_action == 'status':
        editor_get_status(editor_id, conn, mycursor)
    elif editor_action == 'assign':
        editor_assign(editor_id, conn, mycursor)
    elif editor_action == 'reject':
        editor_reject(editor_id, conn, mycursor)
    elif editor_action == 'accept':
        editor_accept(editor_id, conn, mycursor)
    elif editor_action == 'schedule':
        editor_schedule(editor_id, conn, mycursor)
    elif editor_action == 'publish':
        editor_publish(editor_id, conn, mycursor)
    elif editor_action == 'exit':
        conn.close()
        mycursor.close()
        return
    else:
        print("not a valid entry, please try again!\n")
        editor_options(editor_id, conn, mycursor)


def editor_get_status(editor_id, conn, mycursor):

    try:
        query = "SELECT idManuscript, Manuscript_title, Manuscript_status, Manuscript_timestamp FROM `Manuscript` ORDER BY Manuscript_status AND Manuscript_timestamp"
        values = (editor_id)
        mycursor.execute(query, values)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        if len(res) == 0:
            print("you have no Manuscripts assigned!\n")
            editor_options(editor_id, conn, mycursor)
        else:
            for x in range(len(res)):
                print("[\n"
                      "Manuscript ID: {}\n"
                      "Manuscript title: {}\n"
                      "Manuscript Status: {}\n"
                      "Manuscript timestamp: {}\n"
                      "],".format(res[x][0], res[x][1], res[x][2], res[x][3]))
            print('\n')
            editor_options(editor_id, conn, mycursor)

def editor_assign(editor_id, conn, mycursor):

    idManuscript = input("enter the ID for the Manuscript: ")
    idReviewer = input("enter the ID of the Reviewer: ")
    Manuscript_name = None
    Reviewer_fname = None
    Reviewer_lname = None

    ts = time.time()
    feedback_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    try:
        query = "INSERT INTO `Feedback` (`Feedback_appropriateness`,`Feedback_clarity`,`Feedback_methodology`,`Feedback_contribution`,`Feedback_reccomendation`,`Feedback_received_date`,`Manuscript_idManuscript`,`Reviewer_idReviewer`) " \
                "VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"
        values = (0, 0, 0, 0, 0, feedback_timestamp, idManuscript, idReviewer)
        mycursor.execute(query, values)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "SELECT Reviewer_first_name, Reviewer_last_name FROM Reviewer WHERE idReviewer = '{}'".format(idReviewer)
        mycursor.execute(query)
        res = mycursor.fetchall()
        Reviewer_fname = res[0][0]
        Reviewer_lname = res[0][1]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "SELECT Manuscript_title FROM Manuscript WHERE idManuscript = '{}'".format(idManuscript)
        mycursor.execute(query)
        res = mycursor.fetchall()
        Manuscript_name = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:

        print("{} {} has been added as a reviewer to the manuscript titled {}\n".format(Reviewer_fname, Reviewer_lname, Manuscript_name))
        editor_options(editor_id, conn, mycursor)

def editor_reject(editor_id, conn, mycursor):

    idManuscript = input("Enter the ID of the Manuscript you'd like to reject: ")
    Manuscript_status = 'rejected'
    ts = time.time()
    Manuscript_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    try:
        query = "UPDATE Manuscript SET Manuscript_status = '{}', Manuscript_timestamp = '{}' WHERE idManuscript = {}".format(Manuscript_status, Manuscript_timestamp, idManuscript)
        mycursor.execute(query)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "SELECT Manuscript_title FROM Manuscript WHERE idManuscript = '{}'".format(idManuscript)
        mycursor.execute(query)
        res = mycursor.fetchall()
        Manuscript_name = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        print("\nManuscript titled '{}' has been rejected\n".format(Manuscript_name))
        editor_options(editor_id, conn, mycursor)

def editor_accept(idEditor, conn, mycursor):
    idManuscript = input("Enter the id of the Manuscript you'd like to accept: ")
    Manuscript_status = 'accepted'
    ts = time.time()
    Manuscript_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    # only accept if reviewer has 3 reviews in

    try:
        query = "SELECT Reviewer_idReviewer FROM Feedback WHERE Manuscript_idManuscript = {};".format(idManuscript)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)

    if len(res) < 3:
        print("cannot accept this manuscript because it does not have 3 complete reviews!")
        editor_options(idEditor, conn, mycursor)
    try:
        query = "UPDATE Manuscript SET Manuscript_status = '{}' , Manuscript_timestamp = '{}' WHERE idManuscript = {};".format(Manuscript_status, Manuscript_timestamp, idManuscript)
        mycursor.execute(query)
        conn.commit()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "SELECT Manuscript_title FROM Manuscript WHERE idManuscript = {};".format(idManuscript)
        mycursor.execute(query)
        res = mycursor.fetchall()
        print(res[0][0])
        Manuscript_title = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        print("\nManuscript with the title '{}' has been accepted!\n".format(Manuscript_title))
        editor_options(idEditor, conn, mycursor)


def editor_schedule(idEditor, conn, mycursor):
    idManuscript = input("Enter the ID of the manuscript you'd like to: ")
    Manuscript_pages = randint(1,150)
    issue_year = input("Enter the year (YYYY) for the issue you would like to add this Manuscript to: ")
    issue_period = input(
        "Enter the period (1, 2, 3, or 4) for the issue you would like to add this Manuscript to: ")

    ts = time.time()
    Manuscript_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    #check to see if manuscript is in ready status

    try:
        query = "SELECT Manuscript_status FROM `LeadAuthorManuscripts` WHERE idManuscript = '{}'".format(idManuscript)
        mycursor.execute(query)
        res = mycursor.fetchall()
        Manuscript_status = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)

    if Manuscript_status == 'ready':
        try:
            query = "SELECT idIssue, Issue_num FROM `Issue` WHERE issue_year = '{}' AND issue_period = '{}'".format(issue_year, issue_period)
            mycursor.execute(query)
            res = mycursor.fetchall()
            idIssue = res[0][0]
            issue_num = res[0][1]
        except Error as err:
            print(err.msg)
            sys.exit(21)
        if (int(issue_num) + int(Manuscript_pages)) > 100:
            print("\nthis manuscript has too many pages and will make the issue exceed the 100 page limit!\n")
            editor_options(idEditor, conn, mycursor)
        else:
            issue_num = int(issue_num) + int(Manuscript_pages)
            issue_num = str(issue_num)
            try:
                query = "INSERT INTO `Manuscript_accepted` (`Manuscript_idManuscript`,`Issue_idIssue`) VALUES (%n, %n)"
                values = (idManuscript, idIssue)
                mycursor.execute(query, values)
            except Error as err:
                print(err.msg)
                sys.exit(21)
            try:
                query = "UPDATE Issue SET Issue_num = %s WHERE idIssue = %s"
                values = (issue_num, idIssue)
                mycursor.execute(query, values)
            except Error as err:
                print(err.msg)
                sys.exit(21)
            try:
                query = "UPDATE Manuscript SET Manuscript_status = '{}', Manuscript_timestamp = '{}' WHERE idManuscript = '{}'".format(issue_num, Manuscript_timestamp, idManuscript)
                mycursor.execute(query)
                conn.execute()
            except Error as err:
                print(err.msg)
                sys.exit(21)
            else:
                print("\nThis Manuscript has been added to the issue " +issue_year+"-"+issue_period+"\n")
    else:
        print("\nThis Manuscript is not ready to be added to an issue! the current status of this Manuscript is {}\n".format(Manuscript_status))
        editor_options(idEditor, conn, mycursor)

def editor_publish(idEditor, conn, mycursor):

    issue_year = input("Enter the year of the issue (YYYY) that you'd like to publish: ")
    issue_period = input("Enter the period of the issue (1, 2, 3, or 4) you'd like to publish: ")
    Manuscript_status = 'published'
    ts = time.time()
    Manuscript_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')


    try:
        query = "SELECT idIssue FROM `Issue` WHERE issue_year = '{}' AND issue_period = '{}';".format(
            issue_year, issue_period)
        mycursor.execute(query)
        res = mycursor.fetchall()
        idIssue = res[0][0]
    except Error as err:
        print(err.msg)
        sys.exit(21)
    try:
        query = "SELECT Manuscript_idManuscript FROM `Manuscript_Accepted` WHERE issue_idIssue = {};".format(
            idIssue)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    if len(res) == 0:
        print("This issue is not ready to be publish or has no Manuscripts added into it, please try another issue")
        editor_options(idEditor, conn, mycursor)
    for x in range(len(res)):
        try:
            query = "UPDATE Manuscript SET Manuscript_status = '{}', Manuscript_timestamp = '{}' WHERE idManuscript = {};".format(Manuscript_status, Manuscript_timestamp, res[x][0])
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "SELECT Manuscript_title FROM Manuscript WHERE idManuscript = {}".format(res[x][0])
            mycursor.execute(query)
            res = mycursor.fetchall()
            manuscript_title = res[0][0]
        except Error as err:
            print(err.msg)
            sys.exit(21)
        else:
            print("'{}' will now be published in the Issue ".format(manuscript_title) + issue_year+"-"+issue_period+"\n")
    editor_options(idEditor, conn, mycursor)
