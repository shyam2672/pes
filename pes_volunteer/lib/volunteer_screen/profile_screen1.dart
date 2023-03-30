import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/cubit/leave_pehchaan_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/profile_cubit.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/volunteer_screen/widgets/Info_user_profile.dart';

class Profile extends StatelessWidget {
  ProfileCubit? profileCubit;
  User user = User.empty(token: "");
  TextEditingController reasonEditor = TextEditingController();
  Profile({Key? key}) : super(key: key);

  Color appBarColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    profileCubit!.loadVolunteerProfile(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
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
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(children: [
                        SizedBox(
                          height: 25,
                        ),
                        /*Text("Volunteer Information",style: TextStyle(
                              fontFamily: "Roboto",fontSize: 20,fontWeight:FontWeight.bold)
                            ),
                            Spacer(),
                            */
                        Text(
                          state.user.name,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: appBarColor),
                        ),
                        Container(
                          height: 7,
                        ),
                        Text(
                          "PES ID: " + state.user.pes_id,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        SectionHeading("Contact Details"),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 224, 224),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromARGB(255, 224, 224, 224)
                                  .withOpacity(0.05),
                              width: 6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffa6aabc),
                                blurRadius: 8,
                                offset: Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Color(0xfff9faff),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          margin:
                              EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          padding:
                              EdgeInsets.only(top: 15, left: 5, bottom: 10),
                          child: Table(columnWidths: {
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(3)
                          }, children: [
                            TableRow(children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 7),
                                  child: Text(
                                    "Phone: ",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(state.user.phone,
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 14))
                            ]),
                            TableRow(children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 7),
                                  child: Text(
                                    "Email: ",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(state.user.email,
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 14))
                            ])
                          ]),
                        ),
                        SizedBox(height: 5),
                        SectionHeading("Current Address"),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 224, 224),
                            border: Border.all(
                              color: Color.fromARGB(255, 224, 224, 224)
                                  .withOpacity(0.05),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffa6aabc),
                                blurRadius: 8,
                                offset: Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Color(0xfff9faff),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          margin:
                              EdgeInsets.only(left: 5, right: 5, bottom: 10),
                          // height: 90,
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(top: 15, left: 10, bottom: 10),
                          child: Text(state.user.address,
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 14,
                                overflow: TextOverflow.fade,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SectionHeading("Other Details"),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 224, 224),
                            border: Border.all(
                              color: Color.fromARGB(255, 224, 224, 224)
                                  .withOpacity(0.05),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffa6aabc),
                                blurRadius: 8,
                                offset: Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Color(0xfff9faff),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          margin:
                              EdgeInsets.only(left: 5, right: 5, bottom: 10),

                          // height: 90,
                          padding:
                              EdgeInsets.only(top: 15, left: 5, bottom: 10),
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
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(state.user.profession,
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 14))
                            ]),
                            TableRow(children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 7),
                                  child: Text(
                                    "Pathshaala: ",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(state.user.pathshaala,
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 14))
                            ])
                          ]),
                        ),
                        Spacer(),
                        BlocConsumer<LeavePehchaanCubit, LeavePehchaanState>(
                            builder: (context, state) {
                          return InkWell(
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 25, 25, 25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                    child: Text(
                                  "Leave Pehchaan",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                              ),
                              onTap: () => {_showLeavingDialog(context)});
                        }, listener: (context, state) {
                          if (state is LeavePehchaanApplied) {
                            _showBottomNotification(
                                context, "Application Submitted");
                            Timer(Duration(seconds: 3), () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // Navigator.popUntil(
                              //     context, (route) => !route.hasActiveRouteBelow);
                              //setState(() => slotsCubit!.slots = []);
                            });
                          } else if (state is LeavePehchaanNotApplied) {
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
                                context, "Applying to Leave Pehchaan");
                          }
                        }),
                        Spacer(),
                      ]),
                    ),
                  ],
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

  void _showBottomNotification(BuildContext context, message) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.all(10), child: Text(message));
        });
  }

  void _showLeavingDialog(context) {
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

  LeavePehchaanCubit? leavePehchaanCubit;
  Widget _attendanceDialog(context) {
    leavePehchaanCubit = BlocProvider.of<LeavePehchaanCubit>(context);
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      height: 300,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xffe9e8e8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        children: [
          Text(
            "We are sorry to see you go!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Spacer(flex: 2),
          Text(
            "Please state your reason for leaving?",
            style: TextStyle(fontSize: 25, color: Color(0xff164476)),
          ),
          Spacer(),
          ReasonField(
            feedback: reasonEditor,
          ),
          Spacer(),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    leavePehchaanCubit!
                        .leavePehchaan(user.token, reasonEditor.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xde0f80f4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Leave Pehchaan",
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

class ReasonField extends StatelessWidget {
  final TextEditingController feedback;
  ReasonField({Key? key, required this.feedback}) : super(key: key);

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
          color: Colors.black87,
        ),
        autofocus: true,
        controller: feedback,
        decoration: InputDecoration(
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
