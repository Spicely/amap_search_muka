import 'dart:async';
import 'dart:js';

import 'package:amap_core/amap_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'amap_search_muka.dart';

/// A web implementation of the AmapLocationMuka plugin.
class AmapSearchMukaWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'amap_search_muka',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = AmapSearchMukaWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'convert':
        print(call.arguments);
        return '111';
      // return convert(call.arguments[]);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amap_search_muka for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [Location]
  Future<dynamic> convert(LatLng latLng, {ConvertType type = ConvertType.GPS}) {
    Completer completer = Completer<Map<String, dynamic>>();
    MapOptions _mapOptions = MapOptions(
      zoom: 0,
      viewMode: '2D',
    );
    AMap aMap = AMap('location', _mapOptions);

    aMap.plugin(['AMap.Geolocation'], allowInterop(() {
      Geolocation geolocation = Geolocation(GeoOptions());
      aMap.addControl(geolocation);
      geolocation.getCurrentPosition(allowInterop((status, result) {
        if (status == 'complete') {
          completer.complete(Location(
            latitude: result.position.lat,
            longitude: result.position.lng,
            country: result.addressComponent.country,
            province: result.addressComponent.province,
            city: result.addressComponent.city,
            district: result.addressComponent.district,
            street: result.addressComponent.street,
            address: result.formattedAddress,
            accuracy: 0.0,
          ).toJson());
        } else {
          completer.completeError(result.message);
        }
      }));
    }));
    return completer.future;
  }
}
