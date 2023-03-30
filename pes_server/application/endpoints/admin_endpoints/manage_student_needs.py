import json
from flask import current_app, jsonify, make_response, request
import requests
from application import admin_auth


@admin_auth
def admin_student_needs(adminId):
    try:
        retVal = current_app.config['db'].admin_student_needs()
        if(retVal == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:

            responseObject = {
                'status': 'success',
                'message': 'Student Needs',
                'student_needs': retVal
            }
            return make_response(jsonify(responseObject)), 200

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401


@admin_auth
def del_student_needs(adminId):
    try:
        data = request.get_json()
        needs = current_app.config['db'].del_student_needs(
            data['id'])
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




@admin_auth
def admin_add_student_needs(adminId):
    try:
        data = request.get_json()
        needs = current_app.config['db'].admin_add_student_needs(
            data['pathshaala'], data['data'], adminId)
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
