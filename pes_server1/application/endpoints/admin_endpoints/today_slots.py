from flask import current_app, jsonify, make_response, request
from application import admin_auth
from datetime import datetime

def weekdayToday():
    week_days_mapping = ["MONDAY", "TUESDAY","WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    day_ind = datetime.today().weekday()
    return week_days_mapping[day_ind]

@admin_auth
def volunteers_today(adminId):
    try:
        weekday = weekdayToday()
        # To get slotid, pathshaala, batch
        get_slotid_pthshla_batch = current_app.config['db'].get(["slot_id", "pathshaala", "batch"], {'day': weekday}, "slots")
        if (get_slotid_pthshla_batch == -44):
            responseObject = {
                    'status': 'failed',
                    'message': 'Error in getting slots',
                }
            return make_response(jsonify(responseObject)), 400

        
        pathshaala1 = []
        pathshaala2 = []
        for dic in get_slotid_pthshla_batch:
            # Now to get the pesid for every slotid
            get_pesid = current_app.config['db'].get(["pes_id"], {'slot_id': dic["slot_id"]}, "volunteer_slots")
            if (get_pesid == -44):
                responseObject = {
                        'status': 'failed',
                        'message': 'Error in getting pesid',
                    }
                return make_response(jsonify(responseObject)), 400
            
            # Get name for every pesid and make a result dictionary
            for i in get_pesid:
                pathshaal = int(dic["pathshaala"])
                vol_pes_id = i["pes_id"]
                get_names = current_app.config['db'].get(["name", "status"], {'pes_id': vol_pes_id}, "volunteers")
                # if volunteer isnt there
                if(get_names == -44 or len(get_names) == 0 or get_names[0]["status"] == "inactive"):
                    responseObject = {
                        'status': 'failed',
                        'message': 'User Does not Exist',
                    }
                    return make_response(jsonify(responseObject)), 400
                # otherwise
                temp_dic = {"pes_id": vol_pes_id, 
                            "name": get_names[0]["name"], 
                            "batch": dic["batch"]}
                if pathshaal == 1:
                    pathshaala1.append(temp_dic)
                else:
                    pathshaala2.append(temp_dic)
        responseObject = {
            'status': 'success',
            'message': 'Successful',
            'pathshaala1': pathshaala1,
            'pathshaala2': pathshaala2
        }
        return make_response(jsonify(responseObject)), 201

    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401