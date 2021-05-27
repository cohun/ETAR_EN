import 'package:etar_en/app/home_page.dart';
import 'package:etar_en/app/lifecycle.dart';
import 'package:etar_en/app/sign_in/sign_in_page.dart';
import 'package:etar_en/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: widget.auth,
            );
          }
          return LifeCycle(
            child: HomePage(
              auth: widget.auth,
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
