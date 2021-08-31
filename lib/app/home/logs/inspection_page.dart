import 'package:etar_en/app/home/log_entries/inspection_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/inspection_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class Inspection extends StatefulWidget {
  const Inspection({
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
  _InspectionState createState() => _InspectionState();
}

class _InspectionState extends State<Inspection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<InspectionModel>>(
        stream:
            widget.database.inspectionStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final inspections = snapshot.data;
            if (inspections.isNotEmpty) {
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
                      'Időszakos vizsgálatok:',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.lightBlueAccent),
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
                        itemCount: inspections.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () => InspectionEntryPage.show(
                                  context: context,
                                  database: widget.database,
                                  company: widget.company,
                                  productId: widget.productId,
                                  name: widget.name,
                                  inspection: inspections[index],
                                ),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'jegyzőkönyv száma: ${inspections[index].cerId}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'vizsglat fajtája: ${inspections[index].kind}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'dátuma: ${inspections[index].cerDate.toString().substring(0, 10)}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'aláírója: ${inspections[index].cerName}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jkv. megállapítása:',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          '${inspections[index].statement}',
                                          style: TextStyle(
                                              color: Colors.orange[300]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' bejegyző: ${inspections[index].name}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      ' kelt: ${inspections[index].date.toString().substring(0, 10)}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => InspectionEntryPage.show(
            context: context,
            database: widget.database,
            company: widget.company,
            productId: widget.productId,
            name: widget.name),
      ),
    );
  }
}
