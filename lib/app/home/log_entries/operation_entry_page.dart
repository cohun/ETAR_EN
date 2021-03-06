import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/models/etar_inspection_model.dart';
import 'package:etar_en/app/models/operation_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OperationEntryPage extends StatefulWidget {
  const OperationEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.operation,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final OperationModel operation;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      OperationModel operation}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OperationEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            operation: operation),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _OperationEntryPageState();
}

class _OperationEntryPageState extends State<OperationEntryPage> {
  bool _value = false;
  int val = -1;
  String _id;
  DateTime _date;
  String _name;
  String _cerId;
  DateTime _cerDate;
  String _cerName;
  String _cerAuthority;
  String _startName;
  String _startAuthority;
  DateTime _startDate;
  bool _state;
  String _cause;

  @override
  void initState() {
    super.initState();
    _id = widget.operation?.id ?? '';
    final start = widget.operation?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _name = widget.name;
    _cerId = widget.operation?.cerId ?? '';
    final end = widget.operation?.cerDate ?? DateTime.now();
    _cerDate = DateTime(end.year, end.month, end.day);
    _cerName = widget.operation?.cerName ?? '';
    _cerAuthority = widget.operation?.cerAuthority ?? '';
    final middle = widget.operation?.startDate ?? DateTime.now();
    _startName = widget.operation?.startName ?? '';
    _startAuthority = widget.operation?.startAuthority ?? '';
    _startDate = DateTime(middle.year, middle.month, middle.day);
    _state = widget.operation?.state ?? true;
    _cause = widget.operation?.cause ?? '';
  }

  OperationModel _entryFromState() {
    final date = DateTime(_date.year, _date.month, _date.day);
    final cerDate = DateTime(_cerDate.year, _cerDate.month, _cerDate.day);
    final startDate =
        DateTime(_startDate.year, _startDate.month, _startDate.day);
    final id = widget.operation?.id ?? documentIdFromCurrentDate();
    return OperationModel(
      id: id,
      date: date,
      name: _name,
      cerId: _cerId,
      cerDate: cerDate,
      cerName: _cerName,
      cerAuthority: _cerAuthority,
      startName: _startName,
      startAuthority: _startAuthority,
      startDate: startDate,
      state: _state,
      cause: _cause,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      if (_state) {
        await _submitOpStart();
      }
      final entry = _entryFromState();
      await widget.database
          .setOperation(entry, widget.company, widget.productId, entry.id);
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

  Future<void> _submitOpStart() async {
    try {
      final opStart = EtarInspectionModel(
        type: "??zembehelyez??s",
        productID: widget.productId,
        doer: _startName,
        comment: _cerAuthority,
        result: 'Megfelelt',
        date: _startDate.toIso8601String().substring(0, 10),
        nextDate: _startDate.toIso8601String().substring(0, 10),
        nr: (DateTime.now().millisecondsSinceEpoch -
                    _date.millisecondsSinceEpoch)
                .toString()
                .substring(2, 8) +
            '/${DateTime.now().year}',
      );
      await widget.database.setOperationStart(widget.company, opStart);
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text('M??velet sikertelen'),
      );
    }
  }

  //**************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: _state ? Text('??zemeltet??s') : Text('Le??ll??t??s'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.operation != null ? 'jav??t??s' : 'l??trehoz??s',
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
              _buildStatus(),
              _buildDate(),
              SizedBox(height: 8.0),
              _buildCerId(),
              _buildCerName(),
              _buildCerAuthority(),
              _buildCerDate(),
              SizedBox(height: 8.0),
              _buildStartName(),
              _buildStartAuthority(),
              _buildStartDate(),
              SizedBox(height: 8.0),
              _state
                  ? Container(
                      height: 0,
                    )
                  : _buildCause(),
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

  Widget _buildStartDate() {
    return DatePicker(
      labelText:
          _state ? '??zembehelyez??s kelte' : '??zemeltet??s le??ll??t??s??nak kelte',
      selectedDate: _startDate,
      onSelectedDate: (startDate) => setState(() => _startDate = startDate),
    );
  }

  Widget _buildStatus() {
    print('start$val');
    print(_state);
    _state ? val = -1 : val = 1;
    return Theme(
        data: ThemeData(unselectedWidgetColor: Colors.green),
        child: ListTile(
          title: _state
              ? Text(
                  "??zemeltet??s elrendel??se:",
                  style: TextStyle(color: Colors.green),
                )
              : Text("??zemeltet??s le??ll??t??sa:",
                  style: TextStyle(color: Colors.red)),
          leading: Radio(
            value: 1,
            groupValue: val,
            onChanged: (value) {
              setState(() {
                _state = !_state;
                val = value;
                print(val);
              });
            },
            activeColor: Colors.red,
            toggleable: true,
          ),
        ));
  }

  Widget _buildCerId() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _cerId),
      decoration: InputDecoration(
        labelText:
            _state ? 'vizsg??lati jegyz??k??nyv sz??ma' : 'int??zked??s azonos??t??ja',
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
        labelText: _state
            ? 'jegyz??k??nyv ki??ll??t??j??nak neve'
            : 'int??zked??s ki??ll??t??j??nak neve',
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
        labelText: _state
            ? 'jegyz??k??nyv ki??ll??t??j??nak jogosults??ga'
            : 'int??zked??s ki??ll??t??j??nak jogosults??ga',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerAuthority) => _cerAuthority = cerAuthority,
    );
  }

  Widget _buildStartName() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _startName),
      decoration: InputDecoration(
        labelText: _state
            ? '??zembehelyez??st elrendel?? neve'
            : 'Le??ll??t??st elrendel?? neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (startName) => _startName = startName,
    );
  }

  Widget _buildStartAuthority() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _startAuthority),
      decoration: InputDecoration(
        labelText: _state
            ? '??zembehelyez??st elrendel?? beoszt??sa'
            : 'le??ll??t??st elrendel?? beoszt??sa',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (startAuthority) => _startAuthority = startAuthority,
    );
  }

  Widget _buildCause() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _cause),
      decoration: InputDecoration(
        labelText: '??zemeltet??s le??ll??t??s??nak oka',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cause) => _cause = cause,
    );
  }
}
