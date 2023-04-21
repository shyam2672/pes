import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/home_volunteer_tile.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_cubit.dart';
import 'package:pes_admin/cubit/today_volunteer_cubit.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

import '../constants/strings.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _State();
}

bool theme = false;

class _State extends State<HomeScreen> {
  User user = User.empty(token: "");
  SlotCubit? slotsCubit;
  TodayVolunteerCubit? todayVolunteerCubit;

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  // Color appBarColor = Color(0xff274D76);
  Color appBarColor = Colors.black;

  List<Widget> listofall() {
    List<Tab> tab = [
      Tab(
        child: Text("Teal"),
      ),
      Tab(
        child: Text("Green"),
      ),
      Tab(
        child: Text("data"),
      )
    ];

    List<Widget> tabsContent = [
      Container(
        color: Colors.amber,
      ),
      Container(
        color: Colors.black,
      ),
      Container(
        color: Colors.blue,
      ),
    ];

    child:
    TabBar(
      indicatorColor: Colors.amber,
      isScrollable: true,
      tabs: tab,
    );

    List<Widget> p1 = [];

    if (todayVolunteerCubit!.p1_volunteers.isNotEmpty) {
      p1.add(SectionHeading("Pathshaala 1"));
      p1.addAll(todayVolunteerCubit!.p1_volunteers
          .map((volunteer) => HomeVolunteerTile(
                volunteer: volunteer,
              ))
          .toList());
    }
    if (todayVolunteerCubit!.p2_volunteers.isNotEmpty) {
      p1.add(SectionHeading("Pathshaala 2"));
      p1.addAll(todayVolunteerCubit!.p2_volunteers
          .map((volunteer) => HomeVolunteerTile(
                volunteer: volunteer,
              ))
          .toList());
    }

    print(p1);
    print(todayVolunteerCubit!.p1_volunteers);
    return p1;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _notificationIcon() {
    return Container(
      width: 25,
      padding: EdgeInsets.only(top: 13),
      // color: Colors.black12,
      child: Stack(
        children: [
          Icon(Icons.notifications_rounded),
          // BlocBuilder<NewNotificationCubit, NewNotificationState>(
          //   builder: (context, state) {
          //     print(state);
          //     if (state is SomeNewNotification) {
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

  Widget _logoutIcon() {
    return Container(
        width: 25,
        padding: EdgeInsets.only(top: 13),
        // color: Colors.black12,
        child: Stack(children: [
          Icon(Icons.exit_to_app),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    todayVolunteerCubit = BlocProvider.of<TodayVolunteerCubit>(context);
    todayVolunteerCubit!.loadVolunteer(user.token);
    String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String todayDayOfWeekString = "day";
    switch (DateTime.now().weekday) {
      case 1:
        todayDayOfWeekString = 'Monday';
        break;
      case 2:
        todayDayOfWeekString = 'Tuesday';
        break;
      case 3:
        todayDayOfWeekString = 'Wednesday';
        break;
      case 4:
        todayDayOfWeekString = 'Thursday';
        break;
      case 5:
        todayDayOfWeekString = 'Friday';
        break;
      case 6:
        todayDayOfWeekString = 'Saturday';
        break;
      case 7:
        todayDayOfWeekString = 'Sunday';
        break;
    }
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: SideDrawer(),
        appBar: AppBar(
          actions: [
            InkWell(
              child: _notificationIcon(),
              onTap: () {
                Navigator.pushNamed(context, APP_NOTIFICATIONS);
              },
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              child: _logoutIcon(),
              onTap: () {
                BlocProvider.of<LoginCubit>(context).storeToken("").then(
                    (value) => BlocProvider.of<LoginCubit>(context).login());

                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 20,
            ),
          ],
          elevation: 0,
          // centerTitle: true,
          title: const Text(
            "Today's Volunteers",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: appBarColor,
          bottom: TabBar(tabs: <Widget>[
            Tab(
              child: Container(
                child: Text(
                  todayDayOfWeekString + "              " + todayDate,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
            Tab(
              child: Container(
                child: Text(
                  todayDayOfWeekString + "              " + todayDate,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            )
          ]),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            backgroundColor:
                appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
          ),

          controller: _pageRefreshController,
          onRefresh: () {
            setState(() {});
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
                  // Divider(
                  //   thickness: 1,
                  //   color: Colors.grey.withOpacity(0.3),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Hello ${user.name} !",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromARGB(255, 52, 52, 52).withOpacity(0.3),
                  ),
                  Expanded(
                    flex: 30,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child:
                          BlocBuilder<TodayVolunteerCubit, TodayVolunteerState>(
                        builder: (context, state) {
                          print(state);
                          if (state is TodayVolunteerLoaded) {
                            return SmartRefresher(
                              enablePullDown: true,
                              header: WaterDropMaterialHeader(
                                backgroundColor: appBarColor.withOpacity(
                                    0.8), //Theme.of(context).primaryColor,
                              ),
                              controller: _listRefreshController,
                              onRefresh: () {
                                setState(() {
                                  todayVolunteerCubit!.p1_volunteers = [];
                                  todayVolunteerCubit!.p2_volunteers = [];
                                  todayVolunteerCubit!.allVolunteers = [];
                                });
                                _listRefreshController.refreshCompleted();
                              },
                              child: ListView(
                                padding: EdgeInsets.all(4),
                                children: listofall(),
                              ),
                            );
                          } else if (state is TodayVolunteerFailure) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  String heading;
  SectionHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: 40,
      // decoration: BoxDecoration(
      //   color: Color(0xff274D76),
      //   borderRadius: BorderRadius.circular(10)
      // ),
      // decoration: BoxDecoration(
      //     border: Border(
      //         bottom: BorderSide(color: Colors.grey.shade300, width: 2.0))),
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.only(top: 15),
      child: Text(
        heading,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.fade),
      ),
    );
  }
}
