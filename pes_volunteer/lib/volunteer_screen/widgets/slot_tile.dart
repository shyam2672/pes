import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/attendance_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/volunteer_screen/widgets/slot_button.dart';

class SlotTile extends StatelessWidget {
  final Slot slot;
  final bool mySlot;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");

  SlotTile({Key? key, required this.slot, required this.mySlot})
      : super(key: key);

  Widget collapsedTile(bool isCollapsed) {
    return Container(
      //width: 800,
      height: 50,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: isCollapsed ? 0 : 0),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 247, 98, 57),
              Color.fromARGB(255, 247, 57, 215),
            ]),
            // color: Color.fromARGB(255, 249, 66, 224),
            width: 1.5),
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color.fromARGB(255, 18, 18, 18),
      ),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Text(
                //   slot.day,
                //   style: TextStyle(
                //     color: Color.fromARGB(255, 255, 255, 255),
                //     fontSize: 18,
                //     fontFamily: "Roboto",
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // Spacer(),
                // mySlot
                //     ? _slotDayisToday()
                //         ? Icon(
                //             Icons.circle,
                //             color: Colors.greenAccent,
                //             size: 20,
                //           )
                //         : Container()
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                  child: Text(
                    slot.day.substring(0, 3),
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    slot.batch,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Text(
                    slot.pathshaala,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //Spacer(),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: Text(
                    "${slot.timeStart} to ${slot.timeEnd}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //     : Container()
              ],
            ),
          ),
          //Spacer(),
          // Row(
          //   children: [
          //     Spacer(),
          //     TileHeading(heading: "PATHSHAALA", text: slot.pathshaala),
          //     Spacer(flex: 3),
          //     TileHeading(
          //         heading: "TIME",
          //         text: "${slot.timeStart} to ${slot.timeEnd}"),
          //     Spacer(),
          //   ],
          // ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget moreInfo(context) {
    return Container(
      // width: 250,
      // height: 300,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.only(bottom: 0, top: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.4),
        //     offset: Offset(3, 3),
        //   ),
        // ],
        //color: const Color.fromRGBO(93, 139, 214, .4),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            // constraints: BoxConstraints(minHeight: 250, maxHeight: 300),
            // height: 200,
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(),
                    TileHeading(heading: "BATCH", text: slot.batch),
                    Spacer(),
                    TileHeading(
                        heading: "BATCH CLASSES", text: slot.batchClass),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 10),
                TileHeading(
                  heading: "THINGS TAUGHT IN LAST SESSION",
                  text: slot.remarks,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 10),
          _tileButtons(context),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  SlotChangeCubit? slotChangeCubit;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    user = BlocProvider.of<LoginCubit>(context).user;
    attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);

    return BlocBuilder<SlotChangeCubit, SlotChangeState>(
      builder: (context, state) {
        if (!mySlot && state is SlotSelectionActive) {
          return Stack(
            children: [
              collapsedTile(true),
              SlotCheckBox(slot: slot),
            ],
          );
        } else {
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
      },
    );
  }

  _tileButtons(context) {
    if (mySlot)
      return Row(
        children: [
          //Spacer(),
          SlotButton(
            onPressed: () {
              Navigator.pushNamed(context, SYLLABUS_SCREEN,
                  arguments: {'batch': slot.batch});
            },
            text: "Syllabus",
          ),
          Spacer(flex: 3),
          SlotButton(
            isActive: _slotDayisToday(),
            onPressed: () {
              _showAttendanceDialog(context);
              print("Attendance");
            },
            text: "Attendance",
          ),
          Spacer(),
        ],
      );
    else
      return Row(
        children: [
          Spacer(),
          SlotButton(
            onPressed: () {
              Navigator.pushNamed(context, SYLLABUS_SCREEN,
                  arguments: {'batch': slot.batch});
            },
            text: "Syllabus",
          ),
          Spacer(),
        ],
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
  }

  _isSlotActive(Slot slot) {
    print(slot.timeStart);
  }

  AttendanceCubit? attendanceCubit;
  Widget _attendanceDialog(context) {
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
            "Mark Your Attendance",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Spacer(flex: 2),
          Text(
            "What did you teach?",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          Spacer(),
          RemarksField(
            feedback: _remarks,
          ),
          Spacer(),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    _isSlotActive(slot);
                    attendanceCubit!
                        .markAttendance(user.token, slot.slotId, _remarks.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 247, 98, 57),
                        Color.fromARGB(255, 247, 57, 215),
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Center(
                      child: Text(
                        "Mark Attendance",
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

  List<String> days = [
    'SUNDAY',
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY'
  ];
  _slotDayisToday() {
    return days.indexOf(slot.day) == DateTime.now().weekday;
  }
}

class SlotCheckBox extends StatefulWidget {
  bool value = false;
  final Slot slot;

  SlotCheckBox({Key? key, required this.slot}) : super(key: key);

  @override
  State<SlotCheckBox> createState() => _SlotCheckBoxState();
}

class _SlotCheckBoxState extends State<SlotCheckBox> {
  changeState(context) {
    if (!widget.value &&
        !slotChangeCubit!.selectedSlots.contains(widget.slot.slotId)) {
      //If Checked
      slotChangeCubit!.selectedSlots.add(widget.slot.slotId);
    } else if (widget.value &&
        slotChangeCubit!.selectedSlots.contains(widget.slot.slotId)) {
      slotChangeCubit!.selectedSlots
          .removeAt(slotChangeCubit!.selectedSlots.indexOf(widget.slot.slotId));
    }
    print(slotChangeCubit!.selectedSlots);
    setState(() {
      widget.value =
          slotChangeCubit!.selectedSlots.contains(widget.slot.slotId);
    });
  }

  SlotChangeCubit? slotChangeCubit;
  @override
  Widget build(BuildContext context) {
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);
    widget.value = slotChangeCubit!.selectedSlots.contains(widget.slot.slotId);

    print("Slot ${widget.slot.slotId} is ${widget.value}");
    return InkWell(
      onTap: () {
        changeState(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // width: 250,
        height: 50,
        padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
        margin: EdgeInsets.only(top: 0, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: !widget.value
              ? Color(0xffE9EDF1).withOpacity(0.0)
              : Colors.grey.withOpacity(0.1),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            value: widget.value,
            onChanged: (bool? newValue) {
              changeState(context);
              // widget.value = newValue!;
            },
          ),
        ),
      ),
    );
  }
}

class RemarksField extends StatelessWidget {
  final TextEditingController feedback;
  RemarksField({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          contentPadding: EdgeInsets.fromLTRB(20, 7, 20, 7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          labelText: "Remarks",
          labelStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TileHeading extends StatelessWidget {
  final String heading, text;

  const TileHeading({Key? key, required this.heading, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 13,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          // width: MediaQuery.of(context).size.width / 3,
          child: Center(
            child: Text(
              text,
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
