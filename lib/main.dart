import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await Permission.storage.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController controller;
  @override
  void initState(){
    super.initState();
  }

  void _incrementCounter() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: InAppWebView(
          initialUrlRequest: URLRequest.fromMap({"url":"http://192.168.1.107:4200"}),
         //   initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useOnDownloadStart: true,
                  allowFileAccessFromFileURLs : true,
                allowUniversalAccessFromFileURLs: true,

              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              this.controller = controller;
            //  this.controller.javaScriptHandlersMap

            },
            onLoadStart: (InAppWebViewController controller, Uri? url) {

            },
            onLoadStop: (InAppWebViewController controller, Uri? url) {

            },
            onDownloadStartRequest: (controller, request) async {
            final Directory directory = await getExternalStorageDirectory() as Directory;
            final File fileToSave = File('${directory.path}/${request.suggestedFilename as String}');
            final File pickedFile = File(request.url.path);
            await fileToSave.writeAsBytes(pickedFile.readAsBytesSync());

            }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
