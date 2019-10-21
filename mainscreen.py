"""
Syed Tanveer & Eileen
Team 7
CS61

Mainscreen file (check README.md for description)
"""

from registerscreen import register
from loginscreen import login

def home_screen():

    while(True):
        user_action = input("Welcome! Would you like to register a new user or login as an existing user? (type 'register' or 'login' or press enter to exit) ")
        if user_action == 'register' or  user_action == 'Register':
            register()
        elif user_action == 'login' or user_action == 'Login':
            login()
        else:
            print("Exiting system")
            break

home_screen()