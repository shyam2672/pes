from flask_apscheduler import APScheduler
import apscheduler
from pytz import timezone
import requests
import json
from flask import current_app
import datetime
import logging

logging.basicConfig()
logging.getLogger('apscheduler').setLevel(logging.DEBUG)


class Scheduler:
    server_key = "AAAAe4DTkIo:APA91bGbZHRz0myFIHnc7bTMhX4rtV4MP2k9G7KHClWHCxocbo4dYpSdNRoo5OURP3XcbWEeMxw8pBt2IRZMNEsDHWwy3fFGyZhrB590HsMzZRn10y1PB6KjmERp9W43QwOReRuJYdhN"
    fcm_url = "https://fcm.googleapis.com/fcm/send?="



    def __init__(self, server) -> None:
        self.server = server
        scheduler = APScheduler()
        scheduler.init_app(server)
        scheduler.start()
        self.refresh_slot_jobs()

    def refresh_slot_jobs(self):
        try:
            # self.send_notification("Admin", "/topics/all", "2342")
            current_app.apscheduler.delete_all_jobs()
            # current_app.apscheduler.add_job(func=self.send_notification, trigger='interval', args=["Bharat", "dVRDAdNTRfOGi_5WQL3ytf:APA91bFx1iXPuM18AHWwwM8J343gmhEOsn1yW5pz0vHTHPdASqGB39EPkLYaBfxBoOPWBfqcaKT5aYLpTecAEStbOIPk0_OG5gpPj5OSW6PxU-wF4Pw6zS44UNKkVFOV28logd7nleA4","10:00"], id='job', seconds=10)
            slots = current_app.config['db'].get(["slot_id", 'day', 'time_start'], 0, "slots")
            for slot in slots:
                slot_id = slot['slot_id']
            
                day = slot['day'].lower()[:3]
                time_start = slot['time_start']
                t = datetime.datetime.combine(date = datetime.date(30,1,1), time=time_start)
                t = t - datetime.timedelta(minutes=30)
                notif_time = t.time()          

                # print(day, notif_time)
                current_app.apscheduler.add_job(func=self.send_slot_notification, trigger='cron', day_of_week=day, args=[slot_id, day, time_start], id=str(slot_id), hour = notif_time.hour , minute=notif_time.minute, timezone = timezone('Asia/Kolkata'))
            jobs = current_app.apscheduler.get_jobs() 
            # for job in jobs:
            
            #     print(type(job))
        except Exception as e:
            print(e)

        

    def send_slot_notification(self, slot_id, day:str, time_start):
        try:
            volunteers = self.server.config['db'].get_slot_volunteers(slot_id)
            if(volunteers != -44):
                for volunteer in volunteers:
                    # print(volunteer)
                    self.send_notification(volunteer["name"], volunteer["fcm_token"], time_start)
        except Exception as e:
            print(e)


    def send_notification(self, volunteer_name, volunteer_fcm_token, slot_time:datetime.time):
        try:    
            # print(volunteer_fcm_token)
            if(volunteer_fcm_token == None):
                return 

            payload = json.dumps({
            "to": volunteer_fcm_token,
            "priority": "high",
            "notification": {
                "title": "Reminder for Upcoming Slot",
                "body":  f"Hi {volunteer_name}, You have an upcoming slot at {slot_time}",
                "text": "Slot Reminder"
            }
            })
            headers = {
            'Content-Type': 'application/json',
            'Authorization': 'key=' + self.server_key }
            response = requests.request("POST", self.fcm_url, headers=headers, data=payload)

            print(response.text)
        except Exception as e:
            print(e)

