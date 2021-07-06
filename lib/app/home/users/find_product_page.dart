import 'package:etar_en/app/models/product_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FindProduct extends StatefulWidget {
  FindProduct({
    Key key,
    this.database,
    this.company,
  }) : super(key: key);
  final Database database;
  final String company;

  @override
  _FindProductState createState() => _FindProductState();
}

class _FindProductState extends State<FindProduct> {
  final _opStartKey = GlobalKey<FormState>();

  final TextEditingController _textController = TextEditingController();

  final FocusNode _textFocusNode = FocusNode();

  String productId;

  ProductModel productResult;

  bool empty = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          child: Center(
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 140.0)),
                Text(
                  'Az alábbi gyári számú emelőgép hozzáadása:',
                  style: TextStyle(
                    color: Colors.teal[800],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Form(
                  key: _opStartKey,
                  child: TextFormField(
                    controller: _textController,
                    focusNode: _textFocusNode,
                    decoration: InputDecoration(
                      labelText: "Gyári szám:",
                      fillColor: Colors.teal[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    autocorrect: false,
                    validator: (val) {
                      if (val.length == 0) {
                        return "Adj meg egy értéket!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.teal[800],
                    ),
                    textAlign: TextAlign.center,
                    onSaved: (value) => productId = value,
                    onEditingComplete: _submit,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                IconButton(
                  iconSize: 80,
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.teal[800],
                    size: 90,
                  ),
                  onPressed: _submit,
                ),
                SizedBox(height: 12),
                showResult(context),
              ])),
        ));
  }

  bool _validateAndSaveOpStartForm() {
    final form = _opStartKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveOpStartForm()) {
      _textController.clear();
      _textFocusNode.unfocus();
      // print('Submit pruduct: ${productResult.description}');
      try {
        ProductModel product;
        await widget.database
            .retrieveProductFromId(widget.company, productId)
            .then((value) => product = value);
        setState(() {
          if (product != null) {
            productResult = product;
            empty = false;
          } else {
            empty = true;
          }
        });
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Widget showResult(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                empty == false
                    ? Text(
                  '${productResult.type}  ${productResult.length}  ${productResult.description}',
                  style: Theme.of(context).textTheme.bodyText1,
                )
                    : Text(
                  'Nincs találat! ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                empty == false ?
                IconButton(
                    icon: Icon(Icons.chevron_right, size: 36,),
                    onPressed: () => print('mehet')) :
                Container(width: 0,),

                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => EditProductPage(
                //             description: productResult.description,
                //             productGroup: productResult.productGroup,
                //             database: widget.database,
                //             product: productResult,
                //             company: widget.company,
                //             approvedRole: widget.approvedRole,
                //           ),
                //           fullscreenDialog: true,
                //         ),
                //       ):
                //       () =>
                //       PlatformAlertDialog(
                //         title: 'Nincs megfelelő jogosultság!',
                //         content: 'Ehhez a művelethez írási jogosultság szükséges',
                //         defaultActionText: 'Vissza',
                //       ).show(context),
                // )
                //     : Container(width: 0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}