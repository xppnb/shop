import 'GridDataItem.dart';

class Data {
  List<GridDataItem> dataItemList = [];

  Data.fromJson(List items) {
    items.forEach((element) {
      GridDataItem dataItem = new GridDataItem(
          element["id"],
          element["image"],
          element["text"],
          element["banner"],
          element["leadingImage"],
          element["tel"]);
      dataItemList.add(dataItem);
    });
  }
}
