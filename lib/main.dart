import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Index(),
    );
  }
}

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<Index> {
  bool isLoading = false;
  late WebViewController webViewController;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                webViewController = webViewController;
                await webViewController.loadUrl('https://vistacks.com/app');
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onWebResourceError: (err) async {
                setState(() {
                  isLoading = false;
                });
              },
              onPageFinished: (String url) async => setState(() {
                isLoading = false;
                log(url);
              }),
              onProgress: (int progress) {
                log('WebView is loading (progress : $progress%)');
              },
              debuggingEnabled: kDebugMode,
            ),
          ),
          if (isLoading)
            Center(
    child: Lottie.asset('assets/spinner.json')),
        ],
      ),
    );
  }
}
