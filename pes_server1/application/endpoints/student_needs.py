from datetime import datetime
from time import time
from flask import current_app, jsonify, make_response, request
from application import requires_auth
from datetime import datetime


@requires_auth
def get_student_needs(pesId):
    try:
        needs = current_app.config['db'].vol_student_needs(pesId)
        if(needs == -44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            print(needs)
            responseObject = {
                'message': 'Success',
                'student_needs': needs
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401


@requires_auth
def add_student_needs(pesId):
    try:
        data = request.get_json()
        needs = current_app.config['db'].add_student_needs(
            data['data'], pesId)
        if(needs == -44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'message': 'Success',
                'status': 'success'
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
