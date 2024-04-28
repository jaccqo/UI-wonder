# This Python file uses the following encoding: utf-8
import sys
import os
import json

from PySide2.QtGui import QGuiApplication, QIcon
from PySide2.QtQml import QQmlApplicationEngine
from mainWindow import MainWindow
from PySide2.QtCore import QObject, Slot,Signal,QThread
import sqlite3
import requests


base_url = "http://localhost:5000"  # Change the URL if your Flask server is running on a different address
db_worker_running=False
# Define the User class
class User:
    def __init__(self, id, username, email, organization, is_loggedin):
        self.id = id
        self.username = username
        self.email = email
        self.organization = organization
        self.is_loggedin = is_loggedin



class Backend(QObject):
    userReceived = Signal(str)
    userCreated = Signal(str)
    loginResult = Signal(bool, str)

    logoutSignal = Signal(bool)

    def __init__(self):
        super().__init__()


        # Initialize SQLite database connection
        self.db = sqlite3.connect('users.db',check_same_thread=False)

        self.cursor=self.db.cursor()

        # Create the users table if it doesn't exist
        self.create_table()
        

    def create_table(self):
    
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                username TEXT UNIQUE NOT NULL,
                email TEXT UNIQUE NOT NULL,
                organization TEXT UNIQUE NOT NULL,
                is_loggedin BOOLEAN DEFAULT FALSE
            )
        ''')
        self.db.commit()

    @Slot(str)
    def logout(self,username):
        print(f"loggin out {username}")
        # Implement logout functionality here
        # For example, clear session data, reset user state, etc.
        print("Logging out...")
        
        self.set_logged_in_false(username)

        self.logoutSignal.emit(True)


    @Slot()
    def startThread(self):
        # Create an instance of the worker
        if not db_worker_running:

            self.worker = DatabaseWorker(self.cursor,self.is_user_logged_in)

            # Connect signals and slots
            self.worker.userReceived.connect(self.userReceived)

            # Start the worker
            self.worker.start()
            
    @Slot()
    def start_app(self):
        start_application()

    @Slot(str, str, str, str,bool, bool)
    def create_user(self, username, email, organization, password,is_superuser, is_loggedin):

        # Create the worker instance
        self.create_worker = CreateUserWorker(username, email, organization, password,is_superuser, is_loggedin)

        # Connect the signal to a slot
        self.create_worker.userCreated.connect(self.userCreated)

        # Start the worker
        self.create_worker.start()


    @Slot(str, str, str)
    def login(self, username, password, organization):
        # Create a login worker instance
        self.login_worker = LoginWorker(username, password, organization)

        # Connect signals and slots
        self.login_worker.loginResult.connect(self.loginResult)

        # Start the worker
        self.login_worker.start()


    @Slot(str)
    def set_logged_in_false(self, username):
        cursor = self.db.cursor()
        cursor.execute('''
            UPDATE users
            SET is_loggedin = ?
            WHERE username = ?
        ''', (False, username))
        self.db.commit()

    def is_user_logged_in(self, username):
        cursor = self.db.cursor()
        cursor.execute('''
            SELECT is_loggedin FROM users WHERE username = ?
        ''', (username,))
        result = cursor.fetchone()
        if result:
            return result[0]
        else:
            return False


def get_user_location(ip_address):
    # API endpoint for IP Geolocation

    url = f"http://ip-api.com/json/{ip_address}"

    # Send a GET request to the API
    response = requests.get(url)
    
    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()
        
        # Extract relevant location information
        country = data.get('country', 'Unknown')
        city = data.get('city', 'Unknown')
        region = data.get('regionName', 'Unknown')
        
        # Return the user's location
        return f"{city}, {region}, {country}"
    else:
        # Request failed, return None
        return None
def get_user_ip():
    # Make a request to httpbin to get the user's IP address
    response = requests.get('https://httpbin.org/ip')
    if response.status_code == 200:
        data = response.json()
        user_ip = data.get('origin')
        return user_ip
    else:
        print("Failed to retrieve user's IP address.")
        return None
# Define a worker class to perform database operations in a separate thread


class DatabaseWorker(QThread):
    

    userReceived = Signal(str)

    def __init__(self,cursor,is_user_logged_in):
        global db_worker_running

        db_worker_running=True
        self.cursor = cursor
        self.is_user_logged_in=is_user_logged_in
        super().__init__()

    def run(self):
        global db_worker_running
        
        cursor = self.cursor
        cursor.execute("SELECT * FROM users LIMIT 1")

        row = cursor.fetchone()
        if row:
            user = {
                'id': row[0],
                'username': row[1],
                'email': row[2],
                'organization': row[3],
                'is_loggedin': row[4]

            }

            if self.is_user_logged_in(row[1]):
                ip=get_user_ip()
                if(ip):
                    location=get_user_location(ip)
                else:
                    location=None

                params = {
                    'username': row[1],
                    'organization': row[3],
                    'ip':ip,
                    'login_location':location
                }

                # Make a GET request to the endpoint
                response = requests.get(f"{base_url}/get-cloud-user", params=params)

                # Check if the request was successful (status code 200)
                if response.status_code == 200:
                    # Print the user data
                    user_data = response.json()

                    user_data = {"data": user_data, "status": 200}  # Wrap user data in a dictionary with the key "data"
                    json_user_data = json.dumps(user_data)  # Convert dictionary to JSON string
                    self.userReceived.emit(json_user_data)  # Emit the JSON string directly
                else:
                    # Print the error message
                    error_message = response.json().get('message', 'Unknown Error')

                    data = {"data": None, "message": f"{error_message} ", "status": 404}
                    json_data = json.dumps(data)  # Convert dictionary to JSON string
                    self.userReceived.emit(json_data)  # Emit the JSON string directly
            else:
                data = {"data": None, "message": f"{row[1]} Not logged in", "status": 404}
                json_data = json.dumps(data)  # Convert dictionary to JSON string
                self.userReceived.emit(json_data)  # Emit the JSON string directly
        else:
            data = {"data": None, "message": "No users found, login or signup please", "status": 404}
            json_data = json.dumps(data)  # Convert dictionary to JSON string
            self.userReceived.emit(json_data)  # Emit the JSON string directly
        
        db_worker_running=False


class CreateUserWorker(QThread):
    userCreated = Signal(str)
    
    def __init__(self, username, email, organization, password,is_superuser, is_loggedin):

        self.username = username
        self.email = email
        self.organization = organization
        self.password = password
        self.is_loggedin = is_loggedin
        self.is_superuser=is_superuser

        print(self.username)
        print(self.email)
        print(self.organization)
        print(self.password)
        print(self.is_loggedin)

       

        super().__init__()

    def run(self):
       
        
        # Define the endpoint
        endpoint = "/add-cloud-user"

        # Combine the base URL and endpoint
        url = base_url + endpoint

        # Define the data to send in the request body
        data = {
            "username": self.username,
            "organization": self.organization,
            "email": self.email,
            "password": self.password,
            "is_superuser":self.is_superuser
        }

        # Send a POST request to the endpoint with the data
        response = requests.post(url, json=data)

        # Check the response status code and content
        if response.status_code == 200:
            print("User added successfully")

            connection = sqlite3.connect('users.db', check_same_thread=False)
            cursor = connection.cursor()

            # Delete any existing user
            cursor.execute("DELETE FROM users")

            # Insert the new user
            cursor.execute('''
                INSERT INTO users (username, email, organization, is_loggedin)
                VALUES (?, ?, ?, ?)
            ''', (self.username, self.email, self.organization, self.is_loggedin))
            connection.commit()
            connection.close()

            # Emit signal with success message
            data = {"message": "User added successfully", "status": 200}
            self.userCreated.emit(json.dumps(data))

        elif response.status_code == 400:
            error_message = response.json().get('error', 'Unknown Error')
            print("Error:", error_message)

            # Emit signal with error message
            data = {"message": error_message, "status": 400}
            self.userCreated.emit(json.dumps(data))
        else:
            print("Unexpected error occurred")

            # Emit signal with unexpected error message
            data = {"message": "Unexpected error occurred", "status": 400}
            self.userCreated.emit(json.dumps(data))


class LoginWorker(QThread):
    loginResult = Signal(bool, str)

    def __init__(self, username, password, organization):
        super().__init__()
        self.username = username
        self.password = password
        self.organization = organization

    def run(self):
   
        # Define the endpoint URL
        endpoint = '/cloud-login'
        url = base_url + endpoint

        # Define the data to send in the request body
        data = {
            'username': self.username,
            'password': self.password,
            'organization': self.organization
        }

        # Send a POST request to the endpoint with the data
        response = requests.post(url, json=data)

        # Check the response status code and content
        if response.status_code == 200:
            print("Login successful")
            # Delete any existing user

            self.email=response.json().get("email")

            connection = sqlite3.connect('users.db', check_same_thread=False)
            cursor = connection.cursor()
            cursor.execute("DELETE FROM users")

            # Insert the new user
            cursor.execute('''
                INSERT INTO users (username, email, organization, is_loggedin)
                VALUES (?, ?, ?, ?)
            ''', (self.username, self.email, self.organization, True))
            connection.commit()
            connection.close()

            self.loginResult.emit(True, "Login successful")
        elif response.status_code == 401:
            print("Invalid username or password")
            self.loginResult.emit(False, "Invalid username or password")
        elif response.status_code == 404:
            print("User not found")
            self.loginResult.emit(False, "User not found")
        else:
            print("Unexpected error occurred")
            self.loginResult.emit(False, "Unexpected error occurred")

     
def start_application():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    backend = Backend()
    
    # Set the context properties
    engine.rootContext().setContextProperty("db_backend", backend)
    engine.rootContext().setContextProperty("backend", main)

    # Set App Extra Info
    app.setOrganizationName("Ruhmtech")
    app.setOrganizationDomain("N/A")

    # Set Icon
    app.setWindowIcon(QIcon("images/icon.ico"))

    # Load Initial Window
    engine.load(os.path.join(os.path.dirname(__file__), "qml/splashScreen.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

if __name__ == "__main__":
    start_application()
