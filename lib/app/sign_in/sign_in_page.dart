import 'package:etar_en/app/sign_in/email_sign_in_page.dart';
import 'package:etar_en/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => EmailSignInPage(
          auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Bejelentkezés',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Icon(
            Icons.arrow_downward_rounded,
            size: 80,
            color: Colors.yellowAccent,
          ),
          InkWell(
            child: Image.asset('images/ETAR_EN_flat_small.png'),
            onTap: () => _signInWithEmail(context),
          ),
          Divider(
            height: 50,
          ),
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headline4.fontSize * 1.1 + 30.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[900],
            alignment: Alignment.center,
            child: Text('Emelőgép üzemvitel',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.yellowAccent)),
          ),
          Divider(
            height: 50,
          ),
        ],
      ),
    );
  }
}
