import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({
    Key key,
    @required this.company,
    this.onTap,
    this.role,
    @required this.showProduct,
    this.deleteCompany,
  }) : super(key: key);
  final String company;
  final String role;
  final Function onTap;
  final Function showProduct;
  final Function deleteCompany;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(company),
      ),
      subtitle: Row(
        children: [
          Text(role),
          SizedBox(
            width: 48,
          ),
          InkWell(
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () => deleteCompany(context, company),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right),
        onPressed: () => showProduct(company, role),
      ),
      onTap: () => onTap(company),
    );
  }
}
