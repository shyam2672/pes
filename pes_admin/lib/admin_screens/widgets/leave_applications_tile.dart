import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/join_decision_cubit.dart';
import 'package:pes_admin/cubit/leave_decision_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/data/models/join_application.dart';
import 'package:pes_admin/data/models/leave_applications.dart';
import 'package:pes_admin/data/models/user.dart';

class LeaveApplicationTile extends StatelessWidget {
  final LeaveApplication application;
  LeaveDecisionCubit? leaveDecisionCubit;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");

  LeaveApplicationTile({Key? key, required this.application}) : super(key: key);

  Widget collapsedTile(bool isCollapsed) {
    return Container(
      // width: 250,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: isCollapsed ? 5 : 0),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 247, 98, 57),
              Color.fromARGB(255, 247, 57, 215),
            ]),
            // color: Color.fromARGB(255, 249, 66, 224),
            width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Row(
            children: [
              Spacer(),
              TileHeading(
                heading: "PES ID",
                text: application.pes_id,
                noOfSiblings: 3,
              ),
              Spacer(),
              TileHeading(
                heading: "NAME",
                text: application.name,
                noOfSiblings: 3,
              ),
              Spacer(),
              TileHeading(
                heading: "PATHSHAALA",
                text: application.pathshaala,
                noOfSiblings: 3,
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget moreInfo(context) {
    return Container(
      // width: 250,
      // height: 300,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.only(bottom: 5, top: 85),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          TileHeading(
            heading: "DAYS TAUGHT",
            text: application.attend,
            noOfSiblings: 1,
          ),
          SizedBox(
            height: 15,
          ),
          TileHeading(
            heading: "Raeason for leaving",
            text: application.reason,
            noOfSiblings: 1,
          ),
          SizedBox(height: 20),
          Container(
            // decoration: BoxDecoration(boxShadow: [
            //   BoxShadow(
            //     color: const Color.fromRGBO(223, 246, 255, .99),
            //     blurRadius: 2.0,
            //     //offset: Offset(3,3),
            //   )
            // ]),
            // constraints: BoxConstraints(minHeight: 250, maxHeight: 300),
            height: 80,
            //width:  MediaQuery. of(context).size.height *.6,
            child: Row(
              children: [
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, VOLUNTEER_PROFILE,
                          arguments: {
                            'pesId': application.pes_id,
                          });
                    },
                    child: Container(
                      height: 42,
                      width: 95,
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
                      child: Center(
                          child: Text("View Profile",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14))),
                    )),

                Spacer(),
                Column(children: [
                  //Spacer(),
                  SizedBox(width: 15),
                  DecisionButton("Accept", () {
                    leaveDecisionCubit!.makeLeaveDecision(
                        user.token, application.pes_id, "accept");
                  }),
                  Spacer(),
                  DecisionButton("Reject", () {
                    leaveDecisionCubit!.makeLeaveDecision(
                        user.token, application.pes_id, "reject");
                  }),
                ]),
                //SizedBox(width:15),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    user = BlocProvider.of<LoginCubit>(context).user;
    leaveDecisionCubit = BlocProvider.of<LeaveDecisionCubit>(context);
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    return ExpandableNotifier(
      child: Expandable(
        collapsed: ExpandableButton(
          child: collapsedTile(true),
        ),
        expanded: Stack(
          children: [
            moreInfo(context),
            ExpandableButton(
              child: collapsedTile(false),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinApplicationTile extends StatelessWidget {
  final JoinApplication application;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");
  JoinDecisionCubit? joinDecisionCubit;

  JoinApplicationTile({Key? key, required this.application}) : super(key: key);

  Widget collapsedTile(bool isCollapsed) {
    return Container(
      // width: 250,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: isCollapsed ? 5 : 0),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 247, 98, 57),
              Color.fromARGB(255, 247, 57, 215),
            ]),
            // color: Color.fromARGB(255, 249, 66, 224),
            width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Row(
            children: [
              Spacer(),
              TileHeading(
                heading: "NAME",
                text: application.name,
                noOfSiblings: 3,
              ),
              Spacer(),
              TileHeading(
                heading: "PROFESSION",
                text: application.profession,
                noOfSiblings: 3,
              ),
              Spacer(),
              TileHeading(
                heading: "PATHSHAALA",
                text: application.pathshaala,
                noOfSiblings: 3,
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget moreInfo(context) {
    return Container(
      //width:  MediaQuery. of(context).size.height *.6,
      // width: 250,
      // height: 300,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.only(bottom: 5, top: 85),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            // constraints: BoxConstraints(minHeight: 250, maxHeight: 300),
            height: 80,
            //width:  MediaQuery. of(context).size.height *.6,
            child: Row(
              children: [
                Spacer(),
                InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, JOIN_APPLICATION_DETAILS,
                        arguments: {"application": application}),
                    child: Container(
                      height: 42,
                      width: 95,
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
                      child: Center(
                          child: Text("View Details",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14))),
                    )),

                Spacer(),
                Column(children: [
                  //Spacer(),
                  SizedBox(width: 15),
                  DecisionButton("Accept", () {
                    joinDecisionCubit!.makeJoinDecision(
                        user.token, application.phone, "accept");
                  }),
                  Spacer(),
                  DecisionButton("Reject", () {
                    joinDecisionCubit!.makeJoinDecision(
                        user.token, application.phone, "reject");
                  }),
                ]),
                //SizedBox(width:15),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    user = BlocProvider.of<LoginCubit>(context).user;
    joinDecisionCubit = BlocProvider.of<JoinDecisionCubit>(context);
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    return ExpandableNotifier(
      child: Expandable(
        collapsed: ExpandableButton(
          child: collapsedTile(true),
        ),
        expanded: Stack(
          children: [
            moreInfo(context),
            ExpandableButton(
              child: collapsedTile(false),
            ),
          ],
        ),
      ),
    );
  }
}

class DecisionButton extends StatelessWidget {
  String label;
  Function()? onTap;

  DecisionButton(this.label, this.onTap);
  Widget icon() {
    if (label == "Accept")
      return Icon(
        Icons.check_circle_outline,
        color: Color(0xff40AA71),
      );
    else
      return Icon(
        Icons.cancel,
        color: Color(0xffce5454),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            width: 80,
            child: Row(
              //width: 90,
              /*decoration: BoxDecoration(
        color: const Color(0xff274D76),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff274d76),
          width: 1,
        ),
      ),
      */
              children: [
                icon(),
                SizedBox(
                  width: 5,
                ),
                Center(
                    child: Text(label,
                        style: TextStyle(color: Colors.white, fontSize: 14)))
              ],
            )));
  }
}
