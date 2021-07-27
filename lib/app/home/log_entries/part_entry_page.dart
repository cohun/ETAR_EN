import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/models/parts_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class PartEntryPage extends StatefulWidget {
  const PartEntryPage(
      {@required this.database,
        @required this.company,
        this.productId,
        this.part,
        this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final PartsModel part;

  static Future<void> show(
      {BuildContext context,
        Database database,
        String company,
        String name,
        String productId,
        PartsModel part}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PartEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            part: part),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _PartEntryPageState();
}

class _PartEntryPageState extends State<PartEntryPage> {
  String _id;
  DateTime _date;
  String _name;
  String _partName;
  String _partId;
  String _partSize;
  String _serviceName;

  @override
  void initState() {
    super.initState();
    _id = widget.part?.id ?? '';
    final start = widget.part?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _partName = widget.part?.partName ?? '';
    _partId = widget.part?.partId ?? '';
    _partSize = widget.part?.partSize ?? '';
    _serviceName = widget.part?.serviceName ?? '';
  }

  PartsModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final id = widget.part?.id ?? documentIdFromCurrentDate();
    return PartsModel(
      id: id,
      date: date,
      name: _name,
      partName: _partName,
      partId: _partId,
      partSize: _partSize,
      serviceName: _serviceName,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database
          .setParts(entry, widget.company, widget.productId, entry.id);
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
        title: Text('Üzemi csoportszám'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.part != null ? 'javítás' : 'létrehozás',
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
              _buildPartId(),
              _buildPartName(),
              _buildPartSize(),
              SizedBox(height: 8.0),
              _buildService(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DatePicker(
      labelText: 'csere dátuma',
      selectedDate: _date,
      onSelectedDate: (date) => setState(() => _date = date),
    );
  }

  Widget _buildPartId() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _partId),
      decoration: InputDecoration(
        labelText: 'Azonosító',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (partId) => _partId = partId,
    );
  }

  Widget _buildPartName() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _partName),
      decoration: InputDecoration(
        labelText: 'Alkatrész megnevezése',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (partName) => _partName = partName,
    );
  }

  Widget _buildPartSize() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _partSize),
      decoration: InputDecoration(
        labelText: 'Jellemző mérete',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (partSize) => _partSize = partSize,
    );
  }

  Widget _buildService() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _serviceName),
      decoration: InputDecoration(
        labelText: 'Cserét végző',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (serviceName) => _serviceName = serviceName,
    );
  }
}
