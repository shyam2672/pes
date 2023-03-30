import json
from flask import current_app, jsonify, make_response, request
import requests
from application import encode_auth_token, decode_auth_token
from application.database import admin_database as ad_d
import math
import random
import smtplib
import time


class OTPCollection:
    def __init__(self):
        self.otpdict = {}
    def getOTP(self, pesId):
        return self.otpdict[pesId].otp
    def getTimeGenerated(self, pesId):
        return self.otpdict[pesId].time_generated
    def setOTP(self, pesId, otp):
        otp_unit = OTPUnit(otp)
        self.otpdict[pesId] = otp_unit

class OTPUnit:  # This structure will track the OTP and the time
    def __init__(self, otp):
        self.otp = otp
        self.time_generated = time.time()



otp_thing = OTPCollection()
utility_fun = ad_d.UtilityFun()


def generateOTP(): # This function will generate an otp to the given gmailID
    digits = "0123456789"
    OTP = ""
    for i in range(4):
        OTP += digits[math.floor(random.random()*10)]
    return OTP


def sendOTP(gmail, otp): # This function will send an otp to the given gmailID
    senderid = "pehchaantesting@gmail.com"
    # senderpswd = "!@#123qwe"
    senderpswd = "forwmufpzesiuwbh"
    msg = """Subject: OTP for Pehchaan Volunteer\n\nDear Volunteer\n""" + otp + " is your OTP for Pehchaan Volunteer App Login."
    s = smtplib.SMTP('smtp.gmail.com', 587)  # Create an SMTP session
    s.starttls()  # start TLS for security
    s.login(senderid, senderpswd)  # Authentication by sender login
    s.sendmail('&&&&&&&&&&&', gmail, msg)  # send the mail
    #s.quit()  # Terminate the session

def send_vol_otp():
    try:
        data = request.get_json()
        '''# verify the admin from admins table
        get_vol = current_app.config['db'].get(["pes_id"], {"pes_id": data["pesId"]}, "volunteers")
        if get_vol == -44 or len(get_vol) == 0:
            responseObject = {
                'status': 'failed',
                'message': 'Not a volunteer',
                }
            return make_response(jsonify(responseObject)), 400
        vol_pes_id = get_vol[0]["pes_id"]'''

        # get email from volunteers table
        get_mailid = current_app.config['db'].get(["Email", "status"], {"PES_ID": data["pesId"]}, "Volunteers")
        if get_mailid == -44 or len(get_mailid) == 0 or get_mailid[0]["status"] == "inactive":
            responseObject = {
                'status': 'failed',
                'message': 'Not a volunteer',
                }
            return make_response(jsonify(responseObject)), 400
        admin_email = get_mailid[0]["Email"]

        # send otp
        otp_generated = generateOTP()
        otp_thing.setOTP(data["pesId"], otp_generated)
        sendOTP(admin_email, otp_generated)
        
        responseObject = {
                'status': 'success',
                'message': 'OTP has been sent',
                }
        return make_response(jsonify(responseObject)), 201

    except Exception as e:
        print(e)
        responseObject = {
                    'error': str(e),
                    'status': 'fail',
                    'message': 'Some error occurred. Please try again.'
                }
        return make_response(jsonify(responseObject)), 401

        
def verify_vol_otp():
    # print(otp_thing.getOTP("1235"))
    #try:
    data = request.get_json()
    vol_pes_id = data["pesId"]

    ## Verifying the volunteer using their id
    get_vol = current_app.config['db'].get(["name", "pes_id", "password", "phone", "email", "pathshaala",
                           "address", "status"], {"PES_ID": vol_pes_id}, "Volunteers")
    if get_vol == -44 or len(get_vol) == 0 or get_vol[0]["status"] == "inactive":
        responseObject = {
            'status': 'failed',
            'message': 'Not a volunteer',
            }
        return make_response(jsonify(responseObject)), 401
    
    ## Verifying the otp
    entered_otp = data["otp"]
    real_otp = otp_thing.getOTP(vol_pes_id)
    otp_time = otp_thing.getTimeGenerated(vol_pes_id)
    current_time = time.time()
    # Check time difference
    if (current_time - otp_time > 600):
        responseObject = {
            'status': 'failed',
            'message': 'OTP expired',
            }
        return make_response(jsonify(responseObject)), 400
    # check valid otp
    if (entered_otp != real_otp):
        responseObject = {
            'status': 'failed',
            'message': 'Invalid OTP',
            }
        return make_response(jsonify(responseObject)), 401
    else:
        auth_token = encode_auth_token(vol_pes_id)
        #print(decode_auth_token(auth_token))
        if(auth_token == ""):
            responseObject = {
                'status': 'fail',
                'message': 'Some error occurred. Please try again.',
            }
            return make_response(jsonify(responseObject)), 402
        else:
            current_app.config['db'].set({"token": auth_token, "fcm_token": data["fcm_token"]}, {"pes_id": data["pesId"]}, "volunteers")
            get_vol[0].pop("password")
            get_vol[0]['status'] = 'success'
            get_vol[0]['message'] = 'Successfully Logged In'
            get_vol[0]['auth_token'] = auth_token

            return make_response(jsonify(get_vol[0])), 201
        


def push_notif(deviceToken):
    import requests
    import json

    url = "https://fcm.googleapis.com/fcm/send?="

    payload = json.dumps({
    "to": deviceToken,
    "priority": "high",
    "notification": {
        "title": "Title",
        "body": "First Notification",
        "text": "Text"
    }
    })
    headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAe4DTkIo:APA91bGbZHRz0myFIHnc7bTMhX4rtV4MP2k9G7KHClWHCxocbo4dYpSdNRoo5OURP3XcbWEeMxw8pBt2IRZMNEsDHWwy3fFGyZhrB590HsMzZRn10y1PB6KjmERp9W43QwOReRuJYdhN'
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    print(response.text)
    print(response.status_code)

    print(response.json())

    

def login():
    try:
        data = request.get_json()
        user = current_app.config['db'].get(["name", "pes_id", "password", "phone", "email", "pathshaala",
                           "address", "status"], {"pes_id": data["pesId"]}, "volunteers")
        print(user)
        if(user == -44 or len(user) == 0 or user[0]["status"] == "inactive"):
            responseObject = {
                'status': 'failed',
                'message': 'User Does not Exist',
            }
            return make_response(jsonify(responseObject)), 400
        elif(user[0]["password"] != data["password"]):
            responseObject = {
                'status': 'failed',
                'message': 'Wrong Password',
            }
            return make_response(jsonify(responseObject)), 401
        else:
            auth_token = encode_auth_token(data["pesId"])
            #print(decode_auth_token(auth_token))
            if(auth_token == ""):
                responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred. Please try again.'
                }
                return make_response(jsonify(responseObject)), 402
            else:
                current_app.config['db'].set({"token": auth_token, "fcm_token": data["fcm_token"]}, {
                             "pes_id": data["pesId"]}, "volunteers")

                user[0].pop("password")
                user[0]['status'] = 'success'
                user[0]['message'] = 'Successfully Logged In'
                user[0]['auth_token'] = auth_token
                return make_response(jsonify(user[0])), 201
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401