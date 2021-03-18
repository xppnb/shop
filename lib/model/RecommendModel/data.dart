import 'RecommendDataItem.dart';

class Data {
  List<RecommendDataItem> dataItemList = [];

  Data.fromJson(List items) {
    items.forEach((element) {
      RecommendDataItem dataItem = new RecommendDataItem(element["id"],
          element["image"], element["nowPrice"], element["firstPrice"]);
      dataItemList.add(dataItem);
    });
  }
}
