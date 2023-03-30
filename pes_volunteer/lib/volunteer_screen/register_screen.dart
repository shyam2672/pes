import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/registration_cubit.dart';
import 'package:pes/data/models/application.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/volunteer_screen/widgets/loading_dialog.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController? _name = TextEditingController(),
      _profession = TextEditingController(),
      _phoneNo = TextEditingController(),
      _emailId = TextEditingController(),
      _address = TextEditingController(),
      _q1 = TextEditingController(),
      _q2 = TextEditingController(),
      _q3 = TextEditingController(),
      _q4 = TextEditingController(),
      _pathshaala = TextEditingController();

  _validator(String? value, fieldType, RegExp regex) {
    if (value!.length == 0) return "$fieldType Can't be null";

    print(regex.hasMatch(value));
    if (!regex.hasMatch(value)) return "Invalid $fieldType";
  }

  Form? form;
  final _formKey = GlobalKey<FormState>();

  _registrationForm(context) {
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
                    color: Color(0xff274D76),
                    fontWeight: FontWeight.w500),
              ),
              const Divider(
                color: Colors.grey,
              ),
              //Spacer(),
              const Text("Name",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "name",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter your full name",
                keyBoardType: TextInputType.name,
                controller: _name,
                validator: (value) =>
                    _validator(value, "Name", RegExp("^[a-zA-Z][a-zA-Z ]*\$")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Profession",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "profession",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Current Programme (like Btech/PhD/Professor/Staff)",
                keyBoardType: TextInputType.name,
                controller: _profession,
                validator: (value) =>
                    _validator(value, "Profession", RegExp("")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Phone Number",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "phone",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter your phone number (preferably Whatsapp)",
                keyBoardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ], // Only num

                controller: _phoneNo,
                validator: (value) =>
                    _validator(value, "Phone Number", RegExp("^[0-9]{10}\$")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Email id",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "email",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter your institute email Id",
                keyBoardType: TextInputType.emailAddress,
                controller: _emailId,
                validator: (value) => _validator(value, "Email Id",
                    RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              const Text("Current Home Address",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "address",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Enter your current Home Address",
                keyBoardType: TextInputType.text,
                controller: _address,
                validator: (value) =>
                    _validator(value, "Address", RegExp(".*")),
              ),
              // const Divider(
              //   color: Colors.grey,
              // ),
              // const Text(
              //     "What value will you bring to Pehchaan Ek Safar and what do you expect from us?",
              //     style: TextStyle(
              //         fontSize: 15,
              //         fontFamily: "Roboto",
              //         color: Color(0xff274D76),
              //         fontWeight: FontWeight.w100)),
              // InsertField(
              //   title: "text1",
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   hintText: "Your Answer",
              //   keyBoardType: TextInputType.text,
              //   controller: _q1,
              //   validator: (value) => _validator(value, "Answer", RegExp(".*")),
              // ),
              // // const Divider(
              // //   color: Colors.grey,
              // // ),
              // const Text("Why do You want to join?",
              //     style: TextStyle(
              //         fontSize: 15,
              //         fontFamily: "Roboto",
              //         color: Color(0xff274D76),
              //         fontWeight: FontWeight.w100)),
              // InsertField(
              //   title: "text2",
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   hintText: "Your Answer",
              //   keyBoardType: TextInputType.text,
              //   controller: _q2,
              //   validator: (value) => _validator(value, "Answer", RegExp(".*")),
              // ),
              const Text(
                  "If selected, which Pathshaala would you like to work with?",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Roboto",
                      color: Color(0xff274D76),
                      fontWeight: FontWeight.w100)),
              InsertField(
                title: "pathshaala",
                width: MediaQuery.of(context).size.width * 0.9,
                hintText: "Your Answer(1 or 2)",
                keyBoardType: TextInputType.text,
                controller: _pathshaala,
                validator: (value) =>
                    _validator(value, "Answer", RegExp("[1-2]{1}")),
              ),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        print(registrationCubit!.applicationData);
                        registrationCubit!.submitApplication(user.token);
                      }
                    },
                    child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff274D76),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xff274d76),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: const Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
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
  RegistrationCubit? registrationCubit;
  LoginCubit? loginCubit;

  @override
  Widget build(BuildContext context) {
    loginCubit = BlocProvider.of<LoginCubit>(context);
    user = loginCubit!.user;
    registrationCubit = BlocProvider.of<RegistrationCubit>(context);

    registrationCubit!.applicationData["text1"] = "";
    registrationCubit!.applicationData["text2"] = "";
    _name!.text = registrationCubit!.applicationData["name"] ?? "";
    _profession!.text = registrationCubit!.applicationData["profession"] ?? "";
    _phoneNo!.text = registrationCubit!.applicationData["phone"] ?? "";
    _emailId!.text = registrationCubit!.applicationData["email"] ?? "";
    _address!.text = registrationCubit!.applicationData["address"] ?? "";
    _q1!.text = registrationCubit!.applicationData["text1"] ?? "";
    _q2!.text = registrationCubit!.applicationData["text2"] ?? "";
    _pathshaala!.text = registrationCubit!.applicationData["paathshala"] ?? "";

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          print('listener $state');
          if (state is ApplicationSubmitted) {
            showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Application Submitted"));
                });
            registrationCubit!.applicationData = {};
            Timer(Duration(seconds: 3), () {
              Navigator.pop(context);
              loginCubit!.login();
            });
          }
          ;
          if (state is RegistrationError) {
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
          if (state is RegistrationLoading) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: _registrationForm(context),
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
  RegistrationCubit? registrationCubit;

  InsertField({
    Key? key,
    required this.width,
    required this.keyBoardType,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.inputFormatters = const [],
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    registrationCubit = BlocProvider.of<RegistrationCubit>(context);
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
          color: Colors.black87,
        ),
        autofocus: false,
        onChanged: (value) {
          registrationCubit!.applicationData[title] = value;
        },
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Color(0x66000000),
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
