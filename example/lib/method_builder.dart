import 'dart:convert';

import 'package:example/methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum WidgetType { data, media, product, profile, event, summary }

class SnapImageView extends StatefulWidget {
  final List<String> imageUrls;

  const SnapImageView({super.key, required this.imageUrls});

  @override
  State<SnapImageView> createState() => _SnapImageView();
}

class _SnapImageView extends State<SnapImageView> {
  var page = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: PageController(viewportFraction: 1),
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        ),
      ],
    );
  }
}

class MethodBuilder extends StatefulWidget {
  /// [map] is a list of strings that are used when mapping json data from the http method
  /// [example]
  /// ["title","subtitle","description","preview"]
  /// can be used to map for
  /// [
  ///   {
  ///     "title" : "This is title",
  ///     "subtitle" : "This is subtitle",
  ///     "description" : "This is description",
  ///     "preview" : "https://imagenetworkurl/xyz.png"
  ///   },{...},{...}
  /// ]
  ///
  ///
  final List<String> map;

  /// token for header authentication with http method it uses [flutter_secure_storage]
  final String? token;

  /// [apiUrl] is string of the remote server endpoint route is excluded
  /// [route] is string of the method that you are calling
  final String route, apiUrl;

  final double? widthFactor;
  final EdgeInsets? padding, margin;
  final BoxDecoration? boxDecoration;
  final WidgetType? type;
  final double? borderRadius;

  Future<List<List<String>>>? method;

  /// [postBody] is json body that is to be added when using post method with response body
  Encoding? postBody;

  /// [mediaPreviewBuilder] is a method that acceps list of string mapped from json body using map property you can create your own image preview
  Image? Function(List<String> item)? mediaPreviewBuilder;

  /// [productPreviewBuilder] is a method that acceps list of string mapped from json body using map property you can create your own image preview list
  List<String>? Function(List<String> item)? productPreviewBuilder;

  IconData? icon;
  double? aspectRatio;

  /// the following parameter can be used to create dynamic widget from list of string mapped from json body of the future
  Widget Function(List<String> item)? widgetBuilder,
      productDescriptionBuilder,
      iconBuilder,
      timeBuilder,
      topRightLabel,
      bottomRightLabel,
      productSlideBuilder,
      topLeftLabel;

  /// [MethodBuilder.data] returns very basic descriptive widget uses Title, Subtitle, Description, Icon and many more
  MethodBuilder.data({
    super.key,
    required this.route,
    required this.map,
    required this.apiUrl,
    this.method,
    this.mediaPreviewBuilder,
    this.postBody,
    this.borderRadius,
    this.widgetBuilder,
    this.widthFactor,
    this.icon,
    this.token,
    this.boxDecoration,
    this.padding,
    this.margin,
    this.iconBuilder,
    this.type = WidgetType.data,
  });

  /// [MethodBuilder.media] returns media widget like youtube,ott videos and streams uses Title, Subtitle, Image, Description, Icon and many more
  MethodBuilder.media({
    super.key,
    required this.route,
    required this.map,
    required this.apiUrl,
    this.mediaPreviewBuilder,
    this.method,
    this.postBody,
    this.borderRadius,
    this.widthFactor,
    this.icon,
    this.token,
    this.widgetBuilder,
    this.boxDecoration,
    this.padding,
    this.margin,
    this.iconBuilder,
    this.aspectRatio,
    this.topRightLabel,
    this.bottomRightLabel,
    this.topLeftLabel,
    this.timeBuilder,
    this.type = WidgetType.media,
  });

  /// [MethodBuilder.product] returns product widget like amazon or paying gues rooms uses Title, Subtitle, Prices, Discounts, Icon and many more

  MethodBuilder.product({
    super.key,
    required this.route,
    required this.map,
    required this.apiUrl,
    required this.mediaPreviewBuilder,
    this.productDescriptionBuilder,
    this.productPreviewBuilder,
    this.method,
    this.postBody,
    this.widgetBuilder,
    this.token,
    this.widthFactor,
    this.padding,
    this.margin,
    this.boxDecoration,
    this.type = WidgetType.product,
    this.borderRadius,
  });

  @override
  State<MethodBuilder> createState() => _MethodBuilder();
}

class _MethodBuilder extends State<MethodBuilder> {
  bool visible = true;

