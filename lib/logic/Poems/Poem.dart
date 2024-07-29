


class Poem {
  final String id;
  final String poem;
  final List<String> imaginePrompt;
  final List<DateTime> lastModified;
  final List<String> fileId;

  Poem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        poem = json['poem'],
        imaginePrompt = List<String>.from(json['imagine_prompt']),
        lastModified = (json['last_modified'] as List)
            .map((dateString) => DateTime.parse(dateString))
            .toList(),
        fileId = List<String>.from(json['file_id']);
}

class ApiResponse {
  final int status;
  final List<Poem> data;
  final String message;

  const ApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  ApiResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data =
            (json['data'] as List).map((item) => Poem.fromJson(item)).toList(),
        message = json['message'];
}
