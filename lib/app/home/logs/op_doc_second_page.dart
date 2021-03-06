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
        stream: widget.database.adminsStream(widget.company),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
          List<Assignees> admins = [];
          admins = snapshot.data;
          admins.removeWhere((element) =>
              element.role == 'hyper' ||
              element.role == 'hyperSuper' ||
              element.role == 'readOnly');

          return StreamBuilder<List<Assignees>>(
            stream: widget.database
                .assigneesStream(widget.company, widget.productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final assignees = snapshot.data..addAll(admins);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget._controller.jumpToPage(0);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.amber,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            widget._controller.jumpToPage(0);
                          },
                          child: Text(
                            'F?? adatok',
                            style: TextStyle(color: Colors.amber),
                          )),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Al??bbi szem??lyek jogosultak napl??bejegyz??sre:',
                          style: Theme.of(context)
                              .textTheme
                              .overline
                              .copyWith(color: Colors.lightBlueAccent),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 40,
                              child: Card(
                                color: Colors.green[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Kezel??k:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        child: Card(
                          color: Colors.blue[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Karbantart??k:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                            itemCount: operator.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // if you need this
                                  side: BorderSide(
                                    color: Colors.green[200],
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${operator[index].name}',
                                    style: TextStyle(
                                      color: Color(0xff0B0157),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                            itemCount: service.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // if you need this
                                  side: BorderSide(
                                    color: Colors.blue[200],
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${service[index].name}',
                                    style: TextStyle(
                                      color: Color(0xff0B0157),
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
                        height: 40,
                        child: Card(
                          color: Colors.orange[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Vizsg??l??k:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        child: Card(
                          color: Color(0xff02569b),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Adminok:',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
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
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                            itemCount: inspector.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // if you need this
                                  side: BorderSide(
                                    color: Colors.orange[100],
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${inspector[index].name}',
                                    style: TextStyle(
                                      color: Color(0xff0B0157),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                            itemCount: admin.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // if you need this
                                  side: BorderSide(
                                    color: Color(0xff02569b),
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${admin[index].name}',
                                    style: TextStyle(
                                      color: Color(0xff0B0157),
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
    return Center(
      child: CircularProgressIndicator(),
    );
    },
    );

  }
}
