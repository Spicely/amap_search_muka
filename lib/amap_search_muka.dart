import 'package:amap_core/amap_core.dart';

import 'amap_search_muka_platform_interface.dart';
export 'package:amap_core/amap_core.dart';

class AMapSearch {
  /// 设置Android和iOS的apiKey，建议在widget初始化时设置
  /// apiKey的申请请参考高德开放平台官网
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
  /// [androidKey] Android平台的key
  /// [iosKey] ios平台的key
  static Future<void> setApiKey(String androidKey, String iosKey) async {
    await AmapSearchMukaPlatform.instance.setApiKey(androidKey, iosKey);
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await AmapSearchMukaPlatform.instance.updatePrivacyShow(hasContains, hasShow);
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await AmapSearchMukaPlatform.instance.updatePrivacyAgree(hasAgree);
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
  /// [cityLimit] 强制城市限制功能 [default = true]，例如：在上海搜索天安门，如果cityLimit为false，将不返回北京的天安门相关的POI
  static Future<List<AMapPoi>> searchKeyword(
    String keyword, {
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    bool cityLimit = true,
  }) async {
    return await AmapSearchMukaPlatform.instance.searchKeyword(keyword, city: city, types: types, pageSize: pageSize, page: page, cityLimit: cityLimit);
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
    return await AmapSearchMukaPlatform.instance.searchAround(center, keyword: keyword, city: city, types: types, pageSize: pageSize, page: page, radius: radius);
  }

  /// 输入内容自动提示
  ///
  /// [keyword] 关键字
  ///
  /// [city] 城市名称
  ///
  /// [latLng] 如果设置，在此location附近优先返回搜索关键词信息
  ///
  /// [pageSize] 每页记录数, 范围1-25, [default = 20]
  ///
  /// [page] 当前页数, 范围1-100, [default = 1]
  ///
  /// [cityLimit] 强制城市限制功能 [default = false]，例如：在上海搜索天安门，如果cityLimit为true，将不返回北京的天安门相关的POI
  static Future<List<AMapTip>> fetchInputTips(String keyword, {String city = '', LatLng? latLng, bool cityLimit = false}) async {
    return await AmapSearchMukaPlatform.instance.fetchInputTips(keyword, city: city, latLng: latLng, cityLimit: cityLimit);
  }
}
