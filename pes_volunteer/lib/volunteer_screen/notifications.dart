import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/all_slots_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/notifications_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/data/models/notification.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/widgets/sidemenu.dart';
import 'package:pes/volunteer_screen/widgets/slot_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationTile> notifs = [];
  User user = User.empty(token: "");

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  NotificationsCubit? notificationsCubit;
  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    notificationsCubit = BlocProvider.of<NotificationsCubit>(context);
    notificationsCubit!.getNotifications(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Notifications",
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
          backgroundColor:
              appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
        ),

        controller: _pageRefreshController,
        onRefresh: () {
          print("Refresh");
          setState(() {
            notificationsCubit!.notifications = [];
          });
          _pageRefreshController.refreshCompleted();
        },
        // onLoading: _onLoading,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded) {
              return Container(
                color: Colors.black,
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
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        child: Container(
                          width: 200,
                          height: 40,
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
                          child: const Center(
                              child: Text(
                            "Mark All As Read",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )),
                        ),
                        onTap: () {
                          setState(() {
                            for (var notif in notifs) {
                              notif.appNotification.read = true;
                              notificationsCubit!.readNotifications(
                                  user.token, notif.appNotification.id);
                            }
                          });
                        },
                      ),
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
                              notificationsCubit!.notifications = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          // onLoading: _onLoading,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: notificationsCubit!.notifications.map(
                              (e) {
                                print(e);
                                NotificationTile notif =
                                    NotificationTile(appNotification: e);
                                notifs.add(notif);
                                return notif;
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is NotificationsError) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  AppNotification appNotification;

  NotificationTile({Key? key, required this.appNotification}) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  // foregroundColor: Colors.white,
  // backgroundColor: Colors.black,
  // onPrimary: Colors.black87,
  // primary: Color.fromARGB(255, 167, 166, 166),
  textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
);

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.appNotification.read = true;
        Navigator.pushNamed(
          context,
          NOTIFICATION_DETAIL,
          arguments: {
            "notificationObj": widget.appNotification,
            "timeRecieved": _notificationInterval(widget.appNotification.time)
          },
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        // decoration: BoxDecoration(
        //   // border: Border.all(width: 2, color: Colors.black),
        //   // borderRadius: BorderRadius.all(Radius.circular(20)),
        //   color: widget.appNotification.read
        //       ? Colors.white
        //       : Color.fromARGB(255, 218, 233, 250),
        // ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                color: widget.appNotification.read
                    ? appBarColor.withOpacity(0.02)
                    : Color.fromRGBO(223, 246, 255, .8).withOpacity(0.02),
                // color: appBarColor.withOpacity(0.02),
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 245, 72, 72), width: 2)),
                // border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.all(Radius.circular((5)))
              ),
              height: 50,
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
                              widget.appNotification.title.length > 35
                                  ? widget.appNotification.title
                                          .substring(0, 35) +
                                      '...'
                                  : widget.appNotification.title,
                              // maxLines: 1,
                              style: TextStyle(
                                  color: widget.appNotification.read
                                      ? Color.fromARGB(255, 107, 107, 107)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Container(
                                child: widget.appNotification.read
                                    ? Container()
                                    : Icon(
                                        Icons.circle,
                                        size: 13,
                                        color:
                                            Color.fromARGB(255, 247, 57, 215),
                                        // color: Colors.black,
                                      )),
                          ],
                        ),
                        Text(
                          _notificationInterval(widget.appNotification.time),
                          style: TextStyle(
                            color: widget.appNotification.read
                                ? Color.fromARGB(255, 150, 149, 149)
                                : Colors.white,
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

  String _notificationInterval(DateTime notificationTime) {
    int seconds = DateTime.now().difference(notificationTime).inSeconds;

    String timeInterval = "";

    if (seconds < 60) {
      timeInterval = "$seconds sec";
    } else if (seconds / 60 < 60) {
      timeInterval = "${(seconds / 60).floor()} min";
    } else if (seconds / 3600 < 24) {
      timeInterval = "${(seconds / 3600).floor()} hrs";
    } else {
      timeInterval =
          "${notificationTime.day}-${notificationTime.month}-${notificationTime.year}";
    }

    return timeInterval;
  }
}
