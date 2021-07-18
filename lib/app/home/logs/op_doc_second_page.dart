import 'package:etar_en/app/models/assignees_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({
    Key key,
    @required PageController controller,
    this.snapshot,
    this.database,
    this.productId,
    this.company,
  })
      : _controller = controller,
        super(key: key);

  final PageController _controller;
  final snapshot;
  final Database database;
  final String productId;
  final String company;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final List<Assignees> service = [];
  final List<Assignees> inspector = [];
  final List<Assignees> operator = [];
  final List<Assignees> admin = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Assignees>>(
      stream: widget.database.assigneesStream(widget.company, widget.productId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final assignees = snapshot.data;
          for (var assignee in assignees) {
            switch (assignee.role) {
              case 'inspector':
                {
                  inspector.add(assignee);
                }
                break;
              case 'operator':
                {
                  operator.add(assignee);
                }
                break;
              case 'service':
                {
                  service.add(assignee);
                }
                break;
              default:
                {
                  admin.add(assignee);
                }
                break;
            }
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Alábbi személyek jogosultak naplóbejegyzésre:',
                    style: Theme.of(context).textTheme.overline,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: Card(
                          color: Color(0xff0B0157),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Kezelők:',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: Card(
                          color: Colors.blue[200],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Karbantartók:',
                                style: TextStyle(
                                  color: Colors.brown[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                            itemCount: operator.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white70,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${operator[index].name}',
                                      style: TextStyle(
                                        color: Color(0xff0B0157),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                            itemCount: service.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.blueGrey[700],
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${service[index].name}',
                                      style: TextStyle(
                                        color: Colors.blue[100],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: Card(
                          color: Colors.orange[100],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Vizsgálók:',
                                style: TextStyle(
                                  color: Colors.green[900],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: Card(
                          color: Color(0xff02569b),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Adminok:',
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                            itemCount: inspector.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.teal[800],
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${inspector[index].name}',
                                      style: TextStyle(
                                        color: Colors.orange[100],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                            itemCount: admin.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${admin[index].name}',
                                      style: TextStyle(
                                        color: Color(0xff02569b),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
