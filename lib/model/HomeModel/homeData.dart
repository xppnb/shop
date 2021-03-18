import 'package:flutter_shop/model/HomeModel/data.dart';

class HomeData {
  int code;
  String msg;
  Data data;

  HomeData(this.code, this.msg, this.data);

  HomeData.fromJson(Map<String, dynamic> stringStr) {
    this.code = stringStr["code"];
    this.msg = stringStr["msg"];
    this.data = Data.fromJson(stringStr["data"]);
  }
}
