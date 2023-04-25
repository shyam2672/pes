import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/studentNeeds_cubit.dart';
import 'package:pes_admin/cubit/outreach_cubit.dart';

import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pes_admin/data/models/outreachslot.dart';

Widget topbar() {
   
            return PopupMenuButton(
                // padding: EdgeInsets.zero,
                onCanceled: () {
              print('Popupmenu cancelled!');
            }, itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ADDSCHOOL);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.add,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Add School",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ADDTOPIC);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.add,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Add Topic",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                
              ];
            });
          }
    

class OutreachSlotsScreen extends StatefulWidget {
  @override
  State<OutreachSlotsScreen> createState() => _OutreachScreenState();
}

OutreachCubit? outreachcubit;
User user = User.empty(token: "");

class _OutreachScreenState extends State<OutreachSlotsScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  Widget _attendanceDialog(context) {
    return Container(
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
            "Send Student Needs",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          // Spacer(flex: 2),
          Text(
            "Title",
            style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          ),
          SizedBox(height: 5),
          RemarksField(
            feedback: _title,
            minLines: 1,
            maxLines: 1,
          ),
          SizedBox(height: 20),
          // Spacer(),
          Text(
            "Description",
            style: TextStyle(fontSize: 22, color: Color(0xff164476)),
          ),
          SizedBox(height: 5),
          RemarksField(
            feedback: _description,
            minLines: 3,
            maxLines: 3,
          ),
          // Spacer(),
          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    // outreachSlot!.addStudentNeeds(
                    //     user.token, user.name, _title.text, _description.text);
                    // Navigator.pop(context);
                    // setState(() {
                    //   studentNeedsCubit!.studentNeeds = [];
                    // });
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
            ],
          ),
          // Spacer(),
        ],
      ),
    );
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
         actions: [topbar()],
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     _showAttendanceDialog(context);
      //     print("Button tapped");
      //   },
      //   child: Container(
      //     height: 50,
      //     width: 50,
      //     // width: MediaQuery.of(context).size.width * 0.70,
      //     margin: EdgeInsets.all(10),
      //     //padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Color.fromARGB(255, 245, 72, 72),
      //       //borderRadius: BorderRadius.circular(18),
      //       border: Border.all(
      //         color: Color.fromARGB(255, 245, 72, 72),
      //         width: 1,
      //       ),
      //     ),
      //     child: Center(
      //       child: Icon(
      //         Icons.add,
      //         color: Colors.white,
      //       ), //Text("Edit ",style: const TextStyle(color: Colors.white,fontFamily: "Roboto",fontSize: 17),)
      //     ),
      //   ),
      // ),

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
    return InkWell(
      onTap: () {
        //appStudentNeeds.read = true;
        Navigator.pushNamed(
          context,
          OUTREACH,
          arguments: {
            "outreachObj": widget.outreachslots
            // "timeRecieved":
            // _studentNeedsInterval(widget.outreachslots.post_time)
          },
        );
      },
      child: Container(
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
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    outreachcubit!.acceptoutreach(user.token,
                                        widget.outreachslots.slotId);
                                    // setState(() {
                                    // });
                                  },
                                  color: Colors.greenAccent,
                                  icon: Icon(Icons.check)),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    outreachcubit!.rejectoutreach(user.token,
                                        widget.outreachslots.slotId);
                                    // setState(() {
                                    // });
                                  },
                                  color: Colors.greenAccent,
                                  icon: Icon(Icons.close)),
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
                            // Text(
                            //   "NAME: " + widget.outreachslots.Name,
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       // color: appStudentNeeds.read
                            //       //     ? Color.fromARGB(255, 107, 107, 107)
                            //       //     : Colors.white,
                            //       // fontWeight: FontWeight.bold,
                            //       fontSize: 15,
                            //       overflow: TextOverflow.ellipsis),
                            // ),
                          ],
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          widget.outreachslots.timeStart +
                              "-" +
                              widget.outreachslots.timeEnd,
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
// }
