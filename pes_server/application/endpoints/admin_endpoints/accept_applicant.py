import smtplib
from flask import current_app, jsonify, make_response, request
import application
from application.database import volunteer
from application import admin_auth
import random
from datetime import date

def remove_applicant(phone):
    remove_return = current_app.config['db'].remove_application(phone)
    print(remove_return)
    if (remove_return == -20): # The phone isn't there in the applications table
        responseObject = {
            'status': 'failed',
            'message': 'Phone number does not exist.'
        }
        return make_response(jsonify(responseObject)), 401
    if (remove_return == -44):
        responseObject = {
            'status': 'failed',
            'message': 'Some error occurred. Please try again'
        }
        return make_response(jsonify(responseObject)), 401
    else:
        return 1

def generatePES():
    x = "PES"
    current_year = str(date.today().year)
    year_last_two_digits = current_year[-2: ]
    x += year_last_two_digits
    x += "R"
    today = date.today()
    first_day = date(date.today().year, 1, 1)
    count_vols = current_app.config['db'].vol_count(today, first_day)
    if (count_vols == -44):
        return -44
    count_vols += 1
    if (count_vols < 10):
        x += "00" + str(count_vols)
    elif (count_vols < 100):
        x += "0" + str(count_vols)
    else:
        x += str(count_vols)
    return x


def sendEmail(gmail, name, pes_id, accepted): # This function will send an otp to the given gmailID
    senderid = "pehchaantesting@gmail.com"
    # senderpswd = "!@#123qwe"
    senderpswd = "forwmufpzesiuwbh"
    msg = ""
    if(accepted):
        msg = """Subject: Application Accepted\n\nDear """ + name + """\nYour Application for becoming a Pehchaan Volunteer has been acceped. Your Pes ID is """ + pes_id + """
You can now login in the app using this Pes Id"""
    else:
        msg = """Subject: Application Rejected\n\nDear """ + name + """\nYour Application for becoming a Pehchaan Volunteer has been Rejected. Contact Pehchaan Admininstration for more information"""
    s = smtplib.SMTP('smtp.gmail.com', 587)  # Create an SMTP session
    s.starttls()  # start TLS for security
    s.login(senderid, senderpswd)  # Authentication by sender login
    s.sendmail('&&&&&&&&&&&', gmail, msg)  # send the mail
    #s.quit()  # Terminate the session
 

@admin_auth
def check_applicant(pesId):
    try:
        data = request.get_json()
        if data['response'] == "accept":

            ## Checking if the applicant exists
            is_applicant = current_app.config['db'].is_an_applicant(data['phone'])
            print(is_applicant)
            if is_applicant == 0:  # phone doesn't exist in applications
                responseObject = {
                    'status': 'failed',
                    'message': 'Phone number does not exist.'
                }
                return make_response(jsonify(responseObject)), 401
            if (is_applicant == -44):  # Some error
                responseObject = {
                    'status': 'failed',
                    'message': 'Some error occurred. Please try again'
                }
                return make_response(jsonify(responseObject)), 401
            ## Otherwise
            ## Insert it into volunteers table
            applicant = current_app.config['db'].get(["name", "phone", "profession", "email", "address", "pathshaala"], {"phone": data['phone']}, "applications")
            pwd = "hello"
            # Assigning all the values
            pes_id_generated = generatePES()
            if (pes_id_generated == -44):
                responseObject = {
                    'status': 'failed',
                    'message': 'Error in getting count while generating PES'
                }
                return make_response(jsonify(responseObject)), 400

            volunteer_obj = volunteer.volunteer(pes_id_generated, pwd)
            volunteer_obj.Name = applicant[0]["name"]
            volunteer_obj.Phone = applicant[0]["phone"]
            volunteer_obj.Profession = applicant[0]["profession"]
            volunteer_obj.Email = applicant[0]["email"]
            volunteer_obj.address = applicant[0]["address"]
            volunteer_obj.Pathshaala = applicant[0]["pathshaala"]
            volunteer_obj.joining_date = date.today()
            # Inserting it into the volunteers table
            x = current_app.config['db'].create_volunteer(volunteer_obj)
            if (x == 0):
                responseObject = {
                    'status': 'failed',
                    'message': 'Could not add to volunteers'
                }
                return make_response(jsonify(responseObject)), 400

            ## Remove from the application table
            x = remove_applicant(data['phone'])
            if (x == 1):  # Successful removal
                sendEmail(applicant[0]["email"], applicant[0]["name"], pes_id_generated, True)
                responseObject = {
                    'status': 'successful',
                    'message': 'Accepted and removed from applicants'
                }
                return make_response(jsonify(responseObject)), 200
            else:
                return x


        else: #elif data['response'] == "reject":
            applicant = current_app.config['db'].get(["name", "phone", "profession", "email", "address", "pathshaala"], {"phone": data['phone']}, "applications")
            x = remove_applicant(data['phone'])
            if (x == 1):  # Successful removal
                sendEmail(applicant[0]["email"], applicant[0]["name"], "", False)
                responseObject = {
                    'status': 'successful',
                    'message': 'Rejected and removed from applicants'
                }
                return make_response(jsonify(responseObject)), 200
            else:
                return x
                
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
        
        
    

@admin_auth
def display_join_application(adminId):
    try:
        applications = current_app.config['db'].get(["name","phone","profession","email","address","pathshaala","text1","text2"],0,"applications")
        if (applications == -44):  # Some error
                responseObject = {
                    'status': 'failed',
                    'message': 'An error occurred. Please try again'
                }
                return make_response(jsonify(responseObject)), 401
        else:
                responseObject = {
                    'status': 'Succes',
                    'message': 'Join applications',
                    "applications":applications
                }
                return make_response(jsonify(responseObject)), 201
            
            
    except Exception as e:
        print(e)
        responseObject = {
            'status': 'fail',
            'message': 'Some error occurred. Please try again.'
        }
        return make_response(jsonify(responseObject)), 401
    