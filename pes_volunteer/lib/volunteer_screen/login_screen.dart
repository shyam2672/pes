import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/login_cubit.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _adminId = TextEditingController();
  TextEditingController _password = TextEditingController();
  Color appBarColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    var adminId = BlocProvider.of<LoginCubit>(context).data["pesId"];
    _adminId.text = (adminId == null ? "" : adminId);
    _adminId.selection = TextSelection.collapsed(offset: _adminId.text.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
        //title: const Text("Sign in"),
      ),
      body: Center(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                const Text(
                  "Volunteer Sign In",
                  style: TextStyle(
                      fontSize: 24, fontFamily: "Roboto", color: Colors.white),
                ),
                Spacer(),
                Container(
                  child: TextFormField(
                    validator: (value) => _adminId.text.length == 0
                        ? "PES ID can't be Empty"
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                    autofocus: true,
                    controller: _adminId,
                    onChanged: (value) {
                      BlocProvider.of<LoginCubit>(context).data["pesId"] =
                          value;
                      print(BlocProvider.of<LoginCubit>(context).data["pesId"]);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "PES ID",
                      labelStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, REGISTER),
                      child: Text(
                        "Become a Pehchaan Volunteer",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Spacer(flex: 20),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 247, 57, 215),
                        Color.fromARGB(255, 247, 98, 57)
                      ]),
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   color: const Color(0xff274d76),
                      //   width: 1,
                      // ),
                    ),
                    child: Center(
                        child: Text(
                      "Generate OTP",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                  onTap: () {
                    if (_adminId.text.length != 0)
                      BlocProvider.of<LoginCubit>(context)
                          .signIn(_adminId.value.text);
                  },
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
