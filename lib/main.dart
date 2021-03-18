import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/pages/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(750, 1334),
        builder: () => MaterialApp(
              title: "百姓生活",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primaryColor: Colors.pink),
              home: IndexPage(),
            ));
  }
}
