# amap_search_muka

Flutter高德搜索插件

## 引入方式

```
    amap_location_muka: ^0.0.1
```

## 支持
 - [x] 关键字检索POI
 - [x] 周边检索POI
 - [x] 输入内容自动提示

#### AMapSearch

```
    /// 设置key
    AMapSearch.setApiKey("androidKey", "iosKey");

    /// 隐私
    AMapSearch.updatePrivacyShow(true, true);
    AMapSearch.updatePrivacyAgree(true);


    /// 关键字检索POI [得带上城市 不知道啥原因不带就为空]
    AMapSearch.searchKeyword('广场', city: '成都', page: 1, pageSize: 1);

    /// 周边检索POI
    AMapSearch.searchAround(LatLng(30.68025, 104.080081), types: '火车站', radius: 10000);

    /// 输入内容自动提示
    AMapSearch.fetchInputTips('火车');

```