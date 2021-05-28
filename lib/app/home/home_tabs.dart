import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { account, companies, products }

class HomeTabs extends StatelessWidget {
  const HomeTabs({Key key, this.user, this.comp, this.role, this.approvedRole})
      : super(key: key);
  final String user;
  final String comp;
  final String role;
  final String approvedRole;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '$user',
          ),
          BottomNavigationBarItem(
            icon: approvedRole == null || approvedRole == 'entrant'
                ? Icon(Icons.help)
                : Icon(Icons.assignment_turned_in),
            label: switchRole(approvedRole),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '$comp',
          ),
        ],
        selectedItemColor: approvedRole == null || approvedRole == 'entrant'
            ? Colors.amber[800]
            : Colors.green[800],
        currentIndex: 1,
        onTap: (index) {});
  }
}

String switchRole(approvedRole) {
  switch (approvedRole) {
    case 'readOnly':
      return 'betekintési jog';
      break;
    case 'admin':
      return 'adatmódosítási jog';
      break;
    case 'superSuper':
      return 'jogosultságok';
      break;
    case 'hyper':
      return 'betekintés cégekbe';
      break;
    case 'hyperSuper':
      return 'írás jog cégekben';
      break;
    default:
      return 'tagság függőben';
  }
}
