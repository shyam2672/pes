import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/add_new_batch.dart';
import 'package:pes_admin/admin_screens/add_new_slot_screen.dart';
import 'package:pes_admin/admin_screens/all_batch_screen.dart';
import 'package:pes_admin/admin_screens/attendance_screen.dart';
import 'package:pes_admin/admin_screens/all_slots_screen.dart';
import 'package:pes_admin/admin_screens/indiv_slots_screen.dart';
import 'package:pes_admin/admin_screens/join_application_details.dart';
import 'package:pes_admin/admin_screens/join_applications_screen.dart';
import 'package:pes_admin/admin_screens/leave_applications_screen.dart';
import 'package:pes_admin/admin_screens/login_screen.dart';
import 'package:pes_admin/admin_screens/notification_detail.dart';
import 'package:pes_admin/admin_screens/notifications_screen.dart';
import 'package:pes_admin/admin_screens/otp_screen.dart';
import 'package:pes_admin/admin_screens/slot_change_screen.dart';
import 'package:pes_admin/admin_screens/splash_screen.dart';
import 'package:pes_admin/admin_screens/home.dart';
import 'package:pes_admin/admin_screens/syllabus_view.dart';
import 'package:pes_admin/admin_screens/volunteer_slots_screen.dart';
import 'package:pes_admin/cubit/add_batch_cubit.dart';
import 'package:pes_admin/cubit/add_slot_cubit.dart';
import 'package:pes_admin/cubit/all_batches_cubit.dart';
import 'package:pes_admin/cubit/all_slots_cubit.dart';
import 'package:pes_admin/cubit/attendance_cubit.dart';
import 'package:pes_admin/cubit/batch_cubit.dart';
import 'package:pes_admin/cubit/batch_edit_cubit.dart';
import 'package:pes_admin/cubit/delete_batch_cubit.dart';
import 'package:pes_admin/cubit/join_application_cubit.dart';
import 'package:pes_admin/cubit/join_decision_cubit.dart';
import 'package:pes_admin/cubit/leave_applications_cubit.dart';
import 'package:pes_admin/cubit/leave_decision_cubit.dart';
import 'package:pes_admin/cubit/list_volunteers_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/notifications_cubit.dart';
import 'package:pes_admin/cubit/profile_cubit.dart';
import 'package:pes_admin/cubit/slot_change_cubit.dart';
import 'package:pes_admin/cubit/slot_cubit.dart';
import 'package:pes_admin/cubit/slot_delete_cubit.dart';
import 'package:pes_admin/cubit/slot_edit_cubit.dart';
import 'package:pes_admin/cubit/studentNeeds_cubit.dart';
import 'package:pes_admin/cubit/syllabus_cubit.dart';
import 'package:pes_admin/cubit/today_volunteer_cubit.dart';
import 'package:pes_admin/cubit/volunteer_slots_cubit.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';
import 'package:pes_admin/constants/strings.dart';

import 'admin_screens/student_needs.dart';
import 'admin_screens/student_needs_details.dart';
import 'admin_screens/volunteer_profile_screen.dart';

class AppRouter {
  MainRepository? mainRepo;
  LoginCubit? loginCubit;
  SlotCubit? slotCubit;
  SyllabusCubit? syllabusCubit;
  TodayVolunteerCubit? todayVolunteerCubit;
  AllSlotsCubit? allSlotsCubit;
  AttendanceCubit? attendanceCubit;
  ProfileCubit? profileCubit;
  AddSlotCubit? addSlotCubit;
  SlotDeleteCubit? slotDeleteCubit;
  LeaveApplicationsCubit? leaveApplicationsCubit;
  JoinApplicationCubit? joinApplicationCubit;
  JoinDecisionCubit? joinDecisionCubit;
  LeaveDecisionCubit? leaveDecisionCubit;
  SlotEditCubit? slotEditCubit;
  ListVolunteersCubit? listVolunteersCubit;
  VolunteerSlotsCubit? volunteerSlotsCubit;
  SlotChangeCubit? slotChangeCubit;
  NotificationsCubit? notificationsCubit;
  AllBatchesCubit? allBatchesCubit;
  AddBatchCubit? addBatchCubit;
  BatchCubit? batchCubit;
  BatchEditCubit? batchEditCubit;
  BatchDeleteCubit? batchDeleteCubit;
  StudentNeedsCubit? studentNeedsCubit;

  AppRouter() {
    mainRepo = MainRepository();
    loginCubit = LoginCubit(repository: mainRepo!);
    slotCubit = SlotCubit(mainRepo: mainRepo!);
    syllabusCubit = SyllabusCubit(mainRepo!);
    todayVolunteerCubit = TodayVolunteerCubit(mainRepo: mainRepo!);
    allSlotsCubit = AllSlotsCubit(mainRepo: mainRepo!);
    attendanceCubit = AttendanceCubit(mainRepo: mainRepo!);
    profileCubit = ProfileCubit(mainRepository: mainRepo!);
    addSlotCubit = AddSlotCubit(mainRepository: mainRepo!);
    leaveApplicationsCubit = LeaveApplicationsCubit(mainRepo: mainRepo!);
    slotDeleteCubit = SlotDeleteCubit(mainRepo: mainRepo!);
    joinApplicationCubit = JoinApplicationCubit(mainRepo: mainRepo!);
    joinDecisionCubit = JoinDecisionCubit(mainRepository: mainRepo!);
    leaveDecisionCubit = LeaveDecisionCubit(mainRepository: mainRepo!);
    slotEditCubit = SlotEditCubit(mainRepo: mainRepo!);
    listVolunteersCubit = ListVolunteersCubit(mainRepo: mainRepo!);
    volunteerSlotsCubit = VolunteerSlotsCubit(mainRepository: mainRepo!);
    slotChangeCubit = SlotChangeCubit(mainRepo: mainRepo!);
    notificationsCubit = NotificationsCubit(mainRepo: mainRepo!);
    studentNeedsCubit = StudentNeedsCubit(mainRepo: mainRepo!);
    allBatchesCubit = AllBatchesCubit(mainRepo: mainRepo!);
    addBatchCubit = AddBatchCubit(mainRepository: mainRepo!);
    batchCubit = BatchCubit(mainRepo: mainRepo!);
    batchEditCubit = BatchEditCubit(mainRepo: mainRepo!);
    batchDeleteCubit = BatchDeleteCubit(mainRepo: mainRepo!);
  }

