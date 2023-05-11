from functools import wraps
from matplotlib.font_manager import json_load
import psycopg2
import datetime
from datetime import date
from application.database.volunteer import *
from application.database import volunteer
from psycopg2 import Error
import calendar
from datetime import datetime
from psycopg2.extensions import AsIs
from pytz import timezone


def handle_error(ret_on_error):
    def error(function):
        @wraps(function)
        def decorated(*args, **kwargs):
            try:
                return function(*args, **kwargs)
            except Exception as e:
                print(e)
                if (type(e) == psycopg2.InterfaceError):
                    args[0].__init__()
                    return function(*args, **kwargs)
                else:
                    return ret_on_error
        return decorated
    return error


class Database:
    def close_connection(self):
        """
        Close the connection to the database.
        """
        self.cursor.close()
        self.connection.close()
        print("PostgreSQL connection is closed")

    def query(self, cmd):
        """
        Execute a query on the database.
        @param cmd - the query to execute
        """
        try:
            self.cursor.execute(cmd)
        except (Exception, Error) as error:
            print("Error while Executing Command(", cmd, ")\nError: ", error)

    @handle_error(-44)
    def get_slot_volunteers(self, slot_id):
        # try:
        cmd = """select v.name as name, v.fcm_token as fcm_token
from slots as s, volunteer_slots as vs, volunteers as v
where s.slot_id = %s and 
s.slot_id = vs.slot_id and
vs.pes_id = v.pes_id;"""
        cursor = self.connection.cursor()

        cursor.execute(cmd, (str(slot_id), ))

        tuples = cursor.fetchall()
        result = []
        outputParams = ["name", "fcm_token"]
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = i[j]
            result.append(dic)
        return result
        # except Exception as e:
        #     print(e)
        #     return -44

    @handle_error(0)
    def create_volunteer(self, volunteer):
        """
        Create a new volunteer in the database.
        @param volunteer - the volunteer object
        @returns 1 if successful, 0 if not
        """
        cmd = "INSERT INTO %s (pes_id, password, name, phone, profession, email, address, pathshaala, status, joining_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        args = [AsIs('volunteers'), str(volunteer.PES_ID), str(volunteer.Password), str(volunteer.Name), str(volunteer.Phone), str(
            volunteer.Profession), str(volunteer.Email), str(volunteer.address), str(volunteer.Pathshaala), str(volunteer.Status), str(volunteer.joining_date)]
        # try:
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def update_token(self, pesId, token):
        """
        Update the token for a volunteer in the database.
        @param pesId - the pes id of the volunteer to update the token for.
        @param token - the new token for the volunteer.
        @returns 1 if the update was successful, 0 otherwise.
        """
        cmd = "UPDATE %s SET token = %s WHERE pes_id = %s;"
        args = [AsIs('volunteers'), token, pesId]
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except (Exception, Error) as error:
            print("Error: ", error)
            return 0

    @handle_error(False)
    def authenticate_token(self, pesId, token):
        """
        Authenticate the user's token with the database.
        @param pesId - the user's pes id
        @param token - the user's token
        @returns True if the token is valid, False otherwise
        """
        cmd = "SELECT token FROM %s WHERE pes_id = %s limit 1;"
        args = [AsIs('volunteers'), pesId]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        result = cursor.fetchone()
        if (result):
            user_data = {"token": result[0]}
            print(user_data)

            if (result[0] == token):
                return True
        else:
            return False

    @handle_error(False)
    def authenticate_admin_token(self, pesId, token):
        """
        Authenticate the admin token with the database.
        @param pesId - the pesId of the admin
        @param token - the token of the admin
        @returns True if the token is valid, False otherwise
        """
        cmd = "SELECT token FROM %s WHERE admin_id = %s limit 1;"
        args = [AsIs('admins'), str(pesId)]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        result = cursor.fetchone()
        if (result):
            user_data = {"token": result[0]}
            print(user_data)

            if (result[0] == token):
                return True
        else:
            return False

    @handle_error(0)
    def authenticate_volunteer(self, pesId, password):
        """
        Authenticate a volunteer.
        @param pesId - the pes id of the volunteer
        @param password - the password of the volunteer
        @returns 1 if the volunteer is authenticated, -1 if the password is incorrect, -2 if the pes id is incorrect, 0 if the volunteer is not found
        """
        cmd = "select * from %s where pes_id = %s;"
        args = [AsIs('volunteers'), str(pesId)]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        result = cursor.fetchone()
        if (result):
            if (result[1] == password):
                return 1
            else:
                return -1  # Incorrect Password
        else:
            return -2  # User Does not Exist

    @handle_error(0)
    def get_volunteer(self, pesId):
        """
        Get the volunteer data from the database.
        @param self - the database object itself
        @param pesId - the pes id of the volunteer
        @return the volunteer data
        """
        cmd = "SELECT * FROM %s WHERE pes_id = %s;"
        args = [AsIs('volunteers'), str(pesId)]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        result = cursor.fetchone()
        if (result):
            user_data = {"Name": result[2], "Phone": result[3], "Profession": result[4],
                         "Email": result[5], "Pathshaala": result[6], "Address": result[7]}
            # print(user_data)
            return user_data
        else:
            return -1

    @handle_error(0)
    def leaving(self, pesId):
        """
        Update the volunteers table to reflect that the volunteer has left. Also delete the           
        volunteer from the volunteer_slots table.
        @param self - the database object itself.
        @param pesId - the pes id of the volunteer.
        @return 1 if successful, 0 if not.
        """
        cmd = "update volunteers set status=\'Inactive\' where pes_id = %s;\n"
        cmd += "delete from volunteer_slots where pes_id = %s;"
        cmd += "delete from leaving_pehchaan where pes_id = %s;"
        cmd += "delete from slot_change where pes_id = %s;"
        cmd += "delete from admins where admin_id = %s;"

        args = [str(pesId), str(pesId), str(pesId), str(pesId), str(pesId)]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def volunteer_slots(self, pesId):
        """
        Get the volunteer slots for a particular pes_id.
        @param pesId - the pes_id of the volunteer
        @returns the slots for the volunteer
        """
        cmd = 'select s.*, sb.remarks from slots s,volunteer_slots vs, syllabus sb where vs.pes_id =%s' + \
            """and vs.slot_id = s.slot_id and sb.batch = s.batch order by day;"""
        cursor = self.connection.cursor()
        args = [str(pesId)]
        cursor.execute(cmd, args)
        outputParams = ['slot_id', 'pathshaala', 'batch', 'day',
                        'description', 'time_start', 'time_end', 'remarks', 'batch_remarks']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                if (j == 6 or j == 5):
                    dic[outputParams[j]] = i[j].strftime("%H:%M")
                else:
                    dic[outputParams[j]] = i[j]
            result.append(dic)
        return result

    @handle_error(-44)
    def all_slots(self,):
        """
        Get all the slots from the database.
        @returns the slots in the database
        """
        cmd = "select s.pathshaala, s.day, s.time_start, s.time_end, s.slot_id, s.remarks, s.batch, sb.remarks from slots s,days d, syllabus sb where sb.batch = s.batch and d.day = s.day order by d.id;"
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['pathshaala', 'day', 'time_start',
                        'time_end', 'slot_id', 'remarks', 'batch', 'batch_remarks']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                if (j == 2 or j == 3):
                    dic[outputParams[j]] = i[j].strftime("%H:%M")
                else:
                    dic[outputParams[j]] = i[j]
            result.append(dic)
        return result

    @handle_error(-44)
    def volunteer_slots_lists(self, pesId):
        lists = []
        cursor = self.connection.cursor()
        cmd = 'select slot_id from volunteer_slots where pes_id = %s;'
        args = [str(pesId)]
        cursor.execute(cmd, args)
        result = [r[0] for r in cursor.fetchall()]
        lists.append(result)
        cmd = 'select slot_id from slot_change where pes_id = %s;'
        args = [str(pesId)]
        cursor.execute(cmd, args)
        result = [r[0] for r in cursor.fetchall()]
        lists.append(result)

        all = self.all_slots()
        if (all == -44):
            return -44
        else:
            lists.append(all)
        return lists

    @handle_error(-44)
    def insert_slot_change(self, inputParams, pesId):  # To add items to slot_change
        """
        Insert the slot change into the database.
        @param inputParams - the input parameters dictionary
        @param pesId - the pes id
        @returns 1 if successful, -44 if not
        """
        slotids = inputParams['slot_id']
        # cursor=self.connection.cursor()
        args = [str(pesId)]
        cmd = "delete from slot_change where pes_id = %s;"
        for val in slotids:
            args.append(AsIs('slot_change'))
            args.append(str(pesId))
            args.append(str(val))
            cmd += "insert into %s values(%s, %s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-20)
    def delete_from_volunteers_slots(self, pes_id):
        args = [AsIs('volunteer_slots'), str(pes_id)]
        cmd = "DELETE FROM %s WHERE (pes_id=%s);"
        # cmd += "pes_id=\'" + str(pes_id) + "\'"
        # cmd += ");"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-23)
    def delete_from_slot_change(self, pes_id):
        args = [AsIs('slot_change'), str(pes_id)]
        cmd = "DELETE FROM %s WHERE (pes_id=%s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-24)
    def add_to_volunteer_slots(self, pes_id, slots_lst):  # slots_lst is a list
        cmd = ""
        args = []
        for slot in slots_lst:
            args.append(AsIs('volunteer_slots'))
            args.append(str(pes_id))
            args.append(str(slot))
            cmd += "insert into %s values(%s, %s);"
            # cmd = cmd + "\'" + str(pes_id) + '\','
            # cmd = cmd + "\'" + str(slot) + '\''
            # cmd = cmd + ");"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def accept_slot_change(self, pes_id):
        # Delete from volunteer_slots table
        delete_vol_slots = self.delete_from_volunteers_slots(pes_id)
        if (delete_vol_slots == -20):
            return -20

        # Get slots from slot_change table to be added to the volunteer_slots table
        get_slot_ids = self.get(["slot_id"], {"pes_id": pes_id}, "slot_change")
        if (len(get_slot_ids) == 0):
            return -21
        if (get_slot_ids == -44):
            return -22

        # delete from slot_change table
        delete_slot_change_slots = self.delete_from_slot_change(pes_id)
        if (delete_slot_change_slots == -23):
            return -23

        # add to the volunteer_slots_table
        slots_lst = []
        for slot in get_slot_ids:
            slots_lst.append(slot["slot_id"])
        add_vol_slot = self.add_to_volunteer_slots(pes_id, slots_lst)
        if (add_vol_slot == -24):
            return -24
        return 1

    @handle_error(-23)
    def delete_from_slot_change(self, pes_id):
        args = [AsIs('slot_change'), str(pes_id)]
        cmd = "DELETE FROM %s WHERE (pes_id=%s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-24)
    def add_to_volunteer_slots(self, pes_id, slots_lst):  # slots_lst is a list
        cmd = ""
        args = []
        for slot in slots_lst:
            args.append(AsIs('volunteer_slots'))
            args.append(str(pes_id))
            args.append(str(slot))
            cmd += "insert into %s values(%s, %s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def admin_slot_change(self, pes_id, slot_ids):
        try:
            cmd = "delete from slot_change where pes_id = %s; "
            cmd += "delete from volunteer_slots where pes_id = %s;"
            args = [pes_id, pes_id]
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            cmd = ''
            if (len(slot_ids) == 0):
                return 0
            args = []
            for slot in slot_ids:
                args.append(str(pes_id))
                args.append(str(slot))
                cmd += "insert into volunteer_slots values(%s, %s);\n"
                # cmd = cmd + "\'" + str(pes_id) + '\','
                # cmd = cmd + "\'" + str(slot) + '\''
                # cmd = cmd + ");\n"

            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -44

    @handle_error(-44)
    def reject_slot_change(self, pes_id):
        # Get slots from slot_change table to check
        get_slot_ids = self.get(["slot_id"], {"pes_id": pes_id}, "slot_change")
        if (len(get_slot_ids) == 0):
            return -21
        if (get_slot_ids == -44):
            return -22
        # delete from slot_change table
        delete_slot_change_slots = self.delete_from_slot_change(pes_id)
        if (delete_slot_change_slots == -23):
            return -23
        return 1

    @handle_error(-44)
    def set(self, inputParams, condition, table):
        """
        Set the values in the database.
        @param inputParams - the input parameters to set in the database.
        @param condition - the conditions to set in the database.
        @param table - the table to set the values in.
        @returns 1 if successful, -44 if not.
        """
        args = [AsIs(table)]
        cmd = "update %s set "
        for i in inputParams:
            args.append(AsIs(str(i)))
            args.append(str(inputParams[i]))
            cmd += "%s=%s, "
        cmd = cmd[:-2]

        if (len(condition) != 0):
            cmd += " where "

            for i in condition:
                args.append(AsIs(str(i)))
                args.append(str(condition[i]))
                cmd += "%s=%s and "
            cmd = cmd[:-5]
        cmd = cmd + ";"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def get(self, outputParams, inputParams, table):
        """
        Given a list of output parameters, input parameters, and a table, return a list of dictionaries containing the output parameters.
        @param outputParams - the output parameters           
        @param inputParams - the input parameters           
        @param table - the table           
        @return The list of dictionaries containing the output parameters           
        """
        args = []
        cmd = "select "
        for i in outputParams:
            args.append(AsIs(i))
            cmd += "%s, "
        cmd = cmd[:-2]
        args.append(AsIs(table))
        cmd += " from %s"  # + table

        if (inputParams != 0):
            cmd += " where "
            for i in inputParams:
                args.append(AsIs(str(i)))
                args.append(str(inputParams[i]))
                cmd += "%s=%s and "
            cmd = cmd[:-5]

        cmd += ";"
        cursor = self.connection.cursor()
        print("Here1")
        cursor.execute(cmd, args)
        print("Here")
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = i[j]
            result.append(dic)
        print("Here3", result)
        return result

    @handle_error(-44)
    def insert_application(self, inputParams):
        """
        Insert the application into the database.
        @param inputParams - the input parameters for the application
        @returns the status of the insert
        """
        check_key = self.get(["name", "phone"], {"phone": str(
            inputParams['phone'])}, "applications")
        if (len(check_key) >= 1):
            return -20
        args = [AsIs('applications'), str(inputParams['name']), str(inputParams['phone']), str(inputParams['profession']), str(
            inputParams['email']), str(inputParams['address']), str(inputParams['pathshaala']), str(inputParams['text1']), str(inputParams['text2'])]
        cmd = "insert into %s values(%s, %s, %s, %s, %s, %s, %s, %s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def remove_application(self, phone):
        check_key = self.get(["name", "phone"], {
                             "phone": str(phone)}, "applications")
        print('check1', check_key)
        if (len(check_key) == 0):
            return -20
        args = [AsIs('applications'), str(phone)]
        cmd = "DELETE FROM %s WHERE (phone=%s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def is_an_applicant(self, phone):
        """
        Check if the phone number is in the database. If it is, return 1. If not, return 0.
        @param phone - the phone number to check against the database.
        @return 1 if the phone number is in the database, 0 if not.
        """
        print('a')
        check_key = self.get(["name", "phone"], {
                             "phone": str(phone)}, "applications")
        print('b')
        print("check key", check_key)
        if (len(check_key) == 0):
            return 0
        else:
            return 1

    @handle_error(-44)
    def mark_attendance(self, pes_id, slot_id, remarks):
        """
        Mark the attendance of a volunteer for a particular slot.
        @param pes_id - the pes_id of the volunteer
        @param slot_id - the slot_id of the volunteer
        @param remarks - the remarks of the volunteer
        @returns the status of the request
        """
        cursor = self.connection.cursor()
        args = [AsIs('volunteer_slots'), pes_id, str(slot_id)]
        cmd = 'select slot_id from %s where pes_id = %s and slot_id = %s;'
        cursor.execute(cmd, args)
        if (cursor.fetchone()):
            args = [remarks, str(slot_id)]
            cmd = 'update slots set remarks = %s where batch = (select batch from slots where slot_id = %s);'
            # cursor.execute(cmd, args)
            today = date.today().strftime("%Y-%m-%d")
            args += [pes_id, today]
            cmd += 'select count(*) from slot_attendance where pes_id= %s and date= %s;'
            cursor.execute(cmd, args)
            if (cursor.fetchone()[0] != 0):
                return 400
            args = [AsIs('slot_attendance'), str(slot_id), pes_id, today]
            cmd = 'insert into %s values(%s, %s, %s);'
            cursor.execute(cmd, args)
            return 200
        else:
            return 404

    @handle_error(-44)
    def insert_leaving_application(self, pes_id, reason):
        """
        Insert a leaving application into the database. If the pes_id is already in the database, update the reason.
        @param pes_id - the pes_id of the leaving pehchaan
        @param reason - the reason for leaving
        @returns the status code of the insert/update
        """
        args = [AsIs('leaving_pehchaan'), str(pes_id)]
        cmd = 'select count(*) from %s where pes_id = %s;'
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        if (cursor.fetchone()[0] == 0):
            args = [AsIs('leaving_pehchaan'), str(pes_id), str(reason)]
            cmd = 'insert into %s values(%s, %s);'
            cursor.execute(cmd, args)
            return 1
        else:
            args = [AsIs('leaving_pehchaan'), str(reason), str(pes_id)]
            cmd = 'update %s set reason = %s where pes_id = %s;'
            return 400

    @handle_error(-44)
    def remove_leaving_application(self, pes_id):
        """
        Remove a leaving application from the database.
        @param pes_id - the pes_id of the leaving application           
        @return 1 if successful, -20 if the pes_id is not in the database, -44 if there is an error with the query.
        """
        check_key = self.get(
            ["pes_id"], {"pes_id": pes_id}, "leaving_pehchaan")
        # Check pes_id in leaving_pehchaan table
        if (len(check_key) == 0):
            return -20
        # Remove from the table
        args = [AsIs('leaving_pehchaan'), str(pes_id)]
        cmd = "DELETE FROM %s WHERE (pes_id=%s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)

        user = self.get(["status"], {"pes_id": pes_id}, "volunteers")
        if (user == -44 or len(user) == 0):  # Check if pesid is in the volunteers table
            return -21
        if (user[0]["status"] == "inactive"):  # Check if the status is inactive
            return -22
        return 1

    # This function is to add another slot (pathshaala, batch, day, description, time_start, time_end, remarks)
    @handle_error(-44)
    def add_slot(self, data):
        """
        Add a new slot to the database.
        @param data - the data to be added.
        @returns the result of the query.
        """
        args = [AsIs('slots'), str(data['pathshaala']), str(data['batch']), str(
            data['day']), "No description", str(data['time_start']), str(data['time_end']), " "]
        cmd = "INSERT INTO %s values (DEFAULT, %s, %s, %s, %s, %s, %s, %s);"
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -21

    # TO update the slot given the slot id
    @handle_error(-44)
    def edit_slot(self, data):
        """
        Edit a slot in the database.
        @param data - the data to be updated.
        @returns 1 if successful, -20 if the slot does not exist, -21 if the update failed.
        """
        check_slot_id = self.get(["slot_id", "pathshaala"], {
                                 "slot_id": data['slot_id']}, "slots")
        if (len(check_slot_id) == 0):
            return -20
        args = [AsIs('slots'), str(data['pathshaala']), str(data['batch']), str(data['day']), str(
            data['description']), str(data['time_start']), str(data['time_end']), str(data['remarks']), str(data['slot_id'])]
        cmd = "UPDATE %s SET "
        cmd += "pathshaala = %s, "
        cmd += "batch = %s, "
        cmd += "day = %s, "
        cmd += "description = %s, "
        cmd += "time_start = %s, "
        cmd += "time_end = %s, "
        cmd += "remarks = %s"
        cmd += " WHERE slot_id = %s;"
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -21

    # To delete a slot given the slot id
    @handle_error((-44, []))
    def delete_slot(self, data):
        lst = [[], []]
        for slot in data['slot_ids']:
            check_slot_id = self.get(["slot_id", "pathshaala"], {
                                     "slot_id": slot}, "slots")
            if (len(check_slot_id) == 0):
                lst[0].append(slot)
            else:
                cmd = "DELETE FROM %s WHERE (slot_id=%s);"
                cursor = self.connection.cursor()
                cursor.execute(cmd, (AsIs("slots"), slot))

                lst[1].append(slot)
        return 1, lst

    # To add a volunteer
    @handle_error(-44)
    def add_vol(self, data):
        """
        Add a volunteer to the database.
        @param data - the data to be added.
        @returns the status of the operation.
        """
        # try:
        check_pes_id = self.get(["pes_id", "name"], {
                                "pes_id": data['pes_id']}, "volunteers")
        if (len(check_pes_id) > 0):  # This pes id already exists
            return -20
        volunteer_obj = volunteer.volunteer(data['pes_id'], data['password'])
        volunteer_obj.Name = data['name']
        volunteer_obj.Phone = data['phone']
        volunteer_obj.Profession = data['profession']
        volunteer_obj.Email = data['email']
        volunteer_obj.address = data['address']
        volunteer_obj.Pathshaala = data['pathshaala']
        volunteer_obj.joining_date = data['joining_date']
        volunteer_obj.Status = 'Active'
        # Inserting it into the volunteers table
        x = self.create_volunteer(volunteer_obj)
        if (x == 0):
            return -44
        else:
            return 1

    # To edit a volunteer given the pesid
    @handle_error(-44)
    def edit_vol(self, data):
        check_slot_id = self.get(["pes_id", "name"], {
                                 "pes_id": data['pes_id']}, "volunteers")
        if (len(check_slot_id) == 0):  # doesnt exist
            return -20
        args = [AsIs('volunteers'), str(data['pes_id']), str(data['password']), str(data['name']), str(data['phone']), str(
            data['profession']), str(data['email']), str(data['pathshaala']), str(data['status']), str(data['address']), str(data['pes_id'])]
        cmd = "UPDATE %s SET "
        cmd += "pes_id = %s, "
        cmd += "password = %s, "
        cmd += "name = %s, "
        cmd += "phone = %s, "
        cmd += "profession = %s, "
        cmd += "email = %s, "
        cmd += "pathshaala = %s, "
        cmd += "status = %s, "
        cmd += "address = %s"
        cmd += " WHERE pes_id = %s;"
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -44

    # To delete a volunteer
    @handle_error(-44)
    def delete_vol(self, data):
        """
        Delete a volunteer from the database.
        @param data - the data to be deleted.
        @returns 1 if successful, -20 if the volunteer does not exist, -44 if there is an error.
        """
        check_slot_id = self.get(["pes_id", "name"], {
                                 "pes_id": data['pes_id']}, "volunteers")
        if (len(check_slot_id) == 0):  # doesnt exist
            return -20
        args = [AsIs('volunteers'), str(data['pes_id'])]
        cmd = "DELETE FROM %s WHERE (pes_id=%s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    def individual_attendance(self, pesID, cursor):
        """
        Count the number of times a volunteer has attended a slot in the past month.
        @param pesID - the pes_id of the volunteer
        @param cursor - the cursor to the database
        @returns the number of times the volunteer has attended a slot in the past month
        """
        cmd = '''select day from slots where slot_id in (select slot_id from volunteer_slots where
        pes_id = \''''+pesID+'''\');'''
        # cursor = self.connection.cursor()  #???
        cursor.execute(cmd)
        result1 = cursor.fetchall()
        result = []
        for i in range(len(result1)):
            result.append(result1[i][0])
        cal = calendar.Calendar()
        today1 = datetime.today().strftime('%Y%m%d')
        today1 = '2022-04-30'
        today = today1[::-1]
        today = int(today[:2][::-1])
        days = {0: "MONDAY", 1: "TUESDAY", 2: "WEDNESDAY",
                3: "THURSDAY", 4: "FRIDAY", 5: "SATURDAY", 6: 'SUNDAY'}
        c = 0
        total = 0
        for i in cal.itermonthdays(datetime.now(timezone('Asia/Kolkata')).year, datetime.now(timezone('Asia/Kolkata')).month):
            if (i != 0):

                if (days[c] in result):
                    total += 1
                if (i == today):
                    break
            c += 1
            c = c % 7
        print(pesID)
        print(total)
        if (total == 0):
            return [0, 0]
        month = datetime.now(timezone('Asia/Kolkata')).month
        if (month < 10):
            month = '0'+str(month)

        month = '04'
        cmd = 'select count(*) from slot_attendance where pes_id = \''+pesID+'\' and date <=\''+today1+'''\'
        and date>= \''''+str(datetime.now(timezone('Asia/Kolkata')).year)+"-"+str(month)+"-01\';"
        try:
            cursor.execute(cmd)
        except Exception as e:
            print(e)
            return [-44, -44]
        ans = cursor.fetchone()
        return [ans[0], total]

    @handle_error(-44)
    def all_vols_attendance(self, count):
        cmd = """select total_slots.*,a.name, a.pathshaala,a.profession, a.present from
            (select pes_id, sum(days_freq) as total_days
            from 
                (select pes_id, ar.arr[day_id+1] as days_freq 
                from (SELECT array """
        cmd += "%s"
        cmd += """ as arr)ar, 
                    (select v.pes_id as pes_id, kk.day_id as day_id 
        from volunteers as v full outer join (select vs.pes_id as pes_id,d.id as day_id from volunteer_slots as vs, slots as s, days as d
        where  vs.slot_id = s.slot_id and s.day = d.day)kk on v.pes_id = kk.pes_id where v.status = 'Active'
        )vd
                )vdays
            group by pes_id
            )total_slots,
            (
                select v.pes_id,v.name,v.pathshaala,v.profession, jj.present from volunteers v,
                (select pes_id,count(date) as present from 
                    (
                    select v1.pes_id,tt.date from volunteers v1 full outer join 
                        (select pes_id,date from slot_attendance where date < current_date and date >= current_date - extract(day from current_date)::int +1)tt
                        on v1.pes_id = tt.pes_id
                    )at group by pes_id
                )jj where jj.pes_id = v.pes_id
            )a
            where a.pes_id = total_slots.pes_id
        ;"""
        outputParams = ["pesId", "totalSlots", "name",
                        "pathshaala", "profession", "slotsAttended"]
        cursor = self.connection.cursor()
        args = [AsIs(str(count))]
        cursor.execute(cmd, args)
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                if (i[j] == None):
                    dic[outputParams[j]] = 0
                else:
                    dic[outputParams[j]] = i[j]
            result.append(dic)
        return result

    @handle_error(-44)
    def display_leaving_applications(self,):
        cmd = '''select kk.*, case when att.attend is null then 0 else att.attend end as attend from
        (select v.pes_id,v.name,v.pathshaala,l.reason from volunteers v,leaving_pehchaan l where v.pes_id = l.pes_id)kk
        left outer join (select pes_id,count(*) as attend from slot_attendance group by pes_id)att on att.pes_id = kk.pes_id
        ;'''
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        applications = cursor.fetchall()
        print(applications)
        outputParams = ["pes_id", "name", "pathshaala", "reason", "attend"]
        result = []
        for i in applications:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def add_batch(self, data):
        args = [AsIs('syllabus'), str(data['syllabus']), str(data['remarks'])]
        cmd = "INSERT INTO %s VALUES (DEFAULT, %s, %s);"
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def edit_batch(self, data):
        check_batch = self.get(["batch"], {"batch": data['batch']}, "syllabus")
        if (len(check_batch) == 0):
            return -20
        cmd = "UPDATE %s SET "
        cmd += "syllabus = %s, "
        cmd += "remarks = %s"
        cmd += " WHERE batch = %s;"
        cursor = self.connection.cursor()
        args = [AsIs('syllabus'), str(data['syllabus']),
                str(data['remarks']), str(data['batch'])]
        cursor.execute(cmd, (args))
        return 1

    @handle_error((-44, []))
    def delete_batch(self, data):
        cursor = self.connection.cursor()
        lst = [[], []]
        for batch in data['batches']:
            check_batch = self.get(["batch"], {"batch": batch}, "syllabus")
            if (len(check_batch) == 0):  # If the batch doesn't exist
                lst[0].append(batch)
            else:
                cmd = "DELETE FROM %s WHERE (batch=%s);"
                cursor.execute(cmd, (AsIs('syllabus'), batch))
                # cmd = "DELETE FROM %s WHERE (batch=%s);"
                # cursor.execute(cmd, (AsIs('slots'), batch))
                lst[1].append(batch)
        return 1, lst

    @handle_error(-44)
    def view_admin(self):
        get_admin_id = self.get(["admin_id"], 0, "admins")
        if (len(get_admin_id) == 0):
            return -20
        if (get_admin_id == -44):
            return -21

        result = []
        for admin in get_admin_id:
            get_admin_data = self.get(["name", "phone", "profession", "email", "pathshaala", "status", "address", "joining_date"], {
                                      "pes_id": admin["admin_id"]}, "volunteers")
            if (get_admin_data == -44):
                return -21
            result.append(get_admin_data)
        return result

