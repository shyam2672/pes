import 'package:flutter/material.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/data/models/studentNeeds.dart';

class StudentNeedsDetails extends StatelessWidget {
  AppStudentNeeds appStudentNeeds;
  final String timeRecieved;
  StudentNeedsDetails(
      {required this.appStudentNeeds, Key? key, required this.timeRecieved})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                "Pathshaala " + appStudentNeeds.pathshaala,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "PES ID: " + appStudentNeeds.pesId,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
                Text(
                "NAME: " + appStudentNeeds.Name,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
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

    // return Material(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text(
    //         "FAQs",
    //         style: TextStyle(
    //             color: Colors.black,
    //             fontWeight: FontWeight.bold,
    //             fontFamily: "Sans-Serif",
    //             fontSize: 25 * MediaQuery.of(context).devicePixelRatio / 2.6),
    //       ),
    //       elevation: 0,
    //       backgroundColor: Colors.transparent,
    //       iconTheme: IconThemeData(
    //         color: Colors.black, //change your color here
    //       ),
    //     ),
    //     body: LayoutBuilder(
    //         builder: (context, BoxConstraints constraints) => Container(
    //               margin: EdgeInsets.fromLTRB(20, 4, 20, 4),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Container(
    //                     width: MediaQuery.of(context).size.width,
    //                     child: Align(
    //                       child: Text(
    //                         faq.faqQuestion,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontFamily: "Sans-Serif",
    //                             fontSize: 20 *
    //                                 MediaQuery.of(context).devicePixelRatio /
    //                                 2.6),
    //                       ),
    //                       alignment: Alignment.centerLeft,
    //                     ),
    //                   ),
    //                   Divider(thickness: 1),
    //                   Expanded(
    //                     flex: 20,
    //                     child: Container(
    //                       width: constraints.maxWidth,
    //                       child: Text(
    //                         faq.solution,
    //                         softWrap: true,
    //                         maxLines: null,
    //                         style: TextStyle(
    //                             fontFamily: "Sans-Serif",
    //                             fontSize: 20 *
    //                                 MediaQuery.of(context).devicePixelRatio /
    //                                 2.6),
    //                       ),
    //                     ),
    //                   ),
    //                   Spacer(flex: 1),
    //                 ],
    //               ),
    //             )),
    //   ),
    // );
  }
}
