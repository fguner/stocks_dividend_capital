import 'package:mongo_dart/mongo_dart.dart';

class MessageType{
  ObjectId id;
  String message;

  MessageType(
  {this.id, this.message});

  factory MessageType.fromJson(Map<String, dynamic> parsedJson) {
    return MessageType(
      id: parsedJson['_id'],
      message: parsedJson['message'].toString()
    );
  }
}



