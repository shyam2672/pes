import 'package:flutter/material.dart';

class TileHeading extends StatelessWidget {
  final String heading, text;
  final int noOfSiblings;

  const TileHeading(
      {Key? key,
      required this.heading,
      required this.text,
      required this.noOfSiblings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7 / noOfSiblings,
          child: Center(
            child: Text(
              text,
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 15,
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
