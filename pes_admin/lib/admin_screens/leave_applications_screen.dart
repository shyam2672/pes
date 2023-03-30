import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/leave_applications_tile.dart';
import 'package:pes_admin/admin_screens/widgets/msg_dialog.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/leave_applications_cubit.dart';
import 'package:pes_admin/cubit/leave_decision_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LeaveApplicationsScreen extends StatefulWidget {
  var bottomSheetController;
  @override
  _LeaveApplicationsScreenState createState() =>
      _LeaveApplicationsScreenState();
}

class _LeaveApplicationsScreenState extends State<LeaveApplicationsScreen> {
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

  LeaveApplicationsCubit? leaveApplicationsCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    leaveApplicationsCubit = BlocProvider.of<LeaveApplicationsCubit>(context);
    leaveApplicationsCubit!.loadApplications(user.token);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //drawer: SideDrawer(),
        appBar: AppBar(
          elevation: 0,
          // centerTitle: true,
          title: const Text(
            "Leave Pehchaan Applications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: appBarColor,
        ),
        body: BlocConsumer<LeaveDecisionCubit, LeaveDecisionState>(
            listener: (context, state) {
          Navigator.popUntil(context,
              (route) => Navigator.defaultRouteName != LEAVE_APPLICATIONS);
          if (state is LeaveDecisionMarked) {
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
            setState(() => leaveApplicationsCubit!.applications = []);
          } else if (state is LeaveDecisionNotMarked) {
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
                  child:
                      MsgDialog("Could not process request. Try again later"),
                );
              },
            );
            setState(() => leaveApplicationsCubit!.applications = []);
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
              backgroundColor: appBarColor
                  .withOpacity(0.8), //Theme.of(context).primaryColor,
            ),

            controller: _pageRefreshController,
            onRefresh: () {
              setState(() {
                leaveApplicationsCubit!.applications = [];
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
                        child: BlocBuilder<LeaveApplicationsCubit,
                            LeaveApplicationsState>(
                          builder: (context, state) {
                            print(state);
                            if (state is LeaveApplicationsLoaded) {
                              return SmartRefresher(
                                enablePullDown: true,
                                header: WaterDropMaterialHeader(
                                  backgroundColor: appBarColor.withOpacity(
                                      0.8), //Theme.of(context).primaryColor,
                                ),
                                controller: _listRefreshController,
                                onRefresh: () {
                                  setState(() {
                                    leaveApplicationsCubit!.applications = [];
                                  });
                                  _listRefreshController.refreshCompleted();
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(4),
                                  children: leaveApplicationsCubit!.applications
                                      .map(
                                          (application) => LeaveApplicationTile(
                                                application: application,
                                              ))
                                      .toList(),
                                ),
                              );
                            } else if (state is LeaveApplicationsLoadFailed) {
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
        }));
  }
}
