import 'package:mongo_dart/mongo_dart.dart';

class StocksType{
  ObjectId id;
  String Code;

  StocksType(
  {this.id, this.Code});

  factory StocksType.fromJson(Map<String, dynamic> parsedJson) {
    return StocksType(
      id: parsedJson['_id'],
      Code: parsedJson['Code'].toString()
    );
  }
}