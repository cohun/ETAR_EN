import 'package:etar_en/app/models/assignees_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class Classification extends StatefulWidget {
  const Classification({
    Key key,
    @required PageController controller,
    this.snapshot,
    this.database,
    this.productId,
    this.company,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;
  final snapshot;
  final Database database;
  final String productId;
  final String company;

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  final List<Assignees> service = [];
  final List<Assignees> inspector = [];
  final List<Assignees> operator = [];
  final List<Assignees> admin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Assignees>>(
        stream:
            widget.database.assigneesStream(widget.company, widget.productId),
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
                              'Fő adatok',
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
                      'Vizsgálati csoportszám és vizsgálatok időköze:',
                      style: Theme.of(context).textTheme.overline,
                    ),
                    SizedBox(
                      height: 24,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
