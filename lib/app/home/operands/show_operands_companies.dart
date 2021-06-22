import 'package:etar_en/app/home/operands/company_list_tile.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowOperandsCompanies extends StatefulWidget {
  ShowOperandsCompanies({Key key, @required this.operand, this.onSelect, @required this.database}) : super(key: key);
  final Operand operand;
  final Function onSelect;
  final Database database;

  @override
  _ShowOperandsCompaniesState createState() => _ShowOperandsCompaniesState();
}

class _ShowOperandsCompaniesState extends State<ShowOperandsCompanies> {
  String selectedCompany;
  TextEditingController _textController;
  String _company;
  List<String> _newCompanyList;
  int _companyId = 1;

  _addCompany(BuildContext context) {
    _showEtarCode(context);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hibás adatbevitel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A megadott ETAR kód nem létezik.'),
                Text('Kérjük próbálja meg még egyszer!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Rendben'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> retrieveCompany() async {
    try {
      await widget.database
          .retrieveCompanyFromCounter(_companyId)
          .then((value) => _company = value.company);
      _newCompanyList = widget.operand.companies;
      setState(() {
        _newCompanyList.add(_company);
      });
      print(_newCompanyList);
    } catch (e) {
      await _showMyDialog();
    }
  }

  _showEtarCode(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
          title: new Text("Kérem a cég ETAR-kódját!"),
          content: new Text(
              "Új cég felviteléhez az adott cégtől el kell kérni az ETAR-kódot!"),
          actions: <Widget>[
            TextButton(
              child: Text('Mégsem!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoTextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              controller: _textController,
              onChanged: (val) => _companyId = int.tryParse(val),
              placeholder: 'ETAR-kód',
              keyboardType: TextInputType.number,
            ),
            TextButton(
              child: Text('Mehet!'),
              onPressed: () {
                retrieveCompany();
                print('Here: $_companyId');
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cégeim'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => CompanyListTile(
          company: widget.operand.companies[index],
          onTap: (company) => widget.onSelect(company),
        ),
        itemCount: widget.operand.companies.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEtarCode(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
