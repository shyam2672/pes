from flask import current_app, jsonify, make_response, request
from application import admin_auth
from datetime import datetime, timedelta
import numpy as np
from pytz import timezone

# Since we'd be using the same thing both the functions, I've made a utility function.

def util():
    try:
        z = datetime.now(timezone('Asia/Kolkata'))
        t = z - timedelta(days=z.day - 1)
        days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        count = []
        for i in days:
            count.append(np.busday_count(t.date(), z.date(), weekmask=i))
        #print(count)
        #print(datetime.now() - z)
        ### Check for errors
        vol_att = current_app.config['db'].all_vols_attendance(str(count))
        if vol_att == -44:
            return -1
        return vol_att
        if len(vol_att) == 0:
            return -2
        return vol_att
        
    except Exception as e:
        return -4

               
@admin_auth
def all_attendance(adminId):
    '''
        return {attendance : [
                {pesId: ***, name: ***, profession: ***, pathshaala: ***, totalSlots: ***, slotsAttended: ***}
                ]
            }
        '''
    try:
        ans = util()
        if ans == -1:
            responseObject = {
                    'status': 'failed',
                    'message': 'some error occured in getting attendance data',
                    }
            return make_response(jsonify(responseObject)), 400
        if ans == -2:
            responseObject = {
                    'status': 'failed',
                    'message': 'No volunteer',
                    }
            return make_response(jsonify(responseObject)), 400
        '''
        if ans == -3:
            responseObject = {
                    'status': 'failed',
                    'message': 'No name',
                    }
            return make_response(jsonify(responseObject)), 400
        '''
        if ans == -4:
            responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred in obtaining all-attendance.'
                    }
            return make_response(jsonify(responseObject)), 401
        else:
            responseObject = {
                    'status': 'success',
                    'message': 'Successful',
                    'attendance': ans,
                    }
            return make_response(jsonify(responseObject)), 201
    
    except Exception as e:
        print(e)
        responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred. Please try againd.'
                }
        return make_response(jsonify(responseObject)), 401


@admin_auth
def individual_attendance(adminId):
    try:
        ans = util()
        if ans == -1:
            responseObject = {
                    'status': 'failed',
                    'message': 'some error occured in getting attendance data',
                    }
            return make_response(jsonify(responseObject)), 400
        if ans == -2:
            responseObject = {
                    'status': 'failed',
                    'message': 'No volunteer',
                    }
            return make_response(jsonify(responseObject)), 400
        if ans == -3:
            responseObject = {
                    'status': 'failed',
                    'message': 'No name',
                    }
            return make_response(jsonify(responseObject)), 400
        if ans == -4:
            responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred in obtaining all-attendance.'
                    }
            return make_response(jsonify(responseObject)), 401

        data = request.get_json()
        id = data["pes_id"]
        result = {}
        
        for el in ans:
            if el["pesId"] == id:
                result = el
                break
        responseObject = {
                'status': 'success',
                'message': 'Successful',
                'attendance': result
                }
        return make_response(jsonify(responseObject)), 201
        
    except Exception as e:
        print(e)
        responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred. Please try again.'
                }
        return make_response(jsonify(responseObject)), 401