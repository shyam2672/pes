import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/studentNeeds_cubit.dart';
import 'package:pes/data/models/studentNeeds.dart';

import '../constants/strings.dart';
import '../data/models/user.dart';

class StudentNeedsDetails extends StatelessWidget {
  AppStudentNeeds appStudentNeeds;
  final String timeRecieved;
  StudentNeedsDetails(
      {required this.appStudentNeeds, Key? key, required this.timeRecieved})
      : super(key: key);

  StudentNeedsCubit? studentNeedsCubit;

  User user = User.empty(token: "");

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    studentNeedsCubit = BlocProvider.of<StudentNeedsCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Student Needs Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Pathshala " + appStudentNeeds.pathshaala,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.white),
              ),
              // Spacer(),
              Container(
                height: 15,
              ),
              Align(
                child: Text(
                  timeRecieved,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                alignment: Alignment.centerRight,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                color: Color.fromARGB(255, 52, 52, 52).withOpacity(0.3),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 10,
                child: ListView(
                  children: [
                    Text(
                      appStudentNeeds.data,
                      softWrap: true,
                      maxLines: null,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
