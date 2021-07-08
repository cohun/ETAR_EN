import 'package:flutter/material.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile(
      {Key key,
      @required this.company,
      this.onTap,
      this.role,
      @required this.showProduct,
      this.index})
      : super(key: key);
  final String company;
  final String role;
  final Function onTap;
  final Function showProduct;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(company),
      subtitle: Text(role),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right),
        onPressed: () => showProduct(company, role, index),
      ),
      onTap: () => onTap(company),
    );
  }
}
