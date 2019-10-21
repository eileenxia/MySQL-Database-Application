# MySQL Database Application
## Constructing the database (SQL, data, Stored Procedures, Triggers, and Views)
## Eileen Xia and Syed Tanveer

Make sure to have mysql installed. Run these commands:
`brew install mysql`
`pip3 install mysql-connector`

To run this program, run `python3 mainscreen.py`, then follow the prompts. There is already pre-filled data in the database to give the tester data to work with. However, the tester must make a reivewer, editor, and an author user in order to test functionality of the program. the `idReviewer` for the reviewer will be 41 as it is the next number to be added into the database. the next Manuscript to be added will be 51. these will help if you would like to assign a reviewer to a manuscript you created.


#### File Description

##### mainscreen.py

Main runs `registerscreen.py` and `loginscreen.py` and put it into one functioning program. This allows the user to specify if they want to register or login. Once the user completes this, return to the main page and a new user can enter info.

##### registerscreen.py
`register.py` lets the user specify whether they are registering as an author, editor, or reviewer. When an author registers, they enter first and last name, email, address, and affiliation. When an editor registers, they enter first and last name. When a reviewer registers, they enter first and last name, email, affiliation, and 1-3 ICodes. We raise an exception if there already exists a reviewe with the same first and last name and if the reviewer doesn't specify an ICode.

##### loginscreen.py
`loginscreen.py` will allow for an existing user to login as an Author, Editor, or a Reviewer. Once the user selects a user type, they are asked to enter their user ID. An error is thrown if the user ID is wrong. The user will then be sent back to the register/login prompt and have to start again. If the user does enter a correct user_id, the user is will be given options to choose from that corispond with his/her role.

##### author.py
`author.py` hold all of the functionality for a author user. A author can see the status of his/her manuscripts by typing status. Or, add a new manuscript to the database by typing submit into the prompt.

##### editor.py
`editor.py` holds all of the functionality for a editor user. A editor can view the status of all manuscripts in the system. They can assign an existing reviewer to an existing manuscript. They can change the status of a Manuscript with 3 reviewers who have reviewed the Manuscript to accepted. They can change the status of a manuscript to rejected. They can schedule a manuscript to be published in an issue. They can also publish an Issue.

##### reviewer.py
`reviewer.py` hold all the functionality of a reviewer user. A reviewer can give feedback to a manuscript they are assigned to. If they are not assigned to the particular manuscript they want to give feedback to, the function will throw an error and exit. They can also delete themselves from the system. First, the program will check to see if they are on any manuscripts, if they arnt then they will be deleted from the system. But, if they are on any manuscript, then the program checks to see if they are the only reviewer or if they are any other reviewers on that particular manuscript. If they are the only one, then the manuscript gets changed to accepted and the reviewer gets deleted. If they arn't the only one, then they are just deleted off of that manuscript.

##### dbconfig.ini
This stores all of the database information that we are connecting to.


##### python_mysql_dbconfig.py
Read database configuration file and return a dictionary object


##### connect.py
`connect.py` gets database login information so that we can connect to the database.
