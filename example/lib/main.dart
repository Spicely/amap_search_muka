import 'package:amap_search_muka/amap_search_muka.dart';
import 'package:flutter/material.dart';
import 'package:amap_core/amap_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text('坐标转换'),
              onPressed: () async {
                LatLng pos = await AmapSearch.convert(LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
                print(pos.toJson());
              },
            ),
            ElevatedButton(
              child: Text('面积'),
              onPressed: () async {
                double area = await AmapSearch.calculateArea(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
                print(area);
              },
            ),
            ElevatedButton(
              child: Text('直线距离'),
              onPressed: () async {
                double distance = await AmapSearch.calculateLineDistance(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
                print(distance);
              },
            ),
            ElevatedButton(
              child: Text('获取POI'),
              onPressed: () async {
                print('获取POI');
                PoiSearchResult poi = await AmapSearch.poiKeywordsSearch('饭店', city: '成都');
                poi.pois.forEach((element) {
                  print(element.toJson());
                });
              },
            ),
            ElevatedButton(
              child: Text('获取输入提示'),
              onPressed: () async {
                print('获取输入提示');
                List<InputTip> pois = await AmapSearch.inputTipsSearch('火车');
                pois.forEach((element) {
                  print(element.toJson());
                });
              },
            ),
            ElevatedButton(
              child: Text('逆地理编码'),
              onPressed: () async {
                ReGeocode reGeocode = await AmapSearch.reGeocodeSearch(LatLng(30.766903, 103.955872));
                print(reGeocode.toJson());
              },
            ),
          ],
        )),
      ),
    );
  }
}
