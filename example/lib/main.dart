import 'package:flutter/material.dart';
import 'package:future_widget_builder/main.dart';
import 'package:future_widget_builder/method_builder.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String apiUrl = 'https://xyz.endpoint/route';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Package Example')),
        body: CustomScrollView(
          slivers: [
            MethodBuilder.media(
              apiUrl: apiUrl,
              route: 'fetchCameras',
              icon: Icons.access_alarm_rounded,
              map: [],

            ),
          ],
        )
      ),
    );
  }
}