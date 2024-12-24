import 'package:app_logger/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/base_data_model.dart';

import 'package:github_client/github_client.dart';

class DataModel extends BaseDataModel{
  @override
  BaseDataModel parser(Map<String, dynamic> json) {
    return DataModel();
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

void main() {

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  },);

  test("description", () async{


  },);

}
