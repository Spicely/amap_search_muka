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

  /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
  /// [hasContains] 隐私声明中是否包含高德隐私政策说明<br>
  /// [hasShow] 隐私权政策是否弹窗展示告知用户<br>
  static void updatePrivacyShow(bool hasContains, bool hasShow) {
    _channel.invokeMethod('updatePrivacyStatement', {'hasContains': hasContains, 'hasShow': hasShow});
  }

  /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// [hasAgree] 隐私权政策是否已经取得用户同意<br>
  static void updatePrivacyAgree(bool hasAgree) {
    _channel.invokeMethod('updatePrivacyStatement', {'hasAgree': hasAgree});
  }

  /// 关键字搜索poi
  ///
  /// 在城市[city]搜索关键字[keyword]的poi, 可以设置每页数量[pageSize](1-50)和第[page](1-100)页
  static Future<List<AMapPoi>> searchKeyword(
    String keyword, {
    String city = '',
    int pageSize = 20,
    int page = 1,
  }) async {
    assert(page > 0 && page < 100, '页数范围为1-100');
    assert(pageSize > 0 && pageSize < 50, '每页大小范围为1-50');
    final List? dataList =
        await _channel.invokeMethod('searchKeyword', {'keyword': keyword, 'city': city, 'pageSize': pageSize, 'page': page});

    return dataList?.map((e) {
          return AMapPoi.fromJson(e);
        }).toList() ??
        [];
  }

  /// 依据坐标查询
  ///
  /// 可以设置每页数量[pageSize](1-50)和第[page](1-100)页
  static Future<List<AMapPoi>> searchLatLng(
    LatLng latLng, {
    String city = '',
    int pageSize = 20,
    int page = 1,
    int range = 2000,
  }) async {
    assert(page > 0 && page < 100, '页数范围为1-100');
    assert(pageSize > 0 && pageSize < 50, '每页大小范围为1-50');
    final List? dataList = await _channel.invokeMethod('searchLatLng', {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
      'city': city,
      'pageSize': pageSize,
      'page': page,
      'range': range,
    });

    return dataList?.map((e) {
          return AMapPoi.fromJson(e);
        }).toList() ??
        [];
  }

  /// 周边搜索poi
  ///
  /// 在中心点[center]周边搜索关键字[keyword]和城市[city]的poi, 可以设置每页数量[pageSize](1-50)和第[page](1-100)页
  static Future<List<AMapPoi>> searchAround(
    Location center, {
    String keyword = '',
    String city = '',
    int pageSize = 20,
    int page = 1,
    int radius = 1000,
  }) async {
    assert(page > 0 && page < 100, '页数范围为1-100');
    assert(pageSize > 0 && pageSize < 50, '每页大小范围为1-50');

    final List? dataList = await _channel.invokeMethod('searchAround',
        {'keyword': keyword, 'city': city, 'pageSize': pageSize, 'page': page, 'longitude': center.longitude, 'latitude': center.latitude});
    return dataList?.map((e) {
          return AMapPoi.fromJson(e);
        }).toList() ??
        [];
  }

  /// 输入内容自动提示
  ///
  /// 输入关键字[keyword], 并且限制所在城市[city]
  static Future<List> fetchInputTips(
    String keyword, {
    String city = '',
    LatLng? latLng,
  }) async {
    final List? dataList = await _channel
        .invokeMethod('fetchInputTips', {'keyword': keyword, 'city': city, 'latitude': latLng?.latitude, 'longitude': latLng?.longitude});
    return dataList?.map((e) {
          return AmapTips.fromJson(e);
        }).toList() ??
        [];
  }

  /// 地理编码（地址转坐标）
  ///
  /// 输入关键字[keyword], 并且限制所在城市[city]
  static Future<List> searchGeocode(
    String keyword, {
    String city = '',
  }) async {
    final String? version = await _channel.invokeMethod('searchGeocode');
    return [];
  }
}
