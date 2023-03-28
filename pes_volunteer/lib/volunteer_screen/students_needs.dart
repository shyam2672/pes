import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/all_slots_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/studentNeeds_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/data/models/studentNeeds.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/widgets/sidemenu.dart';
import 'package:pes/volunteer_screen/widgets/slot_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../cubit/add_studentNeeds_cubit.dart';

class StudentNeedsScreen extends StatefulWidget {
  @override
  State<StudentNeedsScreen> createState() => _StudentNeedsScreenState();
}

class _StudentNeedsScreenState extends State<StudentNeedsScreen> {
  User user = User.empty(token: "");
  TextEditingController needsEditor = TextEditingController();

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  StudentNeedsCubit? studentNeedsCubit;
  AddStudentNeedsCubit? addStudentNeedsCubit;
  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    studentNeedsCubit = BlocProvider.of<StudentNeedsCubit>(context);
    studentNeedsCubit!.getStudentNeeds(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Student Needs",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          backgroundColor:
              appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
        ),

        controller: _pageRefreshController,
        onRefresh: () {
          print("Refresh");
          setState(() {
            studentNeedsCubit!.studentNeeds = [];
          });
          _pageRefreshController.refreshCompleted();
        },
        // onLoading: _onLoading,
        child: BlocBuilder<StudentNeedsCubit, StudentNeedsState>(
          builder: (context, state) {
            if (state is StudentNeedsLoaded) {
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      BlocConsumer<AddStudentNeedsCubit, AddStudentNeedsState>(
                          builder: (context, state) {
                        return InkWell(
                            child: Container(
                              width: 200,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 247, 57, 215),
                                  Color.fromARGB(255, 247, 98, 57)
                                ]),
                                // color: const Color(0xff274D76),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color.fromARGB(255, 247, 57, 215),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                  child: Text(
                                "Add Student Needs",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                            ),
                            onTap: () =>
                                {_showNeedsDialog(context), setState(() {})});
                      }, listener: (context, state) {
                        if (state is AddStudentNeedsApplied) {
                          _showBottomNotification(
                              context, "Student Needs Added");
                          Timer(Duration(seconds: 3), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Navigator.popUntil(
                            //     context, (route) => !route.hasActiveRouteBelow);
                            //setState(() => slotsCubit!.slots = []);
                          });
                        } else if (state is AddStudentNeedsNotApplied) {
                          _showBottomNotification(context, state.message);
                          Timer(Duration(seconds: 3), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Navigator.popUntil(
                            //     context, (route) => !route.hasActiveRouteBelow);
                            //setState(() => slotsCubit!.slots = []);
                          });
                        } else {
                          _showBottomNotification(
                              context, "Adding Student Needs");
                        }
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      // ElevatedButton(
                      //   style: raisedButtonStyle,
                      //   onPressed: () {
                      //     setState(() {
                      //       studentNeedsCubit!.studentNeeds.map((e) {
                      //         print(e.read);
                      //         return;
                      //       });
                      //     });
                      //   },
                      //   child: Text('Mark All as Read'),
                      // ),
                      Divider(),
                      Expanded(
                        child: SmartRefresher(
                          enablePullDown: true,
                          header: WaterDropMaterialHeader(
                            backgroundColor: appBarColor.withOpacity(
                                0.8), //Theme.of(context).primaryColor,
                          ),

                          controller: _listRefreshController,
                          onRefresh: () {
                            print("Refresh");
                            setState(() {
                              studentNeedsCubit!.studentNeeds = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          // onLoading: _onLoading,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: studentNeedsCubit!.studentNeeds.map(
                              (e) {
                                print(e);
                                return StudentNeedsTile(appStudentNeeds: e);
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is StudentNeedsError) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _showBottomNotification(BuildContext context, message) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.all(10), child: Text(message));
        });
  }

  void _showNeedsDialog(context) {
    showDialog(
      context: context,
      builder: (contexts) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _attendanceDialog(context),
        );
      },
    );
  }

  AddStudentNeedsCubit? addstudentNeedsCubit;
  Widget _attendanceDialog(context) {
    addStudentNeedsCubit = BlocProvider.of<AddStudentNeedsCubit>(context);
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      height: 300,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromARGB(255, 18, 18, 18),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        children: [
          Text(
            "Add Student Needs",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Spacer(flex: 2),
          Text(
            "Please state the needs for your Pathshaala",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          Spacer(),
          needsField(
            feedback: needsEditor,
          ),
          Spacer(),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    addStudentNeedsCubit!
                        .addStudentNeeds(user.token, needsEditor.text);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 247, 57, 215),
                        Color.fromARGB(255, 247, 98, 57)
                      ]),
                      // color: Color(0xde0f80f4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Add Needs",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class StudentNeedsTile extends StatefulWidget {
  AppStudentNeeds appStudentNeeds;

  StudentNeedsTile({Key? key, required this.appStudentNeeds}) : super(key: key);

  @override
  State<StudentNeedsTile> createState() => _StudentNeedsTileState();
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  // foregroundColor: Colors.white,
  // backgroundColor: Colors.black,
  onPrimary: Colors.black87,
  primary: Color.fromARGB(255, 167, 166, 166),
  textStyle: TextStyle(fontWeight: FontWeight.bold),
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

class _StudentNeedsTileState extends State<StudentNeedsTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NEEDS_DETAIL,
          arguments: {
            "studentNeedsObj": widget.appStudentNeeds,
            "timeRecieved":
                _studentNeedsInterval(widget.appStudentNeeds.post_time)
          },
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        // decoration: BoxDecoration(
        //   // border: Border.all(width: 2, color: Colors.black),
        //   // borderRadius: BorderRadius.all(Radius.circular(20)),
        //   color: widget.appStudentNeeds.read
        //       ? Colors.white
        //       : Color.fromARGB(255, 218, 233, 250),
        // ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                // color: Color.fromRGBO(223, 246, 255, .8).withOpacity(0.02),
                // color: widget.appStudentNeeds.read
                //     ? appBarColor.withOpacity(0.02)
                //     : Color.fromRGBO(223, 246, 255, .8).withOpacity(0.02),
                // color: appBarColor.withOpacity(0.02),
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 245, 72, 72), width: 2)),
                // border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.all(Radius.circular((5)))
              ),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (Container(
                    // padding: const EdgeInsets.only(top: 5, bottom: 5),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.appStudentNeeds.data.length > 30
                                  ? widget.appStudentNeeds.data
                                          .substring(0, 30) +
                                      '...'
                                  : widget.appStudentNeeds.data,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  // color: widget.appStudentNeeds.read
                                  //     ? Color.fromARGB(255, 107, 107, 107)
                                  //     : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PES ID: " + widget.appStudentNeeds.pesId,
                              style: TextStyle(
                                  color: Colors.grey,
                                  // color: widget.appStudentNeeds.read
                                  //     ? Color.fromARGB(255, 107, 107, 107)
                                  //     : Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          _studentNeedsInterval(
                              widget.appStudentNeeds.post_time),
                          style: TextStyle(
                            color: Colors.grey,
                            // color: widget.appStudentNeeds.read
                            //     ? Color.fromARGB(255, 150, 149, 149)
                            //     : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          },
        ), //
      ),
    );
  }

  String _studentNeedsInterval(DateTime studentNeedsTime) {
    int seconds = DateTime.now().difference(studentNeedsTime).inSeconds;

    String timeInterval = "";

    if (seconds < 60) {
      timeInterval = "$seconds sec";
    } else if (seconds / 60 < 60) {
      timeInterval = "${(seconds / 60).floor()} min";
    } else if (seconds / 3600 < 24) {
      timeInterval = "${(seconds / 3600).floor()} hrs";
    } else {
      timeInterval =
          "${studentNeedsTime.day}-${studentNeedsTime.month}-${studentNeedsTime.year}";
    }

    return timeInterval;
  }
}

class needsField extends StatelessWidget {
  final TextEditingController feedback;
  needsField({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("something");
    return Container(
      child: TextField(
        onSubmitted: (_) {
          print("Feedback ${feedback.value.text}");
          Navigator.pop(context);
        },
        // keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: 3,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
        autofocus: true,
        controller: feedback,
        decoration: InputDecoration(
          // fillColor: Color.fromARGB(255, 247, 57, 215),
          contentPadding: EdgeInsets.fromLTRB(20, 7, 20, 7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          labelText: "Reason",
          labelStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
