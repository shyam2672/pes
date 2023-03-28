import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/all_slots_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_delete_cubit.dart';
import 'package:pes_admin/cubit/slot_edit_cubit.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllSlots extends StatefulWidget {
  var bottomSheetController;

  @override
  State<AllSlots> createState() => _State();
}

class _State extends State<AllSlots> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  Color appBarColor = Colors.black;

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

  Widget topbar() {
    if (slotDeleteCubit!.state is SlotSelectionActive) {
      Navigator.pop(context);
      return AvailabilityButtons(
        onTap: () {
          slotDeleteCubit!.selectedSlots = [];
          slotDeleteCubit!.emit(SlotDeleteInitial());
        },
        child: Center(
          child: BlocBuilder<SlotDeleteCubit, SlotDeleteState>(
            builder: (context, state) {
              return Text(
                "Cancel",
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      );
    } else {
      return BlocBuilder<SlotEditCubit, SlotEditState>(
        builder: (context, state) {
          if (slotEditCubit!.state is SlotEditSelect) {
            // Navigator.pop(context);
            return AvailabilityButtons(
              onTap: () {
                slotEditCubit!.selectSlot();
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
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
                        Navigator.pushNamed(context, ADD_SLOT,
                            arguments: {"isBeingEdited": false});
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
                        "Add Slot",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        slotEditCubit!.selectSlot();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.edit,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Edit Slots",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        slotDeleteCubit!.selectSlotDelete();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.delete,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Delete Slots",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
              ];
            });
          }
        },
      );
    }
  }

  AllSlotsCubit? slotsCubit;
  SlotDeleteCubit? slotDeleteCubit;
  SlotEditCubit? slotEditCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    slotDeleteCubit = BlocProvider.of<SlotDeleteCubit>(context);
    slotsCubit = BlocProvider.of<AllSlotsCubit>(context);
    slotsCubit!.loadAllSlots(user.token);
    slotEditCubit = BlocProvider.of<SlotEditCubit>(context);

    return BlocConsumer<SlotDeleteCubit, SlotDeleteState>(
      listenWhen: ((previous, current) {
        return current is ApplicationSubmitted ||
            current is ApplicationNotSubmitted ||
            current is SlotDeleteLoading;
      }),
      listener: (context, state) {
        Navigator.popUntil(
            context, (route) => Navigator.defaultRouteName != ALL_SLOTS);
        if (state is ApplicationSubmitted) {
          _showBottomNotification(context, "Slot Delete Application Submitted");
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => slotsCubit!.allSlots = []);
          });
        } else if (state is ApplicationNotSubmitted) {
          _showBottomNotification(context, state.message);
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => slotsCubit!.allSlots = []);
          });
        } else if (state is SlotDeleteLoading) {
          _showBottomNotification(context, "Processing Delete Request...");
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
            actions: [topbar()],
            elevation: 0,
            // centerTitle: true,
            title: const Text(
              "Active Slots",
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
              if (slotDeleteCubit!.state is! SlotSelectionActive) {
                setState(() {
                  slotsCubit!.allSlots = [];
                });
              }
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
                          BlocBuilder<SlotDeleteCubit, SlotDeleteState>(
                            builder: (context, state) {
                              if (state is SlotSelectionActive) {
                                return AvailabilityButtons(
                                  onTap: () {
                                    slotDeleteCubit!
                                        .slotDeleteApplication(user.token);
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else {
                                return BlocBuilder<SlotEditCubit,
                                    SlotEditState>(
                                  builder: (context, state) {
                                    if (state is SlotEditSelect) {
                                      return Column(
                                        children: [
                                          Text(
                                            "Select Slot to Edit",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          Text(
                                            getWeek(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
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
                        child: BlocBuilder<AllSlotsCubit, AllSlotsState>(
                          builder: (context, state) {
                            print(state);
                            if (state is AllLoaded) {
                              return SmartRefresher(
                                enablePullDown: true,
                                header: WaterDropMaterialHeader(
                                  backgroundColor: appBarColor.withOpacity(
                                      0.8), //Theme.of(context).primaryColor,
                                ),
                                controller: _listRefreshController,
                                onRefresh: () {
                                  if (slotDeleteCubit!.state
                                      is! SlotSelectionActive) {
                                    setState(() {
                                      slotsCubit!.allSlots = [];
                                    });
                                  }
                                  _listRefreshController.refreshCompleted();
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(4),
                                  children: slotsCubit!.allSlots
                                      .map((slot) => SlotTile(
                                            slot: slot,
                                            mySlot: false,
                                          ))
                                      .toList(),
                                ),
                              );
                            } else if (state is AllLoadFailure) {
                              return Center(
                                  child: Text(
                                state.error,
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

  List<String> months = [
    "January",
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String getWeek() {
    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(days: now.weekday % 7));
    DateTime end = start.add(const Duration(days: 6));

    return ("${start.day} ${months[start.month - 1].substring(0, 3)} - ${end.day} ${months[end.month - 1].substring(0, 3)}");
  }
}

class AvailabilityButtons extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  const AvailabilityButtons(
      {Key? key, required this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 35,
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
      child: InkWell(child: child, onTap: onTap),
    );
  }
}