  Future<List<List<String>>> getMethod() async {
    try {
      final response = await (widget.postBody == null
          ? http.get(
              Uri.parse('${widget.apiUrl}/${widget.route}'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${widget.token}',
              },
            )
          : http.post(
              Uri.parse('${widget.apiUrl}/${widget.route}'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${widget.token}',
              },
              body: widget.postBody,
            ));

      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        return (jsonDecode(response.body) as List)
            .map(
              (e) => List.generate(
                widget.map.length,
                (index) => e[widget.map[index]].toString(),
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
      future: widget.method ?? getMethod(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<dynamic> data = (snapshot.data as List?) ?? [];
          return SliverToBoxAdapter(
            child: FractionallySizedBox(
              widthFactor: widget.widthFactor ?? 1,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {

                  final item = data[index];

                  if (widget.widgetBuilder != null) {
                    return widget.widgetBuilder!(item);
                  }

                  switch (widget.type) {
                    case WidgetType.data:
                    case null:
                      return Container(
                        width: getWidth(context) / (widget.widthFactor ?? 1),
                        padding:
                            widget.padding ??
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        margin:
                            widget.margin ??
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration:
                            widget.boxDecoration ??
                            BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 15,
                              ),
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
                              spacing: 10,
                              mainAxisAlignment: item.length==1 ? MainAxisAlignment.center : MainAxisAlignment.start,
                              children: [
                                widget.iconBuilder?.call(item) ?? const SizedBox.shrink(),
                                Text(
                                  (item.isNotEmpty ? (item[0] ?? "Title") : "Title"),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            if (item.length > 1 && (item[1]?.isNotEmpty ?? false))
                              Text(
                                item[1]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: item.length > 2 && (item[2]?.isNotEmpty ?? false)
                                      ? Text(
                                    item[2]!,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                  )
                                      : const SizedBox.shrink(),
                                ),
                                if (item.length > 3 && (item[3]?.isNotEmpty ?? false))
                                  Text(item[3]!),
                              ],
                            ),

                          ],
                        ),
                      );

                    case WidgetType.media:
                      return Container(
                        width: getWidth(context) / (widget.widthFactor ?? 1),
                        padding: widget.padding ?? EdgeInsets.all(14),
                        margin:
                            widget.margin ??
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration:
                            widget.boxDecoration ??
                            BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 15,
                              ),
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
                          spacing: 3,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: widget.aspectRatio ?? (2 / 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 15,
                                ),
                                child: Stack(
                                  children: [
                                    widget.mediaPreviewBuilder?.call(item) ??
                                        Image.network(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTc9APxkj0xClmrU3PpMZglHQkx446nQPG6lA&s",
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          widget.bottomRightLabel?.call(item) ??
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              item.length > 4
                                                  ? item[4]
                                                  : "02:20",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child:
                                          widget.topRightLabel?.call(item) ??
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              "LIVE",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child:
                                          widget.topLeftLabel?.call(item) ??
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Icon(
                                              Icons.access_time_filled_outlined,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              item.isNotEmpty ? item[0] : "Title",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                fontFamily: 'noto',
                              ),
                            ),
                            Text(
                              item.length > 1 ? item[1] : "Channel Name",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontFamily: 'noto',
                              ),
                            ),
                            // Expanded(
                            //   child:
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.length > 2 ? item[2] : "Views",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontFamily: 'noto',
                                  ),
                                ),
                                widget.timeBuilder?.call(item) ??
                                    Text(
                                      item.length > 3 ? item[3] : "3 hours ago",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontFamily: 'noto',
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      );

                    case WidgetType.product:
                      return Container(
                        width: getWidth(context) / (widget.widthFactor ?? 1),
                        padding: widget.padding ?? EdgeInsets.all(14),
                        margin:
                            widget.margin ??
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration:
                            widget.boxDecoration ??
                            BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 15,
                              ),
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
                          spacing: 3,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: widget.aspectRatio ?? (3 / 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 15,
                                ),
                                child: Stack(
                                  children: [
                                    widget.mediaPreviewBuilder?.call(item) ??
                                        SnapImageView(
                                          imageUrls:
                                              widget.productPreviewBuilder
                                                  ?.call(item) ??
                                              [
                                                "https://m.media-amazon.com/images/I/61Lc-Qp7A9L._SX466_.jpg",
                                                "https://m.media-amazon.com/images/I/51MZOY88uNL._SL1000_.jpg",
                                                "https://m.media-amazon.com/images/I/613wpJbBznL._SL1000_.jpg",
                                              ],
                                        ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          widget.bottomRightLabel?.call(item) ??
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                for (int i = 0; i < 4; i++)
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),

                                                Text(
                                                  item.length > 4
                                                      ? item[4]
                                                      : "(40)",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child:
                                          widget.topRightLabel?.call(item) ??
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              "Limited Offer",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child:
                                          widget.topLeftLabel?.call(item) ??
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Icon(
                                              Icons.access_time_filled_outlined,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widget.productDescriptionBuilder?.call(item) ??
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.isNotEmpty ? item[0] : "PROCUS",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        fontFamily: 'noto',
                                      ),
                                    ),
                                    Text(
                                      item.length > 1
                                          ? item[1]
                                          : "Irusu Play VR Ultra 3D VR Headset-Virtual Reality Headset with HD Lens,Controller,Stereo Headphones 3.5mm Jack to Type C ",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontFamily: 'noto',
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        Text(
                                          item.length > 2 ? item[2] : "-43%",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.red.shade600,
                                            fontFamily: 'noto',
                                          ),
                                        ),
                                        Text(
                                          item.length > 3
                                              ? item[3]
                                              : "Rs 4,080",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black,
                                            fontFamily: 'noto',
                                          ),
                                        ),
                                        Text(
                                          item.length > 3
                                              ? item[3]
                                              : "₹4,999.00",
                                          style: TextStyle(
                                            fontSize: 22,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.black54,
                                            fontFamily: 'noto',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      );
                    case WidgetType.profile:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case WidgetType.event:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case WidgetType.summary:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                  }
                },
              ),
            ),
          );
        }
        return SliverToBoxAdapter(child: CircularProgressIndicator());
      },
    );
  }
}
