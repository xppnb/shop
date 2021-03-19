
import 'data.dart';

class RecommendData {
  int code;
  String msg;
  Data data;

  RecommendData(this.code, this.msg, this.data);

  RecommendData.fromJson(Map<String, dynamic> stringStr) {
    this.code = stringStr["code"];
    this.msg = stringStr["msg"];
    this.data = Data.fromJson(stringStr["data"]);
  }
}