# Student neeeds section
# Start here

    @handle_error(-44)
    def admin_student_needs(self):
        cmd = 'select * from student_needs order by pathshaala, post_time desc;'
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['id', 'data', 'pes_id','name',
                         'pathshaala', 'post_time']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def del_student_needs(self, id):
        cmd = 'delete from student_needs where n_id=%s;'
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def del_volunteer_slots(self, id):
        cmd = 'delete from volunteer_slots where slot_id=%s;'
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def admin_add_student_needs(self, pathshaala, data, Name, adminId):
        cmd = "insert into %s values(DEFAULT, %s, %s, %s, %s);"
        cursor = self.connection.cursor()
        args = [AsIs('student_needs'), data, adminId,  pathshaala, str(datetime.now(
            timezone('Asia/Kolkata')).strftime("%m-%d-%Y, %H:%M:%S"))]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def getPathshaala(self, pes_id):
        cmd = 'select pathshaala from volunteers where pes_id = %s;'
        cursor = self.connection.cursor()
        args = [pes_id]
        cursor.execute(cmd, args)
        return str(cursor.fetchall()[0][0])

    @handle_error(-44)
    def vol_student_needs(self, pes_id):
        pathshaala = self.getPathshaala(pes_id)
        cmd = 'select * from student_needs where pathshaala = %s order by post_time desc;'
        cursor = self.connection.cursor()
        args = [pathshaala]
        cursor.execute(cmd, args)
        outputParams = ['id', 'data', 'pes_id','name',
                        'pathshaala', 'post_time']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def add_student_needs(self, data, pes_id, name):
        pathshaala = self.getPathshaala(pes_id)
        cmd = "insert into %s values(DEFAULT, %s, %s,%s,%s, %s, %s);"
        cursor = self.connection.cursor()
        args = [AsIs('student_needs'), data, pes_id,name,  pathshaala, str(datetime.now(
            timezone('Asia/Kolkata')).strftime("%m-%d-%Y, %H:%M:%S"))]
        cursor.execute(cmd, args)
        return 1

