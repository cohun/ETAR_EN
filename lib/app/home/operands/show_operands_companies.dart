import 'package:etar_en/app/home/operands/company_list_tile.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowOperandsCompanies extends StatefulWidget {
  ShowOperandsCompanies({Key key, @required this.operand, this.onSelect}) : super(key: key);
  final Operand operand;
  final Function onSelect;

  @override
  _ShowOperandsCompaniesState createState() => _ShowOperandsCompaniesState();
}

class _ShowOperandsCompaniesState extends State<ShowOperandsCompanies> {
  String selectedCompany;
  TextEditingController _textController;

  _addCompany(BuildContext context) {
    _showEtarCode(context);
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
              placeholder: 'ETAR-kód',
            ),
            TextButton(
              child: Text('Mehet!'),
              onPressed: () {

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
