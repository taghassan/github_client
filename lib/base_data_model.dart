abstract class BaseDataModel {
  BaseDataModel parser(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}