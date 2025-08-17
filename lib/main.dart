import 'package:flutter/material.dart';
import 'method_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MethodBuilder.data(
          route: "/home",
          map: ["Name", "Email", "Phone"],
          apiUrl: "https://api.example.com/data",
          icon: Icons.info,
          widthFactor: 0.8,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          boxDecoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          iconBuilder: (items) => Icon(Icons.star, color: Colors.amber)
        ),
      ),
    );
  }
}
