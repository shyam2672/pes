from flask import current_app, jsonify, make_response, request
from application.database import volunteer
from application import admin_auth


@admin_auth
def admin_vol_view(adminId):
    try:
        data = request.get_json()
        view_vol_return = current_app.config['db'].get(["pes_id", "name", "phone", "profession", "email", "address", "pathshaala","joining_date"], {"status": "Active","pes_id":data["pes_id"]}, "volunteers")
        if(view_vol_return == -44 or len(view_vol_return) == 0):
            responseObject = {
                'status': 'failed',
                'message': 'Error in getting volunteers',
            }
            return make_response(jsonify(responseObject)), 400
        if (len(view_vol_return) == 0):
            responseObject = {
                'status': 'failed',
                'message': 'No users exist',
            }
            return make_response(jsonify(responseObject)), 400
        else:
            view_vol_return[0]["joining_date"] = view_vol_return[0]["joining_date"].strftime("%d-%m-%Y")
            view_vol_return[0]["joining_date"] = str(view_vol_return[0]["joining_date"])
            print(view_vol_return[0]["joining_date"])
            responseObject = {
                'status': 'success',
                'message': 'Got all the volunteers',
                'Vols': view_vol_return
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
def admin_vol_add(adminId):
    try:
        data = request.get_json()
        add_vol_return = current_app.config['db'].add_vol(data)
        if add_vol_return == -20:
            responseObject = {
                'status': 'failed',
                'message': 'This PES ID already exists'
            }
            return make_response(jsonify(responseObject)), 401
        if add_vol_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Volunteer has been added'
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
def admin_vol_edit(adminId):
    try:
        data = request.get_json()
        edit_vol_return = current_app.config['db'].edit_vol(data)
        if (edit_vol_return == -20):
            responseObject = {
                'status': 'failed',
                'message': 'This PES ID does not exist'
            }
            return make_response(jsonify(responseObject)), 401
        if edit_vol_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Volunteer has been edited'
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
def admin_vol_delete(adminId):
    try:
        data = request.get_json()
        delete_vol_return = current_app.config['db'].delete_vol(data)
        if (delete_vol_return == -20):
            responseObject = {
                'status': 'failed',
                'message': 'This volunteer does not exist'
            }
            return make_response(jsonify(responseObject)), 401
        if delete_vol_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Volunteer has been deleted'
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
def admin_vol_attendance(adminId):
    try:
        #data = request.get_json()
        vol_return = current_app.config['db'].view_attendance()
        if vol_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'Attendance': vol_return
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401 

