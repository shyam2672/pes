import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

loadingIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
