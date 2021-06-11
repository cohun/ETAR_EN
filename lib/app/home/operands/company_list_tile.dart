import 'package:flutter/material.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({Key key, @required this.company, this.onTap}) : super(key: key);
  final String company;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(company),
      trailing: Icon(Icons.chevron_right),
      onTap: () => onTap(company),
    );
  }
}
