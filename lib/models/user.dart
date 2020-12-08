import 'dart:async';

import 'package:bikerr/models/services.dart';
import 'package:bikerr/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name, email, password, uid;
  User({this.email, this.name, this.password});
}

class CurrentUser extends User with ChangeNotifier {
  static CurrentUser user = CurrentUser();
  int kms;
  SharedPreferences prefs;
  Map<String, dynamic> documents;
  DocumentSnapshot userDoc;
  StreamSubscription<DocumentSnapshot> userInfoStream;

  Future<void> setData(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDoc = await DatabaseService().getUserDoc(email);
    prefs.setString('email', email);
    user.prefs = prefs;
    user.initialize(userDoc);
    user.setStream();
  }

  void initialize(DocumentSnapshot userDoc) {
    print('initialzing user...');
    Map<String, dynamic> data = userDoc.data();
    user.userDoc = userDoc;
    email = data['email'];
    name = data['name'];
    uid = data['uid'];
    documents = data['documents'];
    kms = int.tryParse(data['kms'].toString());
    setPrefs();
    user.notifyListeners();
  }

  setPrefs() {
    prefs.setInt('400', kms ~/ 400 ?? 0);
    prefs.setInt('3000', kms ~/ 3000 ?? 0);
    prefs.setInt('5000', kms ~/ 5000 ?? 0);
    prefs.setInt('6000', kms ~/ 6000 ?? 0);
    prefs.setInt('10000', kms ~/ 10000 ?? 0);
    prefs.setInt('40000', kms ~/ 40000 ?? 0);
    Service.initialze(prefs);
  }

  setStream() => userInfoStream =
      DatabaseService.users.doc(email).snapshots().listen(initialize);

  void discard() {
    userInfoStream.cancel();
  }
}
