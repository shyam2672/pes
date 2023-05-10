import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/studentNeeds_cubit.dart';
// import 'package:pes/cubit/outreach_added_cubit.dart';
import 'dart:async';

import 'package:pes/cubit/outreach_slots_cubit.dart';

import 'package:pes/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pes/data/models/outreachslot.dart';

// Widget topbar() {

//             return PopupMenuButton(
//                 // padding: EdgeInsets.zero,
//                 onCanceled: () {
//               print('Popupmenu cancelled!');
//             }, itemBuilder: (context) {
//               return [
//                 PopupMenuItem<int>(
//                   value: 0,
//                   child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Navigator.pushNamed(context, ADDSCHOOL);
//                       },
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           minimumSize:
//                               Size(MediaQuery.of(context).size.width, 30)),
//                       icon: Icon(
//                         Icons.add,
//                         color: appBarColor,
//                       ),
//                       label: Text(
//                         "Add School",
//                         style: TextStyle(color: appBarColor),
//                       )),
//                 ),
//                 PopupMenuItem<int>(
//                   value: 1,
//                   child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Navigator.pushNamed(context, ADDTOPIC);
//                       },
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           minimumSize:
//                               Size(MediaQuery.of(context).size.width, 30)),
//                       icon: Icon(
//                         Icons.add,
//                         color: appBarColor,
//                       ),
//                       label: Text(
//                         "Add Topic",
//                         style: TextStyle(color: appBarColor),
//                       )),
//                 ),

//               ];
//             });
//           }

class OutreachSlotsScreen extends StatefulWidget {
  @override
  State<OutreachSlotsScreen> createState() => _OutreachScreenState();
}

User user = User.empty(token: "");
OutreachCubit? outreachcubit;

class _OutreachScreenState extends State<OutreachSlotsScreen> {
// AddOutreachCubit? addOutreachCubit;
  // TextEditingController _date = TextEditingController();
  String? _date;
  String? _school;
  String? _topic;
  DateTime? _selectedDate;
  bool _isslot1 = false;
  bool _isslot2 = false;

  TextEditingController _remarks = TextEditingController();
  TextEditingController _timestart = TextEditingController();
  TextEditingController _timeend = TextEditingController();
  TextEditingController _description = TextEditingController();

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  void _handleschool(String selectedItem) {
    setState(() {
      _school = selectedItem;
    });
    print('Selected item: $selectedItem');
  }

  void _handletopic(String selectedItem) {
    _topic = selectedItem;

    print('Selected item: $selectedItem');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      //  datePickerMode: DatePickerMode.date,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        print("date");
        print(_selectedDate);
        _date = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
        print(_date);
      });
    }
  }

  Widget _attendanceDialog(context) {
    // addOutreachCubit = BlocProvider.of<AddOutreachCubit>(context);

    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      // height: MediaQuery.of(context).size.height * 0.8,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add a Slot",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Text(
              //   "Select a School",
              //   style: TextStyle(fontSize: 22, color: Color(0xff164476)),
              // ),
              MyWidget(
                f: "school",
                items: outreachcubit!.schools,
                onItemSelected: _handleschool,
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Text(
              //   "Select a topic",
              //   style: TextStyle(fontSize: 22, color: Color(0xff164476)),
              // ),
              MyWidget(
                f: "topic",
                items: outreachcubit!.topics,
                onItemSelected: _handletopic,
              ),
            ],
          ),

          SizedBox(height: 20),

          // Spacer(flex: 2),

          // Spacer(),
          // Text(
          //   "Description",
          //   style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          // ),
          // SizedBox(height: 5),
          // RemarksField(
          //   feedback: _description,
          //   minLines: 3,
          //   maxLines: 3,
          // ),
          // SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(_selectedDate == null
              //     ? 'No date selected'
              //     : 'Selected date: ${_selectedDate!.toString()}'),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select a date'),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //   child: DateWidget("")
              // )
            ],
          ),

          SizedBox(height: 20),

          Text(
            "Start Time (HH:MM)",
            style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          ),
          SizedBox(height: 5),
          RemarksField(
            feedback: _timestart,
            minLines: 1,
            maxLines: 1,
          ),
          SizedBox(height: 20),
          Text(
            "End Time (HH:MM)",
            style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          ),
          SizedBox(height: 5),
          RemarksField(
            feedback: _timeend,
            minLines: 1,
            maxLines: 1,
          ),
          SizedBox(height: 20),
          Text(
            "Remarks",
            style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          ),
          SizedBox(height: 5),
          RemarksField(
            feedback: _remarks,
            minLines: 1,
            maxLines: 1,
          ),
          // Spacer(),
          SizedBox(height: 20),

          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    outreachcubit!.addOutreach(
                        user.token,
                        _school,
                        _topic,
                        _description.text,
                        _date,
                        _timestart.text,
                        _timeend.text,
                        _remarks.text);

                    // context?.navigator?.pop();
                    setState(() {});
