import 'dart:ffi';

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

class HistoricalData{
  ObjectId id;
  String Code;
  String Date;
  double Amount;

  HistoricalData(
  {this.id, this.Code, this.Date, this.Amount});

  factory HistoricalData.fromJson(Map<String, dynamic> parsedJson) {
    return HistoricalData(
      id: parsedJson['_id'],
      Code: parsedJson['Code'].toString(),
      Date: parsedJson['Date'].toString(),
      Amount: double.parse(parsedJson['Amount'].toString()),
    );
  }
}

class EndeksType{
  String c;
  double last;
  String description;
  double dailyVolume;
  double previousDayClose;
  double dailyChange;
  double dailyChangePercentage;

  EndeksType(
  {this.c, this.last, this.description, this.dailyVolume, this.previousDayClose, this.dailyChange, this.dailyChangePercentage});

  factory EndeksType.fromJson(Map<String, dynamic> parsedJson) {
    return EndeksType(
      c: parsedJson['c'],
      last: double.parse(parsedJson['last'].toString()),
      description: parsedJson['description'].toString(),
      dailyVolume: double.parse(parsedJson['dailyVolume'].toString()),
      previousDayClose: double.parse(parsedJson['previousDayClose'].toString()),
      dailyChange: double.parse(parsedJson['dailyChange'].toString()),
      dailyChangePercentage: double.parse(parsedJson['dailyChangePercentage'].toString()),
    );
  }
}