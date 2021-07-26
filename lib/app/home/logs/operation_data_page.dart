import 'package:etar_en/app/home/log_entries/operation_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/operation_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class Operation extends StatefulWidget {
  const Operation({
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
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OperationModel>>(
        stream: widget.database
            .operationStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final operations = snapshot.data;
            if (operations.isNotEmpty) {
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
                      'Üzemeltetésre vonatkozó adatok:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .overline,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            Divider(
                              color: Colors.yellowAccent,
                            ),
                        itemCount: operations.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Center(
                                child: operations[index].state
                                    ? Text('üzembehelyezve',
                                  style: TextStyle(color: Colors.green),)
                                    : Text('üzemeltetés leállítva',
                                  style: TextStyle(color: Colors.red),),
                              ),
                              ListTile(
                                onTap: () =>
                                    OperationEntryPage.show(
                                      context: context,
                                      database: widget.database,
                                      company: widget.company,
                                      productId: widget.productId,
                                      name: widget.name,
                                      operation: operations[index],
                                    ),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('jegyzőkönyv száma: ${operations[index]
                                        .cerId}'),
                                    Text(
                                        'dátuma: ${operations[index].cerDate
                                            .toString().substring(0, 10)}'),
                                    Text(
                                        'aláírója: ${operations[index]
                                            .cerName}'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    operations[index].state ?
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                            '${operations[index].startDate
                                                .toString().substring(0, 10)}'),
                                      ),
                                    ) :
                                    Card(
                                      child: Text(
                                          '${operations[index].startDate
                                              .toString().substring(0, 10)}'),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        ' bejegyző: ${operations[index].name}'),
                                    Text(
                                        ' kelt: ${operations[index].date
                                            .toString().substring(0, 10)}'),
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
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () => OperationEntryPage.show(
            context: context,
            database: widget.database,
            company: widget.company,
            productId: widget.productId,
            name: widget.name
        ),
      ),
    );
  }
}
