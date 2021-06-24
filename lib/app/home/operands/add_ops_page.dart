import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/dialogs/show_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class AddOpPage extends StatefulWidget {
  const AddOpPage({Key key, this.uid, this.database}) : super(key: key);
  final String uid;
  final Database database;

  static Future<void> show(BuildContext context, String uid, Database database) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddOpPage(uid: uid, database: database,),
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
  String _name;
  List<Map<String, dynamic>> _certificates = [{'description': '',
  'nr': '', 'date': ''}];

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _createOp(BuildContext context, String uid) async {
    try {
      await widget.database.createOperand(
        Operand(
          name: _name,
          certificates: _certificates,
          companies: [],
          uid: uid,
        ),
      );
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation failed',
          content: e.toString(),
          defaultActionText: 'OK');
    }
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      print('név: $_name');
      print('certificates: $_certificates');
      print('form saved');
      _createOp(context, widget.uid);
      Navigator.of(context).pop();
    }
  }
  void _partialSubmit() {
    if (_validateAndSaveForm()) {
      print('partial');
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
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        validator: (value) => value.isNotEmpty ? null : 'Kötelező kitölteni!',
        onSaved: (val) => _name = val,
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
          _partialSubmit();
          setState(() {
            count += 1;
            if (count > 3) {
              count = 3;
            }
          });
        },
        child: Text('További bizonyítvány'),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple[900]),
      ),
    ];
  }

  Widget _buildCertificates() {
    var ind = count -1;
    if (ind > 0) {
      _certificates.add({'description': '',
        'nr': '', 'date': ''});
    }
    _certificates.removeRange(count, _certificates.length);
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Bizonyítvány megnevezése:'),
          textAlign: TextAlign.center,
          onSaved: (val) => _certificates[ind]['description'] = val,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Bizonyítvány száma:'),
          textAlign: TextAlign.center,
          onSaved: (val) => _certificates[ind]['nr'] = val,
        ),
        DateTimePicker(
          textAlign: TextAlign.center,
          initialValue: '',
          dateMask: 'yyyy-MM-dd',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          dateLabelText: 'Bizonyítvány érvényessége:',
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => _certificates[ind]['date'] = val,
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
