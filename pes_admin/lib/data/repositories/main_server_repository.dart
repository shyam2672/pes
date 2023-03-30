import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pes_admin/data/models/batches.dart';
import 'package:pes_admin/data/models/join_application.dart';
import 'package:pes_admin/data/models/leave_applications.dart';
import 'package:pes_admin/data/models/notifications.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/models/volunteer_attendance.dart';

import '../models/studentNeeds.dart';

class MainRepository {
  final baseUrl = "http://172.30.8.213:5002/";
  // final baseUrl = 'http://20.231.8.139/';
  // final baseUrl = "http://10.0.2.2:5000/";
  // final baseUrl = "http://pesserver.azurewebsites.net/";
  //"https://pehchaan-ek-safar.herokuapp.com/";

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Response> validateToken(token) async {
    print("Getting User");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/admin/get/"),
        headers: {"Authorization": token},
      );
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e);
      return http.Response("", 404);
    }
  }

  Future<Response> generateOtp(pesId) async {
    try {
      print("sent");
      final response =
          await http.post(Uri.parse(baseUrl + "admin/register/otp/send/"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                <String, String>{"pesId": pesId},
              ));
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return http.Response("", 404);
    }
  }

  Future<Response> validateOtp(String pesId, String otp) async {
    final response =
        await http.post(Uri.parse(baseUrl + "admin/register/otp/verify/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              <String, String>{"pesId": pesId, "otp": otp},
            ));
    print(response.body);
    return response;
  }

  Future<String> getSyllabus(batch, token) async {
    //"https://drive.google.com/uc?export=download&id=12vPGqtyICT0ax_7kCfBJvDtQoiDVPtpp";

    print("Getting Syllabus");
    try {
      final response =
          await http.post(Uri.parse(baseUrl + "admin/get_syllabus/"),
              headers: {
                "Authorization": token,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                <String, String>{"batch": batch},
              ));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return jsonDecode(response.body)['url'];
      else
        return "";
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<SlotResponse> getAllSlots(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/slot/all/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      SlotResponse slotResponse = SlotResponse(hasLoaded: false);

      if (((response.statusCode / 100).floor() == 2)) {
        slotResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["slots"])
          slotResponse.slots.add(Slot.fromJson(i));
      }
      return slotResponse;
    } catch (e) {
      print(e);
      return SlotResponse(hasLoaded: false);
    }
  }

  Future<BatchResponse> getAllBatches(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/batch/view/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      BatchResponse slotResponse = BatchResponse(hasLoaded: false);

      if (((response.statusCode / 100).floor() == 2)) {
        slotResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["applications"])
          slotResponse.batches.add(Batch.fromJson(i));
      }
      return slotResponse;
    } catch (e) {
      print(e);
      return BatchResponse(hasLoaded: false);
    }
  }

  Future<JoinApplicationResponse> getJoiningApplications(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/view_applications/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      JoinApplicationResponse joinResponse =
          JoinApplicationResponse(hasLoaded: false);

      if (((response.statusCode / 100).floor() == 2)) {
        joinResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["applications"])
          joinResponse.applications.add(JoinApplication.fromJson(i));
      }
      return joinResponse;
    } catch (e) {
      print(e);
      return JoinApplicationResponse(hasLoaded: false);
    }
  }

  Future<String> joinApplicationDecision(token, phone, decision) async {
    print("join Application Decision");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/accept_applicant/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "phone": phone,
            "response": decision,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Marked";
      else
        return "Failed to Mark";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> leaveApplicationDecision(token, pes_id, decision) async {
    print("leave Application Decision");
    try {
      String url;
      if (decision == "accept") {
        url = baseUrl + "admin/leaving_application/accept/";
      } else {
        url = baseUrl + "admin/leaving_application/reject/";
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "pesId": pes_id,
            "response": decision,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Marked";
      else
        return "Failed to Mark";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<LeaveApplicationsResponse> getLeavingApplications(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/leaving_application/display/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      LeaveApplicationsResponse leaveResponse =
          LeaveApplicationsResponse(hasLoaded: false);

      if (((response.statusCode / 100).floor() == 2)) {
        leaveResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["applications"])
          leaveResponse.applications.add(LeaveApplication.fromJson(i));
      }
      return leaveResponse;
    } catch (e) {
      print(e);
      return LeaveApplicationsResponse(hasLoaded: false);
    }
  }

  Future<ListVolunteersResponse> listVolunteers(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/volunteer_slots/list_volunteers/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      ListVolunteersResponse listResponse =
          ListVolunteersResponse(hasLoaded: false);

      if (((response.statusCode / 100).floor() == 2)) {
        listResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["volunteers"])
          listResponse.volunteers.add(VolunteerSlotPage.fromJson(i));
      }
      return listResponse;
    } catch (e) {
      print(e);
      return ListVolunteersResponse(hasLoaded: false);
    }
  }

  Future<List> individualSlots(token, pes_id) async {
    print("Indiv slots");
    try {
      String url = baseUrl + "admin/volunteer_slots/volunteer/";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "pes_id": pes_id,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        List<Slot> allSlots = [];
        List current = [], requested = [];
        for (Map i in jsonDecode(response.body)["all"])
          allSlots.add(Slot.fromJson(i));
        current = jsonDecode(response.body)['current'];
        requested = jsonDecode(response.body)['requested'];

        return [true, allSlots, current, requested];
      } else
        return [false];
    } catch (e) {
      print(e);
      return [false];
    }
  }

  // Student Needs

  Future<List> getStudentNeeds(token) async {
    print("Student Needs");
    try {
      String url = baseUrl + "admin/student_needs/";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        List<AppStudentNeeds> student_needs = [];
        for (Map i in jsonDecode(response.body)["student_needs"])
          student_needs.add(AppStudentNeeds.fromJson(i));

        return [true, student_needs];
      } else
        return [false];
    } catch (e) {
      print(e);
      return [false];
    }
  }

  Future<String> delStudentNeeds(token, id) async {
    print("Student Needs");
    try {
      String url = baseUrl + "admin/student_needs/del";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "id": id,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        return "Deleted";
      } else
        return "Not Deleted";
    } catch (e) {
      print(e);
      return "Not Deleted";
    }
  }

  Future<String> addStudentNeeds(token,name, pathshaala, data) async {
    try {
      String url = baseUrl + "admin/student_needs/add/";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "name": name,
            "pathshaala": pathshaala,
            "data": data,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        return "Added";
      } else
        return "Not Added";
    } catch (e) {
      print(e);
      return "Not Added";
    }
  }

  // Ends here

  Future<List> displayNotifications(token) async {
    print("Notifications");
    try {
      String url = baseUrl + "admin/notifications/view/";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        List<AppNotification> notifications = [];
        for (Map i in jsonDecode(response.body)["notifications"])
          notifications.add(AppNotification.fromJson(i));

        return [true, notifications];
      } else
        return [false];
    } catch (e) {
      print(e);
      return [false];
    }
  }

  Future<String> addNotification(token, title, description) async {
    try {
      String url = baseUrl + "admin/notifications/add/";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "title": title,
            "description": description,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2)) {
        return "Sent";
      } else
        return "Not sent";
    } catch (e) {
      print(e);
      return "Not sent";
    }
  }

  Future<VolunteerHomeResponse> getHomeVolunteers(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/today_slots/"),
        headers: {"Authorization": token},
      );
      VolunteerHomeResponse volunteerHomeResponse =
          VolunteerHomeResponse(hasLoaded: false);
      print(response.body);
      if (((response.statusCode / 100).floor() == 2)) {
        volunteerHomeResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["pathshaala1"])
          volunteerHomeResponse.p1_volunteers
              .add(VolunteerHomeScreen.fromJson(i));
        for (Map i in jsonDecode(response.body)["pathshaala2"])
          volunteerHomeResponse.p2_volunteers
              .add(VolunteerHomeScreen.fromJson(i));
      }
      return volunteerHomeResponse;
    } catch (e) {
      print(e);
      return VolunteerHomeResponse(hasLoaded: false);
    }
  }

  Future<String> slotDeleteApplication(token, slotIds) async {
    print("Slot Delete Application");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/slot/delete/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "slot_ids": slotIds,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "SlotDeleted";
      else
        return "Failed to Send Slot Delete Request";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> slotChangeApplication(token, pes_id, slotIds) async {
    print("Slot Changw Application");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/slot/change/accept/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "pes_id": pes_id,
            "slot_ids": slotIds,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Slots Changed";
      else
        return "Failed to Send Slot Change Request";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> batchDeleteApplication(token, slotIds) async {
    print("Batch Delete Application");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/batch/delete/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "batches": slotIds,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Batch Deleted";
      else
        return "Failed to Send Batch Delete Request";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> addBatch(Map applicationData, String token) async {
    print("Batch Adding Application");
    print(applicationData);
    try {
      final response = await http.post(Uri.parse(baseUrl + "admin/batch/add/"),
          headers: {
            "Authorization": token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            applicationData,
          ));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Submitted";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> editExistingBatch(String token, Batch batch) async {
    print("Editing Application");
    //print(slot.day);
    try {
      final response = await http.post(Uri.parse(baseUrl + "admin/batch/edit/"),
          headers: {
            "Authorization": token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "batch": batch.batch,
            "syllabus": batch.syllabus,
            "remarks": batch.remarks,
          }));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Submitted";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> addSlot(Map applicationData, String token) async {
    print("Adding Application");
    print(applicationData);
    try {
      final response = await http.post(Uri.parse(baseUrl + "admin/slot/add/"),
          headers: {
            "Authorization": token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            applicationData,
          ));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Submitted";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> editExistingSlot(String token, Slot slot) async {
    print("Editing Application");
    print(slot.day);
    print(slot.timeEnd);
    try {
      final response = await http.post(Uri.parse(baseUrl + "admin/slot/edit/"),
          headers: {
            "Authorization": token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "slot_id": slot.slotId,
            "pathshaala": slot.pathshaala,
            "batch": slot.batch,
            "day": slot.day,
            "description": slot.description,
            "time_start": slot.timeStart,
            "time_end": slot.timeEnd,
            "remarks": slot.remarks,
          }));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Submitted";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<VolunteerResponse> getAllVolunteers(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/admin_volunteer/attendance/"),
        headers: {"Authorization": token},
      );
      VolunteerResponse volunteerResponse = VolunteerResponse(hasLoaded: false);
      print(response.body);
      if (((response.statusCode / 100).floor() == 2)) {
        volunteerResponse.hasLoaded = true;
        for (Map i in jsonDecode(response.body)["Attendance"])
          volunteerResponse.volunteers.add(VolunteerProfile.fromJson(i));
      }
      return volunteerResponse;
    } catch (e) {
      print(e);
      return VolunteerResponse(hasLoaded: false);
    }
  }

  Future<VolunteerAttendanceResponse> getVolunteerAttendance(token) async {
    print('Getting Attendances');
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/all_vol_attendance/"),
        headers: {"Authorization": token},
      );

      VolunteerAttendanceResponse attendanceResponse =
          VolunteerAttendanceResponse(
              hasLoaded: false, VolunteerAttendances: []);

      print(response.body);
      if (((response.statusCode / 100).floor() == 2)) {
        attendanceResponse.hasLoaded = true;
        attendanceResponse.VolunteerAttendances = jsonDecode(
                response.body)['attendance']
            .map<VolunteerAttendance>((e) => VolunteerAttendance.fromJson(e))
            .toList();
      }
      return attendanceResponse;
    } catch (e) {
      print(e);
      return VolunteerAttendanceResponse(
        hasLoaded: true,
        VolunteerAttendances: [],
      );
    }
  }

  Future getVolunteerProfile(token, pesId) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "admin/volunteer/view/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": token
        },
        body: jsonEncode(
          <String, String>{"pes_id": pesId},
        ),
      );

      print(response.body);
      if (((response.statusCode / 100).floor() == 2)) {
        //print(DateTime.parse(jsonDecode(response.body)['Vols'][0]["joining_date"]));
        return VolunteerProfile.fromJson(jsonDecode(response.body)['Vols'][0]);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class SlotResponse {
  bool hasLoaded;
  List<Slot> slots = [];

  SlotResponse({required this.hasLoaded});
}

class VolunteerHomeResponse {
  bool hasLoaded;
  List<VolunteerHomeScreen> p1_volunteers = [];
  List<VolunteerHomeScreen> p2_volunteers = [];

  VolunteerHomeResponse({required this.hasLoaded});
}

class VolunteerResponse {
  bool hasLoaded;
  List<VolunteerProfile> volunteers = [];
  VolunteerResponse({required this.hasLoaded});
}

class VolunteerProfileResponse {
  bool hasLoaded;
  VolunteerProfile volunteer;
  VolunteerProfileResponse({required this.hasLoaded, required this.volunteer});
}

class VolunteerAttendanceResponse {
  bool hasLoaded;
  List<VolunteerAttendance> VolunteerAttendances;

  VolunteerAttendanceResponse(
      {required this.hasLoaded, required this.VolunteerAttendances});
}

class LeaveApplicationsResponse {
  bool hasLoaded;
  final List<LeaveApplication> applications = [];
  LeaveApplicationsResponse({required this.hasLoaded});
}

class JoinApplicationResponse {
  bool hasLoaded;
  final List<JoinApplication> applications = [];
  JoinApplicationResponse({required this.hasLoaded});
}

class BatchResponse {
  bool hasLoaded;
  List<Batch> batches = [];
  BatchResponse({required this.hasLoaded});
}

class ListVolunteersResponse {
  bool hasLoaded;
  List<VolunteerSlotPage> volunteers = [];
  ListVolunteersResponse({required this.hasLoaded});
}
