import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/components/new_poem_tab.dart';
import 'package:ai_poem_app/components/prompt_tab.dart';

class NewPoem extends StatefulWidget {
  const NewPoem({super.key});

  @override
  State<NewPoem> createState() => _NewPoemState();
}

class _NewPoemState extends State<NewPoem> {
  @override
  void initState() {
    super.initState();
    Provider.of<PoemNotifier>(context, listen: false).clearCreatedUpdatedPoem();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10.0,
            bottom: const TabBar(
            tabs: [
                  Tab(text: "Poem"),
                  Tab(text: "Prompt")
                ]
            ),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
          children: [
          NewPoemTab(
            bottomContextHeight: MediaQuery.of(context).viewInsets.bottom
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

