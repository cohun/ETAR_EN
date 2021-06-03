import 'package:flutter/material.dart';

class AddOpPage extends StatefulWidget {
  const AddOpPage({Key key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddOpPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddOpPageState createState() => _AddOpPageState();
}

class _AddOpPageState extends State<AddOpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Adatok felvitele'),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Név:'),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.deepPurple[900],
          child: _buildCertificates(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.deepPurple[900],
          child: _buildCertificates(),
        ),
      ),
    ];
  }

  Widget _buildCertificates() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Bizonyítvány megnevezése:'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Bizonyítvány száma:'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Bizonyítvány érvényessége:'),
        ),
      ],
    );
  }
}
