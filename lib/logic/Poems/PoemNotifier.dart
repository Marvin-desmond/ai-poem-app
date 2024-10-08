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
  String basePoem = "https://acceptable-comfort-production.up.railway.app/api/poems";
  String basePics = "https://acceptable-comfort-production.up.railway.app/api/pics";

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
                if (thirdRes.data.buffer != null) {
                poem.buffer = base64Decode(thirdRes.data.buffer!); 
                }
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
  
  Future<MetadataResponse> getMetadata() async {
    final response =
        await http.get(Uri.parse("$basePics/getmeta"));
    if (response.statusCode == 200) {
      return MetadataResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load meta data');
    }
  }

  Future<PicDataResponse> getPic(String fileId) async {
    final response =
        await http.get(Uri.parse("$basePics/get/$fileId"));
    if (response.statusCode == 200) {
      return PicDataResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load pic');
    }
  }

  void addCreatedPoem() {
    List<Poem> poemsToAdd = [createdUpdatedPoem!]; 
    populate(poemsToAdd);
  }

  void addUpdatedPoem(String id) {
    int i = poems.indexWhere((x) => x.id == id);
    poems[i] = createdUpdatedPoem!; 
    notifyListeners();
  }

  void setCreatedUpdatedPoem(Poem poem) {
    createdUpdatedPoem = poem; 
    notifyListeners();
  }

  void deletePoem(String id) {
    poems.removeWhere((x) => x.id == id);
    notifyListeners();
  }
  
  void setBuffer(Uint8List buffer) {
    createdUpdatedPoem!.buffer = buffer; 
    notifyListeners();
  }

  void setNewPic(Uint8List buffer) {
    if (createdUpdatedPoem != null) {
      createdUpdatedPoem!.buffer = buffer; 
    }
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
