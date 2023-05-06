from datetime import datetime
from time import time
from flask import current_app, jsonify, make_response, request
from application import requires_auth
from datetime import datetime


@requires_auth
def volunteer_getoutreach(pesId):
    print("rsdgsg");
    try:
        retVal = current_app.config['db'].volunteer_outreach(pesId)
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



    
@requires_auth
def volunteer_addoutreach(pesId):
    try:
        print("fefefef")
        data = request.get_json()
        needs = current_app.config['db'].addoutreach(pesId,
            data)
        if(needs == -44):
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
def volunteer_getschools(pesId):
    try:
        retVal = current_app.config['db'].admin_schools()
        if(retVal == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:

            responseObject = {
                'status': 'success',
                'message': 'all schools',
                'schools': retVal 
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
def volunteer_gettopics(pesId):
    try:
        retVal = current_app.config['db'].admin_topics()
        if(retVal == -44):
            responseObject = {
                'status': 'failed',
                'message': 'Some error occurred. Please try again.'
            }
            return make_response(jsonify(responseObject)), 400
        else:

            responseObject = {
                'status': 'success',
                'message': 'all topics',
                'topics': retVal 
            }
            return make_response(jsonify(responseObject)), 200
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401

    



# @requires_auth
# def add_student_needs(pesId):
#     try:
#         data = request.get_json()
#         needs = current_app.config['db'].add_student_needs(
#             data['data'], pesId)
#         if(needs == -44):
#             responseObject = {
#                 'status': 'failed',
#                 'message': 'An error occurred. Please try again.'
#             }
#             return make_response(jsonify(responseObject)), 400
#         else:
#             responseObject = {
#                 'message': 'Success',
#                 'status': 'success'
#             }
#             return make_response(jsonify(responseObject)), 200
#     except Exception as e:
#         print(e)
#         responseObject = {
#             'status': 'fail',
#             'message': 'Some error occurred. Please try again.'
#         }
#         return make_response(jsonify(responseObject)), 401
