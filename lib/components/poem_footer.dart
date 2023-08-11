import 'package:ai_poem_app/common.dart';

class PoemFooter extends StatelessWidget {
  const PoemFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: const <Widget>[
            Flexible(
              flex: 1,
              child: IconMessage(
                  icon: Icons.favorite,
                  iconColor: Colors.red,
                  message: "7541 Likes"),
            ),
            // Flexible(
            //   flex: 1,
            //   child: IconMessage(
            //       icon: Icons.chat_rounded,
            //       iconColor: Colors.blue,
            //       message: "302 comment"),
            // ),
          ]),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10.0),
          //   child: Row(
          //     children: <Widget>[
          //       Container(
          //         margin: const EdgeInsets.only(right: 5.0),
          //         child: const Text("marvinuiux"),
          //       ),
          //       Text(
          //         "A good one!",
          //         style: TextStyle(color: Colors.grey[400]),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class IconMessage extends StatelessWidget {
  const IconMessage(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.message});
  final IconData icon;
  final Color iconColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        Text(
          message,
          style: const TextStyle(
            fontFamily: 'FuzzyBubbles',
          ),
        )
      ],
    );
  }
}
