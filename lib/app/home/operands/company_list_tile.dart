import 'package:flutter/material.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({Key key, @required this.company, this.onTap, this.role}) : super(key: key);
  final String company;
  final String role;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(company),
      subtitle: Text(role),
      trailing: Icon(Icons.chevron_right),
      onTap: () => onTap(company),
    );
  }
}
