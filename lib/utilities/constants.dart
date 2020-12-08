import 'package:bikerr/widgets/dialog_box.dart';
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

Future<bool> showConfirmationDialog(BuildContext context,
    {@required String title, @required String content}) {
  return showDialog<bool>(
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: () {
              Navigator.of(context).pop(false);
              return Future.value(false);
            },
            child: DialogBox(
              title: title,
              description: content,
              titleColor: primary,
              buttonText1: 'Cancel',
              buttonText2: 'Yes',
              btn1Color: Colors.white,
              btn2Color: secondary,
              button1Func: () => Navigator.of(context).pop(false),
              button2Func: () => Navigator.of(context).pop(true),
            ),
          ));
}
