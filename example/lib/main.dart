import 'package:flutter/material.dart';
import 'package:example/future_widget_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Package Example')),
        body: FutureWidgetBuilder.data(
          fetchType: FetchType.sqlite3,
          databaseName: 'assets/output.db',
          tableName: 'polling_table',
          map: ["District", "Assembly"],
          direction: Axis.horizontal,
          widgetBuilder: (List<String> data) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                "${data[0]} _ ${data[1]}",
                style: TextStyle(color: Colors.white,fontSize: 25),
              ),
            );
          },
        ),
      ),
    );
  }
}
