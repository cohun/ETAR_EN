import 'package:etar_en/dialogs/conditions/policy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatefulWidget {
  final bool isAccepted;
  final Function accept;

  TermsOfUse({Key key, this.isAccepted, this.accept}) : super(key: key);

  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.blueGrey[800],
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 48, 4, 24),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Az ETAR® rendszerbe való bejelentkezéssel az\n',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white60),
                      children: [
                        TextSpan(text: '\n', style: TextStyle(fontSize: 4)),
                        TextSpan(
                          text: 'Általános Felhasználási Feltételeket\n',
                          style: TextStyle(fontWeight: FontWeight.bold)
                              .copyWith(fontSize: 17, color: Colors.white),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return PolicyDialog(
                                      mdFileName: 'terms_and_conditions.md');
                                },
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CheckboxListTile(
                        dense: true,
                        title: Text(
                          'elfogadom:',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white60),
                        ),
                        activeColor: Colors.teal,
                        checkColor: Colors.yellow,
                        selected: _isChecked1,
                        value: _isChecked1,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked1 = value;
                          });
                        }),
                  ),
                  Container(
                    height: 24,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'és az\n',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white60),
                      children: [
                        TextSpan(text: '\n', style: TextStyle(fontSize: 4)),
                        TextSpan(
                          text: 'Általános Adatvédelmi Irányelveket',
                          style: TextStyle(fontWeight: FontWeight.bold)
                              .copyWith(fontSize: 17, color: Colors.white),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return PolicyDialog(
                                      mdFileName: 'privacy_policy.md');
                                },
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CheckboxListTile(
                        dense: true,
                        title: Text(
                          'elfogadom:',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.white60),
                        ),
                        activeColor: Colors.teal,
                        checkColor: Colors.yellow,
                        selected: _isChecked2,
                        value: _isChecked2,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked2 = value;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              padding: EdgeInsets.all(0.0),
            ),
            onPressed: enableButton,
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey[800], Colors.blueGrey[300]],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  "Bejelentkezés",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  enableButton() {
    if (_isChecked1 == true && _isChecked2 == true) {
      widget.accept();
    } else {
      _showCupertinoDialog(context);
    }
  }

  _showCupertinoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: Text("Kötelező elfogadni a feltételeket"),
              content: Text("A továbblépéshez jelöld a négyzeteket!"),
              actions: <Widget>[
                TextButton(
                  child: Text('Újra!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
