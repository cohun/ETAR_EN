import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/operands/company_list_tile.dart';
import 'package:etar_en/app/home/users/assigned_products_page.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/dialogs/show_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowOperandsCompanies extends StatefulWidget {
  ShowOperandsCompanies(
      {Key key,
      @required this.operand,
      this.onSelect,
      @required this.database,
      this.selectedCompany,
      this.onItemSelect})
      : super(key: key);
  final Operand operand;
  final Function onSelect;
  final Function onItemSelect;
  final Database database;
  final String selectedCompany;

  @override
  _ShowOperandsCompaniesState createState() => _ShowOperandsCompaniesState();
}

class _ShowOperandsCompaniesState extends State<ShowOperandsCompanies> {
  String selectedCompany;
  TextEditingController _textController;
  String _company;
  List<String> _newCompanyList;
  int _companyId = 1;
  List<String> _choice = List.filled(50, 'pending', growable: true);
  bool _showProducts = false;

  // initState
  @override
  void initState() {
    super.initState();
    _newCompanyList = widget.operand.companies;
  }

  _changeShowProduct(String company, String role) {
    _company = company;
      if (_company == widget.selectedCompany && role != 'függőben') {
        _showProducts = !_showProducts;
      } else {
        _snackBar(context, company, widget.selectedCompany);
    }
  }

  _snackBar(BuildContext context, String company, String selected) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 90,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Jelenleg '),
                    Text(
                      selected,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(' van kiválasztva,'),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(' és nincs jogosultság a '),
                    Text(
                      company,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(' adataihoz. '),
                  ],
                ),
              ),
              Divider(
                thickness: 4,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Ha van jogosultságod, válaszd: '),
                    Text(
                      company,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: Duration(seconds: 5),
      ),
    );
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
      setState(() {
        _newCompanyList.add(_company);
        widget.database.updateCompanies(_newCompanyList);
      });
      print(_newCompanyList);
    } catch (e) {
      await _showMyDialog();
    }
  }

  Future<void> removeCompany(String company) async {
    try {
      setState(() {
        _newCompanyList.remove(company);
        widget.database.updateCompanies(_newCompanyList);
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
              title: new Text("ETAR-kód"),
              content: new Text("Új cég felviteléhez add meg az ETAR-kódot!"),
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
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
              _deleteId(context, company);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteId(BuildContext context, String company) async {
    try {
      await widget.database.deleteCompany(company, widget.operand.uid);
      await removeCompany(company);
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation failed',
          content: e.toString(),
          defaultActionText: 'OK');
    }
    setState(() {
      _showProducts = false;
      _newCompanyList = widget.operand.companies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _showProducts ? Text('Emelőgépek') : Text('Cégeim'),
      ),
      body: _showProducts && _company == widget.selectedCompany
          ? buildAssignedProducts()
          : ListView.builder(
              itemBuilder: (context, index) {
                retrieveCompanyRole(
                    widget.operand.uid, _newCompanyList[index], index);
                return CompanyListTile(
                    showProduct: _changeShowProduct,
                    company: _newCompanyList[index],
                    role: _choice[index],
                    deleteCompany: _showCupertinoDialog,
                    onTap: (company) {
                      widget.onItemSelect('', '');
                      return widget.onSelect(company, _choice[index]);
                    });
        },
              itemCount: _newCompanyList.length,
            ),
      floatingActionButton: _showProducts
          ? null
          : FloatingActionButton(
              onPressed: () => _showEtarCode(context),
              child: Icon(Icons.add),
            ),
    );
  }

  Container buildAssignedProducts() {
    return Container(
      color: Colors.white70,
      child: AssignedProductsPage(
        database: widget.database,
        company: _company,
        uid: widget.operand.uid,
        forOperands: true,
        onItemSelect: widget.onItemSelect,
      ),
    );
  }

  Future<void> retrieveCompanyRole(String uid, String company, int ind) async {
    try {
      await widget.database.retrieveCompany(uid, company).then((value) {
        if (value.role == '') _choice[ind] = 'függőben';
        if (value.role != '') {
          _choice[ind] = value.role;
          switch (_choice[ind]) {
            case 'pending':
              {
                _choice[ind] = 'függőben';
              }
              break;
            case 'inspector':
              {
                _choice[ind] = 'vizsgáló';
              }
              break;
            case 'operator':
              {
                _choice[ind] = 'gépkezelő';
              }
              break;
            case 'service':
              {
                _choice[ind] = 'szervíz';
              }
              break;
            default:
              {
                _choice[ind] = 'függőben';
              }
              break;
          }
          if (mounted) setState(() {});
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
