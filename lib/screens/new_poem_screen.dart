import 'package:ai_poem_app/common.dart';

class NewPoem extends StatefulWidget {
  const NewPoem({super.key});

  @override
  State<NewPoem> createState() => _NewPoemState();
}

class _NewPoemState extends State<NewPoem> {
  final ImagePicker picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "New poem",
                    style: TextStyle(
                      fontFamily: 'FuzzyBubbles',
                      fontWeight: FontWeight.w700,
                      color: Color(0xffFF185D),
                      fontSize: 18.0,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.fit_screen_outlined),
                      onPressed: () async {
                            try {
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              setState(() {
                                _image = File(image.path);
                              });
                            } catch (e) {
                              print("ERROR == ${e}");
                              // setState(() {
                              //   _pickImageError = e;
                              // });
                            }
                      })
                ],
              ),
            ),
            /* Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                          _image!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),*/
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                onPressed: () => context.pop(), icon: const Icon(Icons.close)
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                  onPressed: () {}, 
                  icon: Image.asset("assets/images/icon-quill.png"),
                  )
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            )
          ],
        ),
      ),
    );
  }
}
