import 'package:bikerr/models/user.dart';
import 'package:bikerr/services/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(
      () => Future.delayed(Duration(seconds: 2)).then((_) => enterApp()),
    );
  }

  void enterApp() async {
    final currentUser = AuthService.currentUser;
    bool isUserLoggedIn = currentUser != null;
    if (isUserLoggedIn) await CurrentUser.user.setData(currentUser.email);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          if (!isUserLoggedIn) return AuthScreen();
          return ChangeNotifierProvider<CurrentUser>.value(
              value: CurrentUser.user, child: MainScreen());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/crop.jpg'),
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.darken),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 150,
            child: Row(
              children: [
                Text(
                  'BIKERR',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(letterSpacing: 2, fontFamily: 'Raleway'),
                ),
                SizedBox(width: 25),
                SpinKitDualRing(color: Colors.teal, size: 30)
              ],
            ),
          )
        ],
      ),
    );
  }
}
