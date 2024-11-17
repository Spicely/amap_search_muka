import 'package:flutter/material.dart';
import 'dart:async';

import 'package:amap_search_muka/amap_search_muka.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AMapSearch.setApiKey("d0c22c82dcc475502cd816ed5e68ce9b", "56250708b9588800db63161534716f8c");
  await AMapSearch.updatePrivacyAgree(true);
  await AMapSearch.updatePrivacyShow(true, true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              List<AMapPoi> pois = await AMapSearch.searchKeyword('广场', city: '成都', page: 1, pageSize: 10);
              print(pois);
            },
            child: const Text('样式设置'),
          ),
        ),
      ),
    );
  }
}
