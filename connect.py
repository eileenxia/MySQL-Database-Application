from python_mysql_dbconfig import read_db_config
import getpass

def connect():

    dbconfig = read_db_config()
    if dbconfig['password'] == "":
        dbconfig['password'] = getpass.getpass("database password ? :")

    return dbconfig