import 'package:http/http.dart' as http;
import 'dart:convert';
import './Poem.dart';

class Api {
    String basePoemUrl = "http://10.0.2.2:8080/api/poems";
    String basePicUrl = "http://10.0.2.2:8080/api/pics";
    String imagines = "http://10.0.2.2:8080/api/imagines";

    Future<ApiResponse> getPoems() async {
    final response =
        await http.get(Uri.parse(basePoemUrl));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load poems');
    }
  }

  Future<PicData> getPic(String fileId) async {
    final response =
        await http.get(Uri.parse("$basePicUrl/get/$fileId"));

    PicDataResponse res = PicDataResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data;
    } else {
      throw Exception(res.message);
    }
  }

  Future<CreateData> createPoem(String poem) async {
    final response =
        await http.post(
          Uri.parse("$basePoemUrl/create"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'poem': poem,
          }),
          );
    CreateResponse res = CreateResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data!;
    } else {
      throw Exception(res.message);
    }
  }

    Future<PicData> createPic(String poemId, String prompt) async {
    final response =
        await http.post(
          Uri.parse("$basePicUrl/create"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'poem_id': poemId,
            'prompt': prompt
          }),
          );
    PicDataResponse res = PicDataResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data;
    } else {
      throw Exception(res.message);
    }
  }
    Future<UpdateData> updatePoem(String id, String newPoem) async {
    final response =
        await http.put(
          Uri.parse("$basePoemUrl/update"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'id': id,
            'new_poem': newPoem,
          }),
          );
    UpdateResponse res = UpdateResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data!;
    } else {
      throw Exception(res.message);
    }
  }

    Future<Poem> getPoem(String poemId) async {
    final response =
        await http.get(Uri.parse("$basePoemUrl/get/$poemId"));
    SinglePoemResponse res = SinglePoemResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data;
    } else {
      throw Exception(res.message);
    }
  }
}