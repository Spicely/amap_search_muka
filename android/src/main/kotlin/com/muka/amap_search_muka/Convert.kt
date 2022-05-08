package com.muka.amap_search_muka

import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.IndoorData
import com.amap.api.services.poisearch.PoiResult
import io.flutter.Log

class Convert {
    companion object {


        private fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }

        //        fun toLatLng(o: Any?): LatLng? {
//            if (o == null) {
//                return null
//            }
//            var data = toMap(o)
//            var latitude = data["latitude"]
//            var longitude = data["longitude"]
//            if (latitude != null && longitude != null) {
//                return LatLng(toDouble(latitude), toDouble(longitude))
//            }
//            return null
//        }
//
//        fun toDouble(o: Any): Double {
//            return o as Double
//        }
//
//        fun toDPoint(o: Any?): DPoint? {
//            if (o == null) {
//                return null
//            }
//            var data = toMap(o)
//            if (data["latitude"] != null && data["longitude"] != null) {
//                return DPoint(data["latitude"] as Double, data["longitude"] as Double)
//            }
//            return null
//        }
//
//        fun toJson(result: RegeocodeResult): Any {
//            val data = HashMap<String, Any>()
//            data["building"] = result.regeocodeAddress.building
//            data["towncode"] = result.regeocodeAddress.towncode
//            data["township"] = result.regeocodeAddress.township
//            data["adcode"] = result.regeocodeAddress.adCode
//            data["city"] = result.regeocodeAddress.city
//            data["citycode"] = result.regeocodeAddress.cityCode
//            data["neighborhood"] = result.regeocodeAddress.neighborhood
//            data["country"] = result.regeocodeAddress.country
//            data["formatAddress"] = result.regeocodeAddress.formatAddress
//            data["province"] = result.regeocodeAddress.province
//            data["district"] = result.regeocodeAddress.district
//            data["streetNumber"] = result.regeocodeAddress.streetNumber.number
//            data["pois"] = result.regeocodeAddress.pois
//            return data
//        }
//
        fun toArr(result: PoiResult): Any {
            val pois = mutableListOf<Any>()
            result.pois.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any?>()
                    var latLonPoint = HashMap<String, Double?>()
                    data["id"] = it.poiId
                    data["name"] = it.title
                    data["typeDes"] = it.typeDes
                    data["typeCode"] = it.typeCode
                    data["address"] = it.snippet
                    data["tel"] = it.tel
                    data["distance"] = it.distance
                    data["parkingType"] = it.parkingType
                    data["shopID"] = it.shopID
                    data["postCode"] = it.postcode
                    data["website"] = it.website
                    data["email"] = it.email
                    data["province"] = it.provinceName
                    data["provinceCode"] = it.provinceCode
                    data["city"] = it.cityName
                    data["cityCode"] = it.cityCode
                    data["adCode"] = it.adCode
                    data["direction"] = it.direction
                    data["indoorData"] = if (it.indoorData == null) null else toMap(it.indoorData)
                    data["businessArea"] = it.businessArea
                    data["latLng"] = if (it.latLonPoint == null) null else toMap(it.latLonPoint)
                    data["district"] = it.adName
                    pois.add(data)
                }
            }
            return pois
        }

        fun toArr(result: MutableList<Tip>): Any? {
            val arr = mutableListOf<Any>()
            result.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any?>()
                    data["id"] = it.poiID
                    data["name"] = it.name
                    data["adCode"] = it.adcode
                    data["address"] = it.address
                    data["typeCode"] = it.typeCode
                    data["latLng"] = if (it.point == null) null else toMap(it.point)
                    data["district"] = it.district
                    arr.add(data)
                }
            }
            return arr
        }

        private fun toMap(data: IndoorData): MutableMap<String, Any?> {
            val map: MutableMap<String, Any?> = java.util.HashMap()
            map["floor"] = data.floor
            map["floorName"] = data.floorName
            map["id"] = data.poiId
            map["description"] = null
            return map
        }

        private fun toMap(point: LatLonPoint): MutableMap<String, Any> {
            val pointMap: MutableMap<String, Any> = java.util.HashMap()
            pointMap["latitude"] = point.latitude
            pointMap["longitude"] = point.longitude
            return pointMap
        }
    }
}