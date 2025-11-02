import 'package:flutter/material.dart';
import 'package:example/method_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String apiUrl = 'http://localhost:3000';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Package Example')),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            MethodBuilder.data(
              apiUrl: apiUrl,
              route: 'recipes',
              widthFactor: 0.3,
              map: ["recipe_name","sugar"],
              widgetBuilder: (List<String> data) {
                return Container(
                  width: double.infinity,
                  height:50,
                  child: Text(
                    "${data[0]} _ ${data[1]}",
                    style: TextStyle(
                      color: Colors.blueGrey
                    ),
                  ),
                );
            },
            ),
          ],
        )
      ),
    );
  }
}