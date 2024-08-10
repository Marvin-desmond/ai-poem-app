import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/components/new_poem_tab.dart';
import 'package:ai_poem_app/components/prompt_tab.dart';

class NewPoem extends StatefulWidget {
  const NewPoem({super.key, required this.id});
  final String? id;

  @override
  State<NewPoem> createState() => _NewPoemState();
}

class _NewPoemState extends State<NewPoem> {
  final _controller = TextEditingController();
  late PoemNotifier poemNotifierInDispose;
  bool acknowledged = false;

  @override
  void initState() {
    super.initState();
    Poem? fetchedPoem = Provider.of<PoemNotifier>(context, listen: false).createdUpdatedPoem;
    if (fetchedPoem != null) {
      _controller.text = fetchedPoem.poem;
    }
  }

  void setAcknowledged() {
    setState(() {
      acknowledged = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    poemNotifierInDispose = Provider.of<PoemNotifier>(context, listen: false);
  }

  @override 
  void dispose() {
    poemNotifierInDispose.clearCreatedUpdatedPoem();
    super.dispose();
  }

  String? editedPoemTextFromChild;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10.0,
            bottom: TabBar(
            onTap: (index) {
              if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
                  FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            tabs: const[
                  Tab(text: "Poem"),
                  Tab(text: "Prompt")
                ]
            ),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
          children: [
          NewPoemTab(
            bottomContextHeight: MediaQuery.of(context).viewInsets.bottom,
            textEditController: _controller,
            setAcknowledged: setAcknowledged,
            acknowledged: acknowledged,
            id: widget.id
          ),
          const Center(
            child: PromptTab()
            ),
          ]),
        ),
      ),
    );
  }
}

