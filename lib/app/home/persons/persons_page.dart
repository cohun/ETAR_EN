import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:etar_en/dialogs/show_alert_dialog.dart';

class PersonsPage extends StatefulWidget {
  PersonsPage({
    Key key,
    @required this.database,
    @required this.uid,
    @required this.admin,
  }) : super(key: key);
  final Database database;
  final String uid;
  final bool admin;

  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  var count = 1;
  var countOriginal;
  final _formKey = GlobalKey<FormState>();
  Operand _operand;
  String _name = '';
  List<Map<String, dynamic>> _certificates = [
    {'description': '', 'nr': '', 'date': ''}
  ];
  List<String> _companies = [];

  Widget _buildFirstContents(BuildContext context) {
    FutureBuilder(
        future: _retrieveOperand(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _buildForm();
            }
          } else if (snapshot.hasError) {
            return Text('no data');
          }
          return Container(
            height: 0,
          );
        });
  }

  Future<Operand> _retrieveOperand() async {
    try {
      await widget.database
          .retrieveOperand(widget.uid)
          .then((value) => _operand = value);
      if (_operand != null) {
        setState(() {});
        _name = _operand.name;
        _certificates = _operand.certificates;
        _companies = _operand.companies;
        count = _operand.certificates.length;
        countOriginal = _operand.certificates.length;
        print(_name);
        print(count);
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    return null;
  }

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
          companies: _companies,
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
        title: Text('Személyes adatok'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submit,
            child: Column(
              children: [
                Text(
                  'Változások',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'feltöltése',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: widget.admin
          ? Center(
              child: Card(
                child: Text('admin'),
              ),
            )
          : _operand != null
              ? _buildContents()
              : _buildFirstContents(context),
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
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Név:'),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        validator: (value) => value.isNotEmpty ? null : 'Kötelező kitölteni!',
        onSaved: (val) => _name = val,
      ),
      count >= 1
          ? _buildMultipleCertificates(0)
          : Container(
              height: 0,
            ),
      count >= 2
          ? _buildMultipleCertificates(1)
          : Container(
              height: 0,
            ),
      count == 3
          ? _buildMultipleCertificates(2)
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
            print('count: $count');
            if (count > countOriginal) {
              countOriginal = count;
              _certificates.add({'description': '', 'nr': '', 'date': ''});
            }
          });
        },
        child: Text('További bizonyítvány'),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple[900]),
      ),
    ];
  }

  Widget _buildCertificates(int _count) {
    if (_count >= 0) {
      return Column(
        children: [
          TextFormField(
            initialValue: _operand.certificates[_count]['description'],
            decoration: InputDecoration(labelText: 'Bizonyítvány megnevezése:'),
            textAlign: TextAlign.center,
            onSaved: (val) => _certificates[_count]['description'] = val,
          ),
          TextFormField(
            initialValue: _operand.certificates[_count]['nr'],
            decoration: InputDecoration(labelText: 'Bizonyítvány száma:'),
            textAlign: TextAlign.center,
            onSaved: (val) => _certificates[_count]['nr'] = val,
          ),
          DateTimePicker(
            initialValue: _operand != null
                ? _count < count
                    ? _operand.certificates[_count]['date']
                    : ''
                : '',
            textAlign: TextAlign.center,
            dateMask: 'yyyy-MM-dd',
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            dateLabelText: 'Bizonyítvány érvényessége:',
            validator: (val) {
              print(val);
              return null;
            },
            onSaved: (val) => _certificates[_count]['date'] = val,
          ),
        ],
      );
    }
  }

  Widget _buildMultipleCertificates(int _count) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Card(
            color: Colors.grey[900],
            child: _buildCertificates(_count),
          ),
        ),
        count - 1 == _count
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _certificates.removeAt(_count);
                    if (count >= 1) {
                      count = count - 1;
                      countOriginal = count;
                    } else {
                      count = 0;
                      countOriginal = count;
                    }
                  });
                },
                icon: Icon(Icons.indeterminate_check_box_sharp),
              )
            : Container(
                height: 0,
              ),
      ],
    );
  }
}
