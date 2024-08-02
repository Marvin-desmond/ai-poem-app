import 'package:ai_poem_app/common.dart';

import 'package:ai_poem_app/components/profile_bar.dart';
import 'package:ai_poem_app/components/poem_parent.dart';


class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: MainPage(id: id)),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.id});
  final String id;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScrollController _scroller = ScrollController()
    ..addListener(_handleScrollChanged);
  final _scrollPos = ValueNotifier(0.0);
  final _scrollToPopThreshold = 50;
  String defaultImage = "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80";

  bool _isPointerDown = false;
  bool _checkPointerIsDown(d) => _isPointerDown = d.dragDetails != null;

  late Poem currentPoem;

  void _handleDetailsScrolled(double scrollPos) =>
      _detailsHasScrolled.value = scrollPos > 0;
  final _detailsHasScrolled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    List<Poem> poems =
        Provider.of<PoemNotifier>(context, listen: false).poems;
    currentPoem = poems.firstWhere((e) => e.id == widget.id);
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  /// Various [ValueListenableBuilders] are mapped to the _scrollPos and will rebuild when it changes
  void _handleScrollChanged() {
    _scrollPos.value = _scroller.position.pixels;
    _handleDetailsScrolled.call(_scrollPos.value);
    // If user pulls far down on the elastic list, pop back to
    if (_scrollPos.value < -_scrollToPopThreshold) {
      if (_isPointerDown) {
        Navigator.pop(context);
        _scroller.removeListener(_handleScrollChanged);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: _checkPointerIsDown,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              controller: _scroller,
              slivers: <Widget>[
                SliverAppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  backgroundColor: Colors.black,
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  snap: false,
                  actionsIconTheme: const IconThemeData(opacity: 0.0),
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: 
                        Container(
                          decoration: BoxDecoration(
                          image: currentPoem.buffer == null ? 
                          DecorationImage(
                            image: NetworkImage(defaultImage),
                            fit: BoxFit.cover
                          ) : 
                          DecorationImage(
                            image: MemoryImage(currentPoem.buffer!),
                            fit: BoxFit.cover
                          ) 
                        ),
                        ),
                      )),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: ScrollMainContent(poem: currentPoem.poem))
              ],
            ),
          ),
          const Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ToggleLike(),
              )),
        ]),
      ),
    );
  }
}

class ScrollMainContent extends StatelessWidget {
  const ScrollMainContent({super.key, required this.poem});
  final String poem;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        const ProfileBar(),
        PoemParent(poem: poem),
      ]),
    );
  }
}

class ToggleLike extends StatefulWidget {
  const ToggleLike({super.key});

  @override
  State<ToggleLike> createState() => _ToggleLikeState();
}

class _ToggleLikeState extends State<ToggleLike> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      width: 35.0,
      child: IconButton(
        iconSize: 25.0,
        icon: liked
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
        onPressed: () {
          setState(() {
            liked = !liked;
          });
        },
      ),
    );
  }
}
