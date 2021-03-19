
import 'data.dart';

class GridData {
  int code;
  String msg;
  Data data;

  GridData(this.code, this.msg, this.data);

  GridData.fromJson(Map<String, dynamic> stringStr) {
    this.code = stringStr["code"];
    this.msg = stringStr["msg"];
    this.data = Data.fromJson(stringStr["data"]);
  }
}
