import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppPageIndicator extends StatefulWidget {
  AppPageIndicator(
      {Key? key,
      required this.count,
      required this.controller,
      this.onDotPressed,
      this.color,
      this.dotSize})
      : super(key: key);
  final int count;
  final PageController controller;
  final void Function(int index)? onDotPressed;
  final Color? color;
  final double? dotSize;

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {
  final _currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handlePageChanged);
  }

  int get _controllerPage => widget.controller.page?.round() ?? 0;

  void _handlePageChanged() => _currentPage.value = _controllerPage;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.transparent,
        height: 30,
        alignment: Alignment.center,
        child: ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (_, value, child) {
              return Semantics(
                  container: true, liveRegion: true, child: Container());
            }),
      ),
      Positioned.fill(
        child: Center(
          child: ExcludeSemantics(
            child: SmoothPageIndicator(
              controller: widget.controller,
              count: widget.count,
              onDotClicked: widget.onDotPressed,
              effect: ScrollingDotsEffect(
                  dotWidth: widget.dotSize ?? 6,
                  dotHeight: widget.dotSize ?? 6,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: (widget.dotSize ?? 6) / 2,
                  dotColor: Colors.white,
                  activeDotColor: Colors.white,
                  maxVisibleDots: 5
                  ),
            ),
          ),
        ),
      ),
    ]);
  }
}
