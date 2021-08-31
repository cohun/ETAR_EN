import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/models/load_test_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadTestEntryPage extends StatefulWidget {
  const LoadTestEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.loadTest,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final LoadTestModel loadTest;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      LoadTestModel loadTest}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoadTestEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            loadTest: loadTest),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _LoadTestEntryPageState();
}

class _LoadTestEntryPageState extends State<LoadTestEntryPage> {
  String _id;
  DateTime _date;
  String _name;
  String _cerId;
  DateTime _cerDate;
  String _cerName;
  String _cerAuthority;
  String _kind;
  String _load;
  String _measuredParam;
  String _measuredValue;

  @override
  void initState() {
    super.initState();
    _id = widget.loadTest?.id ?? '';
    final start = widget.loadTest?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _cerId = widget.loadTest?.cerId ?? '';
    final end = widget.loadTest?.cerDate ?? DateTime.now();
    _cerDate = DateTime(end.year, end.month, end.day);
    _cerName = widget.loadTest?.cerName ?? '';
    _cerAuthority = widget.loadTest?.cerAuthority ?? '';
    _kind = widget.loadTest?.kind ?? '';
    _load = widget.loadTest?.load ?? '';
    _measuredParam = widget.loadTest?.measuredParam ?? '';
    _measuredValue = widget.loadTest?.measuredValue ?? '';
  }

  LoadTestModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final cerDate = DateTime(_cerDate.year, _cerDate.month, _cerDate.day);
    final id = widget.loadTest?.id ?? documentIdFromCurrentDate();
    return LoadTestModel(
      id: id,
      date: date,
      name: _name,
      cerId: _cerId,
      cerDate: cerDate,
      cerName: _cerName,
      cerAuthority: _cerAuthority,
      kind: _kind,
      load: _load,
      measuredParam: _measuredParam,
      measuredValue: _measuredValue,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database
          .setLoadTest(entry, widget.company, widget.productId, entry.id);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Terhelési próba'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.loadTest != null ? 'javítás' : 'létrehozás',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDate(),
              SizedBox(height: 8.0),
              _buildCerId(),
              _buildCerName(),
              _buildCerAuthority(),
              _buildCerDate(),
              SizedBox(height: 8.0),
              _buildKind(),
              _buildLoad(),
              _buildParam(),
              _buildValue(),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DatePicker(
      labelText: 'bejegyzés dátuma',
      selectedDate: _date,
      onSelectedDate: (date) => setState(() => _date = date),
    );
  }

  Widget _buildCerDate() {
    return DatePicker(
      labelText: 'jegyzőkönyv kelte',
      selectedDate: _cerDate,
      onSelectedDate: (cerDate) => setState(() => _cerDate = cerDate),
    );
  }

  Widget _buildCerId() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _cerId),
      decoration: InputDecoration(
        labelText: 'jegyzőkönyv száma',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerId) => _cerId = cerId,
    );
  }

  Widget _buildCerName() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _cerName),
      decoration: InputDecoration(
        labelText: 'vizsgálatot végző neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerName) => _cerName = cerName,
    );
  }

  Widget _buildCerAuthority() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _cerAuthority),
      decoration: InputDecoration(
        labelText: 'vizsgálat végző jogosultsága',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerAuthority) => _cerAuthority = cerAuthority,
    );
  }

  Widget _buildKind() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _kind),
      decoration: InputDecoration(
        labelText: 'teherpróba jellege',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (kind) => _kind = kind,
    );
  }

  Widget _buildLoad() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _load),
      decoration: InputDecoration(
        labelText: 'Próbateher tömege',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (load) => _load = load,
    );
  }

  Widget _buildParam() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _measuredParam),
      decoration: InputDecoration(
        labelText: 'Mért jellemző',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (param) => _measuredParam = param,
    );
  }

  Widget _buildValue() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _measuredValue),
      decoration: InputDecoration(
        labelText: 'Mért érték',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (value) => _measuredValue = value,
    );
  }
}
