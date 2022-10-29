import 'package:flutter/material.dart';

class PoemParent extends StatelessWidget {
  const PoemParent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
      child: Column(
        children: const <Widget>[
          PoemChild(),
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
  late ScrollController _controller;
  String message = "";
  final globalKey = GlobalKey<_PoemTextState>();

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    } else if (_controller.offset >=
            _controller.position.maxScrollExtent - 10 &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    } else {
      message = "scrolling";
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
    super.initState();
  }

  void getHeight() {
    final _PoemTextState state = globalKey.currentState!;
    final BuildContext context = globalKey.currentContext!;
    final RenderBox box = state.context.findRenderObject() as RenderBox;
    print("HEIGHT: ${box.constraints}");
    print("HEIGHT 2 : ${context.size!.height}");
    state.runFun();
  }

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
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        padding: const EdgeInsets.all(5.0),
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Text(message),
                ),
                PoemText(
                    key: globalKey,
                    controller: _controller,
                    poemContents: poemContents),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xffe94c89),
                    child: Text("${constraints.maxHeight.round()}"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PoemText extends StatefulWidget {
  const PoemText({
    Key? key,
    required ScrollController controller,
    required this.poemContents,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;
  final String poemContents;

  @override
  State<PoemText> createState() => _PoemTextState();
}

class _PoemTextState extends State<PoemText> {
  void runFun() {
    print("Run Fun");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget._controller,
      child: Text(
        widget.poemContents * 1,
        style: const TextStyle(
          fontFamily: 'FuzzyBubbles',
          fontWeight: FontWeight.bold,
          height: 1.8,
        ),
      ),
    );
  }
}
