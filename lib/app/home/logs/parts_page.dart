import 'package:etar_en/app/home/log_entries/operation_entry_page.dart';
import 'package:etar_en/app/home/log_entries/part_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/parts_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class PartsPage extends StatefulWidget {
  const PartsPage({
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
  _PartsPageState createState() => _PartsPageState();
}

class _PartsPageState extends State<PartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<PartsModel>>(
        stream: widget.database.partsStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final parts = snapshot.data;
            if (parts.isNotEmpty) {
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
                      'Cserélt fő darabok:',
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
                        itemCount: parts.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () =>
                                PartEntryPage.show(
                                  context: context,
                                  database: widget.database,
                                  company: widget.company,
                                  productId: widget.productId,
                                  name: widget.name,
                                  part: parts[index],
                                ),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'csere kelte: ${parts[index].date.toString().substring(0, 10)}'),
                                    Text(
                                        'cserét végző: ${parts[index].serviceName}'),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      child: Text(
                                          'Azonosító: ${parts[index].partId}'),
                                    ),
                                    Card(
                                      child: Text(
                                          'Megnevezés: ${parts[index].partName}'),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(' bejegyző: ${parts[index].name}'),
                                    Text(
                                        ' kelt: ${parts[index].id.toString().substring(0, 10)}'),
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
        onPressed: () => PartEntryPage.show(
            context: context,
            database: widget.database,
            company: widget.company,
            productId: widget.productId,
            name: widget.name),
      ),
    );
  }
}
