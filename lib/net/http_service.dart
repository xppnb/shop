import 'dart:convert';
import 'dart:io';

import 'package:flutter_shop/model/AllModel.dart';
import 'package:flutter_shop/model/FloorModel/FloorData.dart';
import 'package:flutter_shop/model/GridModel/GridData.dart';
import 'package:flutter_shop/model/HomeModel/homeData.dart';
import 'package:flutter_shop/model/RecommendModel/RecommendData.dart';
import 'package:flutter_shop/net/http_url.dart';

///网络请求
AllModel allModel = new AllModel();

Future getHomePageContent() async {
  try {
    HttpClient httpClient = new HttpClient();
    var httpClientRequest =
        await httpClient.postUrl(Uri.parse(servicePath["home"]));
    httpClientRequest.headers.contentType =
        ContentType("application/json", "charset=utf-8");
    var httpClientResponse = await httpClientRequest.close();
    if (httpClientResponse.statusCode == 200) {
      var s = await httpClientResponse.transform(Utf8Decoder()).join();
      var homeData = HomeData.fromJson(json.decode(s.toString()));
      //print(homeData.data.dataItemList[0].image);
      return homeData.data.dataItemList;
    } else {
      throw Exception("后端出现异常");
    }
  } catch (e) {
    print(e);
    throw Exception("home网络请求出现异常");
  }
}

Future getGridViewContent() async {
  return getHomePageContent().then((value) async {
    try {
      HttpClient httpClient = new HttpClient();
      var httpClientRequest =
          await httpClient.postUrl(Uri.parse(servicePath["grid"]));
      httpClientRequest.headers.contentType =
          ContentType("application/json", "charset=utf-8");
      var httpClientResponse = await httpClientRequest.close();
      if (httpClientResponse.statusCode == 200) {
        var s = await httpClientResponse.transform(Utf8Decoder()).join();
        var gridData = GridData.fromJson(json.decode(s.toString()));
        print(gridData.data.dataItemList);
        allModel.dataItemList = value as List;
        allModel.gridDataItemList = gridData.data.dataItemList;
        return allModel;
      } else {
        throw Exception("后端出现异常");
      }
    } catch (e) {
      print(e);
      throw Exception("home网络请求出现异常");
    }
  });
}

Future getRecommendContent() async {
  return getGridViewContent().then((value) async {
    try {
      HttpClient httpClient = new HttpClient();
      var httpClientRequest =
          await httpClient.postUrl(Uri.parse(servicePath["recommend"]));
      httpClientRequest.headers.contentType =
          ContentType("application/json", "charset=utf-8");
      var httpClientResponse = await httpClientRequest.close();
      if (httpClientResponse.statusCode == 200) {
        var s = await httpClientResponse.transform(Utf8Decoder()).join();
        var recommendData = RecommendData.fromJson(json.decode(s.toString()));
        print(recommendData.data.dataItemList[0].firstPrice);
        allModel.recommendDataItemList = recommendData.data.dataItemList;
        return allModel;
      } else {
        throw Exception("后端出现异常");
      }
    } catch (e) {
      print(e);
      throw Exception("home网络请求出现异常");
    }
  });
}

Future getFloorContent() async {
  return getRecommendContent().then((value) async {
    try {
      HttpClient httpClient = new HttpClient();
      var httpClientRequest =
          await httpClient.postUrl(Uri.parse(servicePath["floor"]));
      httpClientRequest.headers.contentType =
          ContentType("application/json", "charset=utf-8");
      var httpClientResponse = await httpClientRequest.close();
      if (httpClientResponse.statusCode == 200) {
        var s = await httpClientResponse.transform(Utf8Decoder()).join();
        var floorData = FloorData.fromJson(json.decode(s.toString()));
        print(floorData.data.dataItemList[0].firstPrice);
        allModel.floorDataItemList = floorData.data.dataItemList;
        return allModel;
      } else {
        throw Exception("后端出现异常");
      }
    } catch (e) {
      print(e);
      throw Exception("home网络请求出现异常");
    }
  });
}
