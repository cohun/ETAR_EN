import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/date_picker.dart';
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
  int nrMonths;
  final SnackBar _snackBar = SnackBar(
      content: Text(
    'Adatok feltöltve',
    style: TextStyle(color: Colors.green, fontSize: 20),
    textAlign: TextAlign.center,
  ));

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
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
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
        labelText: 'jegyzőkönyv kiállítójának neve',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: null,
      onChanged: (cerName) => _cerName = cerName,
    );
  }

  Widget _buildClassNr() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          Text(
            'Válassz a legördülő menüből:',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 4,
          ),
          DropdownButton<String>(
            items: [
              DropdownMenuItem<String>(
                child: Text(
                  '\"1 -es\" vizsgálati csoportszám MSZ 9750 szerint',
                  overflow: TextOverflow.ellipsis,
                ),
                value: '8',
              ),
              DropdownMenuItem<String>(
                child: Text(
                  '\"2 -es\" vizsgálati csoportszám MSZ 9750 szerint',
                  overflow: TextOverflow.ellipsis,
                ),
                value: '7',
              ),
              DropdownMenuItem<String>(
                child: Text(
                  '\"3 -es\" vizsgálati csoportszám MSZ 9750 szerint',
                  overflow: TextOverflow.ellipsis,
                ),
                value: '6',
              ),
              DropdownMenuItem<String>(
                child: Text(
                  '\"4 -es\" vizsgálati csoportszám MSZ 9750 szerint',
                  overflow: TextOverflow.ellipsis,
                ),
                value: '4',
              ),
              DropdownMenuItem<String>(
                child: Text(
                  '\"5 -es\" vizsgálati csoportszám MSZ 9750 szerint',
                  overflow: TextOverflow.ellipsis,
                ),
                value: '3',
              ),
              DropdownMenuItem<String>(
                child: Text('Egyedi'),
                value: '',
              ),
            ],
            onChanged: (String value) {
              if (value != '') {
                nrMonths = int.tryParse(value);
                print(nrMonths);
                _periodInspection = '$nrMonths hó';
                _periodThoroughEx = '${nrMonths * 3} hó';
                setClassNr(value);
              } else {
                _classNr = '';
              }
              setState(() {});
            },
            hint: Text('Üzemi csoportszám'),
            value:
                _classNr != '' ? _periodInspection.substring(0, 1) : _classNr,
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }

  setClassNr(String value) {
    switch (value) {
      case '8':
        setState(() {
          _classNr = '1';
        });
        break; // The switch statement must be told to exit, or it will execute every case.
      case '7':
        setState(() {
          _classNr = '2';
        });
        break;
      case '6':
        setState(() {
          _classNr = '3';
        });
        break;
      case '4':
        setState(() {
          _classNr = '4';
        });
        break;
      case '3':
        setState(() {
          _classNr = '5';
        });
        break;
      default:
        print('choose a different number!');
        setState(() {
          _classNr = '';
        });
        break;
    }
  }

  Widget _buildThoroughEx() {
    return _classNr == ''
        ? TextField(
            keyboardType: TextInputType.text,
            maxLength: 50,
            controller: TextEditingController(text: _periodThoroughEx),
            decoration: InputDecoration(
              hintText: 'pl. 36 hó',
              labelText: 'Fővizsgálat időköze',
              labelStyle:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            style: TextStyle(fontSize: 20.0, color: Colors.white),
            maxLines: null,
            onChanged: (periodThoroughEx) =>
                _periodThoroughEx = periodThoroughEx,
          )
        : Container(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 8),
              child: Text(
                  'Fővizsgálat időköze: ${_periodThoroughEx != null ? _periodThoroughEx : nrMonths * 3}'),
            ),
          );
  }

  Widget _buildinspection() {
    return _classNr == ''
        ? TextField(
            keyboardType: TextInputType.text,
            maxLength: 50,
            controller: TextEditingController(text: _periodInspection),
            decoration: InputDecoration(
              hintText: 'pl. 12 hó',
              labelText: 'szerkezeti vizsgálatok időköze',
              labelStyle:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            style: TextStyle(fontSize: 20.0, color: Colors.white),
            maxLines: null,
            onChanged: (periodInspection) =>
                _periodInspection = periodInspection,
          )
        : Container(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Szerkezeti vizsgálatok időköze: ${_periodInspection != null ? _periodInspection : nrMonths}'),
            ),
          );
  }
}
