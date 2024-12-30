import 'dart:convert';
import 'dart:io';

import 'package:app_logger/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:github/github.dart';
import 'package:github_client/base_data_model.dart';
import 'package:path_provider/path_provider.dart';

export 'package:github/github.dart';

class GithubClient {
  final String owner;
  final String? token;
  final Authentication? auth;
  GitHub gitHubInstance=GitHub();
  GithubClient({required this.owner,this.token,this.auth}){
    if(token!=null){
      gitHubInstance=GitHub(auth: Authentication.withToken(token));
    }else{
       gitHubInstance=GitHub(auth: auth ??findAuthenticationFromEnvironment());
    }
  }

  Future<BaseDataModel?>? fetchGithubData<T extends BaseDataModel>({
    required T model,
    required String pathInRepo,
    required String repositoryName,
    String? folder,
  }) async {
    try {
      var response = await githubCall(
        repositoryName: repositoryName,
        pathInRepo: pathInRepo,
        folder: folder,
          token:token
      );

      return response!=null?model.parser(response):null;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> githubCall({
    required String pathInRepo,
    required String repositoryName,
    String? token,
    String? folder,
  }) async {
    AppLogger.it.logInfo("githubCall path $pathInRepo");
    AppLogger.it.logInfo("githubCall folder $folder");

    AppLogger.it.logInfo("githubCall owner $owner");
    AppLogger.it.logInfo("githubCall pathInRepo $pathInRepo");
    AppLogger.it.logInfo("githubCall repositoryName $repositoryName");
    AppLogger.it.logInfo("githubCall token ${gitHubInstance.auth.token}");

    var repo = (await
    gitHubInstance.repositories
        .getContents(RepositorySlug(owner, repositoryName), pathInRepo));

    AppLogger.it.logInfo("githubCall repo $repo");


    var file = repo.file;
    await FileHandler.downloadFile(
        url: file?.downloadUrl, fileName: file?.name, path: folder);
    AppLogger.it.logInfo("repo ${file?.name}");
    var response =
        await FileHandler.readJsonFile(path: "$folder/${file?.name}");
    return response;
  }
}

class FileHandler {
  static downloadFile({String? url, String? fileName, String? path}) async {
    try {
      var response = await Dio().download(url.toString(),
          '${(await getApplicationDocumentsDirectory()).path}/${path != null ? '$path/' : ''}${fileName ?? '${DateTime.now().microsecondsSinceEpoch}_data.json'}');

      AppLogger.it.logInfo(response.toString());
    } catch (e) {
      AppLogger.it.logError(e.toString());
    }
  }

  static Future readJsonFile({required String path}) async {
    try {
      // Get the path to the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$path';

      final fileSystemEntity = FileSystemEntity.typeSync(filePath);

      //***************** created by TajEldeen *****************//
      // handle if path is file
      //********************************************************//
      if (fileSystemEntity == FileSystemEntityType.file) {
        // Check if the file exists
        AppLogger.it.logInfo("Check if the file exists");
        final file = File(filePath);
        if (await file.exists()) {
          AppLogger.it.logInfo("Read the file as a string");
          // Read the file as a string
          final contents = await file.readAsString();

          AppLogger.it.logInfo("Decode the JSON string into a Dart Map");
          // Decode the JSON string into a Dart Map
          final json = jsonDecode(contents);

          AppLogger.it.logInfo("data $json");

          return json;
          // return  GooglePlacesResponseModel.fromJson(json);
        } else {
          AppLogger.it.logInfo("File not found:");
          throw Exception('File not found: $filePath');
        }
      }

      Directory directoryFromPath = Directory(filePath);

      if (await directoryFromPath.exists()) {
        var directoryFiles = directoryFromPath.listSync();

        AppLogger.it.logInfo("directoryFiles : ${directoryFiles.length}");

        List<dynamic> tempList = [];

        for (FileSystemEntity directoryFile in directoryFiles) {
          // Check if the file exists
          final file = File(directoryFile.path);
          if (await file.exists()) {
            // Read the file as a string
            final contents = await file.readAsString();

            // Decode the JSON string into a Dart Map
            final json = jsonDecode(contents);

            // AppLogger.it.logInfo("data $json");

            tempList.add(json);
            // return  GooglePlacesResponseModel.fromJson(json);
          } else {
            throw Exception('File not found: $filePath');
          }
        }

        return tempList;
      }
    } catch (e) {
      AppLogger.it.logError('Error reading JSON file: $e');
      return null;
    }
  }
}
