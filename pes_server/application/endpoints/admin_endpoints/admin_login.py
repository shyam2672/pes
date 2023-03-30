from flask import current_app, jsonify, make_response, request
from application import requires_auth, encode_auth_token, decode_auth_token
# from application.database import db
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

    msg = """Subject: OTP for Pehchaan Admin\n\nDear Admin\n""" + otp + " is your OTP for Login."
    s = smtplib.SMTP('smtp.gmail.com', 587)  # Create an SMTP session
    s.starttls()  # start TLS for security
    s.login(senderid, senderpswd)  # Authentication by sender login
    s.sendmail('&&&&&&&&&&&', gmail, msg)  # send the mail
    #s.quit()  # Terminate the session

def login_as_admin():
    try:
        data = request.get_json()
        # verify the admin from admins table
        get_admin = current_app.config['db'].get(["admin_id"], {"admin_id": data["pesId"]}, "admins")
        if get_admin == -44 or len(get_admin) == 0:
            responseObject = {
                'status': 'failed',
                'message': 'Not an admin',
                }
            return make_response(jsonify(responseObject)), 400
        admin_pes_id = get_admin[0]["admin_id"]

        # get email from volunteers table
        get_mailid = current_app.config['db'].get(["Email", "status"], {"PES_ID": admin_pes_id}, "Volunteers")
        if get_mailid == -44 or len(get_mailid) == 0 or get_mailid[0]["status"] == "inactive":
            responseObject = {
                'status': 'failed',
                'message': 'Not a volunteer',
                }
            return make_response(jsonify(responseObject)), 401
        admin_email = get_mailid[0]["Email"]

        # send otp
        otp_generated = generateOTP()
        otp_thing.setOTP(admin_pes_id, otp_generated)
        sendOTP(admin_email, otp_generated)
        
        responseObject = {
                'status': 'success',
                'message': 'OTP has been sent',
                }
        return make_response(jsonify(responseObject)), 201

    except Exception as e:
        print(e)
        responseObject = {
                    'status': 'fail',
                    'message': 'Some error occurred. Please try againd.'
                }
        return make_response(jsonify(responseObject)), 401

        
def verifyWithOTP():
    # print(otp_thing.getOTP("1235"))
    #try:
    data = request.get_json()
    admin_pes_id = data["pesId"]

    ## Verifying the admin using their id
    is_valid_admin = utility_fun.isValidAdmin(admin_pes_id)
    if not is_valid_admin:
        return is_valid_admin
    
    ## Verifying the otp
    entered_otp = data["otp"]
    real_otp = otp_thing.getOTP(admin_pes_id)
    otp_time = otp_thing.getTimeGenerated(admin_pes_id)
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
        auth_token = encode_auth_token(admin_pes_id)
        #print(decode_auth_token(auth_token))
        if(auth_token == ""):
            responseObject = {
                'status': 'fail',
                'message': 'Some error occurred. Please try again.',
            }
            return make_response(jsonify(responseObject)), 402
        else:
            current_app.config['db'].set({"token": auth_token}, {"admin_id": admin_pes_id}, "admins")
            responseObject = {
                'status': 'success',
                'message': 'Successfully logged in',
                'token' : auth_token
                }
            return make_response(jsonify(responseObject)), 201
        

