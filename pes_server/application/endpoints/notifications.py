from datetime import datetime
from time import time
from flask import current_app, jsonify, make_response, request
from application import requires_auth
from datetime import datetime


@requires_auth
def get_notifications(pesId):
    try:
        notifs = current_app.config['db'].volunteer_notifications(pesId)
        if(notifs == -44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            print(notifs)
            responseObject = {
                'message': 'Success',
                'notifications': notifs
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401


@requires_auth
def mark_read(pesId):
    try:
        data = request.get_json()
        notifs = current_app.config['db'].volunteer_notification_read(
            pesId, data['id'])
        if(notifs == -44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'message': 'Success',
                'status': 'success'
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401


@requires_auth
def check_new(pesId):
    try:
        notifs = current_app.config['db'].volunteer_notifications_check_unread(
            pesId)
        if(notifs == -44):
            responseObject = {
                'status': 'failed',
                'message': 'An error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:
            responseObject = {
                'message': 'Success',
                'new_notifications': notifs != 0
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
