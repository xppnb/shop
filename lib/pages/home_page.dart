import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/AllModel.dart';
import 'package:flutter_shop/model/GridModel/GridDataItem.dart';
import 'package:flutter_shop/model/HomeModel/DataItem.dart';
import 'package:flutter_shop/model/HomeModel/data.dart';
import 'package:flutter_shop/model/HomeModel/homeData.dart';
import 'package:flutter_shop/model/RecommendModel/RecommendDataItem.dart';
import 'package:flutter_shop/net/http_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget{
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<HomePage>  with AutomaticKeepAliveClientMixin{
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
          var data = snap.data as AllModel;
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
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: Text("加载中。。。。。。。。"),
          );
        }
      },
      future: getRecommendContent(),
    ));
  }


}

///轮播图
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

///中间的横幅
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

///拨打电话
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
      throw "url不能正常访问";
    }
  }
}

///商品推荐
class RecommendWidget extends StatelessWidget {
  List<RecommendDataItem> recommendDataItemList = [];

  RecommendWidget({this.recommendDataItemList});

  ///字体
  Widget recommendText() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        "商品推荐",
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
        border: Border(
          left: BorderSide(
            width: 1,color: Colors.grey
          )
        )
      ),
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
          Text("¥" + recommendDataItemList[index].nowPrice.toString()),
          Text(
            "¥" + recommendDataItemList[index].firstPrice.toString(),
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
