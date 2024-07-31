import 'package:http/http.dart' as http;
import 'dart:convert';
import './Poem.dart';

class Api {
    String poems = "http://10.0.2.2:8080/api/poems";
    String files = "http://10.0.2.2:8080/api/pics";
    String imagines = "http://10.0.2.2:8080/api/imagines";

    Future<ApiResponse> getPoems() async {
    final response =
        await http.get(Uri.parse(poems));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load poems');
    }
  }

  Future<ApiResponse> getPic() async {
    final response =
        await http.get(Uri.parse(poems));


    if (response.statusCode == 200) {
      return ApiResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load poems');
    }
  }

  Future<CreateData> createPoem(String poem) async {
    final response =
        await http.post(
          Uri.parse("$poems/create"),
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
}