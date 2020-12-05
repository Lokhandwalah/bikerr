import 'package:flutter/material.dart';

Color get primary => Colors.teal;
Color get primaryDark => Colors.teal[700];
Color get secondary => Colors.tealAccent[200];

Widget loader() => Center(
        child: CircularProgressIndicator(
      strokeWidth: 1,
    ));

void showLoader(BuildContext context, {bool canPop = false}) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
          onWillPop: () => Future.value(canPop),
          child: loader(),
        ));
