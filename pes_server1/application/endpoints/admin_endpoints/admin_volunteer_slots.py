from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def list_volunteers(adminId):
    try:
        list_return = current_app.config['db'].get(['pes_id','name','pathshaala'],{'status':'Active'},'volunteers')
        if(list_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'All Volunteers',
                'volunteers':list_return
            }
            return make_response(jsonify(responseObject)), 201
    except:
        responseObject = {
            'status': 'failed',
            'message': 'An error occurred. Please try again'
        }
        return make_response(jsonify(responseObject)), 401

@admin_auth
def list_slots(adminId):
    try:
        data = request.get_json()
        lists=current_app.config['db'].volunteer_slots_lists(str(data["pes_id"]))
        if(lists==-44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Success',
                'current':lists[0],
                'requested':lists[1],
                'all':lists[2]
            }
            return make_response(jsonify(responseObject)), 201


    except Exception as e:
        print(e)
        responseObject = {
            'status': 'failed',
            'message': 'An error occurred. Please try again'
        }
        return make_response(jsonify(responseObject)), 401
