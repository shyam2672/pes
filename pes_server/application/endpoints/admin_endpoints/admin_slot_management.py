from flask import current_app, jsonify, make_response, request
from application import admin_auth

@admin_auth
def admin_slot_add(adminId):
    try:
        data = request.get_json()
        add_slot_return = current_app.config['db'].add_slot(data)
        if add_slot_return == -44 or add_slot_return == -21:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Slot has been added'
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
def admin_slot_edit(adminId):
    try:
        data = request.get_json()
        edit_slot_return = current_app.config['db'].edit_slot(data)
        if (edit_slot_return == -20):
            responseObject = {
                'status': 'failed',
                'message': 'This slot does not exist'
            }
            return make_response(jsonify(responseObject)), 401
        if edit_slot_return == -44 or edit_slot_return == -21:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Slot has been edited'
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
def admin_slot_delete(adminId):
    try:
        data = request.get_json()
        delete_slot_return, succ_fail = current_app.config['db'].delete_slot(data)
        if delete_slot_return == -44:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Slot has been deleted',
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
def all_slots(adminId):
    slots = current_app.config['db'].all_slots()
    if(slots == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Invalid Token',
        }
        return make_response(jsonify(responseObject)), 400
    else:
        retObj = {}
        retObj['status'] = 'success'
        retObj['message'] = 'All Slots'
        retObj['slots'] = slots
        return make_response(jsonify(retObj)), 201


@admin_auth
def accept_slot_change_request(adminId):
    try:
        data = request.get_json()
        accept = current_app.config['db'].admin_slot_change(data['pes_id'],data['slot_ids'])
        if (accept == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Error in accepting'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Slot change accepted',
            }
            return make_response(jsonify(responseObject)), 201
        '''
        if (accept == -20):
            responseObject = {
                'status': 'failed',
                'message': 'Error in deleting from volunteer_slots table'
            }
            return make_response(jsonify(responseObject)), 401
        if (accept == -21):
            responseObject = {
                'status': 'failed',
                'message': 'No slot available in requests'
            }
            return make_response(jsonify(responseObject)), 401
        
        if (accept == -22):
            responseObject = {
                'status': 'failed',
                'message': 'Error in getting slots'
            }
            return make_response(jsonify(responseObject)), 401

        if (accept == -23):
            responseObject = {
                'status': 'failed',
                'message': 'Error in deleting from slot_change table'
            }
            return make_response(jsonify(responseObject)), 401
        if (accept == -24):
            responseObject = {
                'status': 'failed',
                'message': 'Error in adding to volunteeer_slots table'
            }
            return make_response(jsonify(responseObject)), 401
        '''
        
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401 


@admin_auth
def reject_slot_change_request(adminId):
    try:
        data = request.get_json()
        reject = current_app.config['db'].reject_slot_change(data['pes_id'])
        if (reject == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Error in rejecting'
            }
            return make_response(jsonify(responseObject)), 401
        if (reject == -21):
            responseObject = {
                'status': 'failed',
                'message': 'No slot available in requests'
            }
            return make_response(jsonify(responseObject)), 401
        
        if (reject == -22):
            responseObject = {
                'status': 'failed',
                'message': 'Error in checking slots'
            }
            return make_response(jsonify(responseObject)), 401
        if (reject == -23):
            responseObject = {
                'status': 'failed',
                'message': 'Error in deleting from slot_change table'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'success',
                'message': 'Slot change rejected',
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
def view_slot_volunteers(adminId):  # This one would return all the volunteer in a given slot
    try:
        data = request.get_json()
        get_slot_vols = current_app.config['db'].get(["pes_id"], {"slot_id": data['slot']}, "volunteer_slots")
        if (len(get_slot_vols) == 0):  # if no volunteer
            responseObject = {
                'status': 'failed',
                'message': 'No volunteer with this slot id'
            }
            return make_response(jsonify(responseObject)), 401
        if (get_slot_vols == -44):  # if error in get function
            responseObject = {
                'status': 'failed',
                'message': 'Error in get volunteers'
            }
            return make_response(jsonify(responseObject)), 401
        # If there's no problem, then get name, profession of those pes_ids
        vol_data_lst = current_app.config['db'].get_vol_info(get_slot_vols)
        if (vol_data_lst == -20):
            responseObject = {
                'status': 'failed',
                'message': 'error in get function'
            }
            return make_response(jsonify(responseObject)), 401
        if (vol_data_lst == -21):
            responseObject = {
                'status': 'failed',
                'message': 'Volunteer ID does not exist'
            }
            return make_response(jsonify(responseObject)), 401
        if (vol_data_lst == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Error in getting volunteer data'
            }
            return make_response(jsonify(responseObject)), 401
        responseObject = {
            'status': 'success',
            'message': 'Got the volunteers',
            'volunteers': vol_data_lst
        }
        return make_response(jsonify(responseObject)), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401