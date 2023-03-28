import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pes_admin/data/models/volunteer_attendance.dart';
import 'package:gradient_borders/gradient_borders.dart';

class HomeVolunteerTile extends StatelessWidget {
  User user = User.empty(token: "");
  VolunteerHomeScreen? volunteer;
  VolunteerAttendance? volunteerAttendance;
  List<Color> tileColorGrading = [
    Colors.redAccent,
    Colors.redAccent,
    Colors.yellow,
    Colors.lightGreenAccent,
    Colors.lightGreenAccent,
  ];

  HomeVolunteerTile({Key? key, this.volunteer, this.volunteerAttendance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(volunteer != null || volunteerAttendance != null);
    //user = BlocProvider.of<LoginCubit>(context).user;
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    return InkWell(
      onTap: () {
        if (volunteer != null) {
          Navigator.pushNamed(context, VOLUNTEER_PROFILE, arguments: {
            'pesId': volunteer!.pes_id,
          });
        } else if (volunteerAttendance != null) {
          Navigator.pushNamed(context, VOLUNTEER_PROFILE, arguments: {
            'pesId': volunteerAttendance!.pesId,
            'volunteerAttendance': volunteerAttendance!,
          });
        }
      },
      child: Container(
        // width: 250,
        height: 70,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          border: const GradientBoxBorder(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 247, 98, 57),
                Color.fromARGB(255, 247, 57, 215),
              ]),
              // color: Color.fromARGB(255, 249, 66, 224),
              width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.4),
          //     offset: Offset(3, 3),
          //   ),
          // ],
          color: volunteer != null
              // ? Color(0xffE9EDF1)
              ? Color.fromARGB(255, 18, 18, 18)
              : tileColorGrading[
                  (volunteerAttendance!.attendancePercentage / 25).floor() < 5
                      ? (volunteerAttendance!.attendancePercentage / 25).floor()
                      : 4],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            TileHeading(
              heading: "Name",
              text: volunteer != null
                  ? volunteer!.name
                  : volunteerAttendance!.name,
              noOfSiblings: 3,
            ),
            Spacer(),
            TileHeading(
              heading: "PES ID",
              text: volunteer != null
                  ? volunteer!.pes_id
                  : volunteerAttendance!.pesId,
              noOfSiblings: 3,
            ),
            Spacer(),
            TileHeading(
              heading: volunteer != null ? "Batch" : 'Profession',
              text: volunteer != null
                  ? volunteer!.batch
                  : volunteerAttendance!.profession,
              noOfSiblings: 3,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
