import 'dart:io';

import 'package:bikerr/models/user.dart';
import 'package:bikerr/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final db = FirebaseFirestore.instance;
  static final users = db.collection('users');
  static final explore = db.collection('explore');

  Future<void> createUser(User user) async {
    await db.runTransaction((transaction) async {
      transaction.set(users.doc(user.email), {
        'name': user.name,
        'email': user.email,
        'uid': user.uid,
        'kms': 0,
        'documents': {},
        'joined_on': DateTime.now()
      });
    }).catchError((e) =>
        throw Exception('$e\nError creating user. Try again after sometime.'));
  }

  Future<DocumentSnapshot> getUserDoc(String email) async {
    DocumentSnapshot userDoc;
    await db.runTransaction(
      (transaction) async => userDoc = await transaction.get(
        users.doc(email),
      ),
    );
    return userDoc;
  }

  Future<void> uploadDoc(CurrentUser user, String docName, File doc) async {
    final url = await StorageService()
        .uploadDoc(user.email, docName, doc)
        .catchError((e) {
      print(e.toString());
      throw Exception('Error uploading image. Try again after sometime');
    });
    await db.runTransaction((transaction) async {
      final Map<String, dynamic> documents = user.documents ?? {};
      documents.update(docName, (_) => url, ifAbsent: () => url);
      transaction.update(user.userDoc.reference, {'documents': documents});
    });
  }

  Future<void> deleteDoc(CurrentUser user, String docName) async {
    await db.runTransaction((transaction) async {
      final Map<String, dynamic> documents = user.documents;
      documents.remove(docName);
      transaction.update(user.userDoc.reference, {'documents': documents});
      await StorageService().deleteDoc(user.email, docName).catchError((e) {
        print(e.toString());
        throw Exception('Error deleting image. Try again after sometime');
      });
    });
  }

  Future<void> updateKM(CurrentUser user, int kms, {bool reset = false}) async {
    await db.runTransaction((transaction) async => transaction
        .update(user.userDoc.reference, {'kms': reset ? 0 : user.kms + kms}));
  }
}
