import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/all_slots_screen.dart';
import 'package:pes_admin/admin_screens/widgets/msg_dialog.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/all_slots_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_change_cubit.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SlotChangeScreen extends StatefulWidget {
  var bottomSheetController;
  List allSlots;
  List currentSlots;
  List requestedSlots;
  String pes_id;
  SlotChangeScreen(
      {required this.allSlots,
      required this.currentSlots,
      required this.requestedSlots,
      required this.pes_id});
  @override
  _SlotChangeScreenState createState() => _SlotChangeScreenState();
}

class _SlotChangeScreenState extends State<SlotChangeScreen> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);
  AllSlotsCubit? allSlotsCubit;
  SlotChangeCubit? slotChangeCubit;

  @override
  void initState() {
    super.initState();
  }

  void _showBottomNotification(BuildContext context, message) {
    widget.bottomSheetController = showModalBottomSheet(
        routeSettings: RouteSettings(name: "/bottom-sheet"),
        useRootNavigator: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.all(10), child: Text(message));
        });
    // widget.bottomSheetController.closed.then((value) {
    //   print(value);
    // });
  }

  /*Widget topbar(){
    return AvailabilityButtons(
        onTap: () {

          slotChangeCubit!.selectedSlots = [];
          slotChangeCubit!.emit(SlotChangeInitial());
          
        },
        child: Center(
          child: BlocBuilder<SlotChangeCubit, SlotChangeState>(
            builder: (context, state) {
              return Text(
                "Cancel",
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      );
  }*/

  Color tile_color(slot_id) {
    if (widget.requestedSlots.contains(int.parse(slot_id))) {
      print(slot_id + " orange");
      return Color.fromARGB(255, 255, 181, 70);
    }
    if (widget.currentSlots.contains(int.parse(slot_id)))
      return Colors.lightGreen;
    return Color.fromARGB(255, 84, 199, 253);
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);
    slotChangeCubit!.selectSlotChange();
    return BlocConsumer<SlotChangeCubit, SlotChangeState>(
      listenWhen: ((previous, current) {
        return current is ApplicationSubmitted ||
            current is ApplicationNotSubmitted ||
            current is SlotChangeLoading;
      }),
      listener: (context, state) {
        Navigator.popUntil(
            context, (route) => Navigator.defaultRouteName != CHANGE_SLOT);
        if (state is ApplicationSubmitted) {
          Navigator.pop(context);
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (contexts) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: MsgDialog("Slots changed"),
              );
            },
          );
          // _showBottomNotification(context, "Slot Changed for Volunteer");
          // Timer(Duration(seconds: 3), () {
          //   // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
          //   Navigator.pop(context);
          //   Navigator.pop(context);
          //   Navigator.pop(context);
          //   //setState(() => slotChangeCubit!.selectedSlots = []);
          // });
        } else if (state is ApplicationNotSubmitted) {
          Navigator.pop(context);
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (contexts) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: MsgDialog("Slots could not be changed. Try again"),
              );
            },
          );

          // _showBottomNotification(context, state.message);
          // Timer(Duration(seconds: 3), () {
          //   // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
          //   Navigator.pop(context);
          //   Navigator.pop(context);
          //   setState(() => slotChangeCubit!.selectedSlots = []);
          // });
        } else if (state is SlotChangeLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (contexts) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          //_showBottomNotification(context, "Processing Change Request...");
        }
      },
      buildWhen: (previous, current) {
        return (previous is SlotSelectionActive ||
            current is SlotSelectionActive);
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // drawer: SideDrawer(),
          appBar: AppBar(
            //actions: [topbar()],
            elevation: 0,
            // centerTitle: true,
            title: const Text(
              "Select Slots",
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
              backgroundColor: appBarColor
                  .withOpacity(0.8), //Theme.of(context).primaryColor,
            ),

            controller: _pageRefreshController,
            onRefresh: () {
              setState(() => slotChangeCubit!.selectedSlots = []);
              _pageRefreshController.refreshCompleted();
            },
            // onLoading: _onLoading,
            child: Container(
              color: appBarColor,
              child: Container(
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
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          BlocBuilder<SlotChangeCubit, SlotChangeState>(
                              builder: (context, state) {
                            return AvailabilityButtons(
                              onTap: () {
                                slotChangeCubit!.slotChangeApplication(
                                    user.token, widget.pes_id);
                              },
                              child: const Center(
                                child: Text(
                                  "Change",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }),
                          Spacer(),
                          SizedBox(
                              width: 15,
                              height: 15,
                              child: Container(
                                color: Colors.orange,
                              )),
                          Spacer(),
                          const Text(
                            "Requested",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          Spacer(),
                          SizedBox(
                              width: 15,
                              height: 15,
                              child: Container(
                                color: Colors.lightGreen,
                              )),
                          Spacer(),
                          const Text(
                            "Current",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: BlocBuilder<SlotChangeCubit, SlotChangeState>(
                          builder: (context, state) {
                            print(state);
                            if (state is SlotSelectionActive) {
                              return SmartRefresher(
                                enablePullDown: true,
                                header: WaterDropMaterialHeader(
                                  backgroundColor: appBarColor.withOpacity(
                                      0.8), //Theme.of(context).primaryColor,
                                ),
                                controller: _listRefreshController,
                                onRefresh: () {
                                  setState(() =>
                                      slotChangeCubit!.selectedSlots = []);
                                  // setState(() {
                                  //   slotsCubit!.allSlots = [];
                                  // });
                                  _listRefreshController.refreshCompleted();
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(4),
                                  children: widget.allSlots
                                      .map((mslot) => ChangeSlotTile(
                                            slot: mslot,
                                            mySlot: false,
                                            color: tile_color(mslot.slotId),
                                          ))
                                      .toList(),
                                ),
                              );
                            } else if (state is ApplicationNotSubmitted) {
                              return Center(
                                  child: Text(
                                state.message,
                                style: TextStyle(fontSize: 20),
                              ));
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChangeSlotTile extends StatelessWidget {
  final Slot slot;
  final bool mySlot;
  final Color color;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");

  ChangeSlotTile(
      {Key? key, required this.slot, required this.mySlot, required this.color})
      : super(key: key);

  Widget collapsedTile(bool isCollapsed) {
    return Container(
      // width: 250,
      height: 100,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: isCollapsed ? 5 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            offset: Offset(3, 3),
          ),
        ],
        color: color, //Color(0xffE9EDF1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slot.day,
            style: TextStyle(
              color: Color(0xff0f0f0f),
              fontSize: 18,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Spacer(),
              TileHeading(
                heading: "PATHSHAALA",
                text: slot.pathshaala,
                noOfSiblings: 2,
              ),
              Spacer(flex: 3),
              TileHeading(
                heading: "TIME",
                text: "${slot.timeStart} to ${slot.timeEnd}",
                noOfSiblings: 2,
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
      margin: const EdgeInsets.only(bottom: 5, top: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: const Color.fromRGBO(223, 246, 255, .8),
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

  SlotChangeCubit? slotChangeCubit;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    user = BlocProvider.of<LoginCubit>(context).user;
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);

    return BlocBuilder<SlotChangeCubit, SlotChangeState>(
      builder: (context, state) {
        if (!mySlot && state is SlotSelectionActive) {
          return Stack(
            children: [
              collapsedTile(true),
              SlotChangeCheckBox(slot: slot),
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
    return Row(
      children: [
        Spacer(),
        // SlotButton(
        //   onPressed: () {},
        //   text: 'Volunteers Assigned',
        // ),
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

class SlotChangeCheckBox extends StatefulWidget {
  bool value = false;
  final Slot slot;

  SlotChangeCheckBox({Key? key, required this.slot}) : super(key: key);

  @override
  State<SlotChangeCheckBox> createState() => _SlotChangeCheckBoxState();
}

class _SlotChangeCheckBoxState extends State<SlotChangeCheckBox> {
  DeleteState(context) {
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
    return InkWell(
      onTap: () {
        DeleteState(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // width: 250,
        height: 100,
        padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
        margin: EdgeInsets.only(top: 5, bottom: 5),
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
            onChanged: (bool) => {DeleteState(context)},
          ),
        ),
      ),
    );
  }
}
