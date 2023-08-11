import 'package:ai_poem_app/common.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/cover.jpg',
                      ),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth),
                ),
              ),
              const Text(
                "Poetic Beauty",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'FuzzyBubbles'),
              ),
            ],
          ),
          SizedBox(
            // width: MediaQuery.of(context).size.width / 5,
            width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.watch_later_outlined,
                  color: Colors.grey[700],
                  size: 18.0,
                ),
                const Text(
                  "5h",
                  style: TextStyle(fontFamily: 'FuzzyBubbles'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
