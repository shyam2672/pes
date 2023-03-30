from flask import current_app, jsonify, make_response, request
from application import requires_auth

@requires_auth
def mark_attendance(pesId):
    try:
        data = request.get_json()
        result = current_app.config['db'].mark_attendance(
            pesId, data["slot_id"], data["remarks"])
        if(result == 200):
            responseObject = {'status': 'passed',
                                'message': 'Attendance Marked'}
            return make_response(jsonify(responseObject)), 200
        elif(result == 400):
            responseObject = {
                'status': 'failed', 'message': 'Attendance Already Marked! Remarks updated'}
            return make_response(jsonify(responseObject)), 201
        else:
            responseObject = {'status': 'failed', 'message': 'Error'}
            return make_response(jsonify(responseObject)), 401


    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401