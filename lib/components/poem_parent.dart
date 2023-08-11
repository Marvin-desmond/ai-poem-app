import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/components/poem_footer.dart';

class PoemParent extends StatelessWidget {
  const PoemParent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
      child: Column(
        children: const <Widget>[
          PoemChild(),
          PoemFooter(),
        ],
      ),
    );
  }
}

class PoemChild extends StatefulWidget {
  const PoemChild({Key? key}) : super(key: key);
  @override
  State<PoemChild> createState() => _PoemChildState();
}

class _PoemChildState extends State<PoemChild> {
  String poemContents = "";
  final globalKey = GlobalKey<_PoemTextState>();
  String message = "";

  @override
  void initState() {
    loadAsset(context).then((value) => {
          setState(() {
            poemContents = value;
          })
        });
    super.initState();
  }

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/files/01_poem.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        padding: const EdgeInsets.all(15.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PoemText(key: globalKey, poemContents: poemContents);
          },
        ),
      ),
    );
  }
}

class PoemText extends StatefulWidget {
  const PoemText({
    Key? key,
    required this.poemContents,
  }) : super(key: key);

  final String poemContents;

  @override
  State<PoemText> createState() => _PoemTextState();
}

class _PoemTextState extends State<PoemText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.poemContents * 3,
      style: const TextStyle(
        fontFamily: 'FuzzyBubbles',
        fontWeight: FontWeight.bold,
        height: 1.8,
      ),
    );
  }
}
