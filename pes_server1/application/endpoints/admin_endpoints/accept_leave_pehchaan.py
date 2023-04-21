from distutils.dir_util import remove_tree
from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def display_leaving_application(adminId):
    try:
        applications = current_app.config['db'].display_leaving_applications()
        if(applications==-44):
            responseObject = {
                    'status': 'failed',
                    'message': 'Could not fetch applications',
                }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                    'status': 'successful',
                    'message': 'List of applications',
                    'applications':applications
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
def status_inactive(adminId):
    try:
        data = request.get_json()
        # remove from leaving_pehchaan table
        remove_return = current_app.config['db'].remove_leaving_application(data["pesId"])
        # Check in leaving_volunteer table
        if (remove_return == -20): # The pesId isn't there in the leaving_pehchaan table
            responseObject = {
                'status': 'failed',
                'message': 'PES ID does not exist.'
            }
            return make_response(jsonify(responseObject)), 401
        if (remove_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
    
        # Check in the volunteer table
        if(remove_return == -21):
            responseObject = {
                'status': 'failed',
                'message': 'User Does not Exist',
            }
            return make_response(jsonify(responseObject)), 400
        elif (remove_return == -22):
            responseObject = {
                'status': 'failed',
                'message': 'User is already inactive',
            }
            return make_response(jsonify(responseObject)), 400
        else: # Change the status to inactive
            set_result = current_app.config['db'].set({"status": "inactive"}, {"pes_id": data["pesId"]}, "volunteers")
            if (set_result == -44):
                responseObject = {
                    'status': 'failed',
                    'message': 'Could not change the status',
                }
                return make_response(jsonify(responseObject)), 400
            else:
                responseObject = {
                    'status': 'Success',
                    'message': 'Status changed to inactive',
                }
                return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401

@admin_auth
def accept_application(adminId):
    try:
        data = request.get_json()
        remove_return = current_app.config['db'].leaving(data["pesId"])
        if(remove_return==-44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'status': 'Success',
                'message': 'Status changed to inactive',
            }
            return make_response(jsonify(responseObject)), 201
            
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
    
@admin_auth
def reject_leaving_pehchaan(adminId):
    try:
        data = request.get_json()
        # remove from leaving_pehchaan table
        remove_return = current_app.config['db'].remove_leaving_application(data["pesId"])
        # Check in leaving_volunteer table
        if (remove_return == -20): # The pesId isn't there in the leaving_pehchaan table
            responseObject = {
                'status': 'failed',
                'message': 'PES ID does not exist.'
            }
            return make_response(jsonify(responseObject)), 401
        if (remove_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
    
        # Check in the volunteer table
        if(remove_return == -21):
            responseObject = {
                'status': 'failed',
                'message': 'User Does not Exist',
            }
            return make_response(jsonify(responseObject)), 400
        elif (remove_return == -22):
            responseObject = {
                'status': 'failed',
                'message': 'User is already inactive',
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'status': 'Success',
                'message': 'Rejected and removed from the table',
            }
            return make_response(jsonify(responseObject)), 201

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401