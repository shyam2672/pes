import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_delete_cubit.dart';
import 'package:pes_admin/cubit/slot_edit_cubit.dart';
import 'package:pes_admin/data/models/slots.dart';

import '../../data/models/user.dart';

class SlotTile extends StatelessWidget {
  final Slot slot;
  final bool mySlot;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");

  SlotTile({Key? key, required this.slot, required this.mySlot})
      : super(key: key);

  Widget collapsedTile(bool isCollapsed) {
    return Container(
      // width: 250,
      height: 50,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 0, bottom: isCollapsed ? 0 : 0),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 247, 98, 57),
              Color.fromARGB(255, 247, 57, 215),
            ]),
            // color: Color.fromARGB(255, 249, 66, 224),
            width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color.fromARGB(255, 18, 18, 18),
      ),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
      margin: const EdgeInsets.only(bottom: 5, top: 50),
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
            // height: 200,
            child: Column(
              children: [
                SizedBox(height: 10),
                TileHeading(
                  heading: "BATCH",
                  text: slot.batch,
                  noOfSiblings: 1,
                ),
                SizedBox(height: 10),
                TileHeading(
                  heading: "THINGS THAT WERE TAUGHT",
                  text: slot.remarks,
                  noOfSiblings: 1,
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

  SlotDeleteCubit? slotDeleteCubit;
  bool selected = false;
  SlotEditCubit? slotEditCubit;

  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    user = BlocProvider.of<LoginCubit>(context).user;
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    slotDeleteCubit = BlocProvider.of<SlotDeleteCubit>(context);
    slotEditCubit = BlocProvider.of<SlotEditCubit>(context);

    return BlocBuilder<SlotDeleteCubit, SlotDeleteState>(
      builder: (context, state) {
        if (!mySlot && state is SlotSelectionActive) {
          return Stack(
            children: [
              collapsedTile(true),
              SlotCheckBox(slot: slot),
            ],
          );
        } else {
          return BlocBuilder<SlotEditCubit, SlotEditState>(
            builder: (context, state) {
              if (state is SlotEditSelect) {
                return InkWell(
                  onTap: () {
                    slotEditCubit!.editSlot(slot);
                    Navigator.pushNamed(context, ADD_SLOT, arguments: {
                      'isBeingEdited': true,
                    });
                  },
                  child: collapsedTile(true),
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
      },
    );
  }

  _tileButtons(context) {
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
}

class SlotCheckBox extends StatefulWidget {
  bool value = false;
  final Slot slot;

  SlotCheckBox({Key? key, required this.slot}) : super(key: key);

  @override
  State<SlotCheckBox> createState() => _SlotCheckBoxState();
}

class _SlotCheckBoxState extends State<SlotCheckBox> {
  DeleteState(context) {
    if (!widget.value &&
        !slotDeleteCubit!.selectedSlots.contains(widget.slot.slotId)) {
      //If Checked
      slotDeleteCubit!.selectedSlots.add(widget.slot.slotId);
    } else if (widget.value &&
        slotDeleteCubit!.selectedSlots.contains(widget.slot.slotId)) {
      slotDeleteCubit!.selectedSlots
          .removeAt(slotDeleteCubit!.selectedSlots.indexOf(widget.slot.slotId));
    }
    print(slotDeleteCubit!.selectedSlots);
    setState(() {
      widget.value =
          slotDeleteCubit!.selectedSlots.contains(widget.slot.slotId);
    });
  }

  SlotDeleteCubit? slotDeleteCubit;
  @override
  Widget build(BuildContext context) {
    slotDeleteCubit = BlocProvider.of<SlotDeleteCubit>(context);
    widget.value = slotDeleteCubit!.selectedSlots.contains(widget.slot.slotId);
    return InkWell(
      onTap: () {
        DeleteState(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // width: 250,
        height: 50,
        padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
        margin: EdgeInsets.only(top: 0, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          // color: !widget.value
          //     ? Color(0xffE9EDF1).withOpacity(0.0)
          //     : Colors.grey.withOpacity(0.1),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            shape:
                CircleBorder(side: BorderSide(width: 1, color: Colors.white)),
            activeColor: Colors.white,
            checkColor: Colors.amber,
            hoverColor: Color.fromARGB(255, 144, 202, 249),
            focusColor: Colors.pink,
            value: widget.value,
            onChanged: (bool) => {DeleteState(context)},
          ),
        ),
      ),
    );
  }
}
