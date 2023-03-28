import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/all_slots_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/widgets/sidemenu.dart';
import 'package:pes/volunteer_screen/widgets/slot_tile.dart';
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

  Color appBarColor = Color.fromARGB(255, 0, 0, 0);

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
    print("234 Route Name: ${widget.bottomSheetController.toString()}");
  }

  AllSlotsCubit? slotsCubit;
  SlotChangeCubit? slotChangeCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);
    slotsCubit = BlocProvider.of<AllSlotsCubit>(context);
    slotsCubit!.loadAllSlots(user.token);
    return BlocConsumer<SlotChangeCubit, SlotChangeState>(
      listenWhen: ((previous, current) {
        return current is ApplicationSubmitted ||
            current is ApplicationNotSubmitted ||
            current is SlotChangeLoading;
      }),
      listener: (context, state) {
        print("Route Name: ${ModalRoute.of(context)?.settings.name}");
        Navigator.popUntil(
            context, (route) => Navigator.defaultRouteName != ALL_SLOTS);
        if (state is ApplicationSubmitted) {
          _showBottomNotification(context, "Slot Change Application Submitted");
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => slotsCubit!.slots = []);
          });
        } else if (state is ApplicationNotSubmitted) {
          _showBottomNotification(context, state.message);
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => slotsCubit!.slots = []);
          });
        } else if (state is SlotChangeLoading) {
          _showBottomNotification(context, "Changing Availability");
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // drawer: SideDrawer(),
          appBar: AppBar(
            elevation: 0,
            // centerTitle: true,
            title: const Text(
              "All Slots",
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
              setState(() {
                slotsCubit!.allSlots = [];
              });
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          BlocBuilder<SlotChangeCubit, SlotChangeState>(
                            builder: (context, state) {
                              if (state is SlotSelectionActive) {
                                return AvailabilityButtons(
                                  onTap: () {
                                    slotChangeCubit!
                                        .slotChangeApplication(user.token);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Submit",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else
                                return Text(
                                  getWeek(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                );
                            },
                          ),
                          Spacer(),
                          //Availbilty
                          AvailabilityButtons(
                            onTap: () {
                              print(
                                  "Selection Changed state = ${slotChangeCubit!.state}");
                              slotChangeCubit!.selectedSlots = [];
                              if (slotChangeCubit!.state is SlotSelectionActive)
                                slotChangeCubit!.emit(SlotChangeInitial());
                              else
                                slotChangeCubit!.emit(SlotSelectionActive());
                            },
                            child: Center(
                              child:
                                  BlocBuilder<SlotChangeCubit, SlotChangeState>(
                                builder: (context, state) {
                                  return Text(
                                    slotChangeCubit!.state
                                            is SlotSelectionActive
                                        ? "Cancel"
                                        : "Request Slots",
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Color.fromARGB(255, 52, 52, 52).withOpacity(0.3),
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
                                  setState(() {
                                    slotsCubit!.allSlots = [];
                                  });
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
      height: 38,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 247, 57, 215),
          Color.fromARGB(255, 247, 98, 57)
        ]),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: const Color(0xff274d76),
        //   width: 1,
        // ),
      ),
      child: InkWell(child: child, onTap: onTap),
    );
  }
}
