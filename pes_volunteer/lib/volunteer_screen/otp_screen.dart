import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Otp extends StatelessWidget {
  Otp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "OTP Screen",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.black,
          //title: const Text("Sign in"),
        ),
        body: Container(
          color: Colors.black,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Color.fromARGB(255, 18, 18, 18),
            ),
            padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 2),
                Text(
                  "An OTP was sent to your registered email.\nPlease enter the otp below",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(flex: 1),
                //OTPTextField(),
                Container(
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: OtpField(),
                      ),
                      //...otpFields,
                      Spacer(flex: 5),
                    ],
                  ),
                ),
                Spacer(flex: 2),
                /*InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnderProgress(
                        navBar: Container(),
                      ),
                    ),
                  ),
                  child: Text(
                    "Didn’t Recieve? Resend OTP",
                    style: TextStyle(color: Color(0xff0f80f4)),
                  ),
                ),*/
                Spacer(flex: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpField extends StatelessWidget {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  LoginCubit? loginCubit;

  OtpField({Key? key}) : super(key: key);

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    loginCubit = BlocProvider.of<LoginCubit>(context);
    return PinPut(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only num

      eachFieldHeight: 60,
      eachFieldWidth: 50,
      fieldsCount: 4,
      //length: 4,
      onSubmit: (String pin) {
        loginCubit!.verifyOtp(pin);
        // if (loginCubit!.state is UserOtp) {
        //   Navigator.popUntil(context, (route) => route.isFirst);
        //   Navigator.pushReplacementNamed(context, USER_SCREEN);
        // } else if (loginCubit!.state is MerchantOtp) {
        //   BlocProvider.of<BottomNavigationCubit>(context).user = Merchant(
        //       outletName: "Hindustan Steel",
        //       photosList: [
        //         "ad1.png",
        //         "ad1.png",
        //         "ad1.png",
        //         "ad1.png",
        //         "ad1.png",
        //       ],
        //       merchantName: "Mr. Raman Mathpal",
        //       merchantId: "AXHP81",
        //       panNumber: "IRKPK8286G",
        //       gstIn: "ASDFSD832",
        //       merchantAddress:
        //           "Sector 42, Near Main Market Chandigarh, India, 140004",
        //       refferalCode: "SGDP82",
        //       phoneNumber: "8234234233",
        //       profilePhoto: "images/ad1.png");
        //   Navigator.popUntil(context, (route) => route.isFirst);
        //   Navigator.pushReplacementNamed(context, MERCHANT_SCREEN);
        // }
        // if (loginCubit!.state is UserRegisterationOtp) {
        //   Navigator.popUntil(context, (route) => route.isFirst);
        //   Navigator.pushReplacementNamed(context, USER_KYC_SCREEN_BASIC);
        // }
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(20.0),
      ),
      selectedFieldDecoration: _pinPutDecoration,
      followingFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.white.withOpacity(.5),
        ),
      ),
    );
  }
}
