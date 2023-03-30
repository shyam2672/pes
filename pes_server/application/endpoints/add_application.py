from flask import current_app, jsonify, make_response, request
from application import database

def add_application():
    try:
        data = request.get_json()
        insert_return = current_app.config['db'].insert_application(data)
        if (insert_return == -20):
            responseObject = {
                'status': 'failed',
                'message': 'You have already applied.'
            }
            return make_response(jsonify(responseObject)), 401
        if(insert_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'successful',
                'message': 'inserted successfully'
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401