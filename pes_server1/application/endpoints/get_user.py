from flask import current_app, jsonify, make_response, request
from application import requires_auth

@requires_auth
def getUser(pesId):
    
    try:
        user = current_app.config['db'].get(["name", "pes_id", "token", "phone", "email","profession",
                            "pathshaala", "address", "status"], {"pes_id": pesId}, "volunteers")
        if(user == -44 or len(user) == 0 or user[0]["status"] == "inactive" or user[0]["token"] != request.headers.get("Authorization")):
            responseObject = {
                'status': 'failed',
                'message': 'Invalid Token',
            }
            return make_response(jsonify(responseObject)), 400
        else:
            user[0].pop("token")
            user[0]['status'] = 'success'
            user[0]['message'] = 'Successfully Logged In'
            return make_response(jsonify(user[0])), 201

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401