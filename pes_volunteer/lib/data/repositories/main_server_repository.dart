import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pes/data/models/application.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/studentNeeds.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/models/user_profile.dart';

import '../models/notification.dart';

class MainRepository {
  final baseUrl = "http://172.30.8.213:5002/";
  // final baseUrl = 'http://20.231.8.139/';
  // final baseUrl = "http://10.0.2.2:5000/";
  // final baseUrl = "http://pesserver.azurewebsites.net/";
  // final baseUrl = "https://pehchaan-ek-safar.herokuapp.com/";

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
        Uri.parse(baseUrl + "get_user/"),
        headers: {"Authorization": token},
      );
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e);
      return http.Response("", 404);
    }
  }

  Future<SlotResponse> getSlots(token) async {
    print("Getting Volunteer Slots");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "slots/"),
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

  Future<SlotResponse> getAllSlots(token) async {
    print("Getting All Slots");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "slots/all/"),
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

  Future<String> getSyllabus(batch, token) async {
    //"https://drive.google.com/uc?export=download&id=12vPGqtyICT0ax_7kCfBJvDtQoiDVPtpp";

    print("Getting Syllabus");
    try {
      final response = await http.post(Uri.parse(baseUrl + "get_syllabus/"),
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

  Future<String> register(Map applicationData, String token) async {
    print("Adding Application");
    try {
      final response = await http.post(Uri.parse(baseUrl + "add_application/"),
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

  Future<String> leavePehchaan(String token, String reason) async {
    //"https://drive.google.com/uc?export=download&id=12vPGqtyICT0ax_7kCfBJvDtQoiDVPtpp";

    print("Leave pehchaan screen");
    try {
      final response =
          await http.post(Uri.parse(baseUrl + "leave_pehchaan_application/"),
              headers: {
                "Authorization": token,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"reason": reason}));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Submitted successfully";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<UserProfile> getProfile(token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "get_user/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      Map json = jsonDecode(response.body);

      if (((response.statusCode / 100).floor() == 2)) {
        return UserProfile.fromJson(json);
      } else {
        return UserProfile();
      }
    } catch (e) {
      print(e);
      Map json = {'name': 'User Error'};
      return UserProfile.fromJson(json);
    }
  }

  Future<String> markAttendance(token, slotId, remarks) async {
    print("Marking Attendance");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "mark_attendance/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "slot_id": slotId,
            "remarks": remarks,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return jsonDecode(response.body)['message'];
      else
        return "Failed to Mark Attendance";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> slotChangeApplication(token, slotIds) async {
    print("Slot Change Application");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "slots/change/"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "slot_id": slotIds,
          },
        ),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return jsonDecode(response.body)['message'];
      else
        return "Failed to Send Slot Change Application";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> delMySlot(token, id) async {
    print("My Slots");
    print(token);
    print(id);

    try {
      String url = baseUrl + "slot/del";
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

// Student Needs

  Future getStudentNeeds(String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "student_needs/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      Map json = jsonDecode(response.body);

      if (((response.statusCode / 100).floor() == 2)) {
        return (json["student_needs"] as List)
            .map((e) => AppStudentNeeds.fromJson(e))
            .toList();
      } else {
        return json["message"];
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<String> addStudentNeeds(String token, String data) async {
    print("Add Student Needs screen");
    try {
      final response =
          await http.post(Uri.parse(baseUrl + "student_needs/add/"),
              headers: {
                "Authorization": token,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"data": data}));
      print(jsonDecode(response.body));
      if (((response.statusCode / 100).floor() == 2))
        return "Added successfully";
      else
        return jsonDecode(response.body)['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

// Ends Here

  Future getNotifications(String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "notifications/"),
        headers: {"Authorization": token},
      );
      print(jsonDecode(response.body));
      Map json = jsonDecode(response.body);

      if (((response.statusCode / 100).floor() == 2)) {
        return (json["notifications"] as List)
            .map((e) => AppNotification.fromJson(e))
            .toList();
      } else {
        return json["message"];
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Response> generateOtp(pesId) async {
    try {
      print("sent");
      final response = await http.post(Uri.parse(baseUrl + "login/otp/send/"),
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

  getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<Response> validateOtp(String pesId, String otp) async {
    String? fcmToken;
    fcmToken = await getToken();
    final response = await http.post(Uri.parse(baseUrl + "login/otp/verify/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{"pesId": pesId, "otp": otp, "fcm_token": fcmToken!},
        ));
    print(response.body);
    return response;
  }

  Future<Response> readNotification(token, String id) async {
    final response = await http.post(Uri.parse(baseUrl + "notifications/read/"),
        headers: <String, String>{
          "Authorization": token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{"id": id.toString()},
        ));
    print(response.body);
    return response;
  }

  // Future<Response> readNotificationAll(token, String id) async {
  //   final response =
  //       await http.post(Uri.parse(baseUrl + "notifications/read/all/"),
  //           headers: <String, String>{
  //             "Authorization": token,
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(
  //             <String, String>{"id": id.toString()},
  //           ));
  //   print(response.body);
  //   return response;
  // }

  Future<bool> getNewNotificationBool(String token) async {
    final response = await http.post(
      Uri.parse(baseUrl + "notifications/new/"),
      headers: <String, String>{
        "Authorization": token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);

    return ((response.statusCode / 100).floor() == 2)
        ? jsonDecode(response.body)['new_notifications']
        : false;
  }
}

class SlotResponse {
  bool hasLoaded;
  List<Slot> slots = [];

  SlotResponse({required this.hasLoaded});
}
