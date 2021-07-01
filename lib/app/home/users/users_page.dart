import 'package:etar_en/app/home/users/find_productId.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key, this.company, this.database}) : super(key: key);

  final String company;
  final Database database;
  List<String> _choice = List.filled(50, 'pending', growable: true);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogosultságok'),
      ),
      body: buildStreamBuilder(context),
    );
  }

  StreamBuilder<List<Operand>> buildStreamBuilder(BuildContext context) {
    return StreamBuilder<List<Operand>>(
      stream: widget.database.filteredOperandStream(company: widget.company),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final operands = snapshot.data;

          return _buildListView(operands, context);
        }
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildListView(List<Operand> operands, BuildContext context) {
    return ListView.separated(
      itemCount: operands.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        thickness: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        retrieveCompany(operands[index].uid, widget.company, index);
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(operands[index].name),
              widget._choice[index] != 'pending'
                  ? ElevatedButton(
                      onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => FindProductId(
                            operandsName: operands[index].name,
                            company: widget.company,
                            role: widget._choice[index],
                            database: widget.database,
                          ),
                          ),
                      );},
                      child: Text(
                        'Emelőgépek',
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                    )
                  : Container(
                      width: 0,
                    ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: 'operator',
                        groupValue: widget._choice[index],
                        onChanged: (value) => assignRole(
                            uid: operands[index].uid,
                            company: widget.company,
                            role: value,
                            index: index),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: Text('gépkezelő'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: 'inspector',
                        groupValue: widget._choice[index],
                        onChanged: (value) => assignRole(
                            uid: operands[index].uid,
                            company: widget.company,
                            role: value,
                            index: index),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: Text('vizsgáló'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: 'service',
                        groupValue: widget._choice[index],
                        onChanged: (value) => assignRole(
                            uid: operands[index].uid,
                            company: widget.company,
                            role: value,
                            index: index),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: Text('szervíz'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        activeColor: Colors.red,
                        value: 'pending',
                        groupValue: widget._choice[index],
                        onChanged: (value) => assignRole(
                            uid: operands[index].uid,
                            company: widget.company,
                            role: value,
                            index: index),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: Text('függöben'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          subtitle: Text(
            'Képesítés: ${operands[index].certificates.map((e) => e['description']).toList()},',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Future<void> retrieveCompany(String uid, String company, int ind) async {
    try {
      await widget.database.retrieveCompany(uid, company).then((value) {
        if (value.role != '') if (mounted)
          setState(() {
            widget._choice[ind] = value.role;
          });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> assignRole(
      {String uid, String company, String role, int index}) async {
    try {
      await widget.database.assignRole(uid, company, role).then((value) {
        widget._choice[index] = role;
      });
    } catch (e) {
      print(e);
    }
  }
}
