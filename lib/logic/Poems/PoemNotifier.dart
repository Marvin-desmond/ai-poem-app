import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:ai_poem_app/common.dart';
import 'package:flutter/services.dart';

class PoemNotifier extends ChangeNotifier {
  Poem? currentPoem;
  Poem? tempPoem;
  Poem? createdUpdatedPoem;

  bool ifError = false;
  List<Poem> poems = [];
  String basePoem = "http://10.0.2.2:8080/api/poems";
  String basePics = "http://10.0.2.2:8080/api/pics";

  PoemNotifier() {
    getPoems().then((res) async {
      if (res.status == 200) {
        List<Poem> fetchedPoems = res.data;
        var secondRes = await getMetadata();
        if (secondRes.status == 200) {
          List<Metadata> picsMeta = secondRes.data;
          for (var poem in fetchedPoems) {
            var specificMeta = picsMeta.where((i) => i.poemId == poem.id).toList();
            if (specificMeta.isNotEmpty) {
              var thirdRes = await getPic(specificMeta[0].fileId);
              if (thirdRes.status == 200) {
                poem.buffer = base64Decode(thirdRes.data.buffer); 
              }
            }
          }
        }
        populate(fetchedPoems);
      } else  {
        ifError = true;
      }
    });
    // .then((_) {});
  }

  Future<ApiResponse> getPoems() async {
    final response =
        await http.get(Uri.parse(basePoem));
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load poems');
    }
  }
  
  Future<MetaResponse> getMetadata() async {
    final response =
        await http.get(Uri.parse("$basePics/getmeta"));
    if (response.statusCode == 200) {
      return MetaResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load meta data');
    }
  }

  Future<PicResponse> getPic(String fileId) async {
    final response =
        await http.get(Uri.parse("$basePics/get/$fileId"));
    if (response.statusCode == 200) {
      return PicResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load pic');
    }
  }

  Future<Iterable> readJson() async {
    final String response =
        await rootBundle.loadString('assets/files/image_models.json');
    Iterable userMap = await jsonDecode(response);
    return userMap;
  }

  void setCreatedUpdatedPoem(Poem poem) {
    createdUpdatedPoem = poem; 
    notifyListeners();
  }

  void clearCreatedUpdatedPoem() {
    createdUpdatedPoem = null;
  }

  void populate(List<Poem> fetchedPoems) {
    poems.addAll(fetchedPoems);
    notifyListeners();
  }

  void currentPoemUpdate(Poem poem) {
    currentPoem = poem;
    notifyListeners();
  }

  void checkPrevAndNextPoem({int current = 0}) {
    int limit = 2, max = current + limit, min = current - limit;
    int lengths = poems.length;

    int imageIndexToCheck;
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
      tempPoem = poems[imageIndexToCheck];
    }
    for (var i = current - 1; i >= min; i--) {
      imageIndexToCheck = getIndex(i);
      tempPoem = poems[imageIndexToCheck];
    }
  }
}
