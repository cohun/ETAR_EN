import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class FindProductId extends StatefulWidget {
  FindProductId({Key key, this.operandsName, this.company, this.role}) : super(key: key);
  final String operandsName;
  final String company;
  final String role;
  Database database;

  @override
  _FindProductIdState createState() => _FindProductIdState();
}

class _FindProductIdState extends State<FindProductId> {
  String _role;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('Emelőgép kiválasztása'),
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.teal[800],
      ),
      body: _buildContents(context),
    );
  }

  _buildContents(BuildContext context) {
    _convertRole(widget.role);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.company} ',
              style: TextStyle(color: Colors.teal[900]),
              textAlign: TextAlign.center,
            ),
            Text(
              ' ${widget.operandsName} ',
              style: TextStyle(color: Colors.red[900]),
              textAlign: TextAlign.center,
            ),
            Text(
              ' részére',
              style: TextStyle(color: Colors.teal[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          'az alábbi emelőgépekhez biztosít hozzáférést',
          style: TextStyle(color: Colors.teal[900]),
          textAlign: TextAlign.center,
        ),
        Text(
          'mint $_role:',
          style: TextStyle(color: Colors.teal[900]),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
  _convertRole(String role) {
    switch (role) {
      case 'inspector':
        {
          _role = 'vizsgáló';
        }
        break;
      case 'operator':
        {
          _role = 'gépkezelő';
        }
        break;
      case 'service':
        {
          _role = 'szervíz';
        }
        break;
      default:
        {
          _role = 'gépkezelő';
        }
        break;
    }
  }
}
