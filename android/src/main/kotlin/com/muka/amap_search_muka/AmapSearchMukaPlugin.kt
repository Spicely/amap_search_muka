package com.muka.amap_search_muka


import android.content.Context
import android.text.TextUtils

import androidx.annotation.NonNull

import com.amap.api.services.core.AMapException
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.core.ServiceSettings
import com.amap.api.services.help.Inputtips
import com.amap.api.services.help.InputtipsQuery
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch

import java.util.ArrayList
import java.util.HashMap

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result


/** AmapSearchMukaPlugin */
class AmapSearchMukaPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, PoiSearch.OnPoiSearchListener, Inputtips.InputtipsListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null
    private var mContext: Context? = null
    private var resultCallback: Result? = null
    private var poiSearch: PoiSearch? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel =
                MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_search")
        channel!!.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "setApiKey" -> {
                setApiKey(call.arguments as Map<*, *>)
            }
            "updatePrivacyShow" -> {
                var hasContains: Boolean = call.argument("hasContains")!!
                var hasShow: Boolean = call.argument("hasShow")!!
                ServiceSettings.updatePrivacyShow(mContext, hasContains, hasShow)
                result.success(null)
            }
            "updatePrivacyAgree" -> {
                var hasAgree: Boolean = call.argument("hasAgree")!!
                ServiceSettings.updatePrivacyAgree(mContext, hasAgree)
                result.success(null)
            }
            "searchKeyword" -> {
                try {
                    searchKeyword(call.arguments as Map<*, *>, result)
                } catch (e: AMapException) {
                    e.printStackTrace()
                }
            }
            "searchAround" -> {
                try {
                    searchAround(call.arguments as Map<*, *>, result)
                } catch (e: AMapException) {
                    e.printStackTrace()
                }
            }
            "fetchInputTips" -> {
                try {
                    fetchInputTips(call.arguments as Map<*, *>, result)
                } catch (e: AMapException) {
                    e.printStackTrace()
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    /**
     * 设置apikey
     *
     * @param apiKeyMap
     */
    private fun setApiKey(apiKeyMap: Map<*, *>?) {
        if (null != apiKeyMap) {
            if (apiKeyMap.containsKey("android")
                    && !TextUtils.isEmpty(apiKeyMap["android"] as String?)) {
                ServiceSettings.getInstance().setApiKey(apiKeyMap["android"] as String?)
            }
        }
    }

    /**
     * POI 根据关键字搜索
     *
     * @param searchParams
     */
    @Throws(AMapException::class)
    private fun searchKeyword(searchParams: Map<*, *>?, result: Result) {
        if (null != searchParams) {
            val keyword = searchParams["keyword"] as String
            val city = searchParams["city"] as String?
            var pageSize = searchParams["pageSize"] as Int
            var page = searchParams["page"] as Int
            var types = searchParams["types"]  as String?
            var cityLimit = searchParams["cityLimit"] as Boolean

            val query = PoiSearch.Query(keyword, types, city)
            query.pageSize = pageSize
            query.pageNum = page
            query.cityLimit = cityLimit
            poiSearch = PoiSearch(mContext, query)
            poiSearch!!.setOnPoiSearchListener(this)
            poiSearch!!.searchPOIAsyn()
            resultCallback = result
        }
    }

    /**
     * POI 搜索周边POI
     *
     * @param searchParams
     */
    @Throws(AMapException::class)
    private fun searchAround(searchParams: Map<*, *>?, result: Result) {
        if (null != searchParams) {
            val keyword = searchParams["keyword"] as String?
            val city = searchParams["city"] as String?
            val latitude = searchParams["latitude"] as Double?
            val longitude = searchParams["longitude"] as Double?
            var types = searchParams["types"]  as String?
            var radius = searchParams["radius"]  as Int
            var pageSize = searchParams["pageSize"] as Int
            var page = searchParams["page"] as Int

            val query = PoiSearch.Query(keyword, types, city)
            query.pageSize = pageSize
            query.pageNum = page
            poiSearch = PoiSearch(mContext, query)
            poiSearch!!.bound = PoiSearch.SearchBound(LatLonPoint(latitude!!, longitude!!), radius)
            poiSearch!!.setOnPoiSearchListener(this)
            poiSearch!!.searchPOIAsyn()
            resultCallback = result
        }
    }

    @Throws(AMapException::class)
    private fun fetchInputTips(inputParams: Map<*, *>?, result: Result) {
        if (null != inputParams) {
            val keyword = inputParams["keyword"] as String?
            val city = inputParams["city"] as String?
            val latitude = inputParams["latitude"] as Double?
            val longitude = inputParams["longitude"] as Double?
            val query = InputtipsQuery(keyword, city)
            if (city != null) {
                query.cityLimit = true
            }
            if (latitude != null && longitude != null) {
                query.location = LatLonPoint(latitude, longitude)
            }
            val inputTips = Inputtips(mContext, query)
            inputTips.setInputtipsListener(this)
            inputTips.requestInputtipsAsyn()
            resultCallback = result
        }
    }


    override fun onPoiSearched(result: PoiResult, rCode: Int) {
        if (rCode != 1000) {
            resultCallback?.success(emptyArray<Any>())
        }
        if (result == null) {
            resultCallback?.success(emptyArray<Any>())
        } else {
            resultCallback?.success(Convert.toArr(result))
        }
    }

    override fun onPoiItemSearched(poiItem: PoiItem?, i: Int) {}
    override fun onGetInputtips(result: MutableList<Tip>?, rCode: Int) {
        if (rCode != 1000) {
            resultCallback?.success(emptyArray<Any>())
        }
        if (result == null) {
            resultCallback?.success(emptyArray<Any>())
        } else {
            resultCallback?.success(Convert.toArr(result))
        }
    }
}
