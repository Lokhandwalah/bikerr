import 'package:flutter/material.dart';

class SelectImagePanel extends StatelessWidget {
  final Function(bool, BuildContext)onTap;
  const SelectImagePanel({Key key, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              onTap: () => onTap(true, context),
              leading: Icon(Icons.photo_camera, color: Colors.white),
              title: Text(
                'Open Camera',
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () => onTap(false, context),
              leading: Icon(Icons.photo_library, color: Colors.white),
              title: Text(
                'Open Gallery',
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
              onTap: () => Navigator.of(context).pop(),
              leading: Icon(Icons.clear, color: Colors.white),
              title: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
