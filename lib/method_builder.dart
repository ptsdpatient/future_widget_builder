import 'dart:convert';

import 'package:future_widget_builder/methods.dart';
import 'package:future_widget_builder/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MethodBuilder extends StatefulWidget {
  final List<String> info;
  final IconData? icon;
  final String? token;
  final String route, apiUrl;
  final num? widthFactor;
  final EdgeInsets? padding, margin;
  final BoxDecoration? boxDecoration;
  final Widget Function(List<String> item)? iconBuilder;

  const MethodBuilder({
    super.key,
    required this.route,
    required this.info,
    required this.apiUrl,
    this.widthFactor,
    this.icon,
    this.token,
    this.boxDecoration,
    this.padding,
    this.margin,
    this.iconBuilder,
  });

  @override
  State<MethodBuilder> createState() => _MethodBuilder();
}

class _MethodBuilder extends State<MethodBuilder> {
  bool visible = true;

  Future<List<List<String>>> getMethod() async {
    // print('${widget.apiUrl}/${widget.route}');

    try {
      final response = await http.get(
        Uri.parse('${widget.apiUrl}/${widget.route}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        return (jsonDecode(response.body) as List)
            .map(
              (e) => List.generate(
                widget.info.length,
                (index) => e[widget.info[index]].toString(),
              ),
            )
            .toList();
      } else {
        print(
          'Problem loading content : ${response.statusCode} - ${response.body}',
        );
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMethod(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data ?? [];
          return SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                return Container(
                  width: getWidth(context) / (widget.widthFactor ?? 1),
                  padding: widget.padding ?? EdgeInsets.all(10),
                  margin:
                      widget.margin ??
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration:
                      widget.boxDecoration ??
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                  child: Column(
                    spacing: 8,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              widget.iconBuilder?.call(item) ??
                                  Icon(widget.icon),
                              Text(
                                item[0] ?? "Title",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item[1] ?? "Side Info",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.length > 2 ? item[2] : "Subtitle",
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),

                          item.length > 3 ? Text(item[3]) : Icon(null),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SliverToBoxAdapter(child: CircularProgressIndicator());
      },
    );
  }
}
