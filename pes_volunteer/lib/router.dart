import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/add_studentNeeds_cubit.dart';
import 'package:pes/cubit/all_slots_cubit.dart';
import 'package:pes/cubit/attendance_cubit.dart';
import 'package:pes/cubit/leave_pehchaan_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/new_notification_cubit.dart';
import 'package:pes/cubit/notifications_cubit.dart';
import 'package:pes/cubit/studentNeeds_cubit.dart';
import 'package:pes/cubit/profile_cubit.dart';
import 'package:pes/cubit/registration_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/cubit/syllabus_cubit.dart';
import 'package:pes/cubit/outreach_slots_cubit.dart';
import 'package:pes/cubit/outreach_added_cubit.dart';


import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/all_slots_screen.dart';
import 'package:pes/volunteer_screen/home.dart';
import 'package:pes/volunteer_screen/login_screen.dart';
import 'package:pes/volunteer_screen/notification_details.dart';
import 'package:pes/volunteer_screen/notifications.dart';
import 'package:pes/volunteer_screen/otp_screen.dart';
import 'package:pes/volunteer_screen/profile_screen.dart';
import 'package:pes/volunteer_screen/register_screen.dart';
import 'package:pes/volunteer_screen/splash_screen.dart';
import 'package:pes/volunteer_screen/students_needs.dart';
import 'package:pes/volunteer_screen/students_needs_details.dart';
import 'package:pes/volunteer_screen/syllabus_view.dart';
import 'package:pes/volunteer_screen/outreach_slots_screen.dart';


class AppRouter {
  LoginCubit? loginCubit;
  SlotsCubit? slotsCubit;
  MainRepository? mainRepo;
  SyllabusCubit? syllabusCubit;
  RegistrationCubit? registrationCubit;
  ProfileCubit? profileCubit;
  AttendanceCubit? attendanceCubit;
  LeavePehchaanCubit? leavePehchaanCubit;
  AddStudentNeedsCubit?addStudentNeedsCubit;
  SlotChangeCubit? slotChangeCubit;
  AllSlotsCubit? allSlotsCubit;
  NotificationsCubit? notificationsCubit;
  NewNotificationCubit? newNotificationCubit;
  StudentNeedsCubit? studentNeedsCubit;
  OutreachCubit? outreachCubit;
  AddOutreachCubit? addOutreachCubit;



  AppRouter() {
    mainRepo = MainRepository();
    loginCubit = LoginCubit(repository: mainRepo!);
    slotsCubit = SlotsCubit(mainRepo: mainRepo!);
    syllabusCubit = SyllabusCubit(mainRepo!);
    registrationCubit = RegistrationCubit(mainRepository: mainRepo!);
    profileCubit = ProfileCubit(mainRepository: mainRepo!);
    attendanceCubit = AttendanceCubit(mainRepo: mainRepo!);
    leavePehchaanCubit = LeavePehchaanCubit(mainRepo: mainRepo!);
    addStudentNeedsCubit = AddStudentNeedsCubit(mainRepo: mainRepo!);
   addOutreachCubit = AddOutreachCubit(mainRepo: mainRepo!);

    slotChangeCubit = SlotChangeCubit(mainRepo: mainRepo!);
    allSlotsCubit = AllSlotsCubit(mainRepo: mainRepo!);
    notificationsCubit = NotificationsCubit(mainRepository: mainRepo!);
    studentNeedsCubit = StudentNeedsCubit(mainRepository: mainRepo!);
    newNotificationCubit = NewNotificationCubit(mainRepository: mainRepo!);
    outreachCubit = OutreachCubit(mainRepo: mainRepo!);

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
          BlocProvider.value(value: slotsCubit!),
          BlocProvider.value(value: syllabusCubit!),
          BlocProvider.value(value: registrationCubit!),
          BlocProvider.value(value: profileCubit!),
          BlocProvider.value(value: attendanceCubit!),
          BlocProvider.value(value: leavePehchaanCubit!),
          BlocProvider.value(value: addStudentNeedsCubit!),
          BlocProvider.value(value: slotChangeCubit!),
          BlocProvider.value(value: allSlotsCubit!),
          BlocProvider.value(value: notificationsCubit!),
          BlocProvider.value(value: studentNeedsCubit!),
          BlocProvider.value(value: outreachCubit!),
          BlocProvider.value(value: addOutreachCubit!),


          BlocProvider.value(value: newNotificationCubit!),
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

      case OTP:
        return _blocProvidedRoute(settings, Otp());

      case REGISTER:
        return _blocProvidedRoute(settings, RegisterScreen());

      case HOME:
        return _blocProvidedRoute(settings, HomeScreen());

      case ALL_SLOTS:
        return _blocProvidedRoute(settings, AllSlots());

      case PROFILE:
        return _blocProvidedRoute(settings, Profile());

      case SYLLABUS_SCREEN:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(settings, SyllabusView(batch: args['batch']));

      case NOTIFICATION_SCREEN:
        return _blocProvidedRoute(settings, NotificationScreen());

      case NOTIFICATION_DETAIL:
        Map args = settings.arguments as Map;
        return _blocProvidedRoute(
            settings,
            NotificationDetails(
                appNotification: args['notificationObj'],
                timeRecieved: args['timeRecieved']));

      case NEEDS:
        return _blocProvidedRoute(settings, StudentNeedsScreen());

      case OUTREACH:
        return _blocProvidedRoute(settings, OutreachSlotsScreen());

      case NEEDS_DETAIL:
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
