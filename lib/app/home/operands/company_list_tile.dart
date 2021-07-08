import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyListTile extends StatelessWidget {
  const CompanyListTile({Key key,
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
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(company),
      ),
      subtitle: Row(
        children: [
          Text(role),
          SizedBox(
            width: 68,
          ),
          InkWell(
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              print('delete ${company}');
              _showCupertinoDialog(context, company);
            },
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right),
        onPressed: () => showProduct(company, role, index),
      ),
      onTap: () => onTap(company),
    );
  }

  _showCupertinoDialog(BuildContext context, String company) {
    showDialog(
      context: context,
      builder: (_) => new CupertinoAlertDialog(
        title: new Text("$company törlése"),
        content: new Text("Törlés után a hozzáférés megszűnik"),
        actions: <Widget>[
          TextButton(
            child: Text('Mégsem!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Törlés!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
