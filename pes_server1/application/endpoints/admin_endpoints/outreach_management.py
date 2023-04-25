from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def admin_topic_add(adminId):
    try:
        data = request.get_json()
        add_topic_return = current_app.config['db'].add_topic(data)
        if add_topic_return == -44 or add_topic_return == -21:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'topic has been added'
            }
            current_app.config["scheduler"].refresh_slot_jobs()
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'An error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 400


@admin_auth
def admin_topic_delete(adminId):
    try:
        data = request.get_json()
        delete_slot_return, succ_fail = current_app.config['db'].delete_topic(data['id'])
        if delete_slot_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'topic has been deleted',
                'successful_deletion': succ_fail[1],
                'failed_deletion': succ_fail[0]
            }
            current_app.config["scheduler"].refresh_slot_jobs()
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401 

@admin_auth
def admin_school_add(adminId):
    try:
        data = request.get_json()
        add_topic_return = current_app.config['db'].add_school(data)
        if add_topic_return == -44 or add_topic_return == -21:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'school has been added'
            }
            current_app.config["scheduler"].refresh_slot_jobs()
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'An error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 400


@admin_auth
def admin_school_delete(adminId):
    try:
        data = request.get_json()
        delete_slot_return, succ_fail = current_app.config['db'].delete_school(data['id'])
        if delete_slot_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'school has been deleted',
                'successful_deletion': succ_fail[1],
                'failed_deletion': succ_fail[0]
            }
            current_app.config["scheduler"].refresh_slot_jobs()
            return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401

@admin_auth
def admin_getoutreach(adminId):
    try:
        retVal = current_app.config['db'].admin_outreach()
        if(retVal == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:

            responseObject = {
                'status': 'success',
                'message': 'all outreach slots',
                'outreach': retVal
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
def admin_reject(adminId):
    data = request.get_json()
    slots = current_app.config['db'].admin_reject_outreach(data['id'])
    if(slots == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Invalid Token',
        }
        return make_response(jsonify(responseObject)), 400
    else:
        retObj = {}
        retObj['status'] = 'success'
        retObj['message'] = 'slot rejected'
        
        return make_response(jsonify(retObj)), 201
    
@admin_auth
def admin_accept(adminId):
    data = request.get_json()
    slots = current_app.config['db'].admin_accept_outreach(data['id'])
    if(slots == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Invalid Token',
        }
        return make_response(jsonify(responseObject)), 400
    else:
        retObj = {}
        retObj['status'] = 'success'
        retObj['message'] = 'slot accepted'
        return make_response(jsonify(retObj)), 201

    
    