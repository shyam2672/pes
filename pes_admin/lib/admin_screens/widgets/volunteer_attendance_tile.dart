import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/models/volunteer.dart';

class HomeVolunteerTile extends StatelessWidget {
  User user = User.empty(token: "");
  final VolunteerHomeScreen volunteer;
  HomeVolunteerTile({Key? key, required this.volunteer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Home Refrehsed");
    //user = BlocProvider.of<LoginCubit>(context).user;
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    return Container(
      // width: 250,
      height: 70,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            offset: Offset(3, 3),
          ),
        ],
        color: Color(0xffE9EDF1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          TileHeading(
            heading: "Name",
            text: volunteer.name,
            noOfSiblings: 3,
          ),
          Spacer(),
          TileHeading(
            heading: "PES ID",
            text: volunteer.pes_id,
            noOfSiblings: 3,
          ),
          Spacer(),
          TileHeading(
            heading: "Batch",
            text: volunteer.batch,
            noOfSiblings: 3,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
