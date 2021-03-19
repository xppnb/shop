import 'package:flutter_shop/model/HomeModel/DataItem.dart';

class Data {
  List<DataItem> dataItemList = [];

  Data.fromJson(List items) {
    items.forEach((element) {
      DataItem dataItem = new DataItem(element["id"], element["image"]);
      dataItemList.add(dataItem);
    });
  }
}
