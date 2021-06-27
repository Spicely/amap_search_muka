package com.muka.amap_search_muka

import com.amap.api.location.DPoint
import com.amap.api.maps.model.LatLng
import com.amap.api.services.geocoder.RegeocodeResult
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.PoiResult
import io.flutter.Log

class Convert {
    companion object {


        private fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }

        fun toLatLng(o: Any?): LatLng? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            var latitude = data["latitude"]
            var longitude = data["longitude"]
            if (latitude != null && longitude != null) {
                return LatLng(toDouble(latitude), toDouble(longitude))
            }
            return null
        }

        fun toDouble(o: Any): Double {
            return o as Double
        }

        fun toDPoint(o: Any?): DPoint? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            if (data["latitude"] != null && data["longitude"] != null) {
                return DPoint(data["latitude"] as Double, data["longitude"] as Double)
            }
            return null
        }

        fun toJson(point: DPoint): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = point.latitude
            data["longitude"] = point.longitude
            return data
        }

        fun toJson(result: RegeocodeResult): Any {
            val data = HashMap<String, Any>()
            data["building"] = result.regeocodeAddress.building
            data["towncode"] = result.regeocodeAddress.towncode
            data["township"] = result.regeocodeAddress.township
            data["adcode"] = result.regeocodeAddress.adCode
            data["city"] = result.regeocodeAddress.city
            data["citycode"] = result.regeocodeAddress.cityCode
            data["neighborhood"] = result.regeocodeAddress.neighborhood
            data["country"] = result.regeocodeAddress.country
            data["formatAddress"] = result.regeocodeAddress.formatAddress
            data["province"] = result.regeocodeAddress.province
            data["district"] = result.regeocodeAddress.district
            data["streetNumber"] = result.regeocodeAddress.streetNumber.number
            data["pois"] = result.regeocodeAddress.pois
            return data
        }

        fun toJson(result: PoiResult): Any {
            val params = HashMap<String, Any>()
            val pois = mutableListOf<Any>()

            val query =  HashMap<String, Any>()
            val queryLocation =  HashMap<String, Any>()
            queryLocation["latitude"] = result.query.location.latitude
            queryLocation["longitude"] = result.query.location.longitude
            query["building"] = result.query.building
            query["category"]  = result.query.category
            query["city"]  = result.query.city
            query["cityLimit"]  = result.query.cityLimit
            query["extensions"]  = result.query.extensions
            query["isDistanceSort"]  = result.query.isDistanceSort
            query["isSpecial"]  = result.query.isSpecial
            query["pageNum"]  = result.query.pageNum
            query["pageSize"]  = result.query.pageSize
            query["queryString"]  = result.query.queryString
            query["location"]  = queryLocation
            Log.d("-----------", queryLocation.toString())

            result.pois.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any>()
                    data["poiId"] = it.poiId
//                    data["name"] = it.adName
                    data["typeDes"] = it.typeDes
                    data["typeCode"] = it.typeCode
                    data["address"] = it.adName
                    data["tel"] = it.tel
                    data["distance"] = it.distance
                    data["parkingType"] = it.parkingType
                    data["shopID"] = it.shopID
                    data["postcode"] = it.postcode
                    data["website"] = it.website
                    data["email"] = it.email
                    data["province"] = it.provinceName
                    data["provinceCode"] = it.provinceCode
                    data["city"] = it.cityName
                    data["cityCode"] = it.cityCode
                    data["adCode"] = it.adCode
                    data["direction"] = it.direction
                    data["isIndoorMap"] = it.isIndoorMap
                    data["businessArea"] = it.businessArea
                    data["latitude"] = it.latLonPoint.latitude
                    data["longitude"] = it.latLonPoint.longitude
                    pois.add(data)
                }
            }

            params["searchSuggestionKeywords"] =  result.searchSuggestionKeywords
            params["pageCount"] = result.pageCount
            params["query"] = query
            params["searchSuggestionCitys"] = result.searchSuggestionCitys
            params["pois"] = pois
            return params
        }

        fun toArr(result: MutableList<Tip>): Any {
            val arr = mutableListOf<Any>()
            result.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any>()
                    data["adcode"] = it.adcode
                    data["address"] = it.address
                    data["district"] = it.district
                    data["name"] = it.name
                    data["typecode"] = it.typeCode
                    data["uid"] = it.poiID
                    data["latitude"] = it.point.latitude
                    data["longitude"] = it.point.longitude
                    arr.add(data)
                }
            }
            return arr
        }
    }
}