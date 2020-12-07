import 'dart:io';

import 'package:bikerr/models/document.dart';
import 'package:bikerr/models/user.dart';
import 'package:bikerr/screens/documentation/image_viewer.dart';
import 'package:bikerr/services/database.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:bikerr/widgets/dialog_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bikerr/widgets/image_source_selection.dart';

class Documentation extends StatefulWidget {
  @override
  _DocumentationState createState() => _DocumentationState();
}

class _DocumentationState extends State<Documentation> {
  Map<String, dynamic> docs;
  CurrentUser user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<CurrentUser>(context);
    docs = user.documents ?? {};
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Documentation',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: primary, letterSpacing: 2, fontFamily: 'Raleway'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Save your important docs here',
                  style: TextStyle(
                      color: primary, fontFamily: 'Raleway', fontSize: 18),
                ),
              ),
              docs.length == 0 ? _buildZeroDocs() : _buildDocs(docs)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleDocUpload,
        tooltip: 'Add Document',
        heroTag: 'Add Document',
        child: Icon(Icons.add),
      ),
    );
  }

  Expanded _buildZeroDocs() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You haven't uploaded anything",
              style: TextStyle(
                  color: primary, fontFamily: 'Raleway', fontSize: 18),
            ),
            SizedBox(height: 4),
            RaisedButton.icon(
                onPressed: _handleDocUpload,
                color: primary,
                icon: Icon(Icons.add),
                label: Text("Upload Documents")),
          ],
        ),
      ),
    );
  }

  void _openImage(Document doc) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewer(doc),
        fullscreenDialog: true,
      ),
    );
  }

  void _handleDocUpload() async {
    final docType = await showModalBottomSheet<DocumentType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DocumentSelectionSheet(),
    );
    if (docType != null) {
      final doc = await showModalBottomSheet<File>(
          context: context, builder: (_) => SelectImagePanel(onTap: getImage));
      if (doc != null) {
        showLoader(context);
        await DatabaseService()
            .uploadDoc(user, docType.toString().split(".").last, doc);
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pop();
      }
    }
  }

  _handleDeleteDoc(String doc) async {
    bool confirm = await showDialog<bool>(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () {
                Navigator.of(context).pop(false);
                return Future.value(false);
              },
              child: DialogBox(
                  title: 'Confirm',
                  titleColor: primary,
                  description:
                      'Are you sure you want to delete your $doc document?',
                  buttonText1: 'Cancel',
                  buttonText2: 'Yes',
                  btn1Color: Colors.white,
                  btn2Color: primary,
                  button1Func: () => Navigator.of(context).pop(false),
                  button2Func: () => Navigator.of(context).pop(
                        true,
                      )),
            ));
    if (confirm) {
      showLoader(context);
      await DatabaseService().deleteDoc(user, doc);
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
    }
  }

  Future getImage(bool camera, BuildContext context) async {
    try {
      PickedFile image = await ImagePicker()
          .getImage(source: camera ? ImageSource.camera : ImageSource.gallery);
      File doc = File(image.path);
      Navigator.of(context).pop(doc);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildDocs(Map<String, dynamic> docs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: docs.keys.map((doc) {
          final document = Document(name: doc, url: docs[doc]);
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openImage(document),
                    child: Hero(
                      tag: document,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(document.url),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black38, BlendMode.darken)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
                      child: ListTile(
                          title: Text(
                            doc,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                color: primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5),
                          ),
                          trailing: IconButton(
                              onPressed: () => _handleDeleteDoc(doc),
                              icon:
                                  Icon(Icons.delete, color: Colors.redAccent))),
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DocumentSelectionSheet extends StatelessWidget {
  final Map<String, IconData> docs = {
    'License': Icons.portrait,
    'RC': Icons.photo,
    'PUC': Icons.picture_as_pdf,
    'Insurance': Icons.receipt,
    'PAN': Icons.account_box,
    'Aadhar': Icons.account_box_outlined
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select Document',
              style: TextStyle(color: primary, fontSize: 18),
            ),
          ),
          ...docs.keys.map(
            (doc) => Card(
              child: ListTile(
                leading: Icon(docs[doc]),
                title:
                    Text(doc, style: TextStyle(color: primary, fontSize: 18)),
                onTap: () => Navigator.of(context).pop(Document.getType(doc)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

String capitalize(String word) =>
    word.substring(0, 1).toUpperCase() + word.substring(1);
