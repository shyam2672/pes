import json
from flask import current_app, jsonify, make_response, request
import requests
from application import admin_auth


def send_broadcast_notification(title, description):
    server_key = "AAAAe4DTkIo:APA91bGbZHRz0myFIHnc7bTMhX4rtV4MP2k9G7KHClWHCxocbo4dYpSdNRoo5OURP3XcbWEeMxw8pBt2IRZMNEsDHWwy3fFGyZhrB590HsMzZRn10y1PB6KjmERp9W43QwOReRuJYdhN"
    fcm_url = "https://fcm.googleapis.com/fcm/send?="

    payload = json.dumps({
        "to": "/topics/all",
        "priority": "high",
        "notification": {
            "title": title,
            "body":  description,
            "text": "Notification from Admin"
        }
    })
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=' + server_key}

    response = requests.request("POST", fcm_url, headers=headers, data=payload)
    return int(response.status_code/100) == 2


@admin_auth
def add_notification(adminId):
    try:
        data = request.get_json()
        retVal = current_app.config['db'].add_notif(
            data['title'], data['description'])
        if(retVal == 1 and send_broadcast_notification(data['title'], data['description'])):
            responseObject = {
                'status': 'success',
                'message': 'Notification posted'
            }
            return make_response(jsonify(responseObject)), 200
        else:
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401


@admin_auth
def display_notifications(adminId):
    try:
        retVal = current_app.config['db'].admin_notifications()
        if(retVal == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:

            responseObject = {
                'status': 'success',
                'message': 'Notifications',
                'notifications': retVal
            }
            return make_response(jsonify(responseObject)), 200

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
