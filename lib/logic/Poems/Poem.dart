import 'package:ai_poem_app/common.dart';

class Metadata {
    final String id;
    final String poemId;
    final String fileId;
    const Metadata({
    required this.id,
    required this.poemId,
    required this.fileId,
  });
    Metadata.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        poemId = json['poem_id'],
        fileId = json['file_id'];
}

class PicData {
    final bool streamDone;
    final bool metaDone;
    final String? fileId;
    final String? buffer;
  
    const PicData({
    required this.streamDone,
    required this.metaDone,
    required this.fileId,
    required this.buffer,
  });
    PicData.fromJson(Map<String, dynamic> json)
      : streamDone = json['stream_done'],
        metaDone = json['meta_done'],
        fileId = json['file_id'] ?? null,
        buffer = json['buffer'] ?? null;
}

class Poem {
  final String id;
  final String poem;
  final List<String> imaginePrompt;
  final List<DateTime> lastModified;
  final List<String>? fileId;
  Uint8List? buffer;

    Poem(
      this.id,this.poem,this.imaginePrompt,
      this.lastModified,this.fileId,this.buffer);

  Poem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        poem = json['poem'],
        imaginePrompt = List<String>.from(json['imagine_prompt']),
        lastModified = (json['last_modified'] as List)
            .map((dateString) => DateTime.parse(dateString))
            .toList(),
        fileId = json['data'] != null ? List<String>.from(json['file_id']) : null;
}

// TO-DO
class BaseResponse<T> {
  final int status;
  T data;
  final String message;

    BaseResponse({
    required this.status,
    required this.data,
    required this.message,
  });
}
// END TO-DO

class PicDataResponse {
  final int status;
  final PicData data;
  final String message;

  const PicDataResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  PicDataResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = PicData.fromJson(json['data']),
        message = json['message'];
}

class MetadataResponse {
  final int status;
  final List<Metadata> data;
  final String message;

  const MetadataResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  MetadataResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data =
            (json['data'] as List).map((item) => Metadata.fromJson(item)).toList(),
        message = json['message'];
}

class SinglePoemResponse {
  final int status;
  final Poem data;
  final String message;

  const SinglePoemResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  SinglePoemResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = Poem.fromJson(json['data']),
        message = json['message'];
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


class CreateData {
  final bool acknowledged;
  final String insertedId;
  CreateData.fromJson(Map<String, dynamic> json)
    : acknowledged = json['acknowledged'],
      insertedId = json['insertedId'];
}

class CreateResponse {
  final int status;
  final CreateData? data;
  final String message;

  CreateResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null ? CreateData.fromJson(json['data']) : null,
        message = json['message'];
}

class UpdateData {
  final bool acknowledged;
  final int modifiedCount;
  final String? upsertedId;
  final int upsertedCount;
  final int matchedCount;

  UpdateData.fromJson(Map<String, dynamic> json)
    : acknowledged = json['acknowledged'],
      modifiedCount = json['modifiedCount'],
      upsertedId = json['upsertedId'],
      upsertedCount = json['upsertedCount'],
      matchedCount = json['matchedCount'];
}

class UpdateResponse {
  final int status;
  final UpdateData? data;
  final String message;

  UpdateResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null ? UpdateData.fromJson(json['data']) : null,
        message = json['message'];
}

