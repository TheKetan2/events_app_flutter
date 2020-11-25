import 'package:events_app_flutter/screens/event_screen.dart';
import 'package:events_app_flutter/shared/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String _userId;
  String _password;
  String _message = "";
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Authentication auth;

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "email",
          icon: Icon(Icons.mail),
        ),
        validator: (value) => value.isEmpty ? "Email is required" : "",
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtPass,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "password",
          icon: Icon(Icons.enhanced_encryption),
        ),
        validator: (value) => value.isEmpty ? "Password is required" : "",
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? "Login" : "Sign up";
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: Container(
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          color: Theme.of(context).accentColor,
          elevation: 3,
          child: Text(buttonText),
          onPressed: submit,
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? "Login" : "Sign up";
    return FlatButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
      _message,
      style: TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  Future submit() async {
    _formKey.currentState.validate();

    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPass.text);
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPass.text);
        print("Sign up for user $_userId");
      }
      if (_userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(),
          ),
        );
      }
    } catch (error) {
      print("Error: ${error.code}");

      setState(() {
        _message = error.message;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                emailInput(),
                passwordInput(),
                mainButton(),
                secondaryButton(),
                validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
