import 'dart:async';

import 'package:flutter/services.dart';

import 'package:amap_core/amap_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

import 'package:amap_search_muka/web/amap.dart';

import 'amap_search_muka.dart';

class AmapSearchMukaWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'plugins.muka.com/amap_search',
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
      // return convert(LatLng.fromJson(call.arguments['latlng']), type: call.arguments['type'] as int);
      case 'calculateArea':
        return Future.value(ringArea(call.arguments['calculate']));
      case 'calculateLineDistance':
        return Future.value(
            distanceOfLine((call.arguments['calculate'] as List).map((e) => LngLat(e['longitude'], e['latitude'])).toList()));
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amap_search_muka for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [Location]
  Future<dynamic> convert(LatLng latLng, int type) {
    Completer completer = Completer<Map<String, dynamic>>();
    MapOptions _mapOptions = MapOptions(
      zoom: 0,
      viewMode: '2D',
    );
    AMap aMap = AMap('container', _mapOptions);

    aMap.plugin(['AMap.Geolocation'], allowInterop(() {
      Geolocation geolocation = Geolocation(GeoOptions());
      aMap.addControl(geolocation);
      geolocation.getCurrentPosition(allowInterop((status, result) {
        if (status == 'complete') {
          completer.complete(Location(
            latLng: LatLng(result.position.lat, result.position.lng),
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
