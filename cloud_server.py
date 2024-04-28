from flask import Flask, request, jsonify
from pymongo import MongoClient
from werkzeug.security import generate_password_hash, check_password_hash
import datetime
from termcolor import colored
import colorama

colorama.init()

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017")

@app.route('/get-cloud-user')
def get_cloud_user():
    username = request.args.get('username')
    organization = request.args.get('organization')
    login_location = request.args.get('login_location')
    ip = request.remote_addr

    db = client[organization]  # Connect to the specified database

    collection_name = "users"  # Use the users collection

    collection = db[collection_name]

    # Query the database to find the user
    atlas_user = collection.find_one({"username": username})

    collection.update_one({"username": username}, {"$set": {"last_login": datetime.datetime.now(), "login_location": login_location, "ip": ip}})

    if atlas_user:
        user = {
            'username': atlas_user.get("username"),
            'email': atlas_user.get("email"),
            'organization': atlas_user.get("organization")
        }
        print(colored(f"User '{username}' accessed from IP: {ip} at {datetime.datetime.now()}", "green"))
        return jsonify(user), 200  # Return user data with status code 200 (OK)
    else:
        print(colored(f"User '{username}' not found in cloud. IP: {ip} at {datetime.datetime.now()}", "yellow"))
        return jsonify({'message': 'User not found in cloud'}), 404  # Return error message with status code 404 (Not Found)
    
@app.route("/add-cloud-user", methods=["POST"])
def add_user():
    # Extract data from request.args
    username = request.json.get("username")
    organization = request.json.get("organization")
    email = request.json.get("email")
    password = request.json.get("password")
    is_superuser = request.json.get("is_superuser")
    ip = request.remote_addr

    db_name = organization  # Variable for the database name
    db = client[db_name]  # Use the variable for the database
    collection_name = "users"  # Variable for the collection name
    collection = db[collection_name]  # Use the variable for the collection

    # Check if the username or email already exists
    if collection.find_one({"$or": [{"username": username}, {"email": email}, {"organization": organization}]}):
        print(colored(f"Failed to add user '{username}'. User already exists. IP: {ip} at {datetime.datetime.now()}", "red"))
        return jsonify({"error": "User already exists"}), 400

    # If username and email are unique, proceed to add the user
    if username and email and password:
        # Hash the password before storing it
        hashed_password = generate_password_hash(password)

        collection.insert_one({
            "username": username,
            "organization": organization,
            "email": email,
            "is_superuser": is_superuser,
            "password": hashed_password,  # Store the hashed password in the database
            "ip": ip  # Log the IP address
        })

        print(colored(f"User '{username}' added successfully. IP: {ip} at {datetime.datetime.now()}", "green"))
        return jsonify({"message": "User added successfully"}), 200
    else:
        print(colored(f"Invalid request to add user. IP: {ip} at {datetime.datetime.now()}", "yellow"))
        return jsonify({"error": "Invalid request"}), 400

@app.route('/cloud-login', methods=['POST'])
def login():
    # Get the username, password, and organization from the request JSON data
    data = request.json
    username = data.get('username')
    password = data.get('password')
    organization = data.get('organization')
    ip = request.remote_addr

    # Connect to MongoDB
    db = client[organization]  # Use the organization as the database name
    collection = db["users"]  # Use "users" collection

    # Query the database to find the user
    user = collection.find_one({"username": username})

    if user:
        # Check if the provided password matches the hashed password in the database
        if check_password_hash(user['password'], password):
            # Password is correct, return success message with status code 200
            print(colored(f"User '{username}' logged in successfully. IP: {ip} at {datetime.datetime.now()}", "green"))
            return jsonify({"success": True, "message": "Login successful", "email": user["email"]}), 200
        else:
            # Password is incorrect, return error message with status code 401
            print(colored(f"Invalid password for user '{username}'. IP: {ip} at {datetime.datetime.now()}", "red"))
            return jsonify({"success": False, "message": "Invalid username or password"}), 401
    else:
        # User not found, return error message with status code 404
        print(colored(f"User '{username}' not found. IP: {ip} at {datetime.datetime.now()}", "yellow"))
        return jsonify({"success": False, "message": "User not found"}), 404



if __name__ == "__main__":
    port=5000

    print(colored(f"[ {datetime.datetime.now()} ] Server started on port {port} ","green"))

    app.run(host="0.0.0.0",port=port)
