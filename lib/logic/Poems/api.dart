import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;
import 'dart:convert';
import './Poem.dart';
class Api {
    String basePoemUrl = "https://acceptable-comfort-production.up.railway.app/api/poems";
    String basePicUrl = "https://acceptable-comfort-production.up.railway.app/api/pics";
    String imagines = "https://acceptable-comfort-production.up.railway.app/api/imagines";

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

    Future<String> getPoemFromImage(File file) async {
      String extractedPoem = "";
      var stream = http.ByteStream(file.openRead());
      stream.cast();
      var length = await file.length();
      var request = http.MultipartRequest("POST", Uri.parse("$basePoemUrl/extract"));
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: path.basename(file.path));  
      request.files.add(multipartFile);
      var response = await request.send();
      extractedPoem = await response.stream.transform(utf8.decoder).join();
      return extractedPoem;
  }

  Future<DeleteData> deletePoem(String poemId) async {
    final response =
        await http.delete(Uri.parse("$basePoemUrl/delete/$poemId"));

    DeleteDataResponse res = DeleteDataResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    if (res.status == 200) {
      return res.data;
    } else {
      throw Exception(res.message);
    }
  }
}