from flask import Flask, redirect, request, jsonify
import connexion

from info import StorageRequest, StorageResponse, ErrorResponse

#Create the application with root as the swagger url
app = connexion.FlaskApp(__name__, specification_dir='./', options={"swagger_url": "/"})


@app.route('/issues', methods=['POST'])
def storage():
    # Check if API Key is provided in the header
    if 'x-webapi-key' not in request.headers:
        error_message = ErrorResponse("Unauthorized")
        return jsonify(error_message.__dict__), 401
    
    #Check if API Key is valid so that the request can be processed
    #Return code 403 if it is forbidden
    
    # Process the request body
    data = request.get_json()
    id = data.get('id')
    user = data.get('user')
    repository = data.get('repository')
    issueId = data.get('issueId')
    issueNumber = data.get('issueNumber')
    title = data.get('title')
    body = data.get('body')
    summary = data.get('summary')
    
    # Create StorageRequest object
    storage_request = StorageRequest(id, user, repository, issueId, issueNumber, title, body, summary)
    
    # Perform storage logic here
    # Add storage request to the database
    
    # Get the storage response from the database
    
    # Create StorageResponse object
    storage_response = StorageResponse(id, user, repository, issueId, issueNumber, title, body, summary)
    
    return jsonify(storage_response.__dict__), 200

if __name__ == '__main__':
    app.add_api("openapi-python.yaml")
    app.run(host='localhost', port=5053)
