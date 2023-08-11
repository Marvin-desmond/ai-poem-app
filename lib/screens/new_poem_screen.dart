import 'package:ai_poem_app/common.dart';
import 'package:rive/rive.dart';

class NewPoem extends StatelessWidget {
  const NewPoem({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Text(
                    "New poem",
                    style: TextStyle(
                      fontFamily: 'FuzzyBubbles',
                      fontWeight: FontWeight.w700,
                      color: Color(0xffFF185D),
                      fontSize: 18.0,
                    ),
                  ),
                  const Gap(15),
                  Flexible(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(10.0)),
                        ),
                        child: const RiveAnimation.asset(
                          "assets/rive/vehicles.riv",
                          fit: BoxFit.cover,
                        )),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: MediaQuery.of(context).size.height * 0.62,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: const TextField(
                  style: TextStyle(fontFamily: "FuzzyBubbles"),
                  maxLines: null, //or null
                  decoration: InputDecoration.collapsed(
                      hintText: "Write your imaginations here...",
                      hintStyle: TextStyle(fontFamily: 'FuzzyBubbles')),
                ),
              ),
            ),
            const Text("Hello new poem!"),
            IconButton(
                onPressed: () => context.pop(), icon: const Icon(Icons.close)),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            )
          ],
        ),
      ),
    );
  }
}
