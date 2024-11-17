package com.muka.amap_search_muka

import android.content.Context
import android.text.TextUtils
import android.util.Log
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItemV2
import com.amap.api.services.core.ServiceSettings
import com.amap.api.services.help.Inputtips
import com.amap.api.services.help.InputtipsQuery
import com.amap.api.services.poisearch.PoiResultV2
import com.amap.api.services.poisearch.PoiSearchV2
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AmapSearchMukaPlugin */
class AmapSearchMukaPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_search")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setApiKey" -> {
                val apiKeyMap = call.arguments as Map<*, *>
                if (apiKeyMap.containsKey("android") && !TextUtils.isEmpty(apiKeyMap["android"] as String?)) {
                    ServiceSettings.getInstance().setApiKey(apiKeyMap["android"] as String?)
                }
                result.success(null)
            }

            "updatePrivacyShow" -> {
                val hasContains: Boolean = call.argument("hasContains")!!
                val hasShow: Boolean = call.argument("hasShow")!!
                ServiceSettings.updatePrivacyShow(mContext, hasContains, hasShow)
                result.success(null)
            }

            "updatePrivacyAgree" -> {
                val hasAgree: Boolean = call.argument("hasAgree")!!
                ServiceSettings.updatePrivacyAgree(mContext, hasAgree)
                result.success(null)
            }

            "searchKeyword" -> {
                try {
                    searchKeyword(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            "searchAround" -> {
                try {
                    searchAround(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            "fetchInputTips" -> {
                try {
                    fetchInputTips(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun searchKeyword(searchParams: Map<*, *>, result: Result) {
        Log.d("TAG", "onPoiSearched: $searchParams ")
        val keyword = searchParams["keyword"] as String
        val city = searchParams["city"] as String
        val pageSize = searchParams["pageSize"] as Int
        val page = searchParams["page"] as Int
        val types = searchParams["types"] as String
        val cityLimit = searchParams["cityLimit"] as Boolean
        val query = PoiSearchV2.Query(keyword, types, city)
        query.pageSize = pageSize
        query.pageNum = page
        query.cityLimit = cityLimit
        val poiSearch = PoiSearchV2(mContext, query)
        Log.d("TAG", "onPoiSearched: $searchParams ")
        poiSearch.setOnPoiSearchListener(object : PoiSearchV2.OnPoiSearchListener {
            override fun onPoiSearched(res: PoiResultV2, rCode: Int) {
                if (rCode != 1000) {
                    result.success(mutableListOf<Any>())
                } else {
                    result.success(Convert.toArr(res))
                }
            }

            override fun onPoiItemSearched(p0: PoiItemV2?, p1: Int) {

            }

        })
        poiSearch.searchPOIAsyn()
    }

    private fun searchAround(searchParams: Map<*, *>, result: Result) {
        val keyword = searchParams["keyword"] as String
        val city = searchParams["city"] as String
        val latitude = searchParams["latitude"] as Double?
        val longitude = searchParams["longitude"] as Double?
        val types = searchParams["types"] as String
        val radius = searchParams["radius"] as Int
        val pageSize = searchParams["pageSize"] as Int
        val page = searchParams["page"] as Int

        val query = PoiSearchV2.Query(keyword, types, city)
        query.pageSize = pageSize
        query.pageNum = page
        val poiSearch = PoiSearchV2(mContext, query)
        poiSearch.bound = PoiSearchV2.SearchBound(LatLonPoint(latitude!!, longitude!!), radius)
        poiSearch.setOnPoiSearchListener(object : PoiSearchV2.OnPoiSearchListener {
            override fun onPoiSearched(res: PoiResultV2, rCode: Int) {
                if (rCode != 1000) {
                    result.success(mutableListOf<Any>())
                } else {
                    result.success(Convert.toArr(res))
                }
            }

            override fun onPoiItemSearched(p0: PoiItemV2, p1: Int) {
            }

        })
        poiSearch.searchPOIAsyn()
    }

    private fun fetchInputTips(inputParams: Map<*, *>, result: Result) {
        val keyword = inputParams["keyword"] as String?
        val city = inputParams["city"] as String?
        val latitude = inputParams["latitude"] as Double?
        val longitude = inputParams["longitude"] as Double?
        val cityLimit = inputParams["cityLimit"] as Boolean

        val query = InputtipsQuery(keyword, city)
        if (latitude != null && longitude != null) {
            query.location = LatLonPoint(latitude, longitude)
        }
        query.cityLimit = cityLimit

        val inputTips = Inputtips(mContext, query)
        inputTips.setInputtipsListener { res, rCode ->
            if (rCode != 1000) {
                result.success(emptyArray<Any>())
            } else {
                result.success(Convert.toArr(res))
            }
        }
        inputTips.requestInputtipsAsyn()
    }

}
