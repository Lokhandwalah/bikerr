import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final storage = FirebaseStorage.instance.ref();

  Future<String> uploadDoc(String user, String docName, File doc) async {
    final ref = storage.child('users/$user/$docName.jpg');
    final uploadTask = await ref.putFile(doc);
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }
}
