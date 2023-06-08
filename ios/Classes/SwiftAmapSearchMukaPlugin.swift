import Flutter
import UIKit
import AMapSearchKit

public class SwiftAmapSearchMukaPlugin: NSObject, FlutterPlugin, AMapSearchDelegate {
    private var search: AMapSearchAPI?
    private var resultCallback: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.muka.com/amap_search", binaryMessenger: registrar.messenger())
        let instance = SwiftAmapSearchMukaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case "setApiKey":
            let apiKey = args?["ios"] as? String
            if apiKey != nil {
                AMapServices.shared().apiKey = apiKey
                result(true)
            } else {
                result(false)
            }
        case "updatePrivacyShow":
            let hasContains = args?["hasContains"] as? Bool == true ? AMapPrivacyInfoStatus.didContain : AMapPrivacyInfoStatus.notContain
            let hasShow = args?["hasShow"] as? Bool == true ? AMapPrivacyShowStatus.didShow : AMapPrivacyShowStatus.notShow
            AMapSearchAPI.updatePrivacyShow(hasShow, privacyInfo: hasContains)
            result(nil)
        case "updatePrivacyAgree":
            let hasAgree = args?["hasAgree"] as? Bool == true ? AMapPrivacyAgreeStatus.didAgree : AMapPrivacyAgreeStatus.notAgree
            AMapSearchAPI.updatePrivacyAgree(hasAgree)
            result(nil)
        case "searchKeyword":
            let keyword = args?["keyword"] as? String
            let city = args?["city"] as? String?
            let types = args?["types"] as? String?
            let cityLimit = args?["cityLimit"] as? Bool
            search = AMapSearchAPI()
            search!.delegate = self
            let geo = AMapPOIKeywordsSearchRequest()
            geo.keywords = keyword
            if city != nil{
                geo.city = city!
            }
            if types != nil {
                geo.types = types!
            }
            geo.cityLimit = cityLimit!
            search!.aMapPOIKeywordsSearch(geo)
            resultCallback = result
        case "searchAround":
            let keyword = args?["keyword"] as? String?
            let city = args?["city"] as? String?
            let types = args?["types"] as? String?
            let page = args?["page"] as? Int
            let pageSize = args?["pageSize"] as? Int
            let latitude = args?["latitude"] as? Double
            let longitude = args?["longitude"] as? Double
            let radius = args?["radius"] as? Int
            
            search = AMapSearchAPI()
            search!.delegate = self
            let geo = AMapPOIAroundSearchRequest()
            geo.location = AMapGeoPoint.location(withLatitude: latitude!, longitude: longitude!)
            if keyword != nil {
                geo.keywords = keyword!
            }
            if city != nil {
                geo.city = city!
            }
            if types != nil {
                geo.types = types!
            }
            geo.page = page!
            geo.offset = pageSize!
            geo.radius = radius!
            search!.aMapPOIAroundSearch(geo)
            resultCallback = result
        case "fetchInputTips":
            let keyword = args?["keyword"] as? String
            let city = args?["city"] as? String?
            let latitude = args?["latitude"] as? Double?
            let longitude = args?["longitude"] as? Double?
            let cityLimit = args?["cityLimit"] as? Bool
            search = AMapSearchAPI()
            search!.delegate = self
            let geo = AMapInputTipsSearchRequest()
            geo.keywords = keyword
            if city != nil {
                geo.city = city!
            }
            if latitude != nil , longitude != nil {
                geo.location = "\(String(describing: longitude)),\(String(describing: latitude))"
            }
            geo.cityLimit = cityLimit!
            search!.aMapInputTipsSearch(geo)
            resultCallback = result
        default:
            result(FlutterMethodNotImplemented)
            
        }
    }
    
    public func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if response.tips.count == 0 {
            resultCallback!([])
            return
        }
        resultCallback!(tipsSearchResponseToObject(res: response.tips))
    }
    
    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if (response.pois.count == 0){
            resultCallback!([])
            return
        }
        resultCallback!(arrayToObject(res: response.pois))
    }
    
    
    private func arrayToObject(res: [AMapPOI]) -> [Dictionary<String, Any>] {
        var arr:[Dictionary<String, Any>] = []
        for it in res {
            var data: Dictionary<String, Any> = [:]
            data["id"] = it.uid
            data["name"] = it.name
            data["typeDes"] = it.type
            data["typeCode"] = it.typecode
            data["address"] = it.address
            data["tel"] = it.tel
            data["distance"] = it.distance
            data["parkingType"] = it.parkingType
            data["shopID"] = it.shopID
            data["postCode"] = it.postcode
            data["website"] = it.website
            data["email"] = it.email
            data["province"] = it.province
            data["provinceCode"] = it.pcode
            data["city"] = it.city
            data["cityCode"] = it.citycode
            data["adCode"] = it.adcode
            data["direction"] = it.direction
            data["indoorData"] = indoorDataToMap(data: it.indoorData)
            data["businessArea"] = it.businessArea
            data["latLng"] = pointToMap(latLng: it.location)
            data["district"] = it.district
            
            arr.append(data)
        }
        return arr
    }
    private func pointToMap(latLng: AMapGeoPoint?) -> Dictionary<String, Any>? {
        if latLng == nil {
            return nil
        }
        return ["latitude": latLng!.latitude,"longitude": latLng!.longitude]
    }
    private func indoorDataToMap(data: AMapIndoorData?) -> Dictionary<String, Any>?{
        if data == nil {
            return nil
        }
        return ["floor": data!.floor,"floorName": data!.floorName as Any, "id": data!.pid as Any, "description":data!.description]
    }
    
    private func tipsSearchResponseToObject(res: [AMapTip]) -> [Dictionary<String, Any>] {
        var arr:[Dictionary<String, Any>] = []
        for it in res {
            var data: Dictionary<String, Any> = [:]
            data["id"] = it.uid
            data["name"] = it.name
            data["adCode"] = it.adcode
            data["address"] = it.address
            data["typeCode"] = it.typecode
            data["latLng"] = pointToMap(latLng: it.location)
            data["district"] = it.district
            arr.append(data)
        }
        return arr
    }
    
}
