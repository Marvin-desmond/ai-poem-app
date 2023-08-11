import 'package:ai_poem_app/common.dart';

import 'package:ai_poem_app/helpers/circle_buttons.dart';
import 'package:ai_poem_app/helpers/app_icons.dart';
import 'package:ai_poem_app/helpers/gradient_container.dart';
import 'package:ai_poem_app/helpers/buttons.dart';

import 'package:ai_poem_app/animations/app_page_indicator.dart';
import 'package:ai_poem_app/screens/grid_poem_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

part '../animations/_vertical_swipe_controller.dart';
part '../animations/_animated_arrow_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late final _VerticalSwipeController _swipeController =
      _VerticalSwipeController(this, () => _showDetailsPage());

  final controller = PageController(
    viewportFraction: 1,
    initialPage:
        10000, // allow 'infinite' scrolling by starting at a very high page
  );

  late int _modelIndex = 0;
  double? _swipeOverride;
  bool _fadeInOnNextBuild = false;
  bool initialLoad = false;
  List<ImageModel> models = [];
  final defaultImageModel = ImageModel(254, "Kenya Here We Are",
      "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80");
  ImageModel currentModel = ImageModel(254, "Kenya Here We Are",
      "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80");
  int currentId = 1;
  late String currentName;

  @override
  void initState() {
    super.initState();
    currentName = currentModel.name;
  }

  void _handleOpenMenuPressed() async {
    setState(() => _isMenuOpen = true);
    ImageModel? pickedImage =
        await appLogic.showFullscreenDialogRoute<ImageModel>(
      context,
      GridPoem(index: _modelIndex, data: currentModel),
    );
    setState(() => _isMenuOpen = false);
    if (pickedImage != null) {
      _setPageIndex(models.indexWhere((x) => x == pickedImage));
    }
  }

  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);

  void _handlePageViewChanged(v) {
    setState(() {
      _modelIndex = v % models.length;
    });
  }

  void _setPageIndex(int index) {
    if (index == _modelIndex) return;
    final pos =
        ((controller.page ?? 0) / models.length).floor() * models.length;
    controller.jumpToPage(pos + index);
  }

  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    if (models.isNotEmpty) {
      context.push(ScreenPaths.imageDetails(currentId));
    }
    await Future.delayed(100.ms);
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageModelClass>(
        builder: (context, imageModelClass, child) {
      if (models.isNotEmpty && !initialLoad) {
        currentName = models[0].name;
        initialLoad = true;
      }
      models = imageModelClass.images;
      return Stack(children: [
        PageView.builder(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              int index = (value - 10000) % models.length;
              currentId = index + 1;
              currentName = models[index % models.length].name;
              Provider.of<ImageModelClass>(context, listen: false)
                  .checkPrevAndNextImageModels(current: index);
              _handlePageViewChanged(index % models.length);
            });
          },
          itemBuilder: (_, index) {
            currentModel = models.isEmpty
                ? defaultImageModel
                : models[index % models.length];
            return _swipeController.wrapGestureDetector(Center(
              child: CachedNetworkImage(
                imageUrl: currentModel.image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    Consumer<ImageModelClass>(
                        builder: (context, imageModelClass, child) {
                      return Text(
                        currentName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Andika',
                            decoration: TextDecoration.none),
                      );
                    }),
                    Consumer<ImageModelClass>(
                        builder: (context, imageModelClass, child) {
                      return AppPageIndicator(
                        count: imageModelClass.images.isEmpty
                            ? 1
                            : imageModelClass.images.length,
                        controller: controller,
                        color: Colors.white,
                        onDotPressed: _handlePageIndicatorDotPressed,
                        dotSize: 8,
                      );
                    }),
                    MergeSemantics(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,

                        /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                        key: ValueKey(_modelIndex),
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

        Positioned(
          left: MediaQuery.of(context).size.width * 0.3, 
          top: 50.0,
          child: IconButton(onPressed: () => context.push(ScreenPaths.infiniteScroll), 
          icon: const Icon(
            Icons.call_made_rounded,
            color: Colors.green,
          )  
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
                border: Border.all(color: Colors.white, width: 1.0)),
            child: IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () => context.push(ScreenPaths.newPoem),
            ),
          ),
        ))
      ]);
    });
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
