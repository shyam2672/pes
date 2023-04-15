import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/firebaseml/v1.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/attendance_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/new_notification_cubit.dart';
import 'package:pes/cubit/profile_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/widgets/sidemenu.dart';
import 'package:pes/volunteer_screen/widgets/slot_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LoggedIn currentstate;
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  Color appBarColor = Colors.black;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          print("Notification Recieved");
        }
      },
    );
  }

  Widget _notificationIcon() {
    return Container(
      width: 25,
      padding: EdgeInsets.only(top: 13),
      // color: Colors.black12,
      child: Stack(
        children: [
          Icon(Icons.notifications_rounded),
          BlocBuilder<NewNotificationCubit, NewNotificationState>(
            builder: (context, state) {
              print(state);
              if (state is SomeNewNotification) {
                return Container(
                  // color: Colors.pink,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.circle,
                      size: 14,
                      color: Colors.red,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _profileIcon() {
    return Container(
      width: 25,
      padding: EdgeInsets.only(top: 13),
      // color: Colors.black12,
      child: Stack(
        children: [
          Icon(Icons.person),
          // BlocBuilder<ProfileCubit, ProfileState>(
          //   builder: (context, state) {
          //     print(state);
          //     if (state is ProfileLoaded) {
          //       return Container(
          //         // color: Colors.pink,
          //         width: double.infinity,
          //         child: Align(
          //           alignment: Alignment.topRight,
          //           child: Icon(
          //             Icons.circle,
          //             size: 14,
          //             color: Colors.red,
          //           ),
          //         ),
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  SlotsCubit? slotsCubit;
  NewNotificationCubit? newNotificationCubit;
  @override
  Widget build(BuildContext context) {
    print("Home Refreshed");
    user = BlocProvider.of<LoginCubit>(context).user;
    slotsCubit = BlocProvider.of<SlotsCubit>(context);
    slotsCubit!.loadVolunteerSlots(user.token);
    newNotificationCubit = BlocProvider.of<NewNotificationCubit>(context);
    newNotificationCubit!.getNewNotification(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(),
      appBar: AppBar(
        actions: [
          InkWell(
            child: _notificationIcon(),
            onTap: () {
              Navigator.pushNamed(context, NOTIFICATION_SCREEN)
                  .then((value) => setState(() {}));
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: _profileIcon(),
            onTap: () {
              Navigator.pushNamed(context, PROFILE)
                  .then((value) => setState(() {}));
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (state is AttendanceMarked) {
            _showBottomNotification(context, "Attendance Marked");
            Timer(Duration(seconds: 3), () {
              Navigator.popUntil(
                  context, (route) => !route.hasActiveRouteBelow);
              setState(() => slotsCubit!.slots = []);
            });
          } else if (state is AttendanceNotMarked) {
            _showBottomNotification(context, state.message);
            Timer(Duration(seconds: 3), () {
              Navigator.popUntil(
                  context, (route) => !route.hasActiveRouteBelow);
              setState(() => slotsCubit!.slots = []);
            });
          } else {
            _showBottomNotification(context, "Marking Attendance");
          }
        },
        builder: (context, state) {
          return SmartRefresher(
            enablePullDown: true,
            header: WaterDropMaterialHeader(
              backgroundColor: appBarColor
                  .withOpacity(0.8), //Theme.of(context).primaryColor,
            ),

            controller: _pageRefreshController,
            onRefresh: () {
              setState(() {
                slotsCubit!.slots = [];
              });
              _pageRefreshController.refreshCompleted();
            },
            // onLoading: _onLoading,
            child: Container(
              color: appBarColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(20),
                  //   topLeft: Radius.circular(20),
                  // ),
                  color: Color.fromARGB(255, 18, 18, 18),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: Text("Hi ${user.name}, your Slots",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    Divider(
                      thickness: 2,
                      color: Color.fromARGB(255, 52, 52, 52).withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      getWeek(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                    Text(
                                      "Day",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    // ElevatedButton(
                                    //   style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all(
                                    //             Color.fromARGB(
                                    //                 255, 88, 93, 94)),
                                    //     overlayColor: MaterialStateProperty.all(
                                    //         Color.fromARGB(255, 153, 191, 224)),
                                    //   ),
                                    //   onPressed: _selectday,
                                    //   child: Text("Filter"),
                                    // )
                                  ],
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(13, 10, 11, 10),
                            child: SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                    Text(
                                      "Batch",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    // ElevatedButton(
                                    //   style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all(
                                    //             Color.fromARGB(
                                    //                 255, 88, 93, 94)),
                                    //     overlayColor: MaterialStateProperty.all(
                                    //         Color.fromARGB(255, 153, 191, 224)),
                                    //   ),
                                    //   onPressed: _selectbatch,
                                    //   child: Text("Filter"),
                                    // )
                                  ],
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(13, 10, 11, 10),
                            child: SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                    Text(
                                      "Pathshaala",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    // ElevatedButton(
                                    //   style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all(
                                    //             Color.fromARGB(
                                    //                 255, 88, 93, 94)),
                                    //     overlayColor: MaterialStateProperty.all(
                                    //         Color.fromARGB(255, 153, 191, 224)),
                                    //   ),
                                    //   onPressed: _selectpathshaala,
                                    //   child: Text("Filter"),
                                    // )
                                  ],
                                )),
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: SizedBox(
                                  width: 40,
                                  child: Text(
                                    "Time",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: BlocBuilder<SlotsCubit, SlotsState>(
                          builder: (context, state) {
                            print(state);
                            if (state is Loaded) {
                              return SmartRefresher(
                                enablePullDown: true,
                                header: WaterDropMaterialHeader(
                                  backgroundColor: appBarColor.withOpacity(
                                      0.8), //Theme.of(context).primaryColor,
                                ),
                                controller: _listRefreshController,
                                onRefresh: () {
                                  // setState(() {});
                                  setState(() {
                                    slotsCubit!.slots = [];
                                  });
                                  _listRefreshController.refreshCompleted();
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(4),
                                  children: slotsCubit!.slots
                                      .map((slot) => SlotTile(
                                            slot: slot,
                                            mySlot: true,
                                          ))
                                      .toList(),
                                ),
                              );
                            } else if (state is LoadFailure) {
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
          );
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
    DateTime start = now.subtract(Duration(days: now.weekday));
    DateTime end = start.add(const Duration(days: 6));

    return ("${start.day} ${months[start.month - 1].substring(0, 3) + "(Sun)"} - ${end.day} ${months[end.month - 1].substring(0, 3) + "(Sat)"}");
  }
}
