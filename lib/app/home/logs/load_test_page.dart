import 'package:etar_en/app/home/log_entries/load_test_entry_page.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/models/load_test_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class LoadTest extends StatefulWidget {
  const LoadTest({
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
  _LoadTestState createState() => _LoadTestState();
}

class _LoadTestState extends State<LoadTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LoadTestModel>>(
        stream:
            widget.database.loadTestStream(widget.company, widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final loadTests = snapshot.data;
            if (loadTests.isNotEmpty) {
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
                      'Terhelési próba:',
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
                        itemCount: loadTests.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () => LoadTestEntryPage.show(
                                  context: context,
                                  database: widget.database,
                                  company: widget.company,
                                  productId: widget.productId,
                                  name: widget.name,
                                  loadTest: loadTests[index],
                                ),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'jegyzőkönyv száma: ${loadTests[index].cerId}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'jellege: ${loadTests[index].kind}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'dátuma: ${loadTests[index].cerDate.toString().substring(0, 10)}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      'aláírója: ${loadTests[index].cerName}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'próbateher súlya:',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          '${loadTests[index].load}',
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
                                      ' bejegyző: ${loadTests[index].name}',
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                    Text(
                                      ' kelt: ${loadTests[index].date.toString().substring(0, 10)}',
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
        onPressed: () => LoadTestEntryPage.show(
            context: context,
            database: widget.database,
            company: widget.company,
            productId: widget.productId,
            name: widget.name),
      ),
    );
  }
}
