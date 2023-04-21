from flask import current_app, jsonify, make_response, request
from application import admin_auth, requires_auth

@admin_auth
def admin_get_syllabus(adminId):
    try:
        syllabus = current_app.config['db'].get(['syllabus'], {'batch': request.get_json()['batch']}, 'syllabus')
        if syllabus == -44 or len(syllabus) == 0:
            responseObject = {
                    'status': 'failed',
                    'message': 'User Does not Exist',
                }
            return make_response(jsonify(responseObject)), 400
        print(syllabus)
        return {'status': 'OK', 'url': syllabus[0]['syllabus']}, 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401