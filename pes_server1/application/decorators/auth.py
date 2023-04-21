import datetime
import secrets
import jwt

secret_key = open("secret.key", "rb").readline()

def encode_auth_token(user_id):
    try:
        payload = {            
            'exp': datetime.datetime.utcnow() + datetime.timedelta(days=30),
            'iat': datetime.datetime.utcnow(),
            'sub': user_id
        }
        return jwt.encode(
            payload,
            secret_key,
            algorithm='HS256'
        )
    except Exception as e:
        print(e)
        return ""

def decode_auth_token(auth_token):
    try:
        print(auth_token)
        payload = jwt.decode(auth_token, secret_key, algorithms='HS256')
        return payload['sub']
    except jwt.ExpiredSignatureError:
        return 'Signature expired. Please log in again.'
    except jwt.InvalidTokenError:
        return 'Invalid token. Please log in again.'

def authorizeRequest(request):
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
