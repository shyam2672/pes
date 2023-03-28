from flask import current_app, jsonify, make_response, request
from application import requires_auth

@requires_auth
def get_volunteer_slots(pesId):
    slots = current_app.config['db'].volunteer_slots(pesId)
    if(slots == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Invalid Token',
        }
        return make_response(jsonify(responseObject)), 400
    else:
        retObj = {}
        retObj['status'] = 'success'
        retObj['message'] = 'Volunteer Slots'
        retObj['slots'] = slots
        return make_response(jsonify(retObj)), 201

@requires_auth
def get_all_slots(pesId):
    slots = current_app.config['db'].all_slots()
    if(slots == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Some Error Occured',
        }
        return make_response(jsonify(responseObject)), 400
    else:
        retObj = {}
        retObj['status'] = 'success'
        retObj['message'] = 'All Slots'
        retObj['slots'] = slots
        return make_response(jsonify(retObj)), 201

@requires_auth
def add_slot_change(pesId):
    try:
        # Inserting slot change data
        data = request.get_json()
        insert_return = current_app.config['db'].insert_slot_change(data, pesId)
        if (insert_return == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again'
            }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                'status': 'successful',
                'message': 'SlotChanged'
            }
            return make_response(jsonify(responseObject)), 200

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401




