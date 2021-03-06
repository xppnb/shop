import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/AllModel.dart';
import 'package:flutter_shop/model/GridModel/GridDataItem.dart';
import 'package:flutter_shop/model/HomeModel/DataItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shop/model/FloorModel/FloorDataItem.dart';
import 'package:flutter_shop/model/RecommendModel/RecommendDataItem.dart';
import 'package:flutter_shop/net/http_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<RecommendDataItem> hotGoodsList = [];
  int page = 1;
  AllModel data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData) {
          data = snap.data as AllModel;
          getHotList();
          return ListView(
            children: [
              Column(
                children: [
                  BannerWidget(
                    imageList: data.dataItemList,
                  ),
                  gridWidget(
                    gridDataItemList: data.gridDataItemList,
                  ),
                  CenterBanner(
                    image: data.gridDataItemList[0].banner,
                  ),
                  PhoneWidget(
                    image: data.gridDataItemList[0].leadingImage,
                    phoneNumber: data.gridDataItemList[0].tel,
                  ),
                  RecommendWidget(
                    recommendDataItemList: data.recommendDataItemList,
                  ),
                  FloorWidget(
                    floorDataItemList: data.floorDataItemList,
                  ),
                  hotGoods(),
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: Text("?????????????????????????????????"),
          );
        }
      },
      future: getFloorContent(),
    ));
  }

  ///????????????
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10,bottom: 10),
    alignment: Alignment.center,
    child: Text("????????????",style: TextStyle(fontWeight: FontWeight.w800),),
  );

  ///????????????
  void getHotList() {
    List<RecommendDataItem> newGoodsList = data.recommendDataItemList;
    hotGoodsList.addAll(newGoodsList);
  }

  ///????????????
  Widget wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((e) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            height: ScreenUtil().setHeight(400),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: [
                Image.network(
                  e.image,
                  width: ScreenUtil().setWidth(372),
                  height: ScreenUtil().setHeight(300),
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  "??${e.nowPrice.toString()}",
                  style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                ),
                Text(
                  "??" + e.firstPrice.toString(),
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: ScreenUtil().setSp(26),
                      color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text("");
    }
  }

  Widget hotGoods() {
    return Container(
      child: Column(
        children: [hotTitle, wrapList()],
      ),
    );
  }
}

///?????????
class BannerWidget extends StatefulWidget {
  List<DataItem> imageList = [];

  BannerWidget({this.imageList});

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int currentIndex = 0;
  PageController pageController;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = new PageController(initialPage: 0);
    startTimer();
  }

  startTimer() {
    timer = new Timer.periodic(Duration(milliseconds: 2000), (value) {
      currentIndex++;
      pageController.animateToPage(currentIndex,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(350),
      child: PageView.builder(
        itemBuilder: (context, index) {
          return showImage(index);
        },
        itemCount: widget.imageList.length * 10000000,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
      ),
    );
  }

  Widget showImage(int index) {
    return Image.network(
      widget.imageList[index % widget.imageList.length].image,
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    pageController.dispose();
  }
}

///gridView
class gridWidget extends StatefulWidget {
  List<GridDataItem> gridDataItemList = [];

  gridWidget({this.gridDataItemList});

  @override
  _gridWidgetState createState() => _gridWidgetState();
}

class _gridWidgetState extends State<gridWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: ScreenUtil().setHeight(320),
        width: ScreenUtil().setWidth(750),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return gridBuilder(index);
          },
          itemCount: widget.gridDataItemList.length,
        ),
      ),
    );
  }

  gridBuilder(index) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Image.network(
            widget.gridDataItemList[index].image,
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(75),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text(widget.gridDataItemList[index].text.toString()),
        ],
      ),
    );
  }
}

///???????????????
class CenterBanner extends StatelessWidget {
  String image;

