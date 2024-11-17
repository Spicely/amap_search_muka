package com.muka.amap_search_muka

import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.IndoorData
import com.amap.api.services.poisearch.PoiResultV2

class Convert {
    companion object {


        private fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }


        fun toArr(result: PoiResultV2): Any {
            val pis = mutableListOf<Any>()
            result.pois.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any?>()
                    data["id"] = it.poiId
                    data["name"] = it.title
                    data["typeDes"] = it.typeDes
                    data["typeCode"] = it.typeCode
                    data["address"] = it.snippet
                    data["province"] = it.provinceName
                    data["provinceCode"] = it.provinceCode
                    data["city"] = it.cityName
                    data["cityCode"] = it.cityCode
                    data["adCode"] = it.adCode
                    data["indoorData"] = if (it.indoorData == null) null else toMap(it.indoorData)
                    data["latLng"] = if (it.latLonPoint == null) null else toMap(it.latLonPoint)
                    data["district"] = it.adName
                    pis.add(data)
                }
            }
            return pis
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