# end here

    @handle_error(-44)
    def add_notif(self, title, data):
        cmd = 'insert into %s values(DEFAULT, %s, %s, %s);'
        cursor = self.connection.cursor()
        args = [AsIs('notifications'), title, data, str(datetime.now(
            timezone('Asia/Kolkata')).strftime("%m-%d-%Y, %H:%M:%S"))]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def admin_notifications(self):
        cmd = 'select * from notifications order by post_time desc;'
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['id', 'title', 'description', 'time']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def volunteer_notifications(self, pes_id):
        cursor = self.connection.cursor()
        cmd = '''select distinct notifications.*, case when kk.n_id is null then 0 else 1 end as read from notifications left outer join 
        (select * from new_notif where pes_id = %s)kk on kk.n_id = notifications.n_id order by post_time desc;'''
        args = [str(pes_id)]
        cursor.execute(cmd, args)
        outputParams = ['id', 'title', 'description', 'time', 'read']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def volunteer_notifications_check_unread(self, pes_id):
        cursor = self.connection.cursor()
        cmd = '''select count(read) from 
        (select notifications.*, case when kk.n_id is null then 0 else 1 end as read from notifications left outer join 
        (select * from new_notif where pes_id = %s)kk on kk.n_id = notifications.n_id 
        ) tt where tt.read = 0;'''
        args = [str(pes_id)]
        cursor.execute(cmd, args)
        tuples = cursor.fetchone()
        result = tuples[0]
        print(result, tuples)
        return result

    @handle_error(-44)
    def volunteer_notification_read(self, pes_id, n_id):

        cursor = self.connection.cursor()
        cmd = 'insert into %s values(%s, %s);'
        args = [AsIs('new_notif'), str(n_id), str(pes_id)]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def get_vol_info(self, lst):
        ans = []
        for vol in lst:
            name_profession = self.get(["name", "profession"], {
                                       "pes_id": vol["pes_id"]}, "volunteers")
            if (name_profession == -44):
                return -20
            if (len(name_profession) == 0):
                return -21
            dic = {"pes_id": vol["pes_id"],
                   "name": name_profession[0]["name"],
                   "profession": name_profession[0]["profession"]}
            ans.append(dic)
        return ans

    @handle_error(-44)
    # To check how many vols have joined since the beginning of the year
    def vol_count(self, today_date, first_day):
        cmd = "select count(*) from %s where joining_date <= %s and joining_date >= %s;"
        args = [AsIs('volunteers'), str(today_date), str(first_day)]
        cursor = self.connection.cursor()
        cursor.execute(cmd, args)
        res = cursor.fetchone()
        return res[0]

    def __init__(self):
        """
        Initialize the database connection.
        @param self - the database object itself
        """
        configs = json_load('application/database/config.json')
        usr = configs['user']
        password = configs['password']
        host = configs['host']
        port = configs['port']
        database = configs['database']
        self.connection = psycopg2.connect(user=usr,
                                           password=password,
                                           host=host,
                                           port=port,
                                           database=database)

        self.connection.autocommit = True

        # self.cursor = self.connection.cursor()
        print(self.connection.get_dsn_parameters(), "\n")

    # outreach handling

    @handle_error(-44)
    def add_topic(self, data):
        print(data)
        print("fkdfnds")
        args = [AsIs('outreach_topics'), str(data['title']),str(data['description']) ]
        cmd = "INSERT INTO %s values (DEFAULT, %s,%s);"
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -21

    @handle_error(-44)
    def delete_topic(self, id):
        cmd = 'delete from outreach_topics where n_id=%s;'
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def add_school(self, data):
        print(data)
        args = [AsIs('schools'), str(data['school']),str(data['address']) ]
        cmd = "INSERT INTO %s values (DEFAULT, %s,%s);"
        try:
            cursor = self.connection.cursor()
            cursor.execute(cmd, args)
            return 1
        except Exception as e:
            print(e)
            return -21

    @handle_error(-44)
    def delete_school(self, id):
        print(id)
        cmd = 'delete from schools where n_id=%s;'
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1
    @handle_error(-44)
    def admin_topics(self):
        cmd = 'select * from outreach_topics;'
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['n_id', 'title','description']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result
    
    @handle_error(-44)
    def admin_schools(self):
        cmd = 'select * from schools;'
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['n_id', 'school','address']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result
    
   
    @handle_error(-44)
    def admin_outreach(self):
        cmd = 'select * from volunteer_outreach_slots order by Date;'
        cursor = self.connection.cursor()
        cursor.execute(cmd)
        outputParams = ['pes_id', 'slot_id', 'school', 'topic', 'description',
                        'date', 'time_start', 'time_end', 'status', 'remarks']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result

    @handle_error(-44)
    def admin_reject_outreach(self, id):
        cmd = 'delete from volunteer_outreach_slots where slot_id=%s;'
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1

    @handle_error(-44)
    def admin_accept_outreach(self, id):
        print(id)
        cmd = "update  volunteer_outreach_slots set status='approved' where slot_id=%s ;"
        cursor = self.connection.cursor()
        args = [id]
        cursor.execute(cmd, args)
        return 1
    
    @handle_error(-44)
    def volunteer_outreach(self,pesId):
        cmd = 'select * from volunteer_outreach_slots where pes_id=%s order by Date;'
        cursor = self.connection.cursor()
        args = [pesId]
        
        cursor.execute(cmd,args)
        outputParams = ['pes_id', 'slot_id', 'school', 'topic', 'description',
                        'date', 'time_start', 'time_end', 'status', 'remarks']
        tuples = cursor.fetchall()
        result = []
        for i in tuples:
            dic = {}
            for j in range(len(outputParams)):
                dic[outputParams[j]] = str(i[j])
            result.append(dic)
        return result
    
    @handle_error(-44)
    def admin_add_outreach(self, pathshaala, data, Name, adminId):
        cmd = "insert into %s values(DEFAULT, %s, %s, %s, %s);"
        cursor = self.connection.cursor()
        args = [AsIs('student_needs'), data, adminId,  pathshaala, str(datetime.now(
            timezone('Asia/Kolkata')).strftime("%m-%d-%Y, %H:%M:%S"))]
        cursor.execute(cmd, args)
        return 1
    
    
    @handle_error(-44)
    def addoutreach(self,pesId, data):
        cmd = "INSERT INTO volunteer_outreach_slots VALUES (%s,DEFAULT, %s, %s,%s,%s,%s,%s,%s,%s);"
        args = [pesId,str(data['school']),str(data['topic']),str(data['description']),str(data['date']),str(data['time_start']),str(data['time_end']),'pending',str(data['remarks'])]
        
        cursor = self.connection.cursor()
        cursor.execute(cmd,args)
        return 1
