import 'package:bikerr/models/screen.dart';
import 'package:bikerr/models/user.dart';
import 'package:bikerr/screens/auth_screen.dart';
import 'package:bikerr/services/authentication.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Bikerr',
          style: TextStyle(letterSpacing: 2, fontSize: 25, color: secondary),
        ),
        iconTheme: IconThemeData(color: secondary),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.name, style: TextStyle(fontSize: 20)),
              accountEmail:
                  Text(user.email, style: TextStyle(color: Colors.grey[400])),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person_outline,
                  size: 45,
                  color: primaryDark,
                ),
              ),
            ),
            Card(
                child: ListTile(
              onTap: () => _handleLogout(context),
              title: Text('Log out', style: TextStyle(fontSize: 18)),
              trailing: Icon(
                Icons.exit_to_app_outlined,
                color: secondary,
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primary,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          onTap: (index) => setState(() => _currentIndex = index),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          items: Screen.pages
              .map(
                (p) => BottomNavigationBarItem(
                  icon: Icon(p.icon),
                  activeIcon: Icon(p.activeIcon),
                  label: p.title,
                ),
              )
              .toList()),
      body: IndexedStack(
        index: _currentIndex,
        children: Screen.pages.map((p) => p.page).toList(),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    Navigator.of(context).pop();
    bool confirm = await showConfirmationDialog(context,
        title: 'Logout', content: 'Are you Sure you want to Logout');
    if (confirm) {
      print('logging out...');
      showLoader(context);
      await AuthService().signout();
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AuthScreen(),
        ),
      );
    }
  }
}
