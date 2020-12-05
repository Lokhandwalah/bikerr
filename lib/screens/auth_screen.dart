import 'package:bikerr/models/user.dart';
import 'package:bikerr/screens/main_screen.dart';
import 'package:bikerr/services/authentication.dart';
import 'package:bikerr/services/database.dart';
import 'package:bikerr/utilities/constants.dart';
import 'package:bikerr/widgets/dialog_box.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _flipKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/crop.jpg'),
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: FlipCard(
            key: _flipKey,
            flipOnTouch: false,
            front: LoginForm(flipKey: _flipKey),
            back: SignUpForm(flipKey: _flipKey),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
    @required this.flipKey,
  }) : super(key: key);
  final GlobalKey<FlipCardState> flipKey;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email, _password;
  TextEditingController _emailController, _passwordController;
  FocusNode _emailFocus, _passwordFocus;
  bool _showPassword = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200),
        Text(
          'Login',
          style: Theme.of(context).textTheme.headline4.copyWith(
              fontWeight: FontWeight.bold,
              color: secondary,
              letterSpacing: 2,
              fontFamily: 'Raleway'),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() => _email = value.trim()),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Please enter email';
                    if (emailvalidation(value.trim())) return 'Invalid Email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    errorStyle: errorTextStyle,
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: primary,
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    fillColor: Colors.grey.withOpacity(0.7),
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  keyboardType: TextInputType.text,
                  obscureText: !_showPassword,
                  onChanged: (value) =>
                      setState(() => _password = value.trim()),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Please enter password';
                    if (value.trim().length < 6)
                      return 'Min 6 characters required';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    errorStyle: errorTextStyle,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: primary,
                    ),
                    suffixIcon: _passwordController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () =>
                                setState(() => _showPassword = !_showPassword),
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: primary,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    fillColor: Colors.grey.withOpacity(0.7),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    onPressed: _handleLogin,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: secondary, fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.flipKey.currentState.toggleCard(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "SignUp",
                        style: TextStyle(fontSize: 18, color: secondary),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      print('logging in');
      showLoader(context);
      final result = await AuthService().signIn(_email, _password);
      bool success = result['success'];
      String title = success ? 'Success' : 'Error :(';
      String msg = success ? 'Login Successfull' : result['msg'];
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => WillPopScope(
          onWillPop: () => Future.value(!success),
          child: DialogBox(
            title: title,
            titleColor: primary,
            description: msg,
            buttonText1: success ? null : 'Ok',
            button1Func: success ? null : () => Navigator.of(context).pop(),
            icon: success ? Icons.verified_user : null,
            iconColor: success ? Colors.teal : null,
          ),
        ),
      );
      if (success) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: CurrentUser.user, child: MainScreen())));
      }
    } else
      setState(() => _autovalidateMode = AutovalidateMode.always);
  }
}

class SignUpForm extends StatefulWidget {
  final GlobalKey<FlipCardState> flipKey;
  const SignUpForm({Key key, @required this.flipKey}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _username, _email, _password;
  TextEditingController _usernameController,
      _emailController,
      _passwordController;
  FocusNode _usernameFocus, _emailFocus, _passwordFocus;
  bool _showPassword = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200),
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.headline4.copyWith(
              fontWeight: FontWeight.bold,
              color: secondary,
              letterSpacing: 2,
              fontFamily: 'Raleway'),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocus,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) =>
                      setState(() => _username = value.trim()),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Please enter username';
                    if (value.trim().length < 3) return 'Name too short';
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    errorStyle: errorTextStyle,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: primary,
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    fillColor: Colors.grey.withOpacity(0.7),
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() => _email = value.trim()),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Please enter email';
                    if (emailvalidation(value.trim())) return 'Invalid Email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    errorStyle: errorTextStyle,
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: primary,
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    fillColor: Colors.grey.withOpacity(0.7),
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  keyboardType: TextInputType.text,
                  obscureText: !_showPassword,
                  onChanged: (value) =>
                      setState(() => _password = value.trim()),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'Please enter password';
                    if (value.trim().length < 6)
                      return 'Min 6 characters required';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    errorStyle: errorTextStyle,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: primary,
                    ),
                    suffixIcon: _passwordController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () =>
                                setState(() => _showPassword = !_showPassword),
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: primary,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    fillColor: Colors.grey.withOpacity(0.7),
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    onPressed: _handleSignUp,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          color: secondary, fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.flipKey.currentState.toggleCard(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: secondary),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _handleSignUp() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      print('logging in');
      showLoader(context);
      final user = User(email: _email, password: _password, name: _username);
      final result = await AuthService().signUp(user);
      bool success = result['success'];
      String title = success ? 'Success' : 'Error :(';
      String msg = success ? 'Signup Successfull' : result['msg'];
      if (success) {
        firebase_auth.User firebaseUser = result['user'];
        user.uid = firebaseUser.uid;
        await DatabaseService().createUser(user);
        await CurrentUser.user.setData(_email);
      }
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => WillPopScope(
          onWillPop: () => Future.value(!success),
          child: DialogBox(
            title: title,
            titleColor: primary,
            description: msg,
            buttonText1: success ? null : 'Ok',
            button1Func: success ? null : () => Navigator.of(context).pop(),
            icon: success ? Icons.check : null,
            iconColor: success ? Colors.teal : null,
          ),
        ),
      );
      if (success) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: CurrentUser.user, child: MainScreen())));
      }
    } else
      setState(() => _autovalidateMode = AutovalidateMode.always);
  }
}

bool emailvalidation(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return !regex.hasMatch(value);
}

TextStyle get errorTextStyle => TextStyle(
    fontSize: 12,
    color: Colors.redAccent,
    letterSpacing: 1,
    fontWeight: FontWeight.bold);