  _blocProvidedRoute(settings, Widget child) {
    return MaterialPageRoute(
        settings: settings, builder: (_) => _blocProvider(child));
  }

  _blocProvider(child) {
    return RepositoryProvider.value(
      value: mainRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: loginCubit!),
          BlocProvider.value(value: slotCubit!),
          BlocProvider.value(value: syllabusCubit!),
          BlocProvider.value(value: todayVolunteerCubit!),
          BlocProvider.value(value: allSlotsCubit!),
          BlocProvider.value(value: attendanceCubit!),
          BlocProvider.value(value: profileCubit!),
          BlocProvider.value(value: addSlotCubit!),
          BlocProvider.value(value: leaveApplicationsCubit!),
          BlocProvider.value(value: slotDeleteCubit!),
          BlocProvider.value(value: joinApplicationCubit!),
          BlocProvider.value(value: joinDecisionCubit!),
          BlocProvider.value(value: leaveDecisionCubit!),
          BlocProvider.value(value: slotEditCubit!),
          BlocProvider.value(value: listVolunteersCubit!),
          BlocProvider.value(value: volunteerSlotsCubit!),
          BlocProvider.value(value: slotChangeCubit!),
          BlocProvider.value(value: notificationsCubit!),
          BlocProvider.value(value: studentNeedsCubit!),
          BlocProvider.value(value: allBatchesCubit!),
          BlocProvider.value(value: addBatchCubit!),
          BlocProvider.value(value: batchCubit!),
          BlocProvider.value(value: batchEditCubit!),
          BlocProvider.value(value: batchDeleteCubit!),
        ],
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            BlocProvider.of<LoginCubit>(context);
            if (state is SignIn) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, LOGIN);
            }
            if (state is LoggedIn) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, HOME);
            }
            if (state is OTPSent) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, OTP);
            }
            if (state is NoNetwork) {
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
                    child: noNetworkDialog(context),
                  );
                },
              );
            }
            if (state is Error) {
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
                    child: errorDialog(state.error),
                  );
                },
              );
            }
            if (state is LoginRequested) {
              print("load");
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
          },
          child: child,
        ),
      ),
    );
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LOGIN:
        return _blocProvidedRoute(settings, LoginScreen());

      case HOME:
        return _blocProvidedRoute(settings, HomeScreen());

      case OTP:
        return _blocProvidedRoute(settings, Otp());

      case ATTENDANCE_SCREEN:
        return _blocProvidedRoute(settings, AttendanceScreen());

      case ALL_SLOTS:
        return _blocProvidedRoute(settings, AllSlots());

      case ALL_BATCHES:
        return _blocProvidedRoute(settings, AllBatches());
      case VOLUNTEER_PROFILE:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings,
            VolunteerProfile(
              pesId: args['pesId'],
              volunteerAttendance: args['volunteerAttendance'],
            ));
      case SYLLABUS_SCREEN:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(settings, SyllabusView(batch: args['batch']));

      case ADD_SLOT:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings, AddSlot(isBeingEdited: args['isBeingEdited']));

      case ADD_BATCH:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings, AddBatch(isBeingEdited: args['isBeingEdited']));

      case LEAVE_APPLICATIONS:
        return _blocProvidedRoute(settings, LeaveApplicationsScreen());

      case JOIN_APPLICATIONS:
        return _blocProvidedRoute(settings, JoinApplicationsScreen());

      case VOLUNTEER_SLOTS:
        return _blocProvidedRoute(settings, ListVolunteersScreen());

      case APP_NOTIFICATIONS:
        return _blocProvidedRoute(settings, NotificationScreen());
      case NOTIFICATION_DETAIL:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings,
            NotificationDetails(
                appNotification: args['notificationObj'],
                timeRecieved: args['timeRecieved']));

      case INDIVIDUAL_SLOTS:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(settings,
            IndividualSlotsScreen(pes_id: args['pes_id'], name: args['name']));

      case JOIN_APPLICATION_DETAILS:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(settings,
            JoinApplicationDetailsScreen(application: args['application']));
      case CHANGE_SLOT:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings,
            SlotChangeScreen(
              allSlots: args['allSlots'],
              currentSlots: args['currentSlots'],
              requestedSlots: args['requestedSlots'],
              pes_id: args['pes_id'],
            ));

      case NEEDS:
        return _blocProvidedRoute(settings, StudentNeedsScreen());
      case NEEDS_DETAILS:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings,
            StudentNeedsDetails(
                appStudentNeeds: args['studentNeedsObj'],
                timeRecieved: args['timeRecieved']));

      default:
        return _blocProvidedRoute(settings, SplashScreen());
    }
  }

  noNetworkDialog(context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xffe9e8e8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "No Internet",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () => BlocProvider.of<LoginCubit>(context).login(),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                    child: Text(
                  "Retry",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  errorDialog(error) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xffe9e8e8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Text(
        error,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
