
import 'package:flutter_shop/model/FloorModel/FloorDataItem.dart';
import 'package:flutter_shop/model/GridModel/GridDataItem.dart';
import 'package:flutter_shop/model/GridModel/GridData.dart';
import 'package:flutter_shop/model/HomeModel/DataItem.dart';
import 'package:flutter_shop/model/HomeModel/homeData.dart';
import 'package:flutter_shop/model/RecommendModel/RecommendDataItem.dart';

///所有bean的集合
class AllModel{
  List<GridDataItem> _gridDataItemList = [];
  List<DataItem> _dataItemList = [];
  List<RecommendDataItem> _recommendDataItemList = [];

  List<FloorDataItem> _floorDataItemList = [];


  List<FloorDataItem> get floorDataItemList => _floorDataItemList;

  set floorDataItemList(List<FloorDataItem> value) {
    _floorDataItemList = value;
  }

  List<RecommendDataItem> get recommendDataItemList => _recommendDataItemList;

  set recommendDataItemList(List<RecommendDataItem> value) {
    _recommendDataItemList = value;
  }

  List<GridDataItem> get gridDataItemList => _gridDataItemList;

  set gridDataItemList(List<GridDataItem> value) {
    _gridDataItemList = value;
  }

  List<DataItem> get dataItemList => _dataItemList;

  set dataItemList(List<DataItem> value) {
    _dataItemList = value;
  }
}