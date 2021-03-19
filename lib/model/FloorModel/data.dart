import 'FloorDataItem.dart';

class Data {
  List<FloorDataItem> dataItemList = [];

  Data.fromJson(List items) {
    items.forEach((element) {
      FloorDataItem dataItem = new FloorDataItem(
          element["id"],
          element["image"],
          element["nowPrice"],
          element["firstPrice"],
          element["name"],
          element["title"],
          element["fistImage"],
          element["secondImage"]
      );
      dataItemList.add(dataItem);
    });
  }
}
