from flask import current_app, current_app, jsonify, make_response, request
from application import requires_auth

@requires_auth
def leave_pehchaan_application(pesId):
    try:
        data = request.get_json()
        print(data)
        insert_return = current_app.config['db'].insert_leaving_application(
            pesId, data["reason"])
        if(insert_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        elif(insert_return == 1):
            responseObject = {
                'status': 'successful',
                'message': 'Submitted successfully'
            }
            return make_response(jsonify(responseObject)), 200
        else:
            responseObject = {
                'status': 'successful',
                'message': 'Updated info'
            }
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401

