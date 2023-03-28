import 'package:flutter/material.dart';

class SlotButton extends InkWell {
  SlotButton({onPressed, text})
      : super(
            onTap: onPressed,
            child: Container(
              // width: 116,
              height: 29,
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 247, 98, 57),
                  Color.fromARGB(255, 247, 57, 215),
                ]),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Center(
                  child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
            ));
}
