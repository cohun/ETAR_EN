import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/models/etar_inspection_model.dart';
import 'package:etar_en/app/models/inspection_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InspectionEntryPage extends StatefulWidget {
  const InspectionEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.inspection,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final InspectionModel inspection;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      InspectionModel inspection}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InspectionEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            inspection: inspection),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _InspectionEntryPageState();
}

class _InspectionEntryPageState extends State<InspectionEntryPage> {
  String _id;
  DateTime _date;
  String _name;
  String _cerId;
  DateTime _cerDate;
  String _cerName;
  String _cerAuthority;
  String _kind;
  String _statement;

  @override
  void initState() {
    super.initState();
    _id = widget.inspection?.id ?? '';
    final start = widget.inspection?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _cerId = widget.inspection?.cerId ?? '';
    final end = widget.inspection?.cerDate ?? DateTime.now();
    _cerDate = DateTime(end.year, end.month, end.day);
    _cerName = widget.inspection?.cerName ?? '';
    _cerAuthority = widget.inspection?.cerAuthority ?? '';
    _kind = widget.inspection?.kind ?? '';
    _statement = widget.inspection?.statement ?? '';
  }

  InspectionModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final cerDate = DateTime(_cerDate.year, _cerDate.month, _cerDate.day);
    final id = widget.inspection?.id ?? documentIdFromCurrentDate();
    return InspectionModel(
      id: id,
      date: date,
      name: _name,
      cerId: _cerId,
      cerDate: cerDate,
      cerName: _cerName,
      cerAuthority: _cerAuthority,
      kind: _kind,
      statement: _statement,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    await _submitEtarInspection();
    try {
      final entry = _entryFromState();
      await widget.database
          .setInspection(entry, widget.company, widget.productId, entry.id);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  //************************ writing opStart in ETAR **************************************

  Future<void> _submitEtarInspection() async {
    try {
      final inspectionEtar = EtarInspectionModel(
        type: "$_kind vizsg??lat",
        productID: widget.productId,
        doer: _cerName,
        comment: _cerAuthority,
        result: 'Megfelelt',
        date: _cerDate.toIso8601String().substring(0, 10),
        nextDate: _cerDate.toIso8601String().substring(0, 10),
        nr: (DateTime.now().millisecondsSinceEpoch -
                    _date.millisecondsSinceEpoch)
                .toString()
                .substring(2, 8) +
            '/${DateTime.now().year}',
      );
      await widget.database.setEtarInspection(widget.company, inspectionEtar);
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text('M??velet sikertelen'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Id??szakos Vizsg??latok'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.inspection != null ? 'jav??t??s' : 'l??trehoz??s',
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
              _buildStatement(),
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
      labelText: 'jegyz??k??nyv kelte',
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
        labelText: 'jegyz??k??nyv sz??ma',
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
        labelText: 'vizsg??latot v??gz?? neve',
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
        labelText: 'vizsg??lat v??gz?? jogosults??ga',
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
        labelText: 'vizsg??lat megnevez??se',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (kind) => _kind = kind,
    );
  }

  Widget _buildStatement() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _statement),
      decoration: InputDecoration(
        labelText: 'Jegyz??k??nyv meg??llap??t??sa',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (statement) => _statement = statement,
    );
  }
}
