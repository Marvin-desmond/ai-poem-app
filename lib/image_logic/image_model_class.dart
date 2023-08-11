import 'dart:ui';

import 'package:ai_poem_app/common.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ImageModelClass extends ChangeNotifier {
  ImageModel currentImage = ImageModel(254, "Kenya Here We Are",
      "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80");
  List<ImageModel> images = [];

  ImageModelClass() {
    readJson().then((response) {
      List<ImageModel> loadedImages = List<ImageModel>.from(
          response.map((model) => ImageModel.fromJson(model)));
      populate(loadedImages);
    });
  }

  Future<Iterable> readJson() async {
    final String response =
        await rootBundle.loadString('assets/files/image_models.json');
    Iterable userMap = await jsonDecode(response);
    return userMap;
  }

  void populate(List<ImageModel> imagesToAdd) {
    images.addAll(imagesToAdd);
    notifyListeners();
  }

  void currentModelUpdate(ImageModel image) {
    currentImage = image;
    notifyListeners();
  }

  void checkPrevAndNextImageModels({int current = 0}) {
    int limit = 2, max = current + limit, min = current - limit;
    int lengths = images.length;

    int imageIndexToCheck;
    ImageModel? tempImage;
    // x[x.length - 1]
    getIndex(int index) {
      if (index < 0) {
        return (lengths + index);
      } else if (index >= lengths) {
        return 0;
      } else {
        return index;
      }
    }

    for (var i = current + 1; i <= max; i++) {
      imageIndexToCheck = getIndex(i);
      tempImage = images[imageIndexToCheck];
    }
    for (var i = current - 1; i >= min; i--) {
      imageIndexToCheck = getIndex(i);
      tempImage = images[imageIndexToCheck];
    }
  }
}
