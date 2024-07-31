import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Path_provider installation.
///
/// If the error MissingPluginException (No implementation found..) is thrown,
/// You need to rebuild the application as the plugin can't be found
///
///
class PoemWidget extends StatelessWidget {
  const PoemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: const Column(
        children: <Widget>[
          // Expanded(
          //   child: GetContent(storage: CounterStorage()),
          // ),
          Expanded(
            child: PoemFromFile(),
          )
        ],
      ),
    );
  }
}

class PoemFromFile extends StatefulWidget {
  const PoemFromFile({super.key});
  @override
  State<PoemFromFile> createState() => _PoemFromFileState();
}

class _PoemFromFileState extends State<PoemFromFile> {
  String poemContents = "";

  @override
  Widget build(BuildContext context) {
    Future<String> loadAsset(BuildContext context) async {
      return await DefaultAssetBundle.of(context)
          .loadString('assets/files/01_poem.txt');
    }

    loadAsset(context).then((value) => {
          setState(() {
            poemContents = value;
          })
        });
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Text(poemContents),
    );
  }
}

class GetContent extends StatefulWidget {
  const GetContent({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<GetContent> createState() => _GetContentState();
}

class _GetContentState extends State<GetContent> {
  String path = "";
  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        path = value;
      });
    });
  }

  Future<void> _incrementCounter() async {
    widget.storage.readCounter().then((value) {
      setState(() {
        path = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Path $path now")),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _localFile async {
    final path = await _localPath;
    return path;
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      return file;
    } catch (e) {
      return "";
    }
  }
}
