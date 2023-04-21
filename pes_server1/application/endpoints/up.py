from flask import current_app, request
from application import requires_auth
 
def up():
    return 'up 12:44'