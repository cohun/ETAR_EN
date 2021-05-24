import 'package:etar_en/services/auth.dart';
import 'package:flutter/material.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Belépés a fiókba'
        : 'Fiók létrehozása';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Nincs még fiókod? Regisztrálj itt!'
        : 'Van már fiókod? Menj a bejelentkezéshez!';
    return [
      TextField(
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
        ),
      ),
      SizedBox(
        height: 8,
      ),
      TextField(
        autocorrect: false,
        controller: _passwordController,
        decoration: InputDecoration(
          enabled: true,
          labelText: 'Jelszó',
        ),
        obscureText: true,
        obscuringCharacter: '*',
      ),
      SizedBox(
        height: 16,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
        ),
        onPressed: _submit,
        child: Text(
          primaryText,
          style: TextStyle(color: Colors.yellowAccent),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(
        style: TextButton.styleFrom(
          primary: Colors.teal,
        ),
        onPressed: _toggleFormType,
        child: Text(
          secondaryText,
          style: TextStyle(fontSize: 14),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
