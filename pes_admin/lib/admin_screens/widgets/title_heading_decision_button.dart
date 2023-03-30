import 'package:flutter/material.dart';
import 'package:pes_admin/constants/strings.dart';

class TileHeading extends StatelessWidget {
  final String heading, text;

  const TileHeading({Key? key, required this.heading, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          // width: MediaQuery.of(context).size.width / 3,
          child: Center(
            child: Text(
              text,
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DecisionButton extends StatelessWidget {
  String label;
  Function()? onTap;

  DecisionButton(this.label, this.onTap);
  Widget icon() {
    if (label == "Accept")
      return Icon(
        Icons.check_circle_outline,
        color: Color(0xff40AA71),
      );
    else
      return Icon(
        Icons.cancel,
        color: Color(0xffce5454),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            width: 80,
            child: Row(
              //width: 90,
              /*decoration: BoxDecoration(
        color: const Color(0xff274D76),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff274d76),
          width: 1,
        ),
      ),
      */
              children: [
                icon(),
                SizedBox(
                  width: 5,
                ),
                Center(
                    child: Text(label,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: appBarColor,
                            fontSize: 14)))
              ],
            )));
  }
}
