import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key, this.company, this.database}) : super(key: key);

  final String company;
  final Database database;

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<String> _choice = List.filled(50, 'pending', growable: true);

  @override
  Widget build(BuildContext context) {
    print(widget.company);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogosultságok'),
      ),
      body: StreamBuilder<List<Operand>>(
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
      ),
    );
  }

  Widget _buildListView(List<Operand> operands, BuildContext context) {
    return ListView.separated(
      itemCount: operands.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        thickness: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(operands[index].name),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: 'operator',
                        groupValue: _choice[index],
                        onChanged: (value) => setState(() {
                          _choice[index] = value;
                        }),
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
                        groupValue: _choice[index],
                        onChanged: (value) => setState(() {
                          _choice[index] = value;
                        }),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          width: 100,
                          child: Text('ellenőr'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                        value: 'service',
                        groupValue: _choice[index],
                        onChanged: (value) => setState(() {
                          _choice[index] = value;
                        }),
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
                        value: 'pending',
                        groupValue: _choice[index],
                        onChanged: (value) => setState(() {
                          _choice[index] = value;
                        }),
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
}
