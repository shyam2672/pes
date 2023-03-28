from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def admin_batch_add(adminId):
    try:
        data = request.get_json()
        add_batch_return = current_app.config['db'].add_batch(data)
        if (add_batch_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Error in adding a new batch'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Batch has been added'
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
def admin_batch_edit(adminId):
    try:
        data = request.get_json()
        edit_batch_return = current_app.config['db'].edit_batch(data)
        if (edit_batch_return == -20):
            responseObject = {
                'status': 'failed',
                'message': 'This batch does not exist'
            }
            return make_response(jsonify(responseObject)), 401
        if (edit_batch_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Error in editing the batch'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Batch has been edited'
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
def admin_batch_delete(adminId):
    try:
        data = request.get_json()
        delete_batch_return, succ_fail = current_app.config['db'].delete_batch(data)
        if delete_batch_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Batches have been deleted',
                'successful_deletion': succ_fail[1],
                'failed_deletion': succ_fail[0]
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
def admin_batch_view(adminId):
    try:
        get_batch = current_app.config['db'].get(["batch", "syllabus", "remarks"], 0, "syllabus")
        if (len(get_batch) == 0):
            responseObject = {
                'status': 'failed',
                'message': 'No batches in the database'
            }
            return make_response(jsonify(responseObject)), 401
        
        if (get_batch == -44):  # Some error
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'Success',
                'message': 'Got all the bitches',
                "applications":get_batch
            }
            return make_response(jsonify(responseObject)), 201
            
            
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401