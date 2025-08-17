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


## Preview


![Preview 1](https://raw.githubusercontent.com/ptsdpatient/flutter_widget_builder/main/preview/data.png)

Basic data representation using future (Title, Subtitle, Icon, Description and Time)

![Preview 2](https://raw.githubusercontent.com/ptsdpatient/flutter_widget_builder/main/preview/product.gif)

Showing product like widgets that are highly customizable and show (Product media, Product Labels, Manufacturing Brand, Model, Title, Rating and Time)

![Preview 3](https://raw.githubusercontent.com/ptsdpatient/flutter_widget_builder/main/preview/media.png)

Showing youtube like widgets that are highly customizable and show (Media Image, Media Labels, Title, Channel Name, Views analytics and Time)
