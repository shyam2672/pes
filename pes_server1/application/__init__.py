# hosted at https://pehchaan-ek-safar.herokuapp.com/

# TODO ADD MULTITHREADING
# TODO ADD MULTITHREADING
# TODO ADD MULTITHREADING
# TODO ADD MULTITHREADING

from asyncore import ExitNow
#from crypt import methods
#from crypt import methods
import datetime
from functools import wraps
from flask import current_app, Flask, current_app, jsonify, make_response, request
import jwt
from application.database import db
import sys
sys.path.append("..")
print(__name__)


def encode_auth_token(user_id):
    """
    Encode a user id into a JWT token.
    @param user_id - the user id to encode into a token
    @returns the encoded token
    """
    try:
        payload = {
            'exp': datetime.datetime.utcnow() + datetime.timedelta(days=30),
            'iat': datetime.datetime.utcnow(),
            'sub': user_id
        }
        return jwt.encode(
            payload,
            current_app.config.get('SECRET_KEY'),
            algorithm='HS256'
        )
    except Exception as e:
        print(e)
        return ""

def decode_auth_token(auth_token):
    try:
        # print(auth_token, current_app.config.get('SECRET_KEY'))
        payload = jwt.decode(auth_token, current_app.config.get(
            'SECRET_KEY'), algorithms='HS256')
        return payload['sub']
    except jwt.ExpiredSignatureError:
        return {"error":'Signature expired. Please log in again.'}
    except jwt.InvalidTokenError:
        return {"error":'Invalid token. Please log in again.'}

def authorizeRequest(request):
    """
    Authorize the request by checking the authorization header. If the token is valid, return the pesId. Otherwise, return an error.
    @param request - the request object
    @returns the pesId and the error if any
    """
    try:
        auth_token = request.headers.get('Authorization')
        if auth_token:
            pesId = decode_auth_token(auth_token)
            auth = current_app.config['db'].authenticate_token(pesId, auth_token)
            return auth, pesId
        else:
            return False, "Provide a valid Auth Token"
    except:
        return False, "Provide a valid Auth Token"

def requires_auth(function):
    """
    A decorator that requires the user to be authenticated.
    @param function - the function we are decorating.
    @returns the function with the authentication requirement.
    """
    @wraps(function)
    def decorated(*args, **kwargs):
        auth_token = request.headers.get("Authorization", None)
        if not auth_token:
            return ({"code": "authorization_header_missing",
                            "message":
                                "Authorization header is expected"}, 401)
        pesId = decode_auth_token(auth_token)
        if not(type(pesId) is str):
            return ({"code": "invalid_token",
                            "message":
                                pesId['error']}, 402)

        auth = current_app.config['db'].authenticate_token(pesId, auth_token)
        if not(auth):
             return ({"code": "invalid_token",
                            "message":
                                "Token is invalid"}, 402)
        return function(pesId)
    return decorated  

def admin_auth(function):
    """
    Decode the authorization token and return the pesId.
    @param auth_token - the authorization token
    @returns the pesId
    """
    @wraps(function)
    def decorated(*args, **kwargs):
        auth_token = request.headers.get("Authorization", None)
        if not auth_token:  # If the token isnt there
            return ({"code": "authorization_header_missing",
                            "message":
                                "Authorization header is expected"}, 401)
        pesId = decode_auth_token(auth_token)
        if not(type(pesId) is str):
            return ({"code": "invalid_token",
                            "message":
                                pesId['error']}, 402)

        auth = current_app.config['db'].authenticate_admin_token(pesId, auth_token)
        if not(auth):
             return ({"code": "invalid_token",
                            "message":
                                "Token is invalid"}, 402)
        return function(pesId)
    return decorated  

