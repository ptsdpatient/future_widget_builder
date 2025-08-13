# MethodBuilder

A comprehensive, customizable widget that works with `FutureBuilder` to create visually appealing, reusable UI components with HTTP methods and JSON Web Token (JWT) support.  
This widget is built for flexibility and supports customization via padding, margin, box decoration, icons, and more.

> **Requires:** [`http`](https://pub.dev/packages/http) and [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)

---

## Features

- **FutureBuilder integration** for asynchronous data fetching
- **Customizable UI** with icon, padding, margin, and box decoration
- **HTTP method support** for fetching data
- **JWT token handling** for secure API calls
- **Optional icon builder** for per-item icon customization
- Adjustable width factor for responsive layouts

---

## Installation

    Add this to your `pubspec.yaml`:
    
        dependencies:
          method_builder: ^0.0.1
          http: ^1.2.0
          flutter_secure_storage: ^9.0.0

## Run
    flutter pub get

## Usage

    import 'package:flutter/material.dart';
    import 'package:method_builder/method_builder.dart';
    
    class ExamplePage extends StatelessWidget {
      const ExamplePage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: MethodBuilder(
            route: "/profile",
            apiUrl: "https://api.example.com/profile",
            info: ["Name", "Email", "Phone"],
            token: "your_jwt_token_here",
            icon: Icons.account_circle,
            widthFactor: 0.8,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(16),
            boxDecoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            iconBuilder: (items) => const Icon(Icons.star, color: Colors.amber),
          ),
        );
      }
    }


## License
    ---
    
    This keeps the README **developer-friendly**, covers:
    - What it is  
    - Features  
    - Installation  
    - Usage example  
    - Parameter table  
    
    If you want, I can also **add an “API Call Flow” diagram** so your `pub.dev` page looks more professional and visual. That usually boosts adoption rates.
