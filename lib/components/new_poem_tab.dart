import 'package:ai_poem_app/common.dart';

class NewPoemTab extends StatefulWidget {
  const NewPoemTab({
    super.key, 
    required this.bottomContextHeight, 
    required this.textEditController,
    required  this.setAcknowledged,
    required this.acknowledged,
    required this.id
    });
  final double bottomContextHeight;
  final TextEditingController textEditController;
  final String? id;
  final bool acknowledged;
  final Function setAcknowledged;

  @override
  State<NewPoemTab> createState() => _NewPoemTabState();
}

class _NewPoemTabState extends State<NewPoemTab> {
  final ImagePicker picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  IconButton(
                  onPressed: (){
                    if (widget.bottomContextHeight > 0.0) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                        if (widget.acknowledged) {
                          if (widget.id != null) {
                            Provider.of<PoemNotifier>(context, listen: false).addUpdatedPoem(widget.id!);
                          }
                          else {
                            Provider.of<PoemNotifier>(context, listen: false).addCreatedPoem();
                          }
                        }
                    context.pop();
                    }
                  }, icon: const Icon(Icons.close)
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
                              // ignore: empty_catches
                              } catch (e) {}
                    }),
                    IconButton(
                    onPressed: () async {
                      String editedPoem = widget.textEditController.text;
                      dynamic response; 
                      Poem? returnedPoem;
                      try {
                      Poem? createdUpdatedPoem = Provider.of<PoemNotifier>(context, listen: false).createdUpdatedPoem;
                      if (createdUpdatedPoem == null) {
                         response = await Api().createPoem(editedPoem);
                         returnedPoem = await Api().getPoem(response.insertedId);
                      } else {
                          response = await Api().updatePoem(createdUpdatedPoem.id, editedPoem);
                          returnedPoem = await Api().getPoem(createdUpdatedPoem.id);
                      }
                      if (response.acknowledged) {
                          setState(() {
                           widget.setAcknowledged();
                           FocusScope.of(context).unfocus();
                           Provider.of<PoemNotifier>(context, listen: false).setCreatedUpdatedPoem(returnedPoem!);
                           DefaultTabController.of(context).animateTo(1);
                          });
                      }
                      } catch(e) {
                        print(e);
                      }
                    }, 
                    icon: Image.asset("assets/images/icon-quill.png"),
                    )
                  ],
                ),
              ),
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
                  child: TextField(
                    controller: widget.textEditController,
                    style: const TextStyle(fontFamily: "FuzzyBubbles"),
                    maxLines: null, //or null
                    decoration: const InputDecoration.collapsed(
                        hintText: "Write your imaginations here...",
                        hintStyle: TextStyle(fontFamily: 'FuzzyBubbles')),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        );
  }
}