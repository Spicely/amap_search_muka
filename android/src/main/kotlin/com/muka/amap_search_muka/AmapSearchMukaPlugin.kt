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
class AmapSearchMukaPlugin : FlutterPlugin, MethodChannel.MethodCallHandler,  PoiSearch.OnPoiSearchListener,Inputtips.InputtipsListener {
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
            "updatePrivacyStatement" -> {
                updatePrivacyStatement(call.arguments as Map<*, *>)
            }
            "searchKeyword" -> {
                try {
                    searchKeyword(call.arguments as Map<*, *>, result)
                } catch (e: AMapException) {
                    e.printStackTrace()
                }
            }

            "searchLatLng" -> {
                try {
                    searchLatLng(call.arguments as Map<*, *>, result)
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
     * 隐私政策设置
     *
     * @param
     */
    private fun updatePrivacyStatement(privacyShowMap: Map<*, *>?) {
        if (null != privacyShowMap) {
            if (privacyShowMap.containsKey("hasContains") && privacyShowMap.containsKey("hasShow")) {
                val hasContains = privacyShowMap["hasContains"] as Boolean
                val hasShow = privacyShowMap["hasShow"] as Boolean
                ServiceSettings.updatePrivacyShow(mContext, hasContains, hasShow)
            }
            if (privacyShowMap.containsKey("hasAgree")) {
                val hasAgree = privacyShowMap["hasAgree"] as Boolean
                ServiceSettings.updatePrivacyAgree(mContext, hasAgree)
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
            val keyword = searchParams["keyword"] as String?
            val city = searchParams["city"] as String?
            var pageSize = searchParams["pageSize"] ?: 20
            var page = searchParams["page"] ?: 1
            val query = PoiSearch.Query(keyword, "", city)
            query.pageSize = pageSize as Int
            query.pageNum = page as Int
            poiSearch = PoiSearch(mContext, query)
            poiSearch!!.setOnPoiSearchListener(this)
            poiSearch!!.searchPOIAsyn()
            resultCallback = result
        }
    }
    @Throws(AMapException::class)
    private fun searchLatLng(searchParams: Map<*, *>?, result: Result) {
        if (null != searchParams) {
            val city = searchParams["city"] as String?
            val latitude = searchParams["latitude"] as Double?
            val longitude = searchParams["longitude"] as Double?
            var pageSize = searchParams["pageSize"] ?: 20
            var range = searchParams["range"] as Int?
            var page = searchParams["page"] ?: 1
            val query = PoiSearch.Query("", "", city)
            query.pageSize = pageSize as Int
            query.pageNum = page as Int
            poiSearch = PoiSearch(mContext, query)
            poiSearch!!.bound = PoiSearch.SearchBound(LatLonPoint(latitude!!, longitude!!), range?:2000)
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
            val query = PoiSearch.Query(keyword, "", city)
            query.pageSize = 35
            query.pageNum = 1
            poiSearch = PoiSearch(mContext, query)
            poiSearch!!.bound = PoiSearch.SearchBound(LatLonPoint(latitude!!, longitude!!), 1000)
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
            val query = InputtipsQuery(keyword,  city)
            if (city != null) {
                query.cityLimit = true
            }
            if (latitude != null && longitude != null) {
                query.location = LatLonPoint(latitude, longitude)
            }
            val inputTips  = Inputtips(mContext, query)
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
