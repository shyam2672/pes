from application import init_app
from scheduler import Scheduler

app = init_app()
with app.app_context():
    app.config['scheduler'] = Scheduler(app)

if __name__ == "__main__":
    print('Started Server')
    app.run(host='172.30.8.213', port=5005)
