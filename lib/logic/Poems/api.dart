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
}