@JS()
library search_amap;

import 'package:js/js.dart';

@JS('AMap.GeometryUtil.ringArea')
external double ringArea(List<dynamic> area);

@JS('AMap.GeometryUtil.distanceOfLine')
external dynamic distanceOfLine(List<dynamic> area);
