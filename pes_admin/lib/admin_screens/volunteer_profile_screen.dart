import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/Info_user_profile.dart';
import 'package:pes_admin/admin_screens/widgets/indicator.dart';
import 'package:pes_admin/cubit/attendance_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/profile_cubit.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/models/volunteer_attendance.dart';

import '../data/models/user.dart';

class VolunteerProfile extends StatelessWidget {
  ProfileCubit? profileCubit;
  final String pesId;
  int touchedIndex = 4;
  VolunteerAttendance? volunteerAttendance;
  VolunteerProfile({
    Key? key,
    required String this.pesId,
    this.volunteerAttendance,
  }) : super(key: key);

  Color appBarColor = Colors.black;

  User user = User.empty(token: "");

  _showAttendanceChart() {
    if (volunteerAttendance != null) {
      print(volunteerAttendance!.attendancePercentage);
      return [
        Container(
          height: 200,
          child: volunteerAttendance!.totalSlots.toDouble() != 0
              ? PieChart(
                  PieChartData(
                    centerSpaceColor: Colors.grey.shade200,
                    centerSpaceRadius: 70,
                    borderData: FlBorderData(show: false),
                    sections: [
                      PieChartSectionData(
                          //title: 'Slots Attended',
                          value: volunteerAttendance!.slotsAttended.toDouble(),
                          color: Colors.lightGreenAccent,
                          radius: 30),
                      PieChartSectionData(

                          // title: 'Total Slots',
                          value: volunteerAttendance!.totalSlots.toDouble() -
                                      volunteerAttendance!.slotsAttended
                                          .toDouble() >
                                  -1
                              ? volunteerAttendance!.totalSlots.toDouble() -
                                  volunteerAttendance!.slotsAttended.toDouble()
                              : 0,
                          color: Colors.redAccent,
                          radius: 30),
                    ],
                  ),
                )
              : Center(child: Text("No Slot Assigned")),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Indicator(
              color: Colors.lightGreenAccent,
              text: "Slots Attended",
              isSquare: false,
              size: 16,
              textColor: Colors.black,
            ),
            Indicator(
              color: Colors.redAccent,
              text: "Slots Not Attended",
              isSquare: false,
              size: 16,
              textColor: Colors.black,
            ),
            /*Indicator(
                  color: Colors.green,
                  text: "Three",
                  isSquare: false,
                  size: touchedIndex == 2 ? 18 : 16,
                  textColor: touchedIndex == 2
                    ? Colors.black
                    : Colors.grey,
                ),
                Indicator(
                  color: Colors.yellow,
                  text: "Four",
                  isSquare: false,
                  size: touchedIndex == 3 ? 18 : 16,
                  textColor: touchedIndex == 3
                    ? Colors.black
                    : Colors.grey,
                ),*/
          ],
        ),
        SizedBox(height: 20),
      ];
    } else {
      return [];
    }
  }

  AttendanceCubit? attendanceCubit;

  @override
  Widget build(BuildContext context) {
    attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    user = BlocProvider.of<LoginCubit>(context).user;
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    profileCubit!.loadVolunteerProfile(user.token, pesId);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Volunteer Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          else if (state is ProfileLoaded) {
            return Container(
              color: Colors.black,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0.5, 0, 0),
                padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 18, 18, 18),
                ),
                child: Center(
                  child: ListView(
                    children: [
                      Container(
                        height: volunteerAttendance == null
                            ? MediaQuery.of(context).size.height * 0.8
                            : 900,
                        child: Column(children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            state.volunteerProfile.name,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            "PES ID: " + state.volunteerProfile.pes_id,
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          // ..._showAttendanceChart(),
                          Container(
                              decoration: BoxDecoration(
                                border: const GradientBoxBorder(
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 247, 98, 57),
                                      Color.fromARGB(255, 247, 57, 215),
                                    ]),
                                    // color: Color.fromARGB(255, 249, 66, 224),
                                    width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(children: [
                                SectionHeading("Contact Details"),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10),
                                  padding: EdgeInsets.only(
                                      top: 15, left: 5, bottom: 10),
                                  child: Table(columnWidths: {
                                    1: FlexColumnWidth(1.75),
                                    2: FlexColumnWidth(3)
                                  }, children: [
                                    TableRow(children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 7),
                                          child: Text(
                                            "Phone : ",
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text(state.volunteerProfile.phone,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Roboto",
                                              fontSize: 14))
                                    ]),
                                    TableRow(children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 7),
                                          child: Text(
                                            "Email: ",
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text(state.volunteerProfile.email,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Roboto",
                                              fontSize: 14))
                                    ])
                                  ]),
                                ),
                              ])),
                          SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: const GradientBoxBorder(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 247, 98, 57),
                                    Color.fromARGB(255, 247, 57, 215),
                                  ]),
                                  // color: Color.fromARGB(255, 249, 66, 224),
                                  width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(children: [
                              SectionHeading("Current Address"),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10),
                                padding: EdgeInsets.only(
                                    top: 15, left: 5, bottom: 10),
                                child: Text(state.volunteerProfile.address,
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: Colors.white,
                                      overflow: TextOverflow.fade,
                                    )),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: const GradientBoxBorder(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 247, 98, 57),
                                    Color.fromARGB(255, 247, 57, 215),
                                  ]),
                                  // color: Color.fromARGB(255, 249, 66, 224),
                                  width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(children: [
                              SectionHeading("Other Details"),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10),
                                padding: EdgeInsets.only(
                                    top: 15, left: 5, bottom: 10),
                                child: Table(columnWidths: {
                                  1: FlexColumnWidth(1.75),
                                  2: FlexColumnWidth(3)
                                }, children: [
                                  TableRow(children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 7),
                                        child: Text(
                                          "Profession: ",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(state.volunteerProfile.profession,
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 14,
                                            color: Colors.white))
                                  ]),
                                  TableRow(children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 7),
                                        child: Text(
                                          "Pathshaala: ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Roboto",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(state.volunteerProfile.pathshaala,
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontSize: 14,
                                        ))
                                  ]),
                                  TableRow(children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 7),
                                        child: Text(
                                          "Joining date: ",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(state.volunteerProfile.joining_date,
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontSize: 14,
                                        ))
                                  ])
                                ]),
                              ),
                            ]),
                          ),
                          Spacer(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is LoadError)
            return Container(
              child: Center(
                child: Text(state.error),
              ),
            );
          else {
            return Container();
          }
        },
      ),
    );
  }
}