  CenterBanner({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(90),
      child: Image.network(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

///????????????
class PhoneWidget extends StatelessWidget {
  String phoneNumber;
  String image;

  PhoneWidget({this.phoneNumber, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _callPhone,
        child: Image.network(
          image,
          fit: BoxFit.contain,
          width: ScreenUtil().setHeight(750),
          height: ScreenUtil().setHeight(300),
        ),
      ),
    );
  }

  _callPhone() async {
    String phoneNumber = "tel:" + this.phoneNumber;
    // String phoneNumber = "http://www.baidu.com";
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw "url??????????????????";
    }
  }
}

///????????????
class RecommendWidget extends StatelessWidget {
  List<RecommendDataItem> recommendDataItemList = [];

  RecommendWidget({this.recommendDataItemList});

  ///??????
  Widget recommendText() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        "????????????",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  ///
  Widget recommendContext() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(420),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return recommendList(index);
        },
        itemCount: recommendDataItemList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget recommendList(index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 1, color: Colors.grey))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            recommendDataItemList[index].image,
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setHeight(300),
          ),
          SizedBox(
            height: 5,
          ),
          Text("??" + recommendDataItemList[index].nowPrice.toString()),
          Text(
            "??" + recommendDataItemList[index].firstPrice.toString(),
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(750),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recommendText(),
          recommendContext(),
        ],
      ),
    );
  }
}

///??????
class FloorWidget extends StatelessWidget {
  List<FloorDataItem> floorDataItemList = [];

  FloorWidget({this.floorDataItemList});

  ///???????????????
  Widget topImage() {
    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(200),
        child: ClipRRect(
          child:
              Image.network(floorDataItemList[0].fistImage, fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(120),
        ));
  }

  ///??????????????????
  Widget firstFloor() {
    return Container(
      height: ScreenUtil().setHeight(400),
      child: Row(
        children: [
          firsetLeft(),
          firstFloorRight(),
        ],
      ),
    );
  }

  ///??????????????????
  Widget firsetLeft() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: Colors.grey),
      )),
      height: ScreenUtil().setHeight(400),
      width: ScreenUtil().setWidth(375),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(floorDataItemList[0].name),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  floorDataItemList[0].title,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "??" + floorDataItemList[0].firstPrice.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Image.network(
              floorDataItemList[0].image,
              fit: BoxFit.contain,
              width: ScreenUtil().setHeight(333),
              height: ScreenUtil().setHeight(250),
            ),
          ],
        ),
      ),
    );
  }

  ///??????????????????
  Widget firstFloorRight() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(width: 1, color: Colors.grey),
          bottom: BorderSide(width: 1, color: Colors.grey),
        )),
        width: ScreenUtil().setWidth(375),
        height: ScreenUtil().setHeight(400),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: ScreenUtil().setHeight(200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(floorDataItemList[1].name),
                            Text(
                              floorDataItemList[1].title,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, left: 10),
                          child: Text(
                            "??" + floorDataItemList[1].firstPrice.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    floorDataItemList[1].image,
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(200),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setWidth(375),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: ScreenUtil().setHeight(200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(floorDataItemList[2].name),
                            Text(
                              floorDataItemList[2].title,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, left: 10),
                          child: Text(
                            "??" + floorDataItemList[2].firstPrice.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    floorDataItemList[2].image,
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(160),
                    // height: ScreenUtil().setHeight(200),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  ///??????????????????
  Widget firstFloorBottom() {
    return Container(
      padding: EdgeInsets.only(left: 1),
      height: ScreenUtil().setHeight(200),
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: [
          ///??????
          InkWell(
            onTap: () {
              print("123");
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey),
              )),
              padding: EdgeInsets.all(8),
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setWidth(373),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(floorDataItemList[3].name),
                                Text(
                                  floorDataItemList[3].title,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(20)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "??" +
                                    floorDataItemList[3].firstPrice.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        floorDataItemList[3].image,
                        fit: BoxFit.contain,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(160),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ///??????
          Container(
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(width: 1, color: Colors.grey),
              bottom: BorderSide(width: 1, color: Colors.grey),
            )),
            padding: EdgeInsets.all(8),
            height: ScreenUtil().setHeight(200),
            width: ScreenUtil().setWidth(375),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(floorDataItemList[4].name),
                              Text(
                                floorDataItemList[4].title,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(20)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "??" + floorDataItemList[4].firstPrice.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.network(
                      floorDataItemList[4].image,
                      fit: BoxFit.contain,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setHeight(160),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(850),
      child: Column(
        children: [
          topImage(),
          firstFloor(),
          firstFloorBottom(),
        ],
      ),
    );
  }
}
