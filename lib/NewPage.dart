import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewPage extends StatefulWidget {
  String link;
  NewPage({Key key, @required this.link}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState(link: link);
}

class _NewPageState extends State<NewPage> {
  String link;
  _NewPageState({this.link});
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(link),
      ),
      body: SafeArea(
        child: Container(
          child: WebView(
            initialUrl: link,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
