import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({Key key}) : super(key: key);

  List<Widget> _buildChildren() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
        ),
      ),
      SizedBox(height: 8,),
      TextField(
        decoration: InputDecoration(
          enabled: true,
          labelText: 'Jelszó',
        ),
        obscureText: true,
      ),
      SizedBox(height: 16,),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
        ),
        onPressed: () {},
        child: Text('Mehet'),
      ),
      SizedBox(height: 8,),
      TextButton(
        style: TextButton.styleFrom(
          primary: Colors.teal,
        ),
          onPressed: () {},
          child: Text('Nincs még fiókod? Regisztrálj itt!',
          style: TextStyle(fontSize: 16),),
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