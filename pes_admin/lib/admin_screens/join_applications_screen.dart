import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/leave_applications_tile.dart';
import 'package:pes_admin/admin_screens/widgets/msg_dialog.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/join_application_cubit.dart';
import 'package:pes_admin/cubit/join_decision_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JoinApplicationsScreen extends StatefulWidget {
  var bottomSheetController;
  @override
  _JoinApplicationsScreenState createState() => _JoinApplicationsScreenState();
}

class _JoinApplicationsScreenState extends State<JoinApplicationsScreen> {
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
    print("234 Route Name: ${widget.bottomSheetController.toString()}");
  }

  JoinApplicationCubit? joinApplicationsCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    joinApplicationsCubit = BlocProvider.of<JoinApplicationCubit>(context);
    joinApplicationsCubit!.loadApplications(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Join Pehchaan Applications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: BlocConsumer<JoinDecisionCubit, JoinDecisionState>(
          listener: (context, state) {
        Navigator.popUntil(context,
            (route) => Navigator.defaultRouteName != JOIN_APPLICATIONS);
        if (state is JoinDecisionMarked) {
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
                child: MsgDialog("Application ${state.decision}ed"),
              );
            },
          );
          setState(() => joinApplicationsCubit!.applications = []);
        } else if (state is JoinDecisionNotMarked) {
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
                child: MsgDialog("Could not process request. Try again later"),
              );
            },
          );
          setState(() => joinApplicationsCubit!.applications = []);
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (contexts) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
      }, builder: (context, state) {
        return SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            backgroundColor:
                appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
          ),

          controller: _pageRefreshController,
          onRefresh: () {
            setState(() {
              joinApplicationsCubit!.applications = [];
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
                  SizedBox(height: 10),
                  // Divider(
                  //   thickness: 3,
                  //   color: Colors.grey.withOpacity(0.1),
                  // ),
                  Expanded(
                    flex: 30,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: BlocBuilder<JoinApplicationCubit,
                          JoinApplicationState>(
                        builder: (context, state) {
                          print(state);
                          if (state is JoinApplicationLoaded) {
                            return SmartRefresher(
                              enablePullDown: true,
                              header: WaterDropMaterialHeader(
                                backgroundColor: appBarColor.withOpacity(
                                    0.8), //Theme.of(context).primaryColor,
                              ),
                              controller: _listRefreshController,
                              onRefresh: () {
                                setState(() {
                                  joinApplicationsCubit!.applications = [];
                                });
                                _listRefreshController.refreshCompleted();
                              },
                              child: ListView(
                                padding: EdgeInsets.all(4),
                                children: joinApplicationsCubit!.applications
                                    .map((application) => JoinApplicationTile(
                                          application: application,
                                        ))
                                    .toList(),
                              ),
                            );
                          } else if (state is JoinApplicationLoadFailed) {
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
      }),
    );
  }
}