def init_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = open("application/secret.key", "rb").readline()
    app.config['db'] = db.Database()
    
    from application.endpoints import up
    app.add_url_rule('/up/', view_func=up.up)

    from application.endpoints import slots
    app.add_url_rule('/slot/del', view_func=slots.del_volunteer_slots, methods = ['POST']) 
    app.add_url_rule('/slots/', view_func=slots.get_volunteer_slots, methods = ['POST']) 
    app.add_url_rule('/slots/all/', view_func=slots.get_all_slots, methods = ['POST'])
    app.add_url_rule('/slots/change/', view_func=slots.add_slot_change, methods = ['POST'])

    from application.endpoints import get_user
    app.add_url_rule('/get_user/', view_func=get_user.getUser, methods = ['POST'])

    from application.endpoints import login
    app.add_url_rule('/login/', view_func=login.login, methods = ['POST'])
    app.add_url_rule('/login/otp/send/', view_func=login.send_vol_otp, methods = ['POST'])
    app.add_url_rule('/login/otp/verify/', view_func=login.verify_vol_otp, methods = ['POST'])

    from application.endpoints import add_application
    app.add_url_rule('/add_application/', view_func=add_application.add_application, methods = ['POST'])

    from application.endpoints import get_syllabus
    app.add_url_rule('/get_syllabus/', view_func=get_syllabus.get_syllabus, methods = ['POST'])

    from application.endpoints import mark_attendance
    app.add_url_rule('/mark_attendance/', view_func=mark_attendance.mark_attendance, methods = ['POST'])

    from application.endpoints import leave_pehchaan
    app.add_url_rule('/leave_pehchaan_application/', view_func=leave_pehchaan.leave_pehchaan_application, methods = ['POST'])

    from application.endpoints import notifications
    app.add_url_rule('/notifications/', view_func=notifications.get_notifications, methods = ["POST"])
    app.add_url_rule('/notifications/read/', view_func=notifications.mark_read, methods = ["POST"])
    app.add_url_rule('/notifications/new/', view_func=notifications.check_new, methods = ["POST"])
    
    from application.endpoints import student_needs
    app.add_url_rule('/student_needs/', view_func=student_needs.get_student_needs, methods = ["POST"])
    app.add_url_rule('/student_needs/add/', view_func=student_needs.add_student_needs, methods = ["POST"])
    

    #Admin Endpoints
    from application.endpoints.admin_endpoints import admin_login
    app.add_url_rule('/admin/register/otp/send/', view_func=admin_login.login_as_admin, methods = ['POST'])
    app.add_url_rule('/admin/register/otp/verify/', view_func=admin_login.verifyWithOTP, methods = ['POST'])

    from application.endpoints.admin_endpoints import admin_admin_management
    app.add_url_rule('/admin/admin/get/', view_func=admin_admin_management.get_admin, methods = ['POST'])
    app.add_url_rule('/admin/admin/view/', view_func=admin_admin_management.admin_admin_view, methods = ['POST'])
    
    from application.endpoints.admin_endpoints import accept_applicant
    app.add_url_rule('/admin/accept_applicant/', view_func=accept_applicant.check_applicant, methods = ['POST'])
    app.add_url_rule('/admin/view_applications/', view_func=accept_applicant.display_join_application, methods = ['POST'])
    
    from application.endpoints.admin_endpoints import accept_leave_pehchaan
    app.add_url_rule('/admin/leaving_application/accept/', view_func=accept_leave_pehchaan.accept_application, methods = ['POST'])
    app.add_url_rule('/admin/leaving_application/display/', view_func=accept_leave_pehchaan.display_leaving_application, methods = ['POST'])
    app.add_url_rule('/admin/leaving_application/reject/', view_func=accept_leave_pehchaan.reject_leaving_pehchaan, methods = ['POST'])

    from application.endpoints.admin_endpoints import admin_slot_management
    app.add_url_rule('/admin/slot/add/', view_func=admin_slot_management.admin_slot_add, methods = ['POST'])
    app.add_url_rule('/admin/slot/edit/', view_func=admin_slot_management.admin_slot_edit, methods = ['POST'])
    app.add_url_rule('/admin/slot/delete/', view_func=admin_slot_management.admin_slot_delete, methods = ['POST'])
    app.add_url_rule('/admin/slot/all/', view_func=admin_slot_management.all_slots, methods = ['POST'])
    app.add_url_rule('/admin/slot/change/accept/', view_func=admin_slot_management.accept_slot_change_request, methods = ['POST'])
    app.add_url_rule('/admin/slot/change/reject/', view_func=admin_slot_management.reject_slot_change_request, methods = ['POST'])
    app.add_url_rule('/admin/slot/view_volunteers', view_func=admin_slot_management.view_slot_volunteers, methods = ['POST'])


    from application.endpoints.admin_endpoints import admin_volunteer_changes
    app.add_url_rule('/admin/volunteer/view/', view_func=admin_volunteer_changes.admin_vol_view, methods = ['POST'])
    app.add_url_rule('/admin/volunteer/add/', view_func=admin_volunteer_changes.admin_vol_add, methods = ['POST'])
    app.add_url_rule('/admin/volunteer/edit/', view_func=admin_volunteer_changes.admin_vol_edit, methods = ['POST'])
    app.add_url_rule('/admin/volunteer/delete/', view_func=admin_volunteer_changes.admin_vol_delete, methods = ['POST'])

    from application.endpoints.admin_endpoints import today_slots
    app.add_url_rule('/admin/today_slots/', view_func=today_slots.volunteers_today, methods = ['POST'])

    from application.endpoints.admin_endpoints import vol_attendance
    app.add_url_rule('/admin/all_vol_attendance/', view_func=vol_attendance.all_attendance, methods = ['POST'])
    app.add_url_rule('/admin/individual_vol_attendance/', view_func=vol_attendance.individual_attendance, methods = ['POST'])

    from application.endpoints.admin_endpoints import admin_batch_management
    app.add_url_rule('/admin/batch/add/', view_func=admin_batch_management.admin_batch_add, methods = ['POST'])
    app.add_url_rule('/admin/batch/edit/', view_func=admin_batch_management.admin_batch_edit, methods = ['POST'])
    app.add_url_rule('/admin/batch/delete/', view_func=admin_batch_management.admin_batch_delete, methods = ['POST'])
    app.add_url_rule('/admin/batch/view/', view_func=admin_batch_management.admin_batch_view, methods = ['POST'])

    from application.endpoints.admin_endpoints import admin_volunteer_slots
    app.add_url_rule('/admin/volunteer_slots/list_volunteers/', view_func=admin_volunteer_slots.list_volunteers, methods = ['POST'])
    app.add_url_rule('/admin/volunteer_slots/volunteer/', view_func=admin_volunteer_slots.list_slots, methods = ['POST'])
    
    from application.endpoints.admin_endpoints import notification_management
    app.add_url_rule('/admin/notifications/add/',view_func=notification_management.add_notification,methods=['POST'])
    app.add_url_rule('/admin/notifications/view/',view_func=notification_management.display_notifications,methods=['POST'])
    
    from application.endpoints.admin_endpoints import admin_syllabus
    app.add_url_rule('/admin/get_syllabus/', view_func=admin_syllabus.admin_get_syllabus, methods = ['POST'])

    from application.endpoints.admin_endpoints import manage_student_needs
    app.add_url_rule('/admin/student_needs/', view_func=manage_student_needs.admin_student_needs, methods = ['POST'])
    app.add_url_rule('/admin/student_needs/del', view_func=manage_student_needs.del_student_needs, methods = ['POST'])
    app.add_url_rule('/admin/student_needs/add', view_func=manage_student_needs.admin_add_student_needs, methods = ['POST'])
  
    from application.endpoints.admin_endpoints import outreach_management
    app.add_url_rule('/admin/getoutreachslots/', view_func=outreach_management.admin_getoutreach, methods = ['POST'])
    app.add_url_rule('/admin/outreach/reject', view_func=outreach_management.admin_reject, methods = ['POST'])
    app.add_url_rule('/admin/outreach/accept', view_func=outreach_management.admin_accept, methods = ['POST'])
    app.add_url_rule('/admin/getschools/', view_func=outreach_management.admin_getschools, methods = ['POST'])


    return app
