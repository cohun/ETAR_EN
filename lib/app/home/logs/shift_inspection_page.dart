import 'package:etar_en/app/home/log_entries/log_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/log_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class ShiftInspection extends StatefulWidget {
  const ShiftInspection({
    Key key,
    @required PageController controller,
    this.snapshot,
    this.database,
    this.productId,
    this.company,
    this.name,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;
  final snapshot;
  final String name;
  final Database database;
  final String productId;
  final String company;

  @override
  _ShiftInspectionState createState() => _ShiftInspectionState();
}

class _ShiftInspectionState extends State<ShiftInspection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LogModel>>(
        stream: widget.database.logsStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final logs = snapshot.data;
            if (logs.isNotEmpty) {
              return SingleChildScrollView(
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
                            color: Colors.deepOrange[300],
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              widget._controller.jumpToPage(0);
                            },
                            child: Text(
                              'Fő adatok',
                              style: TextStyle(color: Colors.deepOrange[300]),
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
                      'Napló bejegyzések:',
                      style: Theme.of(context).textTheme.overline,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.yellowAccent,
                        ),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Center(
                                child: logs[index].state
                                    ? Text(
                                        'OK',
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : logs[index].repairName != ''
                                        ? Text(
                                            'Javítás elvégezve. OK',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        : Text(
                                            'Javításra vár',
                                            style: TextStyle(color: Colors.red),
                                          ),
                              ),
                              ListTile(
                                onTap: () => LogEntryPage.show(
                                  context: context,
                                  database: widget.database,
                                  company: widget.company,
                                  productId: widget.productId,
                                  name: widget.name,
                                  log: logs[index],
                                ),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'dátum: ${logs[index].date.toString().substring(0, 10)}'),
                                    Text('műszak: ${logs[index].shift}'),
                                    Text(
                                        'gépkezelő: ${logs[index].operatorName}'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    logs[index].repairName != ''
                                        ? Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                  'Javítás elvégezve: ${logs[index].repairDate.toString().substring(0, 10)}'),
                                            ),
                                          )
                                        : logs[index].state
                                            ? Card(
                                                child: Text(
                                                    'Használatra alkalmas'),
                                              )
                                            : Card(
                                                child: Text(
                                                    'Használat csak saját felelősségre'),
                                              ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(' bejegyző: ${logs[index].name}'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return EmptyContent();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => LogEntryPage.show(
            context: context,
            database: widget.database,
            company: widget.company,
            productId: widget.productId,
            name: widget.name),
      ),
    );
  }
}