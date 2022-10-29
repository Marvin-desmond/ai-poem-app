import 'package:flutter/material.dart';
import 'package:ai_poem_app/poem_footer.dart';

class PoemParent extends StatelessWidget {
  const PoemParent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
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
  late ScrollController _controller;
  final globalKey = GlobalKey<_PoemTextState>();
  String message = "";
  double scrollerHeight = 0.0;
  bool scrollDown = true;

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
        scrollDown = true;
      });
    } else if (_controller.offset >=
            _controller.position.maxScrollExtent - 10 &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
        scrollDown = false;
      });
    } else {
      message = "scrolling";
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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

  void getHeight() {
    final _PoemTextState state = globalKey.currentState!;
    setState(() {
      scrollerHeight = state.totalScrollHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHeight();
    });
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(1),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xffDDDDDD),
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 0.0),
            ),
            //you can set more BoxShadow() here
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        padding: const EdgeInsets.all(25.0),
        height: MediaQuery.of(context).size.height * 0.75,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child: Text(
                //       "$message $scrollerHeight ${constraints.maxHeight.round()}"),
                // ),
                PoemText(
                    key: globalKey,
                    controller: _controller,
                    poemContents: poemContents),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: scrollerHeight > constraints.maxHeight
                      ? AnimatedFloatButton(
                          scrollDown: scrollDown, controller: _controller)
                      : const Offstage(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedFloatButton extends StatefulWidget {
  const AnimatedFloatButton({
    Key? key,
    required this.scrollDown,
    required ScrollController controller,
  })  : _controller = controller,
        super(key: key);

  final bool scrollDown;
  final ScrollController _controller;

  @override
  State<AnimatedFloatButton> createState() => _AnimatedFloatButtonState();
}

class _AnimatedFloatButtonState extends State<AnimatedFloatButton> {
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(seconds: 2),
      child: FloatingActionButton(
        onPressed: () {
          if (widget.scrollDown) {
            widget._controller.animateTo(widget._controller.offset + 50,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 500));
          } else {
            widget._controller.animateTo(widget._controller.offset - 50,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 500));
          }
        },
        backgroundColor: const Color(0xffe94c89),
        child: widget.scrollDown
            ? const Icon(Icons.keyboard_arrow_down)
            : const Icon(Icons.keyboard_arrow_up),
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
  double totalScrollHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        totalScrollHeight =
            context.size!.height + widget._controller.position.maxScrollExtent;
      });
    });

    return SingleChildScrollView(
      controller: widget._controller,
      child: Text(
        widget.poemContents * 3,
        style: const TextStyle(
          fontFamily: 'FuzzyBubbles',
          fontWeight: FontWeight.bold,
          height: 1.8,
        ),
      ),
    );
  }
}
