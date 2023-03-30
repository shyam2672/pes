import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/analytics/v3.dart';
import 'package:googleapis/chat/v1.dart';
import 'package:pes_admin/cubit/attendance_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';

class DropDownFilter extends StatefulWidget {
  FilterProperties filterProperties;
  final String title;
  DropDownFilter({required this.filterProperties, required this.title});

  @override
  State<DropDownFilter> createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 17),
        Text(
          widget.title,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(width: 17),
        DropdownButton<String>(
          value: widget.filterProperties.value,
          // icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.grey, fontSize: 20),
          underline: Container(
            height: 2,
            color: Colors.grey,
          ),
          onChanged: (String? newValue) {
            if (newValue != widget.filterProperties.value) {
              setState(() {
                widget.filterProperties.value = newValue!;
              });
              // BlocProvider.of<AttendanceCubit>(context)
              //     .filters[widget.filterProperties.key] = newValue;
              // BlocProvider.of<AttendanceCubit>(context).loadAttendance(
              //     BlocProvider.of<LoginCubit>(context).user.token);
              widget.filterProperties.onChanged(newValue);
            }
          },
          items: widget.filterProperties.keys
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }
}

class FilterProperties {
  String value;
  List<String> keys;
  final Function onChanged;
  FilterProperties(
      {required this.onChanged, required this.value, required this.keys});
}
