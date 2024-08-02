import 'package:ai_poem_app/common.dart';

class PromptTab extends StatefulWidget {
  const PromptTab({super.key});

  @override
  State<PromptTab> createState() => _PromptTabState();
}

class _PromptTabState extends State<PromptTab> {
  String testPrompt = "Imaginative prompt...";

  @override
  Widget build(BuildContext context) {
    return Consumer<PoemNotifier>(
      builder: (BuildContext context, PoemNotifier value, Widget? child) {
        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 35.0),
                      decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.blue[100]
                      ),
                    child: Text(
                      value.createdUpdatedPoem !=null ? value.createdUpdatedPoem!.imaginePrompt[0] : testPrompt.replaceAll(r"\", ""),
                      style: TextStyle( 
                        fontFamily: 'Andika',
                        fontSize: 15.0,
                        color: Colors.grey[700]
                      ),
                      )
                    ),
                ),
                Positioned(
                  bottom: 5,
                  left: 20,
                  child: FilledButton.icon(
                    icon: const Image(
                    height: 40,
                    image: AssetImage("assets/images/gen_ai.png"),
                    ),
                    label: const Text(
                    'Generate',
                    style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                onPressed: () {
                  
                },
                iconAlignment: IconAlignment.start,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue[400]!),
                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(15, 5, 15, 5))
                )
                /*style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[400]!,
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                  ),
                )*/
              )
              )
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration( 
                  color: Colors.grey.shade300,
                  // border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                margin: const EdgeInsets.only(left:15.0, top:5.0, right:15.0, bottom: 15),
              ),
            )
          ],
        );
       }
    );
  }
}