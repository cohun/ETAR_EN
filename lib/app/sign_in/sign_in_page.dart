import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

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
          Divider(
            height: 100,
          ),
          Image.asset('images/ETAR_EN_flat_small.png'),
          Divider(
            height: 50,
          ),
          Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headline4.fontSize * 1.1 + 20.0,
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
        ],
      ),
    );
  }
}
