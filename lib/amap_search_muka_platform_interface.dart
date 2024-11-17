import 'package:amap_core/amap_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amap_search_muka_method_channel.dart';

abstract class AmapSearchMukaPlatform extends PlatformInterface {
  /// Constructs a AmapSearchMukaPlatform.
  AmapSearchMukaPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmapSearchMukaPlatform _instance = MethodChannelAmapSearchMuka();

  /// The default instance of [AmapSearchMukaPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmapSearchMuka].
  static AmapSearchMukaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmapSearchMukaPlatform] when
  /// they register themselves.
  static set instance(AmapSearchMukaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setApiKey(String androidKey, String iosKey) {
    throw UnimplementedError('setApiKey() has not been implemented.');
  }

  Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    throw UnimplementedError('updatePrivacyShow() has not been implemented.');
  }

  Future<void> updatePrivacyAgree(bool hasAgree) async {
    throw UnimplementedError('updatePrivacyAgree() has not been implemented.');
  }

  Future<List<AMapPoi>> searchKeyword(String keyword, {String city = '', String types = '', int pageSize = 20, int page = 1, bool cityLimit = true}) async {
    throw UnimplementedError('searchKeyword() has not been implemented.');
  }

  Future<List<AMapPoi>> searchAround(LatLng center, {String keyword = '', String city = '', String types = '', int pageSize = 20, int page = 1, int radius = 1500}) async {
    throw UnimplementedError('searchAround() has not been implemented.');
  }

  Future<List<AMapTip>> fetchInputTips(String keyword, {String city = '', LatLng? latLng, bool cityLimit = false}) async {
    throw UnimplementedError('fetchInputTips() has not been implemented.');
  }
}
