import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/add_slot_cubit.dart';
import 'package:pes_admin/cubit/all_slots_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/slot_edit_cubit.dart';
import 'package:pes_admin/data/models/user.dart';

class AddSlot extends StatefulWidget {
  final bool isBeingEdited;

  const AddSlot({Key? key, this.isBeingEdited = false}) : super(key: key);

  @override
  _AddSlotState createState() => _AddSlotState();
}

class _AddSlotState extends State<AddSlot> {
  TextEditingController? _day = TextEditingController(),
      _startTime = TextEditingController(),
      _endTime = TextEditingController(),
      _pathshaala = TextEditingController(),
      _batch = TextEditingController();

  _validator(String? value, fieldType, RegExp regex) {
    if (value!.length == 0) return "$fieldType Can't be null";

    print(regex.hasMatch(value));
    if (!regex.hasMatch(value)) return "Invalid $fieldType";
  }

  List<String> days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];

  Form? form;
  final _formKey = GlobalKey<FormState>();

  _AddSlotForm(context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Details",
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: "RobotoMono",
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const Divider(
                color: Colors.grey,
              ),
              //Spacer(),
              const Text("Day",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              // InsertField(
              //   title: "day",
              //   isEdit:
              //       widget.isBeingEdited ? slotEditState!.slot.day : null,
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   hintText: "Enter day in Upper case",
              //   keyBoardType: TextInputType.name,
              //   controller: _day,
              //   validator: (value) => _validator(
              //       value,
              //       "Day",
              //       RegExp(
              //           "^(MONDAY|TUESDAY|WEDNESDAY|THURSDAY|FRIDAY|SATURDAY|SUNDAY)\$")),
              // ),
              DropdownButton<String>(
                value: _day!.text,
                // icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                underline: Container(
                  height: 2,
                  color: Colors.grey.shade600,
                ),
                onChanged: (String? newValue) {
                  if (newValue != _day!.text) {
                    setState(() {
                      _day!.text = newValue!;
                      if (widget.isBeingEdited) {
                        slotEditCubit!.slotData['day'] = newValue;
                      } else {
                        addSlotCubit!.applicationData["day"] = newValue;
                      }
                    });
                  }
                },
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Start time",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "time_start",
                isEdit: widget.isBeingEdited,
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Follow 24 hr format",
                keyBoardType: TextInputType.text,
                controller: _startTime,
                validator: (value) => _validator(
                    value, "Start Time", RegExp("^[0-9]{2}:[0-9]{2}\$")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("End time",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "time_end",
                isEdit: widget.isBeingEdited,

                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Follow 24 hr format",
                keyBoardType: TextInputType.text,
                // inputFormatters: <TextInputFormatter>[
                //   LengthLimitingTextInputFormatter(10),
                //   FilteringTextInputFormatter.digitsOnly
                // ], // Only num

                controller: _endTime,
                validator: (value) => _validator(
                    value, "End Time", RegExp("^[0-9]{2}:[0-9]{2}\$")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Pathshaala",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              // InsertField(
              //   title: "pathshaala",
              //   isEdit: widget.isBeingEdited
              //       ? slotEditState!.slot.pathshaala
              //       : null,

              //   width: MediaQuery.of(context).size.width * 0.9,
              //   hintText: "Enter pathshaal (1 or 2)",
              //   keyBoardType: TextInputType.number,
              //   inputFormatters: <TextInputFormatter>[
              //     LengthLimitingTextInputFormatter(1),
              //     FilteringTextInputFormatter.digitsOnly
              //   ], // Only num
              //   controller: _pathshaala,
              //   validator: (value) =>
              //       _validator(value, "Pathshaala", RegExp("^(1|2)\$")),
              // ),
              DropdownButton<String>(
                value: _pathshaala!.text,
                // icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                underline: Container(
                  height: 2,
                  color: Colors.grey.shade600,
                ),
                onChanged: (String? newValue) {
                  if (newValue != _pathshaala!.text) {
                    setState(() {
                      _pathshaala!.text = newValue!;
                      if (widget.isBeingEdited) {
                        slotEditCubit!.slotData['pathshaala'] = newValue;
                      } else {
                        addSlotCubit!.applicationData["pathshaala"] = newValue;
                      }
                    });
                  }
                },
                items: ['1', '2'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),

              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Batch",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "batch",
                isEdit: widget.isBeingEdited,

                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter batch",
                keyBoardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.digitsOnly
                ], // Only num
                controller: _batch,
                validator: (value) =>
                    _validator(value, "Batch", RegExp("^[0-9]+")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 48, 48, 48)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //addSlotCubit!.applicationData["description"]="";
                          //addSlotCubit!.applicationData["remarks"]="";
                          if (widget.isBeingEdited) {
                            slotEditCubit!.submitEdits(user.token);
                          } else {
                            print(addSlotCubit!.applicationData);

                            addSlotCubit!.submitApplication(user.token);
                          }
                        }
                      },
                      child: const Text("Submit")),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  User user = User.empty(token: "");
  AddSlotCubit? addSlotCubit;
  LoginCubit? loginCubit;
  SlotEditCubit? slotEditCubit;
  AllSlotsCubit? slotsCubit;

  @override
  Widget build(BuildContext context) {
    loginCubit = BlocProvider.of<LoginCubit>(context);
    user = loginCubit!.user;
    addSlotCubit = BlocProvider.of<AddSlotCubit>(context);
    slotEditCubit = BlocProvider.of<SlotEditCubit>(context);
    slotsCubit = BlocProvider.of<AllSlotsCubit>(context);

    if (widget.isBeingEdited && slotEditCubit!.state is SlotEditing) {
      _day!.text = slotEditCubit!.slotData['day'] ?? 'MONDAY';
      _startTime!.text = slotEditCubit!.slotData['time_start'] ?? "";
      _endTime!.text = slotEditCubit!.slotData['time_end'] ?? "";
      _batch!.text = slotEditCubit!.slotData['batch'] ?? "";
      _pathshaala!.text = slotEditCubit!.slotData['pathshaala'] ?? "1";
    } else {
      _day!.text = addSlotCubit!.applicationData["day"] ?? "MONDAY";
      addSlotCubit!.applicationData["day"] = _day!.text;
      _startTime!.text = addSlotCubit!.applicationData["time_start"] ?? "";
      _endTime!.text = addSlotCubit!.applicationData["time_end"] ?? "";
      _batch!.text = addSlotCubit!.applicationData["batch"] ?? "";
      _pathshaala!.text = addSlotCubit!.applicationData["pathshaala"] ?? "1";
      addSlotCubit!.applicationData["pathshaala"] = _pathshaala!.text;
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.isBeingEdited ? "Edit Slot" : "Add Slot",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: BlocConsumer<AddSlotCubit, AddSlotState>(
        listener: (context, state) {
          print('listener $state');
          if (state is ApplicationSubmitted) {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          widget.isBeingEdited ? "Slot Edited" : "Slot added"));
                });
            addSlotCubit!.applicationData = {};
            slotsCubit!.allSlots = [];

            Timer(Duration(seconds: 3), () {
              Navigator.pop(context);
              Navigator.pop(context);
              //Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
              //loginCubit!.login();
            });
          }
          ;
          if (state is AddSlotError) {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) {
                  return Container(
                      padding: EdgeInsets.all(10), child: Text(state.error));
                });
            Timer(Duration(seconds: 3), () => Navigator.pop(context));
          }
        },
        builder: (context, state) {
          print("builder $state");
          if (state is SlotEditSubmitting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return BlocConsumer<SlotEditCubit, SlotEditState>(
            listener: (context, state) {
              print(state);
              if (state is SlotEdited) {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: EdgeInsets.all(10),
                          child: Text(widget.isBeingEdited
                              ? "Slot Edited"
                              : "Slot Added"));
                    });
                addSlotCubit!.applicationData = {};
                slotsCubit!.allSlots = [];
                slotsCubit!.slots = [];

                Timer(Duration(seconds: 3), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
                  //loginCubit!.login();
                });
              }

              if (state is SlotEditError) {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: EdgeInsets.all(10),
                          child: Text(state.error));
                    });
                Timer(Duration(seconds: 3), () => Navigator.pop(context));
              }
            },
            builder: (context, state) {
              if (state is SlotEditSubmitting) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container(
                color: Colors.black,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0.5, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 18, 18, 18),
                  ),
                  child: _AddSlotForm(context),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InsertField extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final double width;
  final TextInputType keyBoardType;
  final String hintText;
  final String? Function(String?)? validator;
  List<TextInputFormatter> inputFormatters = [];
  final bool isEdit;
  AddSlotCubit? addSlotCubit;

  InsertField({
    Key? key,
    required this.width,
    required this.keyBoardType,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.inputFormatters = const [],
    required this.title,
    required this.isEdit,
  }) : super(key: key);

  SlotEditCubit? slotEditCubit;
  @override
  Widget build(BuildContext context) {
    addSlotCubit = BlocProvider.of<AddSlotCubit>(context);
    slotEditCubit = BlocProvider.of<SlotEditCubit>(context);
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 25.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        validator: validator,
        keyboardType: keyBoardType,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.singleLineFormatter,
          ...inputFormatters,
        ],
        // Only num
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
        autofocus: false,
        onChanged: (value) {
          if (isEdit) {
            slotEditCubit!.slotData[title] = value;
          } else {
            addSlotCubit!.applicationData[title] = value;
          }
        },
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
          // prefix: Text(
          //   " \u{20B9} ",
          //   style: TextStyle(
          //     fontSize: 30,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
        ),
      ),
    );
  }
}
