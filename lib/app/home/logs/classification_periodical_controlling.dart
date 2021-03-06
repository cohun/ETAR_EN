import 'package:etar_en/app/home/log_entries/classification_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/classification_model.dart';
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
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ClassificationModel>>(
        stream: widget.database
            .classificationStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final classifications = snapshot.data;
            if (classifications.isNotEmpty) {
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
                      'Vizsg??lati csoportsz??m ??s vizsg??latok id??k??ze:',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.lightBlueAccent),
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
                        itemCount: classifications.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () =>
                                ClassificationEntryPage.show(
                                  context: context,
                                  database: widget.database,
                                  company: widget.company,
                                  productId: widget.productId,
                                  name: widget.name,
                                  classification: classifications[index],
                                ),
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('jkv: ${classifications[index].cerId}'),
                                Text(
                                    'd??tuma: ${classifications[index].cerDate
                                        .toString().substring(0, 10)}'),
                                Text(
                                    'al????r??ja: ${classifications[index]
                                        .cerName}'),
                              ],
                            ),
                            title: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                          '??zemi csoportsz??m: ${classifications[index]
                                              .classNr}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                          'f??vizsg??latok: ${classifications[index]
                                              .periodThoroughEx}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                          'szerkezeti vizsg??latok: ${classifications[index]
                                              .periodInspection}'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    ' bejegyz??: ${classifications[index]
                                        .name}'),
                                Text(
                                    ' kelt: ${classifications[index].date
                                        .toString().substring(0, 10)}'),
                              ],
                            ),
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
        onPressed: () => ClassificationEntryPage.show(
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
