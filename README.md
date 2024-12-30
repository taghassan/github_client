> important note file should contain valid json data

## installastion

```
github_client:
    git: https://github.com/taghassan/github_client.git
```

## imaports
```
import 'package:github_client/base_data_model.dart';
import 'package:github_client/github_client.dart';
```

## usage
prepare mode
```
class DataModel  extends BaseDataModel{

  DataModel.fromJson(dynamic json) {/* ... */}

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    /* .... */
    return map;
  }

@override
  BaseDataModel parser(Map<String, dynamic> json) =>DataModel.fromJson(json);

} 
```
create GithubClient instance 
```
 GithubClient client = GithubClient(
          owner: "",
          token: '');
```
make api call
```
 
 try{
late BaseDataModel? response = await client.fetchGithubData<DataModel>(
            model: DataModel(),
            pathInRepo: "file_path_inside_repo/folder_path_inside_repo",
            repositoryName: "repo_name",
            folder: "local_folder_path");


if (response is BaseDataModel) {
    // hande reponse here 
}else{
     // hande error reponse here 
}
 }catch(e){
 // hande error reponse here 
 }

```