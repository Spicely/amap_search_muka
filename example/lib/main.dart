import 'package:amap_search_muka/amap_search_muka.dart';
import 'package:flutter/material.dart';

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
    AmapSearch.updatePrivacyShow(true, true);
    AmapSearch.updatePrivacyAgree(true);
    AmapSearch.setApiKey('6e630e675873f2a548f55ba99ee8c571', '56250708b9588800db63161534716f8c');

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
            // ElevatedButton(
            //   child: Text('坐标转换'),
            //   onPressed: () async {
            //     LatLng pos = await AmapSearch.convert(LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
            //     print(pos.toJson());
            //   },
            // ),
            // ElevatedButton(
            //   child: Text('面积'),
            //   onPressed: () async {
            //     double area = await AmapSearch.calculateArea([
            //       LatLng(39.932670, 116.169465),
            //       LatLng(39.924492, 116.160260),
            //       LatLng(39.710019, 116.150625),
            //       LatLng(39.709920, 116.183198),
            //       LatLng(39.777616, 116.226950),
            //       LatLng(40.052578, 116.468800),
            //     ]);
            //     print(area);
            //   },
            // ),
            // ElevatedButton(
            //   child: Text('直线距离'),
            //   onPressed: () async {
            //     double distance = await AmapSearch.calculateLineDistance([LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418)]);
            //     print(distance);
            //   },
            // ),
            ElevatedButton(
              child: Text('获取POI'),
              onPressed: () async {
                print('获取POI');
                List<AMapPoi> poi = await AmapSearch.searchKeyword('广场', city: '成都', page: 1, pageSize: 1);
                print(poi.length);
                poi.forEach((element) {
                  print(element.toJson());
                });
              },
            ),
            ElevatedButton(
              child: Text('附近POI'),
              onPressed: () async {
                print('获取POI');
                List<AMapPoi> poi = await AmapSearch.searchAround(LatLng(30.68025, 104.080081), types: '火车站', radius: 10000);
                poi.forEach((element) {
                  print(element.toJson());
                });
              },
            ),
            ElevatedButton(
              child: Text('获取输入提示'),
              onPressed: () async {
                print('获取输入提示');
                List<dynamic> pois = await AmapSearch.fetchInputTips('火车');
                pois.forEach((element) {
                  print(element.toJson());
                });
              },
            ),
            // ElevatedButton(
            //   child: Text('逆地理编码'),
            //   onPressed: () async {
            //     ReGeocode reGeocode = await AmapSearch.reGeocodeSearch(LatLng(30.766903, 103.955872));
            //     print(reGeocode.toJson());
            //   },
            // ),
          ],
        )),
      ),
    );
  }
}
