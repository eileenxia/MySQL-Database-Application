"""
Syed Tanveer & Eileen
Team 7
CS61

Reviewer file (check README.md for description)
"""

from mysql.connector import Error
import sys
import time
import datetime

def reviewer_options(reviewer_id, conn, mycursor):

    reviewer_action = input(" -- Please enter what you would like to do -- \n"
                            "To give feedback to a Manuscript you're assigned to, type feedback\n"
                            "To resign, type resign\n"
                            "TO quit, type quit:\n")

    if reviewer_action == "feedback" or reviewer_action == "Feedback":
        reviewer_feedback(reviewer_id, conn, mycursor)
    elif reviewer_action == "resign" or reviewer_action == "resign":
        reviewer_resign(reviewer_id, conn, mycursor)
    elif reviewer_action == "quit" or reviewer_action == "Quit":
        conn.close()
        mycursor.close()
        return
    else:
        print("not a valid entry, please try again!\n")
        reviewer_options(reviewer_id, conn, mycursor)

def reviewer_feedback(reviewer_id, conn, mycursor):

    idManuscript = input("What is the ID of the Manuscript? ")
    clarity = input("Enter a score for clarity (1-10): ")
    methodology = input("Enter a score for methodology (1-10): ")
    contribution = input("Enter a score for contribution (1-10): ")
    appropriateness = input("Enter a score for appropriateness (1-10): ")
    idReviewer = reviewer_id
    reviewer_rec = input("Do you recommend to reject or accept this Manuscript? (type reject or accept): ")
    can_review = False
    ts = time.time()
    feedback_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

    if reviewer_rec == 'accept':
        reviewer_rec = 10
    elif reviewer_rec == 'reject':
        reviewer_rec = 0
    try:
        query = "SELECT Manuscript_idManuscript FROM Feedback WHERE Reviewer_idReviewer = '{}'".format(idReviewer)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    else:
        for x in range(len(res)):
            if res[x][0] == int(idManuscript):
                can_review = True
                try:
                    query = "UPDATE Feedback SET " \
                            "Feedback_appropriateness = '{}'," \
                            "Feedback_clarity = '{}'," \
                            "Feedback_methodology = '{}'," \
                            "Feedback_contribution = '{}'," \
                            "Feedback_reccomendation = '{}'," \
                            "Feedback_received_date = '{}' " \
                            "WHERE Manuscript_idManuscript = {} AND Reviewer_idReviewer = {} ".format(appropriateness, clarity, methodology, contribution, reviewer_rec,
                                                                feedback_timestamp, idManuscript, idReviewer)

                    mycursor.execute(query)
                    conn.commit()
                except Error as err:
                    print(err.msg)
                    sys.exit(2)
                else:
                    print("successfully added feedback for Manuscript with ID {}\n".format(idManuscript))
        if can_review == False:
            print("You are not a reviewer for the Manuscript with an ID {}\n".format(idManuscript))
        reviewer_options(reviewer_id, conn, mycursor)

def reviewer_resign(reviewer_id, conn, mycursor):

    user_id = input("what is your user id?: ")

    ts = time.time()
    manuscript_timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    manuscript_accepted = 'accepted'

    try:
        query = "SELECT Manuscript_idManuscript FROM Feedback WHERE Reviewer_idReviewer = {}".format(reviewer_id)
        mycursor.execute(query)
        res = mycursor.fetchall()
    except Error as err:
        print(err.msg)
        sys.exit(21)
    if len(res) == 0:
        try:
            query = "DELETE FROM Reviewer_has_Interest_area WHERE Reviewer_idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "DELETE FROM Reviewer WHERE idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        print("Thank you for your service.\n")
    elif len(res) == 1:
        try:
            query = "UPDATE Manuscript SET Manuscript_status = '{}' WHERE idManuscript = {}".format(manuscript_accepted, res[0][0])
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
        try:
            query = "DELETE FROM Feedback WHERE Reviewer_idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
            res = mycursor.fetchall()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "DELETE FROM Reviewer_has_Interest_area WHERE Reviewer_idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "DELETE FROM Reviewer WHERE idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        print("Thank you for your service.\n")
    else:
        try:
            query = "DELETE FROM Reviewer_has_Interest_area WHERE Reviewer_idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "DELETE FROM Feedback WHERE Reviewer_idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
            res = mycursor.fetchall()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        try:
            query = "DELETE FROM Reviewer WHERE idReviewer = {}".format(reviewer_id)
            mycursor.execute(query)
            conn.commit()
        except Error as err:
            print(err.msg)
            sys.exit(21)
        print("Thank you for your service.\n")
    return

