from flask import current_app, jsonify, make_response, request
from application import requires_auth
from flask import current_app, Flask, jsonify, make_response, request

class UtilityFun:
    def isValidVolunteer(self, pes_id):
        get_status = current_app.config['db'].get(["status"], {"PES_ID": pes_id}, "Volunteers")
        if get_status == -44 or len(get_status) == 0 or get_status[0]["status"] == "inactive":
            responseObject = {
                'status': 'failed',
                'message': 'Not a volunteer',
                }
            return make_response(jsonify(responseObject)), 401
        else:
            return True

    def isValidAdmin(self, pes_id):
        # verify the admin from admins table
        get_admin = current_app.config['db'].get(["admin_id"], {"admin_id": pes_id}, "admins")
        if get_admin == -44 or len(get_admin) == 0:
            responseObject = {
                'status': 'failed',
                'message': 'Not an admin',
                }
            return make_response(jsonify(responseObject)), 400
        admin_pes_id = get_admin[0]["admin_id"]
        # verifying from volunteers
        if self.isValidVolunteer(admin_pes_id):
            return True
        else:
            return self.isValidVolunteer(admin_pes_id)