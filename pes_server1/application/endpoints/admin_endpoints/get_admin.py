from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def get_admin(adminId):
    try:
        user = current_app.config['db'].get(["name", "pes_id", "token", "phone", "email", "pathshaala", "address", "status", "joining_date"], {"pes_id": adminId}, "volunteers")
        if(user == -44 or len(user) == 0):
            responseObject = {
                'status': 'failed',
                'message': 'Invalid Token',
            }
            return make_response(jsonify(responseObject)), 400
        if (user[0]["status"] == "inactive"):
            responseObject = {
                'status': 'failed',
                'message': 'Inactive',
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

@admin_auth
def admin_admin_view(adminId):
    try:
        get_admin_data = current_app.config['db'].view_admin()
        if (get_admin_data == -20):
            responseObject = {
                'status': 'failed',
                'message': 'No admin',
            }
            return make_response(jsonify(responseObject)), 400
        if (get_admin_data == -21):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occured',
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'status': 'success',
                'message': 'Got all the admins',
                'admins': get_admin_data
            }
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401 