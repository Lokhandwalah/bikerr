import 'package:bikerr/models/services.dart';
import 'package:bikerr/models/user.dart';
import 'package:bikerr/services/database.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ServiceTracker extends StatefulWidget {
  @override
  _ServiceTrackerState createState() => _ServiceTrackerState();
}

class _ServiceTrackerState extends State<ServiceTracker> {
  CurrentUser user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<CurrentUser>(context);
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
                  'Service Tracker',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: primary, letterSpacing: 2, fontFamily: 'Raleway'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Track your kms here',
                  style: TextStyle(
                      color: primary, fontFamily: 'Raleway', fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _openAddSheet,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('You have travelled',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Raleway')),
                          SizedBox(width: 10),
                          Text(user.kms.toString() + ' KM',
                              style: TextStyle(
                                fontSize: 25,
                                color: primary,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Services:',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      letterSpacing: 1,
                      fontSize: 20,
                      color: secondary),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 250,
                child: Center(
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.height * 0.26,
                      mainAxisSpacing: MediaQuery.of(context).size.width * 0.055,
                      crossAxisSpacing:
                          MediaQuery.of(context).size.height * 0.01,
                    ),
                    itemCount: Service.serviceList.length,
                    itemBuilder: (_, i) {
                      final service = Service.serviceList[i];
                      return Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shadowColor: primary,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    service.imageURL),
                                colorFilter: ColorFilter.mode(
                                    Colors.black38, BlendMode.darken),
                                fit: BoxFit.cover),
                          ),
                          child: Center(
                              child: Text(
                            service.name,
                            style: TextStyle(letterSpacing: 1, fontSize: 18),
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'Add KM',
          tooltip: 'Add KM',
          child: Icon(Icons.add),
          onPressed: _openAddSheet),
    );
  }

  void _openAddSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (ctx) => AddKMSheet(screenContext: ctx, user: user));
  }
}

class AddKMSheet extends StatefulWidget {
  final BuildContext screenContext;
  final CurrentUser user;

  const AddKMSheet({Key key, this.screenContext, this.user}) : super(key: key);
  @override
  _AddKMSheetState createState() => _AddKMSheetState();
}

class _AddKMSheetState extends State<AddKMSheet> {
  TextEditingController _kmController;
  FocusNode _kmFocus;

  @override
  void initState() {
    super.initState();
    _kmController = TextEditingController();
    _kmFocus = FocusNode();
  }

  @override
  void dispose() {
    _kmController.dispose();
    _kmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return Future.value(true);
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(widget.screenContext).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: (_kmController.text.length * 25).toDouble(),
                  child: TextField(
                    cursorColor: secondary,
                    autofocus: true,
                    maxLength: 5,
                    controller: _kmController,
                    focusNode: _kmFocus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.white),
                      counterText: "",
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: _handleAddKm,
                  ),
                ),
                SizedBox(width: _kmController.text.length == 0 ? 15 : 0),
                Text(
                  'KM',
                  style: TextStyle(fontSize: 18, color: secondary),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAddKm(String value) async {
    Navigator.of(context).pop();
    int kms = int.tryParse(value);
    if (kms == null) return;
    if (kms <= 0) return;
    await DatabaseService().updateKM(widget.user, kms);
  }
}
