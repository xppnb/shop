
import 'data.dart';

class FloorData {
  int code;
  String msg;
  Data data;

  FloorData(this.code, this.msg, this.data);

  FloorData.fromJson(Map<String, dynamic> stringStr) {
    this.code = stringStr["code"];
    this.msg = stringStr["msg"];
    this.data = Data.fromJson(stringStr["data"]);
  }
}
