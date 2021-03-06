import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/models/similar_safety_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimilarSafetyEntryPage extends StatefulWidget {
  const SimilarSafetyEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.similarSafety,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final SimilarSafetyModel similarSafety;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      SimilarSafetyModel similarSafety}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SimilarSafetyEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            similarSafety: similarSafety),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _SimilarSafetyEntryPageState();
}

class _SimilarSafetyEntryPageState extends State<SimilarSafetyEntryPage> {
  String _id;
  DateTime _date;
  String _name;
  String _cerId;
  DateTime _cerDate;
  String _cerName;
  String _standard;
  String _kind;

  @override
  void initState() {
    super.initState();
    _id = widget.similarSafety?.id ?? '';
    final start = widget.similarSafety?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _cerId = widget.similarSafety?.cerId ?? '';
    final end = widget.similarSafety?.cerDate ?? DateTime.now();
    _cerDate = DateTime(end.year, end.month, end.day);
    _cerName = widget.similarSafety?.cerName ?? '';
    _standard = widget.similarSafety?.standard ?? '';
    _kind = widget.similarSafety?.kind ?? '';
  }

  SimilarSafetyModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final cerDate = DateTime(_cerDate.year, _cerDate.month, _cerDate.day);
    final id = widget.similarSafety?.id ?? documentIdFromCurrentDate();
    return SimilarSafetyModel(
      id: id,
      date: date,
      name: _name,
      cerId: _cerId,
      cerDate: cerDate,
      cerName: _cerName,
      standard: _standard,
      kind: _kind,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database
          .setSimilarSafety(entry, widget.company, widget.productId, entry.id);
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
        title: Text('Szabv??nyt??l val?? elt??r??s'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.similarSafety != null ? 'jav??t??s' : 'l??trehoz??s',
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
              _buildCerDate(),
              _buildCerName(),
              _buildStandard(),
              SizedBox(height: 8.0),
              _buildKind(),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DatePicker(
      labelText: 'bejegyz??s d??tuma',
      selectedDate: _date,
      onSelectedDate: (date) => setState(() => _date = date),
    );
  }

  Widget _buildCerDate() {
    return DatePicker(
      labelText: '??ll??sfoglal??s kelte',
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
        labelText: '??ll??sfoglal??s azonos??t??ja',
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
        labelText: 'igazol?? szervezet neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerName) => _cerName = cerName,
    );
  }

  Widget _buildStandard() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _standard),
      decoration: InputDecoration(
        labelText: '??rintett szabv??ny',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (standard) => _standard = standard,
    );
  }

  Widget _buildKind() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _kind),
      decoration: InputDecoration(
        labelText: 'szabv??nyt??l val?? elt??r??s le??r??sa',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (kind) => _kind = kind,
    );
  }
}
