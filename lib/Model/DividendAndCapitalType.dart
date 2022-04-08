import 'dart:ffi';

import 'package:mongo_dart/mongo_dart.dart';

class DividendAndCapitalType{
  ObjectId id;
  String Code;
  DateTime Date;
  String TypeCode;
  String CapitalIKString;
  String CapitalTMString;
  String DividendString;
  double CapitalIK;
  double CapitalTM;
  double Dividend;


  DividendAndCapitalType(
  {this.id, this.Code, this.Date, this.TypeCode, this.CapitalIKString, this.CapitalTMString, this.DividendString});

  factory DividendAndCapitalType.fromJson(Map<String, dynamic> parsedJson) {
    return DividendAndCapitalType(
      id: parsedJson['_id'],
      Code: parsedJson['Code'].toString(),
      Date: DateTime.parse(parsedJson['Date'].toString()),
      TypeCode: parsedJson['TypeCode'].toString(),
      CapitalIKString: parsedJson['CapitalIK'].toString(),
      CapitalTMString: parsedJson['CapitalTM'].toString(),
      DividendString: parsedJson['Dividend'].toString(),
    );
  }
}