import 'dart:typed_data';

import 'package:flutter/foundation.dart';

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

class MetaStream {
    final bool streamDone;
    final bool metaDone;
    final String buffer;
  
    const MetaStream({
    required this.streamDone,
    required this.metaDone,
    required this.buffer,
  });
    MetaStream.fromJson(Map<String, dynamic> json)
      : streamDone = json['stream_done'],
        metaDone = json['meta_done'],
        buffer = json['buffer'];
}

class Poem {
  final String id;
  final String poem;
  final List<String> imaginePrompt;
  final List<DateTime> lastModified;
  final List<String> fileId;
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
        fileId = List<String>.from(json['file_id']);
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

class PicResponse {
  final int status;
  final MetaStream data;
  final String message;

  const PicResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  PicResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = MetaStream.fromJson(json['data']),
        message = json['message'];
}

class MetaResponse {
  final int status;
  final List<Metadata> data;
  final String message;

  const MetaResponse({
    required this.status,
    required this.data,
    required this.message,
  });
  MetaResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data =
            (json['data'] as List).map((item) => Metadata.fromJson(item)).toList(),
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


