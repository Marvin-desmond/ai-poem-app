import 'package:flutter/material.dart';
import 'package:ai_poem_app/profile_bar.dart';
import 'package:ai_poem_app/poem.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(body: MainPage()),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        CustomScrollView(
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
              snap: true,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: Image.asset(
                      "assets/images/cover.jpg",
                      fit: BoxFit.cover,
                    ),
                  )),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width,
                mainAxisExtent: MediaQuery.of(context).size.height,
              ),
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  child: Column(children: const <Widget>[
                    ProfileBar(),
                    PoemParent(),
                  ]),
                )
              ]),
            ),
          ],
        ),
        const Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ToggleLike(),
            )),
      ]),
    );
  }
}

class ToggleLike extends StatefulWidget {
  const ToggleLike({
    Key? key,
  }) : super(key: key);

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
