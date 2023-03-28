import 'package:flutter/material.dart';

class SlotButton extends InkWell {
  SlotButton({onPressed, text, isActive = true})
      : super(
            onTap: isActive == null
                ? onPressed
                : isActive
                    ? onPressed
                    : () {},
            child: Container(
              width: 116,
              height: 29,
              decoration: BoxDecoration(
                gradient: isActive == null
                    ? LinearGradient(colors: [
                        Color.fromARGB(255, 247, 57, 215),
                        Color.fromARGB(255, 247, 98, 57)
                      ])
                    : isActive
                        ? LinearGradient(colors: [
                            Color.fromARGB(255, 247, 57, 215),
                            Color.fromARGB(255, 247, 98, 57)
                          ])
                        : LinearGradient(colors: [
                            Color.fromARGB(255, 91, 91, 91),
                            Color.fromARGB(255, 91, 91, 91)
                          ]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xff274d76),
                  width: 1,
                ),
              ),
              child: Center(
                  child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              )),
            ));
}
