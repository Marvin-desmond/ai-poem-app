import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_poem_app/wondrous/circle_buttons.dart';
import 'package:ai_poem_app/wondrous/app_icons.dart';
import 'package:ai_poem_app/wondrous/gradient_container.dart';
import 'package:ai_poem_app/wondrous/buttons.dart';

import 'dart:math';

part './wondrous/_vertical_swipe_controller.dart';
part './wondrous/_animated_arrow_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late final _VerticalSwipeController _swipeController =
      _VerticalSwipeController(this, _showDetailsPage);

  late final _pageController = PageController(
    viewportFraction: 1,
    initialPage:
        7 * 9999, // allow 'infinite' scrolling by starting at a very high page
  );

  late int _wonderIndex = 0;

  double? _swipeOverride;
  bool _fadeInOnNextBuild = false;

  void _handleOpenMenuPressed() async {
    setState(() => _isMenuOpen = true);
    setState(() => _isMenuOpen = false);
  }

  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    Navigator.pushNamed(context, '/second');
    await Future.delayed(100.ms);
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
  }

  @override
  Widget build(BuildContext context) {
    return _swipeController.wrapGestureDetector(Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cover.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          /// Floating controls / UI
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
                      Container(
                        child: const Text(
                          "Wonder title text",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      MergeSemantics(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,

                          /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                          key: ValueKey(_wonderIndex),
                          child: Stack(
                            children: [
                              /// Expanding rounded rect that grows in height as user swipes up
                              Positioned.fill(
                                child: _buildSwipeableArrowBg(),
                              ),

                              /// Arrow Btn that fades in and out
                              _AnimatedArrowButton(
                                  onTap: _showDetailsPage,
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
              opacity: _isMenuOpen ? 0 : 1,
              child: MergeSemantics(
                child: Semantics(
                  sortKey: const OrdinalSortKey(0),
                  child: CircleIconBtn(
                    icon: AppIcons.menu,
                    onPressed: _handleOpenMenuPressed,
                    semanticLabel: "homeSemanticOpenMain",
                  ).safe(),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
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
