import 'package:etar_en/app/home/operands/company_list_tile.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:flutter/material.dart';

class ShowOperandsCompanies extends StatelessWidget {
  ShowOperandsCompanies({Key key, @required this.operand, this.onSelect}) : super(key: key);
  final Operand operand;
  final Function onSelect;
  String selectedCompany;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cégeim'),),
      body: ListView.builder(
        itemBuilder: (context, index) => CompanyListTile(
          company: operand.companies[index],
          onTap: (company) => onSelect(company),
        ),
        itemCount: operand.companies.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
