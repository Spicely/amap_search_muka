part of amap_search_muka;

enum ConvertType {
  /// GPS
  GPS,

  /// 百度
  BAIDU,

  /// Google
  GOOGLE,
}

class AmapSearch {
  static const MethodChannel _channel = const MethodChannel('plugins.muka.com/amap_search');

  /// POI 关键字查询
  ///
  /// keyword [查询关键字，多个关键字用“|”分割]
  ///
  /// city [不强制传递 一般来说不传拿不到数据]
  ///
  /// location [如果设置，在此location附近优先返回搜索关键词信息]
  ///
  /// 请求多次只返回一次 所以尽量请求时给个loading
  ///
  /// pageSize 每页返回的个数
  ///
  /// pageNum 第几页
  static Future<PoiSearchResult> poiKeywordsSearch(
    String keywords, {
    String? city,
    LatLng? location,
    int? pageSize,
    int? pageNum,
  }) async {
    dynamic json = await _channel.invokeMethod('poiKeywordsSearch', {
      'keywords': keywords,
      'city': city,
      'latitude': location?.latitude,
      'longitude': location?.longitude,
      'pageSize': pageSize,
      'pageNum': pageNum,
    });
    return PoiSearchResult.fromJson(json);
  }

  /// POI 周边查询
  ///
  /// location 位置
  ///
  /// 请求多次只返回一次 所以尽量请求时给个loading
  ///
  /// pageSize 每页返回的个数
  ///
  /// pageNum 第几页
  ///
  /// range 半径范围
  static Future<PoiSearchResult> poiPeripherySearch(
    LatLng location, {
    int range = 1000,
    int? pageSize,
    int? pageNum,
  }) async {
    dynamic json = await _channel.invokeMethod('poiPeripherySearch', {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'pageSize': pageSize,
      'pageNum': pageNum,
      'range': range,
    });
    return PoiSearchResult.fromJson(json);
  }

  /// 输入提示查询
  ///
  /// keyword [查询关键字]
  ///
  /// city [不强制传递 一般来说不传拿不到数据]
  ///
  /// location [如果设置，在此location附近优先返回搜索关键词信息]
  ///
  /// 请求多次只返回一次 所以尽量请求时给个loading
  static Future<List<InputTip>> inputTipsSearch(
    String keywords, {
    String? city,
    LatLng? location,
  }) async {
    dynamic inputTips = await _channel.invokeMethod('inputTipsSearch', {
      'keywords': keywords,
      'city': city,
      'location': location != null ? '${location.longitude},${location.latitude}' : null,
    });
    return List<InputTip>.from(inputTips.map((i) => InputTip.fromJson(Map<String, dynamic>.from(i))));
  }

  /// 逆地理编码
  ///
  /// 请求多次只返回一次 所以尽量请求时给个loading
  static Future<ReGeocode> reGeocodeSearch(LatLng latLng, {double? range}) async {
    dynamic reGeocode = await _channel.invokeMethod('reGeocodeSearch', {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
      'range': range ?? 200.0,
    });
    return ReGeocode.fromJson(Map<String, dynamic>.from(reGeocode));
  }

  /// 地址转换
  ///
  /// 仅[Android]可用
  static Future<LatLng> convert(LatLng latLng, {ConvertType type = ConvertType.GPS}) async {
    dynamic data = await _channel.invokeMethod('convert', {
      'latlng': latLng.toJson(),
      'type': type.index,
    });
    return LatLng.fromJson(Map<String, dynamic>.from(data));
  }

  /// 直线距离计算
  static Future<double> calculateLineDistance(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('calculateLineDistance', {
      "start": start.toJson(),
      "end": end.toJson(),
    });
  }

  /// 面积计算
  static Future<double> calculateArea(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('calculateArea', {
      "start": start.toJson(),
      "end": end.toJson(),
    });
  }
}
