import 'package:ai_poem_app/common.dart';
import 'package:ai_poem_app/helpers/app_backdrop.dart';

class GridPoem extends StatefulWidget {
  const GridPoem({super.key, required this.index, required this.data});
  final Poem data;
  final int index;

  @override
  State<GridPoem> createState() => _GridPoemState();
}

class _GridPoemState extends State<GridPoem> {
  var poems = [];

  void _handlePoemPressed(BuildContext context, Poem data) =>
      Navigator.pop(context, data);

  @override
  Widget build(BuildContext context) {
    return Consumer<PoemNotifier>(
        builder: (context, poemNotifier, child) {
      poems = poemNotifier.poems;
      return Stack(
        children: [
          AppBackdrop(
            strength: .5,
            child: Container(
              color: Colors.grey.withOpacity(.4),
            ),
          ),
          SafeArea(
            child: PaddedRow(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.transparent,
                    child: Container(
                      color: Colors.transparent,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.transparent)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                const Spacer(),
              ],
            ),
          ),

          /// Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(flex: 1),
                    _buildIconGrid(context, widget.index)
                        .animate()
                        .fade(duration: const Duration(milliseconds: 300))
                        .scale(begin: const Offset(0.8, 0), curve: Curves.easeOut),
                    const Spacer(flex: 1),
                    const Gap(48),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildIconGrid(BuildContext context, int widgetIndex) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: GridView.builder(
                  itemCount: poems.length,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) => Container(
                    child: _buildGridBtn(
                        context, index, widgetIndex, poems[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridBtn(
      BuildContext context, int index, int widgetIndex, Poem currentPoem) {
    bool isSelected = index == widgetIndex;
    return GestureDetector(
      onTap: () {
        _handlePoemPressed(context, currentPoem);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: !isSelected
                ? null
                : Border.all(color: const Color(0xFFF8ECE5), width: 3.0),
            color: Colors.grey.withOpacity(0.7)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox.expand(
              child: Container(
                          decoration: BoxDecoration(
                          image: currentPoem.buffer == null ? 
                          const DecorationImage(
                            image: AssetImage("assets/images/default.png"),
                            fit: BoxFit.cover
                          ) : 
                          DecorationImage(
                            image: MemoryImage(currentPoem.buffer!),
                            fit: BoxFit.cover
                          ) 
                        ),
              )
              ),
        ),
      ),
    );
  }
}
