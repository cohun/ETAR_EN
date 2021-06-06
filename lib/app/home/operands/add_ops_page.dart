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
  var count = 1;
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      print('form saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text('Egyéni adatok'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Feltöltés',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
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
      key: _formKey,
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
        keyboardType: TextInputType.name,
      ),
      _buildMultipleCertificates(),
      count >= 2
          ? _buildMultipleCertificates()
          : Container(
              height: 0,
            ),
      count >= 3
          ? _buildMultipleCertificates()
          : Container(
              height: 0,
            ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            count += 1;
          });
        },
        child: Text('További bizonyítvány'),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple[900]),
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
          keyboardType: TextInputType.datetime,
        ),
      ],
    );
  }

  Widget _buildMultipleCertificates() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Card(
            color: Colors.grey[900],
            child: _buildCertificates(),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (count > 1) {
                count = count - 1;
              } else {
                count = 1;
              }
            });
          },
          icon: Icon(Icons.indeterminate_check_box_sharp),
        ),
      ],
    );
  }
}
