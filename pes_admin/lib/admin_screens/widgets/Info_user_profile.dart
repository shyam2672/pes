import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  String s1, s2;
  Info(this.s1, this.s2);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
      children: [
        Text(s1,
            style: const TextStyle(
                fontSize: 15,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold)),
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 300,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xffa8a8a8),
                width: 1,
              ),
              color: const Color(0x00c4c4c4),
            ),
            child: Row(
              children: [
                Spacer(),
                Text(s2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Roboto",
                    )),
                Spacer()
              ],
            )),
      ],
    ));
  }
}

class SectionHeading extends StatelessWidget {
  String heading;
  SectionHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      // height: 30,
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 249, 66, 224),
          // color: Color(0xff274D76),
          border: Border.all(
            color: Color.fromARGB(255, 18, 18, 18),
            // width: 2,
          ),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.only(bottom: 20,top:20),
      child: Text(
        heading,
        style:
            TextStyle(color: Colors.white, fontFamily: "Roboto", fontSize: 17),
      ),
    );
  }
}
