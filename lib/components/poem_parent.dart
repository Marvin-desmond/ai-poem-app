import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/components/poem_footer.dart';

class PoemParent extends StatelessWidget {
  const PoemParent({super.key, required this.poem});
  final String poem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <Widget>[
          PoemChild(poem: poem),
          const PoemFooter(),
        ],
      ),
    );
  }
}

class PoemChild extends StatefulWidget {
  const PoemChild({super.key, required this.poem});
  final String poem;
  @override
  State<PoemChild> createState() => _PoemChildState();
}

class _PoemChildState extends State<PoemChild> {
  final globalKey = GlobalKey<_PoemTextState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        padding: const EdgeInsets.all(15.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PoemText(key: globalKey, poemContents: widget.poem);
          },
        ),
      ),
    );
  }
}

class PoemText extends StatefulWidget {
  const PoemText({super.key, required this.poemContents});

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
