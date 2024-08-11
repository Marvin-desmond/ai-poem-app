import 'dart:ui';

import 'package:ai_poem_app/common.dart';

import 'package:ai_poem_app/helpers/gradient_container.dart';
import 'package:ai_poem_app/helpers/buttons.dart';

import 'package:ai_poem_app/animations/app_page_indicator.dart';
import 'package:ai_poem_app/screens/grid_poem_screen.dart';

part '../animations/_vertical_swipe_controller.dart';
part '../animations/_animated_arrow_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int initialPageSize;
  bool _isMenuOpen = false;
  late final _VerticalSwipeController _swipeController =
      _VerticalSwipeController(this, () => _showDetailsPage());

  late PageController controller;

  late int _poemIndex = 0;
  double? _swipeOverride;
  bool _fadeInOnNextBuild = false;
  bool initialLoad = false;
  List<Poem> poems = [];
  Poem currentPoem = Poem(
      "123456789",
      """
    If high school me could see me now
    I bet high school me would be so proud, she'd find out
    The cool kids, they ain't everything
    The world is so much bigger then her town
    If high school me could see me now
    """,
      ["imagine poem"],
      [DateTime.now()],
      ["123456789"],
      null);
  String? currentId;
  late String currentImaginePrompt;

  @override
  void initState() {
    super.initState();
    currentImaginePrompt = currentPoem.imaginePrompt[0];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleOpenMenuPressed() async {
    setState(() => _isMenuOpen = true);
    Poem? pickedPoem = await appLogic.showFullscreenDialogRoute<Poem>(
      context,
      GridPoem(index: _poemIndex, data: currentPoem),
    );
    setState(() => _isMenuOpen = false);
    if (pickedPoem != null) {
      _setPageIndex(poems.indexWhere((x) => x == pickedPoem));
    }
  }

  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);

  void _handlePageViewChanged(v) {
    setState(() {
      _poemIndex = v % poems.length;
    });
  }

  void _setPageIndex(int index) {
    if (index == _poemIndex) return;
    final pos = ((controller.page ?? 0) / poems.length).floor() * poems.length;
    controller.jumpToPage(pos + index);
  }

  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    if (poems.isNotEmpty && currentId != null) {
      context.push(ScreenPaths.imageDetails(currentId!));
    }
    await Future.delayed(100.ms);
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PoemNotifier>(builder: (context, poemNotifier, child) {
      /* 
          an interesting bug fix due to dynamic changes in data but pagecontroller
          page size modulus is non-zero, leading to offset of zero index in data
          shown
          */
      initialPageSize = poemNotifier.poems.length * 6000;
      controller = PageController(
          viewportFraction: 1,
          initialPage:
              initialPageSize // allow 'infinite' scrolling by starting at a very high page
          );
      if (poems.isNotEmpty && !initialLoad) {
        currentId = poems[0].id;
        currentPoem = poems[0];
        currentImaginePrompt = poems[0].imaginePrompt[0];
        initialLoad = true;
      }
      poems = poemNotifier.poems;
      return poems.isEmpty
          ? Center(
            child: Container(
              decoration:  BoxDecoration(
              color: Colors.grey[800],
            image: const DecorationImage(
                image: AssetImage('assets/images/default.png'), 
                fit: BoxFit.contain),
              ),
              child: Center(
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 30.0,),
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
                    const SizedBox(height: 30.0,)
                  ],
                )
                )
              ),
          )
          : PagePoems(context, poemNotifier);
    });
  }

  Stack PagePoems(BuildContext context, PoemNotifier poemNotifier) {
    return Stack(children: [
      PageView.builder(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            int index = (value - initialPageSize) % poems.length;
            currentId = poems[index % poems.length].id;
            currentImaginePrompt = poems[index % poems.length].imaginePrompt[0];
            Provider.of<PoemNotifier>(context, listen: false)
                .checkPrevAndNextPoem(current: index);
            _handlePageViewChanged(index % poems.length);
          });
        },
        itemBuilder: (_, index) {
          currentPoem =
              poems.isEmpty ? currentPoem : poems[index % poems.length];
          final foreDecoration = BoxDecoration(
            image: currentPoem.buffer == null
                ? const DecorationImage(
                image: AssetImage('assets/images/default.png'), 
                fit: BoxFit.contain)
                : DecorationImage(
                    image: MemoryImage(currentPoem.buffer!),
                    fit: BoxFit.contain),
          );
          final backDecoration = BoxDecoration(
            image: currentPoem.buffer == null
                ? const DecorationImage(
                image: AssetImage('assets/images/default.png'), 
                fit: BoxFit.cover)
                : DecorationImage(
                    image: MemoryImage(currentPoem.buffer!), fit: BoxFit.cover),
          );
          return _swipeController.wrapGestureDetector(Center(
            child: Container(
              decoration: backDecoration,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: foreDecoration,
                ),
              ),
            ),
          ));
        },
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: RepaintBoundary(
          child: IgnorePointer(
            ignoringSemantics: false,
            child: OverflowBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: double.infinity),
                  const Spacer(),
                  Text(
                      '${currentImaginePrompt.substring(0, 100).replaceAll(r"\", "")}...',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0)),
                  AppPageIndicator(
                    count: poemNotifier.poems.isEmpty
                        ? 1
                        : poemNotifier.poems.length,
                    controller: controller,
                    color: Colors.white,
                    onDotPressed: _handlePageIndicatorDotPressed,
                    dotSize: 8,
                  ),
                  MergeSemantics(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,

                      /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                      key: ValueKey(_poemIndex),
                      child: Stack(
                        children: [
                          /// Expanding rounded rect that grows in height as user swipes up
                          Positioned.fill(
                            child: _buildSwipeableArrowBg(),
                          ),

                          /// Arrow Btn that fades in and out
                          _AnimatedArrowButton(
                              onTap: () => _showDetailsPage(),
                              semanticTitle: "currentWonder.title"),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),

      /// Menu Btn
      TopLeft(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isMenuOpen ? 0.1 : 1,
          child: Container(
          margin: const EdgeInsets.only(top: 45.0, right: 28.0, left: 18.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade700.withOpacity(0.3),
              border: Border.all(color: Colors.white, width: 1.0)),
          child: IconButton(
            iconSize: 10,
            icon: Image.asset(
              "assets/images/icon-menu.png",
              height: 30.0,
              ),
            color: Colors.white,
            onPressed: () => _handleOpenMenuPressed(),
            ),
          ),
        ),
      ),
      TopRight(
          child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isMenuOpen ? 0.1 : 1,
        child: Container(
          margin: const EdgeInsets.only(top: 45.0, right: 28.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade700.withOpacity(0.3),
              border: Border.all(color: Colors.white, width: 1.0)),
          child: IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () => context.push(ScreenPaths.editPoems),
          ),
        ),
      ))
    ]);
  }

  Widget _buildSwipeableArrowBg() {
    return _swipeController.buildListener(
      builder: (swipeAmt, _, child) {
        double heightFactor = .5 + .5 * (1 + swipeAmt * 4);
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: heightFactor,
          child: Opacity(opacity: swipeAmt * .5, child: child),
        );
      },
      child: VtGradient(
        [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(1),
        ],
        const [.3, 1],
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
