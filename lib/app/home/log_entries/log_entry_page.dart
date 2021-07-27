import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
import 'package:etar_en/app/home/logs/date_time_picker.dart';
import 'package:etar_en/app/models/log_model.dart';
import 'package:etar_en/dialogs/show_exception_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class LogEntryPage extends StatefulWidget {
  const LogEntryPage(
      {@required this.database,
      @required this.company,
      this.productId,
      this.log,
      this.name});

  final Database database;
  final String company;
  final String name;
  final String productId;
  final LogModel log;

  static Future<void> show(
      {BuildContext context,
      Database database,
      String company,
      String name,
      String productId,
      LogModel log}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LogEntryPage(
            database: database,
            company: company,
            name: name,
            productId: productId,
            log: log),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage> {
  bool _value = false;
  int val = -1;
  String _id;
  DateTime _date;
  TimeOfDay _time;
  String _name;
  String _shift;
  String _entry;
  bool _state;
  bool _repaired;
  String _operatorName;
  DateTime _repairDate;
  String _repairName;

  @override
  void initState() {
    super.initState();
    _id = widget.log?.id ?? '';
    final start = widget.log?.date ?? DateTime.now();
    _date = DateTime(start.year, start.month, start.day);
    _time = TimeOfDay.fromDateTime(start);
    _name = widget.name;
    _shift = widget.log?.shift ?? '';
    _entry = widget.log?.entry ?? '';
    _state = widget.log?.state ?? true;
    _repaired = widget.log?.repaired ?? false;
    _operatorName = widget.log?.operatorName ?? '';
    final end = widget.log?.repairDate ?? DateTime.now();
    _repairDate = DateTime(end.year, end.month, end.day);
    _repairName = widget.log?.repairName ?? '';
  }

  LogModel _entryFromState() {
    final date = DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.periodOffset);
    final repairDate =
        DateTime(_repairDate.year, _repairDate.month, _repairDate.day);
    final id = widget.log?.id ?? documentIdFromCurrentDate();
    return LogModel(
      id: id,
      date: date,
      name: _name,
      shift: _shift,
      entry: _entry,
      state: _state,
      repaired: _repaired,
      operatorName: _operatorName,
      repairDate: repairDate,
      repairName: _repaired ? _repairName : '',
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database
          .setLog(entry, widget.company, widget.productId, entry.id);
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
        title: Text('Műszakos vizsgálat'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.log != null ? 'javítás' : 'létrehozás',
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
              _buildShift(),
              _buildOperatorName(),
              SizedBox(height: 8.0),
              _buildEntry(),
              SizedBox(height: 8.0),
              _state
                  ? Container(
                      height: 0,
                    )
                  : _buildRepaired(),
              !_repaired
                  ? Container(
                      height: 0,
                    )
                  : _buildRepairName(),
              !_repaired
                  ? Container(
                      height: 0,
                    )
                  : _buildRepairDate(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DateTimePicker(
      labelText: 'bejegyzés ideje',
      selectedDate: _date,
      selectedTime: _time,
      onSelectedDate: (date) => setState(() => _date = date),
      onSelectedTime: (time) => setState(() => _time = time),
    );
  }

  Widget _buildRepairDate() {
    return DatePicker(
      labelText: 'Javítás kelte',
      selectedDate: _repairDate,
      onSelectedDate: (repairDate) => setState(() => _repairDate = repairDate),
    );
  }

  Widget _buildStatus() {
    _state ? val = -1 : val = 1;
    return Theme(
        data: ThemeData(unselectedWidgetColor: Colors.green),
        child: ListTile(
          title: _state
              ? Text(
                  "Üzemelés rendben:",
                  style: TextStyle(color: Colors.green),
                )
              : _repairName != ''
                  ? Text("Korábbi hiba",
                      style: TextStyle(color: Colors.orange[300]))
                  : Text("Hiba észlelve", style: TextStyle(color: Colors.red)),
          leading: Radio(
            value: 1,
            groupValue: val,
            onChanged: (value) {
              setState(() {
                !_repaired ? _state = !_state : null;
                val = value;
              });
            },
            activeColor: Colors.red,
            toggleable: true,
          ),
        ));
  }

  Widget _buildShift() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _shift),
      decoration: InputDecoration(
        labelText: 'Műszak',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (shift) => _shift = shift,
    );
  }

  Widget _buildOperatorName() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _operatorName),
      decoration: InputDecoration(
        labelText: 'Gépkezelő neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (operatorName) => _operatorName = operatorName,
    );
  }

  Widget _buildEntry() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 100,
      controller: TextEditingController(text: _entry),
      decoration: InputDecoration(
        labelText: 'Vizsgálat/használat közben tapasztalt esemény',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (entry) => _entry = entry,
    );
  }

  Widget _buildRepaired() {
    !_repaired ? val = -1 : val = 1;
    return Theme(
        data: ThemeData(unselectedWidgetColor: Colors.green),
        child: ListTile(
          title: _repaired
              ? Text(
                  "Javítva: ",
                  style: TextStyle(color: Colors.green),
                )
              : Text("Hiba javítás rögzítése?",
                  style: TextStyle(color: Colors.green[300])),
          leading: Radio(
            value: 1,
            groupValue: val,
            onChanged: (value) {
              setState(() {
                _repaired = !_repaired;
                val = value;
              });
            },
            activeColor: Colors.green,
            toggleable: true,
          ),
        ));
  }

  Widget _buildRepairName() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _repairName),
      decoration: InputDecoration(
        labelText: 'Hibaelhárítást végző neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (repairName) => _repairName = repairName,
    );
  }
}
