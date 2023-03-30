import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/testing/v1.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/attendance_filters.dart';
import 'package:pes_admin/admin_screens/widgets/home_volunteer_tile.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/cubit/attendance_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_cubit.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/models/volunteer_attendance.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _StateAttendanceScreen();
}

class _StateAttendanceScreen extends State<AttendanceScreen> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  Color appBarColor = Colors.black;

  FilterProperties? _pathshaalaFilter, _attendanceCritFilter;
  @override
  void initState() {
    _pathshaalaFilter = FilterProperties(
      value: 'All',
      keys: ['All', '1', '2'],
      onChanged: (var newValue) {
        BlocProvider.of<AttendanceCubit>(context).filters['pathshaala'] =
            newValue;
        BlocProvider.of<AttendanceCubit>(context)
            .loadAttendance(BlocProvider.of<LoginCubit>(context).user.token);
      },
    );
    _attendanceCritFilter = FilterProperties(
      value: 'All',
      keys: ['All', 'Above 75%', 'Below 75%'],
      onChanged: (var newValue) {
        BlocProvider.of<AttendanceCubit>(context).filters['attendanceCrit'] =
            newValue;
        BlocProvider.of<AttendanceCubit>(context)
            .loadAttendance(BlocProvider.of<LoginCubit>(context).user.token);
      },
    );
    super.initState();
  }

  AttendanceCubit? attendanceCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    attendanceCubit!.loadAttendance(user.token);
    _pathshaalaFilter!.value = attendanceCubit!.filters['pathshaala'];
    _attendanceCritFilter!.value = attendanceCubit!.filters['attendanceCrit'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Volunteer",
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
          setState(() {});
          attendanceCubit!.Attendances = [];
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
                DropDownFilter(
                  title: 'Pathshaala',
                  filterProperties: _pathshaalaFilter!,
                ),
                DropDownFilter(
                  title: 'Attendance',
                  filterProperties: _attendanceCritFilter!,
                ),
                BlocBuilder<AttendanceCubit, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoading) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is AttendanceLoadFailure) {
                      return Center(
                        child: Text(state.error),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView(
                          children: attendanceCubit!.Attendances.map(
                            (e) {
                              print(e.attendancePercentage);
                              if (_allowed(e)) {
                                return HomeVolunteerTile(
                                  volunteerAttendance: e,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _pathshaalaAllowed(VolunteerAttendance volunteerAttendance) {
    return attendanceCubit!.filters['pathshaala'] == 'All' ||
        volunteerAttendance.pathshaala ==
            attendanceCubit!.filters['pathshaala'];
  }

  bool _attendanceAllowed(VolunteerAttendance volunteerAttendance) {
    String _filter = attendanceCubit!.filters['attendanceCrit'];
    int attendancePercentage = volunteerAttendance.attendancePercentage;

    return (_filter == 'All') ||
        (_filter == 'Above 75%' && attendancePercentage >= 75) ||
        (_filter == 'Below 75%' && attendancePercentage < 75);
  }

  bool _allowed(VolunteerAttendance volunteerAttendance) {
    return _pathshaalaAllowed(volunteerAttendance) &&
        _attendanceAllowed(volunteerAttendance);
  }
}
