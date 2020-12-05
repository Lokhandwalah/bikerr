import 'dart:async';

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
  Map<String, dynamic> documents;
  DocumentSnapshot userDoc;
  StreamSubscription<DocumentSnapshot> userInfoStream;

  Future<void> setData(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDoc = await DatabaseService().getUserDoc(email);
    prefs.setString('email', email);
    user.initialize(userDoc);
    user.setStream();
  }

  void initialize(DocumentSnapshot userDoc) {
    final data = userDoc.data();
    print('initialzing user...');
    user.userDoc = userDoc;
    user.email = data['email'];
    user.name = data['name'];
    user.uid = data['uid'];
    user.documents = data['documents'];
    user.kms = int.tryParse(data['kms'].toString());
    user.notifyListeners();
  }

  setStream() => user.userInfoStream =
      DatabaseService.users.doc(user.email).snapshots().listen(initialize);

  void discard() {
    userInfoStream.cancel();
  }
}
