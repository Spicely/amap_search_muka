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

  /// 设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  static void setApiKey(String androidKey, String iosKey) {
    _channel.invokeMethod('setApiKey', {'android': androidKey, 'ios': iosKey});
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await _channel.invokeMethod('updatePrivacyShow', {
      'hasContains': hasContains,
      'hasShow': hasShow,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await _channel.invokeMethod('updatePrivacyAgree', {
      'hasAgree': hasAgree,
    });
  }

  /// 关键字搜索poi
  ///
  /// [keyword] 关键字
  ///
  /// [types] 类型，多个类型用“|”分割 可选值:文本分类、分类代码
  ///
  /// [city] 城市名称
  ///
  /// [pageSize] 每页记录数, 范围1-25, [default = 20]
  ///
  /// [page] 当前页数, 范围1-100, [default = 1]
  ///
  /// [cityLimit] 强制城市限制功能 [default = false]，例如：在上海搜索天安门，如果citylimit为true，将不返回北京的天安门相关的POI
  static Future<List<AMapPoi>> searchKeyword(
    String keyword, {
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    bool cityLimit = false,
  }) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    final List? dataList = await _channel.invokeMethod('searchKeyword', {
      'keyword': keyword,
      'city': city,
      'types': types,
      'pageSize': pageSize,
      'page': page,
      'cityLimit': cityLimit,
    });

    return dataList?.map((e) => AMapPoi.fromJson(e)).toList() ?? [];
  }

  /// 周边搜索poi
  ///
  /// [center] 中心点
  ///
  /// [keyword] 查询关键字，多个关键字用“|”分割
  ///
  /// [radius] 查询半径，范围：0-50000，单位：米 [default = 1500]
  ///
  /// [types] 类型，多个类型用“|”分割 可选值:文本分类、分类代码
  ///
  /// [city] 城市名称
  ///
  /// [pageSize] 每页记录数, 范围1-25, [default = 20]
  ///
  /// [page] 当前页数, 范围1-100, [default = 1]
  static Future<List<AMapPoi>> searchAround(
    LatLng center, {
    String keyword = '',
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    int radius = 1500,
  }) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    assert(radius >= 0 && radius <= 50000, 'radius must be between 0 and 50000');
    final List? dataList = await _channel.invokeMethod('searchAround', {
      'keyword': keyword,
      'city': city,
      'types': types,
      'pageSize': pageSize,
      'page': page,
      'longitude': center.longitude,
      'latitude': center.latitude,
      'radius': radius,
    });
    return dataList?.map((e) => AMapPoi.fromJson(e)).toList() ?? [];
  }

  /// 输入内容自动提示
  ///
  /// [keyword] 关键字
  ///
  /// [city] 城市名称
  ///
  /// [latLng] 如果设置，在此location附近优先返回搜索关键词信息
  ///
  /// [cityLimit] 强制城市限制功能 [default = false]，例如：在上海搜索天安门，如果citylimit为true，将不返回北京的天安门相关的POI
  static Future<List> fetchInputTips(
    String keyword, {
    String city = '',
    LatLng? latLng,
    bool cityLimit = false,
  }) async {
    final List? dataList = await _channel.invokeMethod('fetchInputTips', {
      'keyword': keyword,
      'city': city,
      'latitude': latLng?.latitude,
      'longitude': latLng?.longitude,
      'cityLimit': cityLimit,
    });
    return dataList?.map((e) => AMapTip.fromJson(e)).toList() ?? [];
  }

  // /// 地理编码（地址转坐标）
  // ///
  // /// 输入关键字[keyword], 并且限制所在城市[city]
  // static Future<List> searchGeocode(
  //   String keyword, {
  //   String city = '',
  // }) async {
  //   final String? version = await _channel.invokeMethod('searchGeocode');
  //   return [];
  // }
}
