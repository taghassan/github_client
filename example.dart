import 'package:app_logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:github_client/base_data_model.dart';
import 'package:github_client/github_client.dart';

void main() {
  runApp(const MyApp());
}

class DataModel extends BaseDataModel {
  DataModel() {
    /* ... */
  }
  DataModel.fromJson(dynamic json) {
    AppLogger.it.logDebug("fromJson - json ${json['CheckOut_Pro']}"); /* ... */
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    /* .... */
    return map;
  }

  @override
  BaseDataModel parser(Map<String, dynamic> json) => DataModel.fromJson(json);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  GithubClient client =
      GithubClient(owner: "taghassan", auth: GitHubAuthentication.anonymous());

  @override
  void initState() {
    client.syncProgressListStream.stream.listen(
      (event) {
        if (event is ProgressModel) {
          try {
            AppLogger.it.logInfo("event message ${event}");
          } catch (e) {
            AppLogger.it.logError("event message ${e}");
          }
        }
      },
    );
    super.initState();
  }

  void _incrementCounter() async {
    try {
      BaseDataModel? response = await client.fetchGithubData<DataModel>(
          model: DataModel(),
          pathInRepo: "apps",
          repositoryName: "ads_keys",
          folder: "apps");
      AppLogger.it.logDeveloper(response.toString());

      if (response is BaseDataModel) {
        // hande reponse here
        print(response.toString());
      } else {
        // hande error reponse here
      }
    } catch (e) {
      AppLogger.it.logError("error $e");
      // hande error reponse here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
