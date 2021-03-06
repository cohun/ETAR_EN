import 'package:etar_en/app/sign_in/validators.dart';
import 'package:etar_en/dialogs/show_alert_dialog.dart';
import 'package:etar_en/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _submitted = false;
  bool _isLoading = false;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      showAlertDialog(
        context,
        title: 'Sign in failed',
        content: e.message,
        defaultActionText: 'OK',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Bel??p??s a fi??kba'
        : 'Fi??k l??trehoz??sa';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Nincs m??g fi??kod? Regisztr??lj itt!'
        : 'Van m??r fi??kod? Menj a bejelentkez??shez!';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 16,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
        ),
        onPressed: submitEnabled ? _submit : null,
        child: Text(
          primaryText,
          style: TextStyle(
              color: submitEnabled ? Colors.yellowAccent : Colors.white),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(
        style: TextButton.styleFrom(
          primary: Colors.teal,
        ),
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(
          secondaryText,
          style: TextStyle(fontSize: 14),
        ),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      autocorrect: false,
      controller: _passwordController,
      decoration: InputDecoration(
        enabled: true,
        labelText: 'Jelsz??',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
      enabled: _isLoading == false,
      obscureText: true,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      enabled: _isLoading == false,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  _updateState() {
    setState(() {});
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
