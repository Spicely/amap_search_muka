import 'package:amap_core/amap_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amap_search_muka_platform_interface.dart';

/// An implementation of [AmapSearchMukaPlatform] that uses method channels.
class MethodChannelAmapSearchMuka extends AmapSearchMukaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('plugins.muka.com/amap_search');

  @override
  Future<void> setApiKey(String androidKey, String iosKey) async {
    await methodChannel.invokeMethod('setApiKey', {'android': androidKey, 'ios': iosKey});
  }

  @override
  Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await methodChannel.invokeMethod('updatePrivacyShow', {
      'hasContains': hasContains,
      'hasShow': hasShow,
    });
  }

  @override
  Future<void> updatePrivacyAgree(bool hasAgree) async {
    await methodChannel.invokeMethod('updatePrivacyAgree', {
      'hasAgree': hasAgree,
    });
  }

  @override
  Future<List<AMapPoi>> searchKeyword(
    String keyword, {
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    bool cityLimit = true,
  }) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    final List? dataList = await methodChannel.invokeMethod('searchKeyword', {
      'keyword': keyword,
      'city': city,
      'types': types,
      'pageSize': pageSize,
      'page': page,
      'cityLimit': cityLimit,
    });

    return dataList?.map((e) => AMapPoi.fromJson(e)).toList() ?? [];
  }

  @override
  Future<List<AMapPoi>> searchAround(LatLng center, {String keyword = '', String city = '', String types = '', int pageSize = 20, int page = 1, int radius = 1500}) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    assert(radius >= 0 && radius <= 50000, 'radius must be between 0 and 50000');
    final List? dataList = await methodChannel.invokeMethod('searchAround', {
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

  @override
  Future<List<AMapTip>> fetchInputTips(String keyword, {String city = '', LatLng? latLng, bool cityLimit = false}) async {
    final List? dataList = await methodChannel.invokeMethod('fetchInputTips', {
      'keyword': keyword,
      'city': city,
      'latitude': latLng?.latitude,
      'longitude': latLng?.longitude,
      'cityLimit': cityLimit,
    });
    return dataList?.map((e) => AMapTip.fromJson(e)).toList() ?? [];
  }
}
