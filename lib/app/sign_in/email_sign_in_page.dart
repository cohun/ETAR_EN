import 'package:etar_en/app/sign_in/email_sign_in_form.dart';
import 'package:etar_en/app/sign_in/terms_of_use.dart';
import 'package:etar_en/services/auth.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  bool isAccepted = false;

  accept() {
    print(isAccepted);
    print('start started');
    setState(() {
      isAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: isAccepted
            ? Text(
                'Bejelentkezés',
                style: TextStyle(color: Colors.teal),
              )
            : Text(
                'Feltételek',
                style: TextStyle(color: Colors.teal),
              ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: !isAccepted
                ? TermsOfUse(
                    accept: accept,
                  )
                : EmailSignInForm(
                    auth: widget.auth,
                  ),
          ),
        ),
      ),
    );
  }
}
