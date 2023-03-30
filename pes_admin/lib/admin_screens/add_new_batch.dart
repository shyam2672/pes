import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/add_batch_cubit.dart';
import 'package:pes_admin/cubit/all_batches_cubit.dart';
import 'package:pes_admin/cubit/batch_edit_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/data/models/user.dart';

class AddBatch extends StatefulWidget {
  final bool isBeingEdited;

  const AddBatch({Key? key, this.isBeingEdited = false}) : super(key: key);

  @override
  _AddBatchState createState() => _AddBatchState();
}

class _AddBatchState extends State<AddBatch> {
  TextEditingController? _link = TextEditingController(),
      _remarks = TextEditingController();

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

  _AddBatchForm(context) {
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
              const Text("Classes taught",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "remarks",
                isBeingEdited: widget.isBeingEdited,

                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter classes taught",
                keyBoardType: TextInputType.name,
                // inputFormatters: <TextInputFormatter>[
                //   LengthLimitingTextInputFormatter(2),
                //   FilteringTextInputFormatter.digitsOnly
                // ], // Only num
                controller: _remarks,
                validator: (value) => _validator(value, "Classes", RegExp("")),
              ),
              const Text("Syllabus",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Colors.white,
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "syllabus",
                isBeingEdited: widget.isBeingEdited,
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter the drive link",
                keyBoardType: TextInputType.name,
                controller: _link,
                validator: (value) => _validator(
                    value, "Syllabus", RegExp("^https://drive.google.com.*\$")),
              ),

              // const Divider(
              //   color: Colors.grey,
              // ),
              Row(
                children: [
                  Spacer(),
                  SlotButton(
                      //style: ElevatedButton.styleFrom(onSurface: appBarColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //addBatchCubit!.applicationData["description"]="";
                          //addBatchCubit!.applicationData["remarks"]="";
                          if (widget.isBeingEdited) {
                            batchEditCubit!.submitEdits(user.token);
                          } else {
                            print(addBatchCubit!.applicationData);

                            addBatchCubit!.submitApplication(user.token);
                          }
                        }
                      },
                      text: "Submit"),
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
  AddBatchCubit? addBatchCubit;
  LoginCubit? loginCubit;
  BatchEditCubit? batchEditCubit;
  AllBatchesCubit? batchsCubit;

  @override
  Widget build(BuildContext context) {
    loginCubit = BlocProvider.of<LoginCubit>(context);
    user = loginCubit!.user;
    addBatchCubit = BlocProvider.of<AddBatchCubit>(context);
    batchEditCubit = BlocProvider.of<BatchEditCubit>(context);
    batchsCubit = BlocProvider.of<AllBatchesCubit>(context);

    if (widget.isBeingEdited && batchEditCubit!.state is BatchEditing) {
      print(batchEditCubit!.batchData);
      _remarks!.text = batchEditCubit!.batchData["remarks"];
      _link!.text = batchEditCubit!.batchData['syllabus'];
    } else {
      _remarks!.text = addBatchCubit!.applicationData["remarks"] ?? "";
      _link!.text = addBatchCubit!.applicationData["syllabus"] ?? "";
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: widget.isBeingEdited
            ? const Text(
                "Edit Batch",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              )
            : const Text(
                "Add Batch",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
        backgroundColor: appBarColor,
      ),
      body: BlocConsumer<AddBatchCubit, AddBatchState>(
        listener: (context, state) {
          print('listener $state');
          if (state is ApplicationSubmitted) {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) {
                  return Container(
                      padding: EdgeInsets.all(10), child: Text("Batch added"));
                });
            addBatchCubit!.applicationData = {};
            batchsCubit!.allBatches = [];

            Timer(Duration(seconds: 3), () {
              Navigator.pop(context);
              Navigator.pop(context);
              //Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
              //loginCubit!.login();
            });
          }
          ;
          if (state is AddBatchError) {
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
          if (state is BatchEditSubmitting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return BlocConsumer<BatchEditCubit, BatchEditState>(
            listener: (context, state) {
              print(state);
              if (state is BatchEdited) {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: EdgeInsets.all(10),
                          child: Text(widget.isBeingEdited
                              ? "Batch Edited"
                              : "Batch Added"));
                    });
                addBatchCubit!.applicationData = {};
                batchsCubit!.allBatches = [];

                Timer(Duration(seconds: 3), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
                  //loginCubit!.login();
                });
              }

              if (state is BatchEditError) {
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
              if (state is BatchEditSubmitting) {
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 18, 18, 18),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: _AddBatchForm(context),
                ),
              );
            },
          );
        },
        /*builder: (context, state) {
          print("builder $state");
          if (state is AddBatchLoading) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: _AddBatchForm(context),
          );
        },*/
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
  final bool isBeingEdited;
  AddBatchCubit? addBatchCubit;

  InsertField({
    Key? key,
    required this.width,
    required this.keyBoardType,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.inputFormatters = const [],
    required this.title,
    required this.isBeingEdited,
  }) : super(key: key);

  BatchEditCubit? batchEditCubit;
  @override
  Widget build(BuildContext context) {
    addBatchCubit = BlocProvider.of<AddBatchCubit>(context);
    batchEditCubit = BlocProvider.of<BatchEditCubit>(context);
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
          color: Colors.white,
        ),
        autofocus: false,
        onChanged: (value) {
          if (isBeingEdited) {
            batchEditCubit!.batchData[title] = value;
          } else {
            addBatchCubit!.applicationData[title] = value;
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