//                     if (context != null) {
//   Navigator.pop(context);
// }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          // Spacer(),
        ],
      ),
    ));
  }

  void _showAttendanceDialog(context) {
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
    setState(() {
      outreachcubit!.slots = [];
    });
  }

  void _showBottomNotification(BuildContext context, message) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.all(10), child: Text(message));
        });
  }

  Widget msgBox(msg) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xffe9e8e8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                  onPressed: () => setState(() {
                        outreachcubit!.slots = [];
                      }), // Navigator.pop(context),
                  icon: Icon(Icons.cancel)),
              SizedBox(width: 10)
            ],
          ),
          Center(
              child: Text(msg,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    outreachcubit = BlocProvider.of<OutreachCubit>(context);

    outreachcubit!.loadoutreachslots(user.token);
    outreachcubit!.loadoutreachschools(user.token);
    outreachcubit!.loadoutreachtopics(user.token);

    print(outreachcubit!.schools);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        //  actions: [topbar()],
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Outreach Slots",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          _showAttendanceDialog(context);
          setState(() {});
          print("Button tapped");
        },
        child: Container(
          height: 50,
          width: 50,
          // width: MediaQuery.of(context).size.width * 0.70,
          margin: EdgeInsets.all(10),
          //padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 245, 72, 72),
            //borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromARGB(255, 245, 72, 72),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ), //Text("Edit ",style: const TextStyle(color: Colors.white,fontFamily: "Roboto",fontSize: 17),)
          ),
        ),
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
            outreachcubit!.slots = [];
          });
          _pageRefreshController.refreshCompleted();
        },
        // onLoading: _onLoading,
        child: BlocBuilder<OutreachCubit, OutreachState>(
          builder: (context, state) {
            if (state is OutreachLoaded) {
              print("state loded");
              return Container(
                color: appBarColor,
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
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // BlocConsumer<AddOutreachCubit, AddOutreachState>(
                      // InkWell(
                      //     child: Container(
                      //       width: 200,
                      //       height: 40,
                      //       decoration: BoxDecoration(
                      //         gradient: LinearGradient(colors: [
                      //           Color.fromARGB(255, 247, 57, 215),
                      //           Color.fromARGB(255, 247, 98, 57)
                      //         ]),
                      //         // color: const Color(0xff274D76),
                      //         borderRadius: BorderRadius.circular(20),
                      //         border: Border.all(
                      //           color: Color.fromARGB(255, 247, 57, 215),
                      //           width: 1,
                      //         ),
                      //       ),
                      //       child: const Center(
                      //           child: Text(
                      //         "Add Outreach Slot",
                      //         style:
                      //             TextStyle(fontSize: 15, color: Colors.white),
                      //       )),
                      //     ),
                      //     onTap: () =>
                      //         {_showAttendanceDialog(context), setState(() {})}

                      //     //   if (state is AddOutreachApplied) {
                      //     //     _showBottomNotification(
                      //     //         context, "Outreach Slot Added");
                      //     //     Timer(Duration(seconds: 3), () {
                      //     //       Navigator.pop(context);
                      //     //       Navigator.pop(context);
                      //     //       // Navigator.popUntil(
                      //     //       //     context, (route) => !route.hasActiveRouteBelow);
                      //     //       //setState(() => slotsCubit!.slots = []);
                      //     //     });
                      //     //   } else if (state is AddOutreachNotApplied) {
                      //     //     _showBottomNotification(context, state.message);
                      //     //     Timer(Duration(seconds: 3), () {
                      //     //       Navigator.pop(context);
                      //     //       Navigator.pop(context);
                      //     //       // Navigator.popUntil(
                      //     //       //     context, (route) => !route.hasActiveRouteBelow);
                      //     //       //setState(() => slotsCubit!.slots = []);
                      //     //     });
                      //     //   } else {
                      //     //     _showBottomNotification(
                      //     //         context, "Adding Outreach Slot");
                      //     //   }
                      //     // }
                      //     ),

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
                              outreachcubit!.slots = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          // onLoading: _onLoading,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: Offset(3, 3),
                                ),
                              ],
                              color: appBarColor,
                            ),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: outreachcubit!.slots.map(
                                (e) {
                                  print(e);
                                  return outreachSlotTile(outreachslots: e);
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // else if (state is Outre) {
            //   return Dialog(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     elevation: 0,
            //     backgroundColor: Colors.transparent,
            //     child: msgBox("Student Needs sent"),
            //   );
            // } else if (state is StudentNeedsNotAdded) {
            //   return Dialog(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     elevation: 0,
            //     backgroundColor: Colors.transparent,
            //     child: msgBox("Student Needs could not be sent"),
            //   );
            // }
            else if (state is OutreachFailure) {
              return Center(child: Text(state.error));
            } else if (state is OutreachRejected) {
              // Navigator.pop(context);
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: msgBox("Rejected"),
              );
              setState(() => outreachcubit!.slots = []);
            } else if (state is OutreachAccepted) {
              // Navigator.pop(context);
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: msgBox("Accepted"),
              );
              setState(() => outreachcubit!.slots = []);
            } else if (state is AddOutreachApplied) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: msgBox("Slot added"),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class outreachSlotTile extends StatefulWidget {
  outreachSlot outreachslots;
  // StudentNeedsCubit? studentNeedsCubit;
  outreachSlotTile({Key? key, required this.outreachslots}) : super(key: key);

  @override
  State<outreachSlotTile> createState() => _OutreachTileState();
}

class _OutreachTileState extends State<outreachSlotTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      // color: const Color.fromRGBO(
      //     223, 246, 255, .8), //Color.fromARGB(255, 218, 233, 250),
      //const Color(0x00e5f1ff),
      // const Color(0x00e5f1ff),
      // : Color.fromARGB(4, 229, 241, 255),
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
            height: 150,
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
                            widget.outreachslots.description.length > 30
                                ? widget.outreachslots.description
                                        .substring(0, 30) +
                                    '...'
                                : widget.outreachslots.description,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                // color: appStudentNeeds.read
                                //     ? Color.fromARGB(255, 107, 107, 107)
                                //     : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                overflow: TextOverflow.ellipsis),
                          ),
                          // Expanded(
                          //   child: IconButton(
                          //       onPressed: () {
                          //         outreachcubit!.acceptoutreach(user.token,
                          //             widget.outreachslots.slotId);
                          //         // setState(() {
                          //         // });
                          //       },
                          //       color: Colors.greenAccent,
                          //       icon: Icon(Icons.check)),
                          // ),
                          // Expanded(
                          //   child: IconButton(
                          //       onPressed: () {
                          //         outreachcubit!.rejectoutreach(user.token,
                          //             widget.outreachslots.slotId);
                          //         // setState(() {
                          //         // });
                          //       },
                          //       color: Colors.greenAccent,
                          //       icon: Icon(Icons.close)),
                          // ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "School " + widget.outreachslots.school,
                            style: TextStyle(
                                color: Colors.grey,
                                // color: appStudentNeeds.read
                                //     ? Color.fromARGB(255, 107, 107, 107)
                                //     : Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            "PES ID: " + widget.outreachslots.pes_id,
                            style: TextStyle(
                                color: Colors.grey,
                                // color: appStudentNeeds.read
                                //     ? Color.fromARGB(255, 107, 107, 107)
                                //     : Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            "status: " + widget.outreachslots.status,
                            style: TextStyle(
                                color: Colors.grey,
                                // color: appStudentNeeds.read
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
                        "Date: " + widget.outreachslots.date,
                        style: TextStyle(
                            color: Colors.grey,
                            // color: appStudentNeeds.read
                            //     ? Color.fromARGB(255, 107, 107, 107)
                            //     : Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        widget.outreachslots.timeStart.substring(
                                0, widget.outreachslots.timeStart.length - 3) +
                            "-" +
                            widget.outreachslots.timeEnd.substring(
                                0, widget.outreachslots.timeEnd.length - 3),
                        style: TextStyle(
                          color: Colors.grey,
                          // color: widget.appStudentNeeds.read
                          //     ? Color.fromARGB(255, 150, 149, 149)
                          //     : Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        "TOPIC: " + widget.outreachslots.topic,
                        style: TextStyle(
                            color: Colors.grey,
                            // color: appStudentNeeds.read
                            //     ? Color.fromARGB(255, 107, 107, 107)
                            //     : Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      ), //
    );
  }
}
//   String _studentNeedsInterval(TimeOfDay starttime,TimeOfDay endtime) {
//     // int seconds = DateTime.now().difference(studentNeedsTime).inSeconds;
//     // print("${studentNeedsTime}, ${DateTime.now()}, $seconds");
//     print(starttime );
//     print(endtime );

//     String timeInterval = "";

//     if (seconds < 60) {
//       timeInterval = "$seconds sec";
//     } else if (seconds / 60 < 60) {
//       timeInterval = "${(seconds / 60).floor()} min";
//     } else if (seconds / 3600 < 24) {
//       timeInterval = "${(seconds / 3600).floor()} hrs";
//     } else {
//       timeInterval =
//           "${studentNeedsTime.day}-${studentNeedsTime.month}-${studentNeedsTime.year}";
//     }

//     return timeInterval;
//   }
// }

class RemarksField extends StatelessWidget {
  final TextEditingController feedback;
  final int minLines, maxLines;
  RemarksField(
      {Key? key,
      required this.feedback,
      required this.minLines,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 35.0 * maxLines,
      child: TextField(
        onSubmitted: (_) {
          print("Feedback ${feedback.value.text}");
          Navigator.pop(context);
        },
        // keyboardType: TextInputType.multiline,
        minLines: minLines,
        maxLines: maxLines,
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
          //labelText: "",
          // labelStyle: TextStyle(
          //   fontSize: 25,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  final String f;
  final List<String> items;
  final Function(String) onItemSelected;

  const MyWidget(
      {Key? key,
      required this.items,
      required this.onItemSelected,
      required this.f})
      : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    // if (widget.f == "school") {
    //   _selectedItem = "Select a school";
    // } else {
    //   _selectedItem = "Select a topic";
    // }
    print(widget.items);

    return DropdownButton<String>(
      hint: (widget.f=="school")?Text("Select a School"):Text("Select a topic"),
      // hint:Text("select a school"),
      value: _selectedItem,
      items: widget.items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
          widget.onItemSelected(value!);
        });
      },
    );
  }
}

// class DateWidget extends StatefulWidget {
//   String currentDate;
//   DateWidget({Key? key, required this.currentDate}) : super(key: key);
//   @override
//   _DateWidgetState createState() => _DateWidgetState();
// }

// class _DateWidgetState extends State<DateWidget> {
//   @override
//   void initState() {
//     super.initState();
//     // _updateDate();
//   }

//   void _updateDate(String date) {
//     setState(() {
//       widget.currentDate = date;
//       // _currentDate = formatter.format(now);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       widget.currentDate,
//       style: TextStyle(fontSize: 20),
//     );
//   }
// }
