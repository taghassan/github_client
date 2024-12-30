abstract class BaseDataModel {
  BaseDataModel parser(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

class ProgressModel {
  int total;
  int synced;
  String path;
  ProgressModel({this.total = 0, this.synced = 0, this.path = ''});
}
