from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory user data store
users = {}

# Create a new user
@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    username = data.get('username')
    
    if not username:
        return jsonify({"error": "Username is required"}), 400
    if username in users:
        return jsonify({"error": "User already exists"}), 409
    
    users[username] = {
        "name": data.get("name"),
        "email": data.get("email"),
        "age": data.get("age")
    }
    return jsonify({"message": "User created", "user": users[username]}), 201

# Get user profile
@app.route('/users/<username>', methods=['GET'])
def get_user(username):
    user = users.get(username)
    if not user:
        return jsonify({"error": "User not found"}), 404
    return jsonify(user), 200

# Update user profile
@app.route('/users/<username>', methods=['PUT'])
def update_user(username):
    if username not in users:
        return jsonify({"error": "User not found"}), 404

    data = request.get_json()
    users[username].update({
        k: v for k, v in data.items() if k in ["name", "email", "age"]
    })
    return jsonify({"message": "User updated", "user": users[username]}), 200

# Delete user profile
@app.route('/users/<username>', methods=['DELETE'])
def delete_user(username):
    if username not in users:
        return jsonify({"error": "User not found"}), 404
    del users[username]
    return jsonify({"message": "User deleted"}), 200

if __name__ == '__main__':
    app.run(debug=True)
