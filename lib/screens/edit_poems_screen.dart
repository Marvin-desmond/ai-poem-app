import 'package:ai_poem_app/common.dart';

class EditPoems extends StatefulWidget {
  const EditPoems({super.key});

  @override
  State<EditPoems> createState() => _EditPoemsState();
}

class _EditPoemsState extends State<EditPoems> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PoemNotifier>(builder: (context, poemNotifier, child) {
        List<Poem> poems = poemNotifier.poems;
        return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
         children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top:6),
            padding: const EdgeInsets.only(top: 6, right: 10),
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text(
                  'New',
                  style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => context.push(ScreenPaths.createPoem),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xffFF185D)),
                  )
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: poems.length,
                itemBuilder: (BuildContext context, int index) {
                  return EditEachPoem(poem: poems[index]);
                }),
            ),
          ),
          ],
        ),
      );
      }),
    );
  }
}

class EditEachPoem extends StatelessWidget {
  const EditEachPoem({
    super.key,
    required this.poem,
  });

  final Poem poem;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border:
              Border.all(width: 1.0, color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
          image: poem.buffer == null
              ? DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.dstATop),
                  image:
                      const AssetImage("assets/images/default.png"),
                  fit: BoxFit.cover)
              : DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.dstATop),
                  image: MemoryImage(poem.buffer!),
                  fit: BoxFit.cover),
        ),
        height: 150,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                poem
                    .imaginePrompt[0]
                    .substring(0, 100)
                    .replaceAll(r"\", ""),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey[400]!,
                        offset: const Offset(2.0, 2.0),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                        Provider.of<PoemNotifier>(context, listen: false).setCreatedUpdatedPoem(poem);
                        context.push(ScreenPaths.updatePoem(poem.id));
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () =>
                        _dialogBuilder(context, poem),
                    icon: const Icon(Icons.delete_outline_sharp),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

Future<void> _dialogBuilder(BuildContext context, Poem poem) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xffE1EAF6),
        title: const Text(
          'delete poem...',
          style: TextStyle(fontFamily: "FuzzyBubbles"),
        ),
        content: Text(poem.poem),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff116AAA)
              ),
              ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Yes, delete',
              style: TextStyle(
                color: Color(0xffFE3E35)
              ),
              ),
            onPressed: () async {
              try {
                if (!context.mounted) return;
                Api().deletePoem(poem.id).then((value) {
                  if (value.acknowledged) {
                    Provider.of<PoemNotifier>(context, listen:false).deletePoem(poem.id);
                  }
                });
                Navigator.of(context).pop();
              } catch(e) {
                print("error deleting poem...");
              }
            },
          ),
        ],
      );
    },
  );
}
