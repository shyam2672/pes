import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/data/models/join_application.dart';

class JoinApplicationDetailsScreen extends StatelessWidget {
  final JoinApplication application;
  JoinApplicationDetailsScreen({Key? key, required this.application})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // centerTitle: true,
          title: Text(
            'Application Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.black,
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
            child: Center(
                child: Column(
              children: [
                Container(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 247, 98, 57),
                          Color.fromARGB(255, 247, 57, 215),
                        ]),
                        // color: Color.fromARGB(255, 249, 66, 224),
                        width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      DetailHeading("Personal Details"),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        padding: EdgeInsets.only(top: 15, left: 5, bottom: 10),
                        child: Table(columnWidths: {
                          1: FlexColumnWidth(1.75),
                          2: FlexColumnWidth(3)
                        }, children: [
                          TableRow(children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  "Name: ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(application.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontSize: 14))
                          ]),
                          TableRow(children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  "Phone : ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(application.phone,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontSize: 14))
                          ]),
                          TableRow(children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  "Email: ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(application.email,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontSize: 14))
                          ])
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 247, 98, 57),
                          Color.fromARGB(255, 247, 57, 215),
                        ]),
                        // color: Color.fromARGB(255, 249, 66, 224),
                        width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      DetailHeading("Current Address"),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        padding: EdgeInsets.only(top: 15, left: 5, bottom: 10),
                        width: double.infinity,
                        child: Text(application.address,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              color: Colors.white,
                              overflow: TextOverflow.fade,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 247, 98, 57),
                          Color.fromARGB(255, 247, 57, 215),
                        ]),
                        // color: Color.fromARGB(255, 249, 66, 224),
                        width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      DetailHeading("Other Details"),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        padding: EdgeInsets.only(top: 15, left: 5, bottom: 10),
                        child: Table(columnWidths: {
                          1: FlexColumnWidth(1.75),
                          2: FlexColumnWidth(3)
                        }, children: [
                          TableRow(children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  "Profession: ",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(application.profession,
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.white,
                                    fontSize: 14))
                          ]),
                          TableRow(children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  "Pathshaala: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                            Text(application.pathshaala,
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.white,
                                    fontSize: 14))
                          ])
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}

class DetailHeading extends StatelessWidget {
  String heading;
  DetailHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * (.95),
      height: 35,
      // decoration: BoxDecoration(
      //     color: Color(0xff274D76), borderRadius: BorderRadius.circular(10)),
      // // decoration: BoxDecoration(
      //     border: Border(
      //         bottom: BorderSide(color: Colors.grey.shade300, width: 2.0))),
      padding: EdgeInsets.only(
        left: 10,
      ),
      margin: EdgeInsets.only(top: 15),
      child: Text(
        heading,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 23,
            overflow: TextOverflow.fade),
      ),
    );
  }
}
