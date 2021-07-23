import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_time_picker.dart';
import 'package:etar_en/app/models/classification_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class ClassificationEntryPage extends StatefulWidget {
  const ClassificationEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.classification,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final ClassificationModel classification;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      ClassificationModel classification}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClassificationEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            classification: classification),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ClassificationEntryPageState();
}

class _ClassificationEntryPageState extends State<ClassificationEntryPage> {
  String _id;
  DateTime _date;
  String _name;
  String _cerId;
  DateTime _cerDate;
  String _cerName;
  String _classNr;
  String _periodThoroughEx;
  String _periodInspection;

  @override
  void initState() {
    super.initState();
    _id = widget.classification?.id ?? '';
    final start = widget.classification?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _cerId = widget.classification?.cerId ?? '';
    final end = widget.classification?.cerDate ?? DateTime.now();
    _cerDate = DateTime(end.year, end.month, end.day);

    _cerName = widget.classification?.cerName ?? '';
    _classNr = widget.classification?.classNr ?? '';
    _periodThoroughEx = widget.classification?.periodThoroughEx ?? '';
    _periodInspection = widget.classification?.periodInspection ?? '';
  }

  ClassificationModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final cerDate = DateTime(_cerDate.year, _cerDate.month, _cerDate.day);
    final id = widget.classification?.id ?? documentIdFromCurrentDate();
    return ClassificationModel(
      id: id,
      date: date,
      name: _name,
      cerId: _cerId,
      cerDate: cerDate,
      cerName: _cerName,
      classNr: _classNr,
      periodThoroughEx: _periodThoroughEx,
      periodInspection: _periodInspection,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database
          .setClassification(entry, widget.company, widget.productId, entry.id);
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
              widget.classification != null ? 'javítás' : 'létrehozás',
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
              _buildCerDate(),
              SizedBox(height: 8.0),
              _buildClassNr(),
              _buildThoroughEx(),
              _buildinspection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DateTimePicker(
      labelText: 'bejegyzés dátuma',
      selectedDate: _date,
      onSelectedDate: (date) => setState(() => _date = date),
    );
  }

  Widget _buildCerDate() {
    return DateTimePicker(
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
        labelText: 'jegyzőkönyv kiállítójának neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerName) => _cerName = cerName,
    );
  }

  Widget _buildClassNr() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _classNr),
      decoration: InputDecoration(
        labelText: 'Üzemi csoportszám',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (classNr) => _classNr = classNr,
    );
  }

  Widget _buildThoroughEx() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _periodThoroughEx),
      decoration: InputDecoration(
        labelText: 'Fővizsgálat időköze',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (periodThoroughEx) => _periodThoroughEx = periodThoroughEx,
    );
  }

  Widget _buildinspection() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _periodInspection),
      decoration: InputDecoration(
        labelText: 'szerkezeti vizsgálatok időköze',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (periodInspection) => _periodInspection = periodInspection,
    );
  }
}
